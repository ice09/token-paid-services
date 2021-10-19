package tech.blockchainers.tps.service;

import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tx.gas.DefaultGasProvider;
import tech.blockchainers.GroupCurrencyToken;
import tech.blockchainers.GroupCurrencyTokenOwner;
import tech.blockchainers.OrgaHub;
import tech.blockchainers.tps.EventLogger;
import tech.blockchainers.tps.config.PrototypeConfig;

import java.math.BigInteger;
import java.util.List;

@Slf4j
@Service
public class CirclesGCTPaidService {

    @Autowired
    private Web3j web3j;

    @Autowired
    private PrototypeConfig prototypeConfig;

    @Autowired
    private EventLogger eventLogger;

    public String prepareTokenTrustGraph() throws Exception {
        Credentials contractDeployer = prototypeConfig.getOrgaHubDeployer();
        Credentials groupCurrencyTokenAlice = prototypeConfig.getGroupCurrencyTokenAlice();
        Credentials groupCurrencyTokenBob = prototypeConfig.getGroupCurrencyTokenBob();
        Credentials groupCurrencyTokenCharly = prototypeConfig.getGroupCurrencyTokenCharly();

        TransactionReceipt trx; // Reused for Event logging purposes

        // Deploy new Contract OrgaHub
        OrgaHub orgaHub = deployOrgaHub(contractDeployer);

        // Deploy GCT and GCTO
        GroupCurrencyToken gct = deployGroupCurrencyToken(contractDeployer, orgaHub.getContractAddress(), contractDeployer.getAddress(), prototypeConfig.getTreasuryAddress());
        GroupCurrencyTokenOwner gcto = deployGroupCurrencyTokenOwner(contractDeployer, orgaHub.getContractAddress(), gct.getContractAddress(), contractDeployer.getAddress());

        // Change Admin on Hub to GCTO Contract Address
        orgaHub.changeAdmin(gcto.getContractAddress()).send();
        eventLogger.addManualEvent("Changed Admin on OrgaHub", gcto.getContractAddress());

        // Change Owner on GCT to GCTO Contract Address
        gct.changeOwner(gcto.getContractAddress()).send();
        eventLogger.addManualEvent("Changed Admin on GroupCurrencyToken", gcto.getContractAddress());

        // Setup GCTO, Orga Signup and set Delegate Trustee
        trx = gcto.setup().send();
        eventLogger.addOrgaHubOrgaSignupListener(orgaHub, trx);

        // Create new account for Bob
        OrgaHub orgaHubBob = OrgaHub.load(orgaHub.getContractAddress(), web3j, groupCurrencyTokenBob, new DefaultGasProvider());
        trx = orgaHubBob.signup().send();
        String tokenBob = eventLogger.addOrgaHubSignupListener(orgaHubBob, trx);

        // Trust Bob
        trx = gcto.trust(groupCurrencyTokenBob.getAddress()).send();
        eventLogger.addGCTOTrustListener(orgaHub, trx);

        List<String> tokenOwners = Lists.newArrayList(groupCurrencyTokenBob.getAddress());
        List<String> srcs = Lists.newArrayList(groupCurrencyTokenBob.getAddress());
        List<String> dests = Lists.newArrayList(gcto.getContractAddress());
        List<BigInteger> wads = Lists.newArrayList(BigInteger.ONE);

        // Now mint Bobs Token for GCT
        GroupCurrencyTokenOwner gctoBob = GroupCurrencyTokenOwner.load(gcto.getContractAddress(), web3j, groupCurrencyTokenBob, new DefaultGasProvider());
        gctoBob.mintTransitive(tokenOwners, srcs, dests, wads).send();

        // Create new account for Alice
        OrgaHub orgaHubAlice = OrgaHub.load(orgaHub.getContractAddress(), web3j, groupCurrencyTokenAlice, new DefaultGasProvider());
        trx = orgaHubAlice.signup().send();
        String tokenAlice = eventLogger.addOrgaHubSignupListener(orgaHubAlice, trx);

        // Bob trusts Alice
        trx = orgaHubBob.trust(groupCurrencyTokenAlice.getAddress(), BigInteger.TEN).send();
        eventLogger.addGCTOTrustListener(orgaHub, trx);

        tokenOwners = Lists.newArrayList(groupCurrencyTokenAlice.getAddress(), groupCurrencyTokenBob.getAddress());
        srcs = Lists.newArrayList(groupCurrencyTokenAlice.getAddress(), groupCurrencyTokenBob.getAddress());
        dests = Lists.newArrayList(groupCurrencyTokenBob.getAddress(), gcto.getContractAddress());
        wads = Lists.newArrayList(BigInteger.TWO, BigInteger.TWO);

        // Now mint Alice Token for GCT
        GroupCurrencyTokenOwner gctoAlice = GroupCurrencyTokenOwner.load(gcto.getContractAddress(), web3j, groupCurrencyTokenAlice, new DefaultGasProvider());
        gctoAlice.mintTransitive(tokenOwners, srcs, dests, wads).send();

        // Create new account for Charly
        OrgaHub orgaHubCharly = OrgaHub.load(orgaHub.getContractAddress(), web3j, groupCurrencyTokenCharly, new DefaultGasProvider());
        trx = orgaHubCharly.signup().send();
        String tokenCharly = eventLogger.addOrgaHubSignupListener(orgaHubCharly, trx);

        // Alice trusts Charly
        trx = orgaHubAlice.trust(groupCurrencyTokenCharly.getAddress(), BigInteger.TEN).send();
        eventLogger.addGCTOTrustListener(orgaHub, trx);

        tokenOwners = Lists.newArrayList(groupCurrencyTokenCharly.getAddress(), groupCurrencyTokenAlice.getAddress(), groupCurrencyTokenBob.getAddress());
        srcs = Lists.newArrayList(groupCurrencyTokenCharly.getAddress(), groupCurrencyTokenAlice.getAddress(), groupCurrencyTokenBob.getAddress());
        dests = Lists.newArrayList(groupCurrencyTokenAlice.getAddress(), groupCurrencyTokenBob.getAddress(), gcto.getContractAddress());
        wads = Lists.newArrayList(BigInteger.TWO, BigInteger.TWO, BigInteger.TWO);

        // Now mint Charly Token for GCT
        GroupCurrencyTokenOwner gctoCharly = GroupCurrencyTokenOwner.load(gcto.getContractAddress(), web3j, groupCurrencyTokenCharly, new DefaultGasProvider());
        trx = gctoCharly.mintTransitive(tokenOwners, srcs, dests, wads).send();
        eventLogger.addTokenTransferEvent(tokenBob, groupCurrencyTokenBob, trx);
        eventLogger.addTokenMintingEvent(gct, trx);

        eventLogger.getAllCircleEvents().forEach(it -> log.info(it.toString()));
        return gct.getContractAddress();
    }

    private OrgaHub deployOrgaHub(Credentials deployer) throws Exception {
        return OrgaHub.deploy(web3j, deployer, new DefaultGasProvider(), deployer.getAddress(), BigInteger.ONE, BigInteger.ONE, "CRC", "Circles", new BigInteger("50000000000000000000"), BigInteger.ONE, BigInteger.ONE).send();
    }

    private GroupCurrencyToken deployGroupCurrencyToken(Credentials deployer, String hub, String owner, String treasury) throws Exception {
        return GroupCurrencyToken.deploy(web3j, deployer, new DefaultGasProvider(), hub, treasury, owner, BigInteger.ONE, "GCT", "GCT").send();
    }

    private GroupCurrencyTokenOwner deployGroupCurrencyTokenOwner(Credentials deployer, String hub, String token, String owner) throws Exception {
        return GroupCurrencyTokenOwner.deploy(web3j, deployer, new DefaultGasProvider(), hub, token, owner).send();
    }
}
