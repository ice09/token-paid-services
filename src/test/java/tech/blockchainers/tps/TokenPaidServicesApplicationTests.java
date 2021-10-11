package tech.blockchainers.tps;

import lombok.extern.slf4j.Slf4j;
import org.assertj.core.util.Lists;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tx.gas.DefaultGasProvider;
import tech.blockchainers.ERC20;
import tech.blockchainers.GroupCurrencyToken;
import tech.blockchainers.GroupCurrencyTokenOwner;
import tech.blockchainers.OrgaHub;
import tech.blockchainers.tps.config.CredentialHolder;
import java.math.BigInteger;
import java.util.List;


@SpringBootTest
@Slf4j
class TokenPaidServicesApplicationTests {

	@Autowired
	private Web3j web3j;

	@Autowired
	private CredentialHolder credentialHolder;

	@Test
	void contextLoads() throws Exception {
		String treasuryAddress = "0x0000000000000000000000000000000000000001";

		Credentials orgaHubDeployer = credentialHolder.deriveChildKeyPair(0);
		Credentials orgaHubOrgaSignup = credentialHolder.deriveChildKeyPair(1);
		Credentials groupCurrencyTokenDeployer = credentialHolder.deriveChildKeyPair(2);
		Credentials groupCurrencyTokenOwner = credentialHolder.deriveChildKeyPair(3);
		Credentials groupCurrencyTokenAlice = credentialHolder.deriveChildKeyPair(4);
		Credentials groupCurrencyTokenBob = credentialHolder.deriveChildKeyPair(5);
		OrgaHub orgaHub = deployOrgaHub(orgaHubDeployer);

		// Signup with orgaHubSignupAddress
		OrgaHub orgaHubSignup = OrgaHub.load(orgaHub.getContractAddress(), web3j, orgaHubOrgaSignup, new DefaultGasProvider());
		orgaHubSignup.organizationSignup().send();

		GroupCurrencyToken gct = deployGroupCurrencyToken(groupCurrencyTokenDeployer, orgaHub.getContractAddress(), groupCurrencyTokenDeployer.getAddress(), treasuryAddress);
		GroupCurrencyTokenOwner gcto = deployGroupCurrencyTokenOwner(groupCurrencyTokenOwner, orgaHub.getContractAddress(), gct.getContractAddress(), groupCurrencyTokenOwner.getAddress());

		// Change Admin to GCTO Contract Address
		orgaHub.changeAdmin(gcto.getContractAddress()).send();

		// Change Owner to GCT Contract Address
		gct.changeOwner(gcto.getContractAddress()).send();

		// Setup GCTO, Orga Signup and set Delegate Trustee
		gcto.setup().send();

		// Create new account for Bob
		OrgaHub orgaHubBob = OrgaHub.load(orgaHub.getContractAddress(), web3j, groupCurrencyTokenBob, new DefaultGasProvider());
		TransactionReceipt trxRcp = orgaHubBob.signup().send();
		List<OrgaHub.SignupEventResponse> signupEvents = orgaHubBob.getSignupEvents(trxRcp);
		String bobToken = null;
		for (OrgaHub.SignupEventResponse signupEventResponse : signupEvents) {
			bobToken = signupEventResponse.token;
		}

		// Trust Bob
		gcto.trust(groupCurrencyTokenBob.getAddress()).send();

		List<String> tokenOwners = Lists.newArrayList(groupCurrencyTokenBob.getAddress());
		List<String> srcs = Lists.newArrayList(groupCurrencyTokenBob.getAddress());
		List<String> dests = Lists.newArrayList(gcto.getContractAddress());
		List<BigInteger> wads = Lists.newArrayList(BigInteger.ONE);

		// Bob gives GCTO Contract allowance on his Token
		// Currently this must be GCT *and* GCTO - is that correct? Why?
		ERC20 sampleTokenLoadedFromFrom = ERC20.load(bobToken, web3j, groupCurrencyTokenBob, new DefaultGasProvider());
		sampleTokenLoadedFromFrom.approve(gct.getContractAddress(), BigInteger.valueOf(10)).send();
		sampleTokenLoadedFromFrom.approve(gcto.getContractAddress(), BigInteger.valueOf(10)).send();

		// Now mint Bobs Token for GCT
		GroupCurrencyTokenOwner gctoBob = GroupCurrencyTokenOwner.load(gcto.getContractAddress(), web3j, groupCurrencyTokenBob, new DefaultGasProvider());
		gctoBob.mintTransitive(tokenOwners, srcs, dests, wads).send();
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