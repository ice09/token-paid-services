package tech.blockchainers.tps.service;

import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tx.gas.DefaultGasProvider;
import tech.blockchainers.*;
import tech.blockchainers.tps.EventLogger;
import tech.blockchainers.tps.config.PrototypeConfig;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
public class CirclesGCTCentralizedEditionPaidService {

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
        Hub hub = deployHub(contractDeployer);

        // Deploy GCT and GCTO
        GroupCurrencyTokenCentralizedEdition gct = deployGroupCurrencyToken(contractDeployer, hub.getContractAddress(), contractDeployer.getAddress(), prototypeConfig.getTreasuryAddress());
        GroupCurrencyTokenOwnerCentralizedEdition gcto = deployGroupCurrencyTokenOwner(contractDeployer, hub.getContractAddress(), gct.getContractAddress(), contractDeployer.getAddress());

        // Change Owner on GCT to GCTO Contract Address
        gct.changeOwner(gcto.getContractAddress()).send();
        eventLogger.addManualEvent("Changed Admin on GroupCurrencyToken", gcto.getContractAddress(), gct.getContractAddress());

        // Setup GCTO, Orga Signup
        trx = gcto.setup().send();
        eventLogger.addHubOrgaSignupListener(hub, trx);

        // Create new account for Bob
        Hub hubBob = Hub.load(hub.getContractAddress(), web3j, groupCurrencyTokenBob, new DefaultGasProvider());
        trx = hubBob.signup().send();
        String tokenBob = eventLogger.addHubSignupListener(hubBob, trx);

        // Trust Bob
        trx = gcto.trust(groupCurrencyTokenBob.getAddress()).send();
        eventLogger.addGCTOTrustListener(hub, trx);

        // Create new account for Alice
        Hub hubAlice = Hub.load(hub.getContractAddress(), web3j, groupCurrencyTokenAlice, new DefaultGasProvider());
        trx = hubAlice.signup().send();
        String tokenAlice = eventLogger.addHubSignupListener(hubAlice, trx);

        // Bob trusts Alice
        trx = hubBob.trust(groupCurrencyTokenAlice.getAddress(), BigInteger.TEN).send();
        eventLogger.addGCTOTrustListener(hub, trx);

        // Create new account for Charly
        Hub orgaHubCharly = Hub.load(hub.getContractAddress(), web3j, groupCurrencyTokenCharly, new DefaultGasProvider());
        trx = orgaHubCharly.signup().send();
        String tokenCharly = eventLogger.addHubSignupListener(orgaHubCharly, trx);

        // Alice trusts Charly
        trx = hubAlice.trust(groupCurrencyTokenCharly.getAddress(), BigInteger.TEN).send();
        eventLogger.addGCTOTrustListener(hub, trx);

        List<String> tokenOwners = Lists.newArrayList(groupCurrencyTokenCharly.getAddress(), groupCurrencyTokenAlice.getAddress(), groupCurrencyTokenBob.getAddress());
        List<String> srcs = Lists.newArrayList(groupCurrencyTokenCharly.getAddress(), groupCurrencyTokenAlice.getAddress(), groupCurrencyTokenBob.getAddress());
        List<String> dests = Lists.newArrayList(groupCurrencyTokenAlice.getAddress(), groupCurrencyTokenBob.getAddress(), gcto.getContractAddress());
        List<BigInteger> wads = Lists.newArrayList(BigInteger.TWO, BigInteger.TWO, BigInteger.TWO);

        // Transitive Transfer of Charly Tokens to GCTO
        trx = orgaHubCharly.transferThrough(tokenOwners, srcs, dests, wads).send();
        // The Service must monitor the events on the GCTO contract (to get transfer events)
        eventLogger.addTokenTransferEvent(tokenBob, groupCurrencyTokenBob, trx);
        // The Service must trigger mintTransitive with destination and source (to reduce fraud potential) to mint
        // Use Bob Tokens as source (these have been transferred to GTCO transitively) and Charly as destination
        trx = gcto.mintTransitive(groupCurrencyTokenCharly.getAddress(), groupCurrencyTokenBob.getAddress(), BigInteger.TWO).send();
        eventLogger.addTokenMintingEvent(gct, trx);
        eventLogger.addTokenTransferEvent(tokenCharly, groupCurrencyTokenBob, trx);

        eventLogger.getAllCircleEvents().forEach(it -> log.info(it.toString()));
        return gct.getContractAddress();
    }

    private Hub deployHub(Credentials deployer) throws Exception {
        return Hub.deploy(web3j, deployer, new DefaultGasProvider(), BigInteger.ONE, BigInteger.ONE, "CRC", "Circles", new BigInteger("50000000000000000000"), BigInteger.ONE, BigInteger.ONE).send();
    }

    private GroupCurrencyTokenCentralizedEdition deployGroupCurrencyToken(Credentials deployer, String hub, String owner, String treasury) throws Exception {
        return GroupCurrencyTokenCentralizedEdition.deploy(web3j, deployer, new DefaultGasProvider(), hub, treasury, owner, BigInteger.ONE, "GCT", "GCT").send();
    }

    private GroupCurrencyTokenOwnerCentralizedEdition deployGroupCurrencyTokenOwner(Credentials deployer, String hub, String token, String owner) throws Exception {
        return GroupCurrencyTokenOwnerCentralizedEdition.deploy(web3j, deployer, new DefaultGasProvider(), hub, token, owner).send();
    }
}
