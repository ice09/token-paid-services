# token-paid-services

### Adjustments to the circles smart contracts

web3j currently only supports Solidity 0.7 only, therefore Solidity 0.8 specific instructions must be removed.

* Flatten contracts `OrgaHub`, `GroupCurrencyToken`, `GroupCurrencyTokenOwner`
* Replace `pragma solidity ^0.8.0` with `pragma solidity ^0.7.0`
* Remove `unchecked` from all contracts