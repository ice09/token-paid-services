package tech.blockchainers.tps.config;

import lombok.Getter;
import org.springframework.stereotype.Component;
import org.web3j.crypto.Credentials;

@Component
@Getter
public class PrototypeConfig {

    private final CredentialHolder credentialHolder;

    String treasuryAddress = "0x0000000000000000000000000000000000000001";

    Credentials orgaHubDeployer;
    Credentials groupCurrencyTokenDeployer;

    Credentials groupCurrencyTokenOwner;
    Credentials groupCurrencyTokenAlice;
    Credentials groupCurrencyTokenBob;
    Credentials groupCurrencyTokenCharly;

    public PrototypeConfig(CredentialHolder credentialHolder) {
        this.credentialHolder = credentialHolder;
        orgaHubDeployer = this.credentialHolder.deriveChildKeyPair(0);

        groupCurrencyTokenDeployer = this.credentialHolder.deriveChildKeyPair(1);
        groupCurrencyTokenOwner = this.credentialHolder.deriveChildKeyPair(2);

        groupCurrencyTokenAlice = this.credentialHolder.deriveChildKeyPair(3);
        groupCurrencyTokenBob = this.credentialHolder.deriveChildKeyPair(4);
        groupCurrencyTokenCharly = this.credentialHolder.deriveChildKeyPair(5);
    }
}
