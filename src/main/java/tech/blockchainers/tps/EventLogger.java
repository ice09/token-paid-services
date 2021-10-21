package tech.blockchainers.tps;

import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tx.gas.DefaultGasProvider;
import tech.blockchainers.*;

import java.util.ArrayList;
import java.util.List;

@Component
@Slf4j
public class EventLogger<builder> {

    @Autowired
    private Web3j web3j;

    private CirclesEvent.CirclesEventBuilder builder = new CirclesEvent.CirclesEventBuilder();

    private List<CirclesEvent> circlesEvents = new ArrayList<>();

    public void addTokenMintingEvent(GroupCurrencyToken groupCurrencyToken, TransactionReceipt trx) {
        for (GroupCurrencyToken.MintedEventResponse event : groupCurrencyToken.getMintedEvents(trx)) {
            log.info(String.format("GCT Minted amount %s to %s", event.mintAmount, event.receiver));
            CirclesEvent cEvent = builder.event("GCT." + GroupCurrencyToken.MINTED_EVENT.getName()).eventParams(Lists.newArrayList(event.log.getAddress(), event.receiver, event.amount.toString(), event.mintAmount.toString())).build();
            circlesEvents.add(cEvent);
        }
    }

    public void addTokenMintingEvent(GroupCurrencyTokenCentralizedEdition groupCurrencyToken, TransactionReceipt trx) {
        for (GroupCurrencyTokenCentralizedEdition.MintedEventResponse event : groupCurrencyToken.getMintedEvents(trx)) {
            log.info(String.format("GCT Minted amount %s to %s", event.mintAmount, event.receiver));
            CirclesEvent cEvent = builder.event("GCT." + GroupCurrencyTokenCentralizedEdition.MINTED_EVENT.getName()).eventParams(Lists.newArrayList(event.log.getAddress(), event.receiver, event.amount.toString(), event.mintAmount.toString())).build();
            circlesEvents.add(cEvent);
        }
    }

    public void addOrgaHubOrgaSignupListener(OrgaHub orgaHubSignup, TransactionReceipt trx) {
        for (OrgaHub.OrganizationSignupEventResponse event : orgaHubSignup.getOrganizationSignupEvents(trx)) {
            log.info(String.format("Signed up Organization %s", event.organization));
            CirclesEvent cEvent = builder.event(OrgaHub.ORGANIZATIONSIGNUP_EVENT.getName()).eventParams(Lists.newArrayList(event.organization)).build();
            circlesEvents.add(cEvent);
        }
    }

    public void addHubOrgaSignupListener(Hub orgaHubSignup, TransactionReceipt trx) {
        for (Hub.OrganizationSignupEventResponse event : orgaHubSignup.getOrganizationSignupEvents(trx)) {
            log.info(String.format("Signed up Organization %s", event.organization));
            CirclesEvent cEvent = builder.event(Hub.ORGANIZATIONSIGNUP_EVENT.getName()).eventParams(Lists.newArrayList(event.organization)).build();
            circlesEvents.add(cEvent);
        }
    }

    public List<CirclesEvent> getAllCircleEvents() {
        return circlesEvents;
    }

    public void addManualEvent(String event, String... args) {
        log.info(String.format("Added Manual Event %s with parameters %s", event, List.of(args)));
        CirclesEvent cEvent = builder.event(event).eventParams(List.of(args)).build();
        circlesEvents.add(cEvent);
    }

    public String addOrgaHubSignupListener(OrgaHub orgaHub, TransactionReceipt trx) {
        String lastToken = "";
        for (OrgaHub.SignupEventResponse event : orgaHub.getSignupEvents(trx)) {
            log.info(String.format("Signed up User %s with Token %s", event.user, event.token));
            lastToken = event.token;
            CirclesEvent cEvent = builder.event(OrgaHub.SIGNUP_EVENT.getName()).eventParams(Lists.newArrayList(event.user, event.token)).build();
            circlesEvents.add(cEvent);
        }
        return lastToken;
    }

    public String addHubSignupListener(Hub orgaHub, TransactionReceipt trx) {
        String lastToken = "";
        for (Hub.SignupEventResponse event : orgaHub.getSignupEvents(trx)) {
            log.info(String.format("Signed up User %s with Token %s", event.user, event.token));
            lastToken = event.token;
            CirclesEvent cEvent = builder.event(Hub.SIGNUP_EVENT.getName()).eventParams(Lists.newArrayList(event.user, event.token)).build();
            circlesEvents.add(cEvent);
        }
        return lastToken;
    }

    public void addGCTOTrustListener(OrgaHub hub, TransactionReceipt trx) {
        for (OrgaHub.TrustEventResponse event : hub.getTrustEvents(trx)) {
            log.info(String.format("User %s trusted User %s", event.canSendTo, event.user));
            CirclesEvent cEvent = builder.event(OrgaHub.TRUST_EVENT.getName()).eventParams(Lists.newArrayList(event.canSendTo, event.user)).build();
            circlesEvents.add(cEvent);
        }

    }

    public void addGCTOTrustListener(Hub hub, TransactionReceipt trx) {
        for (Hub.TrustEventResponse event : hub.getTrustEvents(trx)) {
            log.info(String.format("User %s trusted User %s", event.canSendTo, event.user));
            CirclesEvent cEvent = builder.event(Hub.TRUST_EVENT.getName()).eventParams(Lists.newArrayList(event.canSendTo, event.user)).build();
            circlesEvents.add(cEvent);
        }

    }

    public void addTokenTransferEvent(String token, Credentials creds,  TransactionReceipt trx) {
        ERC20 tokenContract = ERC20.load(token, web3j, creds, new DefaultGasProvider());
        log.info("Retrieving TRANSFER events for token " + token);
        for (ERC20.TransferEventResponse event : tokenContract.getTransferEvents(trx)) {
            log.info(String.format("User %s transferred %s to User %s", event.from, event.value, event.to));
            CirclesEvent cEvent = builder.event(ERC20.TRANSFER_EVENT.getName()).eventParams(Lists.newArrayList(event.log.getAddress(), event.from, event.to, event.value.toString())).build();
            circlesEvents.add(cEvent);
        }

    }
}
