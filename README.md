# token-paid-services

## Documentation

see https://github.com/ice09/circles-contracts/blob/master/contracts/GroupCurrencyTokenOwnerReadme.md

## Setup

* Run `hardhat` with `npx hardhat node`

## Run

* Start the application with `mvn spring-boot:run`
* Open your browser at http://localhost:8889/swagger-ui.html
* Call the services `initialize`, `approve` and `call` in this sequence

## Testing

* Run Unittest `TokenPaidServiceApplicationTests`

## Remix Editing

* Run `startRemixDaemon.sh` with `remixd` installed to edit contracts in Remix-IDE.

### Adjustments to the circles smart contracts

web3j currently only supports Solidity 0.7 only, therefore Solidity 0.8 specific instructions must be removed.

* Download `Address.sol` and `SafeMath.sol` from OpenZeppelin Repo to store locally at `lib`
* Replace `pragma solidity ^0.8.0` with `pragma solidity ^0.7.0`
* Remove `unchecked` from all contracts
