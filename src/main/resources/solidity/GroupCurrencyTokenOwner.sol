// SPDX-License-Identifier: AGPL
pragma solidity ^0.7.0;

import "./lib/SafeMath.sol";
import "./GroupCurrencyToken.sol";
import "./OrgaHub.sol";

contract GroupCurrencyTokenOwner {
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
       OrgaHub(hub).organizationSignup();
       GroupCurrencyToken(token).addDelegatedTrustee(address(this));
    }
    
    function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
    }
    
    // Group currently is created from collateral tokens. Collateral is directly part of the directMembers dictionary.
    function mintTransitive(address[] memory tokenOwners, address[] memory srcs, address[] memory dests, uint[] memory wads) public {
        require(tokenOwners[0] == msg.sender, "First token owner must be message sender.");
        uint lastElementIndex = tokenOwners.length-1;
        require(dests[lastElementIndex] == address(this), "GroupCurrencyTokenOwner must be final receiver in the path.");
        OrgaHub(hub).transferThrough(tokenOwners, srcs, dests, wads);
        ERC20(HubI(hub).userToToken(tokenOwners[lastElementIndex])).approve(token, wads[lastElementIndex]);
        uint mintedAmount = GroupCurrencyToken(token).mintDelegate(address(this), HubI(hub).userToToken(tokenOwners[lastElementIndex]), wads[lastElementIndex]);
        GroupCurrencyToken(token).transfer(srcs[0], mintedAmount);
    }
        
    // Trust must be called by this contract (as a delegate) on Hub
    function trust(address _trustee) public onlyOwner {
        OrgaHub(hub).trust(_trustee, 100);
    }
    
}
