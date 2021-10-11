package tech.blockchainers.tps.rest;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.web3j.protocol.Web3j;
import org.web3j.tx.gas.DefaultGasProvider;
import tech.blockchainers.UnlimitedSupplyToken;
import tech.blockchainers.tps.config.CredentialHolder;
import tech.blockchainers.tps.rest.dto.UnlimitedSupplyTokenDto;

import java.math.BigInteger;

@Slf4j
@RestController
@RequestMapping("/api")
public class TokenPaidServicesEndpoint {

    private final CredentialHolder credentialHolder;
    private final Web3j web3j;
    private String tokenAddress;

    public TokenPaidServicesEndpoint(CredentialHolder credentialHolder, Web3j web3j) {
        this.credentialHolder = credentialHolder;
        this.web3j = web3j;
    }

    @PostMapping("/deployDemoToken")
    public UnlimitedSupplyTokenDto deployDemoToken() throws Exception {
        UnlimitedSupplyToken sampleToken = UnlimitedSupplyToken.deploy(web3j, credentialHolder.deriveChildKeyPair(0), new DefaultGasProvider(), "TKN", "TKN").send();
        log.info("Deploy UnlimitedSupplyToken Contract to {}", sampleToken.getContractAddress());
        tokenAddress = sampleToken.getContractAddress();
        sampleToken.mintToken(credentialHolder.deriveChildKeyPair(1).getAddress(), BigInteger.valueOf(1000)).send();
        UnlimitedSupplyTokenDto.UnlimitedSupplyTokenDtoBuilder sampleTokenDtoBuilder = UnlimitedSupplyTokenDto.builder();
        return sampleTokenDtoBuilder.address(sampleToken.getContractAddress()).build();
    }

    @PostMapping("/approveServiceOnDemoToken")
    public UnlimitedSupplyTokenDto approveServiceOnDemoToken() throws Exception {
        if (StringUtils.isEmpty(tokenAddress)) {
            throw new IllegalStateException("TokenAddress not set.");
        }
        UnlimitedSupplyToken sampleToken = UnlimitedSupplyToken.load(tokenAddress, web3j, credentialHolder.deriveChildKeyPair(1), new DefaultGasProvider());
        BigInteger allowance = BigInteger.valueOf(100);
        sampleToken.approve(credentialHolder.deriveChildKeyPair(2).getAddress(), allowance).send();

        UnlimitedSupplyTokenDto.UnlimitedSupplyTokenDtoBuilder sampleTokenDtoBuilder = UnlimitedSupplyTokenDto.builder();
        return sampleTokenDtoBuilder.address(sampleToken.getContractAddress()).allowance(allowance).build();
    }

    @GetMapping("/call")
    public String callService() throws Exception {
        String mockedResult = "YEAH!";
        UnlimitedSupplyToken sampleToken = UnlimitedSupplyToken.load(tokenAddress, web3j, credentialHolder.deriveChildKeyPair(2), new DefaultGasProvider());
        sampleToken.transferFrom(credentialHolder.deriveChildKeyPair(1).getAddress(), credentialHolder.deriveChildKeyPair(3).getAddress(), BigInteger.valueOf(25)).send();
        return mockedResult;
    }
}
