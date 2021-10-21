// SPDX-License-Identifier: AGPL
pragma solidity ^0.7.0;

import "./lib/SafeMath.sol";
import "./GroupCurrencyTokenCentralizedEdition.sol";
import "./Hub.sol";

contract GroupCurrencyTokenOwnerCentralizedEdition {
    using SafeMath for uint256;

    address public token; // the safe/EOA/contract that deployed this token, can be changed by owner
    address public hub; // the address of the hub this token is associated with
    address public owner; 
    
    event Minted(address indexed receiver, address indexed collateral, uint256 amount);

    /// @dev modifier allowing function to be only called by the token owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _hub, address _token, address _owner) {
        owner = _owner;
        hub = _hub;
        token = _token;
    }
    
    function setup() public onlyOwner {
       Hub(hub).organizationSignup();
    }

    // Trust must be called by this contract (as a delegate) on Hub
    function trust(address _trustee) public onlyOwner {
        Hub(hub).trust(_trustee, 100);
    }

    function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
    }
    
    // This is a security-problematic minting (as not the complete path is verified) and has to be onlyOwner
    function mintTransitive(address dest, address src, uint wads) onlyOwner public {
        // approve GCT for CRC to be swapped so CRC can be transferred to Treasury
        ERC20(HubI(hub).userToToken(src)).approve(token, wads);
        uint mintedAmount = GroupCurrencyTokenCentralizedEdition(token).mint(HubI(hub).userToToken(src), wads);
        ERC20(token).transfer(dest, mintedAmount);
    }
    
}
