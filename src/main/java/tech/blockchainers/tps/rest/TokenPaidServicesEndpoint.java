package tech.blockchainers.tps.rest;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.web3j.protocol.Web3j;
import org.web3j.tx.gas.DefaultGasProvider;
import tech.blockchainers.GroupCurrencyToken;
import tech.blockchainers.tps.config.PrototypeConfig;
import tech.blockchainers.tps.rest.dto.GroupCurrencyTokenDto;
import tech.blockchainers.tps.service.CirclesGCTPaidService;

import java.math.BigInteger;

@Slf4j
@RestController
@RequestMapping("/api")
public class TokenPaidServicesEndpoint {

    private final PrototypeConfig prototypeConfig;
    private final Web3j web3j;
    private final CirclesGCTPaidService circlesGCTPaidService;
    private String groupCurrencyTokenAddress;

    public TokenPaidServicesEndpoint(PrototypeConfig prototypeConfig, Web3j web3j, CirclesGCTPaidService circlesGCTPaidService) {
        this.prototypeConfig = prototypeConfig;
        this.web3j = web3j;
        this.circlesGCTPaidService = circlesGCTPaidService;
    }

    @PostMapping("/initializeTrustGraph")
    public GroupCurrencyTokenDto deployDemoToken() throws Exception {
        groupCurrencyTokenAddress = circlesGCTPaidService.prepareTokenTrustGraph();
        return GroupCurrencyTokenDto.builder().address(groupCurrencyTokenAddress).allowance(BigInteger.ZERO).build();
    }

    @PostMapping("/approveServiceOnDemoToken")
    public GroupCurrencyTokenDto approveServiceOnDemoToken() throws Exception {
        if (groupCurrencyTokenAddress == null) {
            throw new IllegalStateException("GroupCurrencyToken and Trust Graph not initialized.");
        }
        BigInteger allowance = BigInteger.valueOf(100);
        GroupCurrencyToken groupCurrencyToken = GroupCurrencyToken.load(groupCurrencyTokenAddress, web3j, prototypeConfig.getGroupCurrencyTokenCharly(), new DefaultGasProvider());
        groupCurrencyToken.approve(prototypeConfig.getCredentialHolder().deriveChildKeyPair(9).getAddress(), allowance).send();
        return GroupCurrencyTokenDto.builder().address(groupCurrencyToken.getContractAddress()).allowance(allowance).build();
    }

    @GetMapping("/call")
    public String callService() throws Exception {
        String mockedResult = "Chuck Norris counted to infinity ... twice.";
        GroupCurrencyToken groupCurrencyToken = GroupCurrencyToken.load(groupCurrencyTokenAddress, web3j, prototypeConfig.getCredentialHolder().deriveChildKeyPair(9), new DefaultGasProvider());
        groupCurrencyToken.transferFrom(prototypeConfig.getGroupCurrencyTokenCharly().getAddress(), prototypeConfig.getCredentialHolder().deriveChildKeyPair(9).getAddress(), BigInteger.valueOf(1)).send();
        return mockedResult;
    }
}
