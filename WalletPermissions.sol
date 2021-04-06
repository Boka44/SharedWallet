pragma solidity ^0.8.1;

contract WalletPermissions {
    
    address owner;
    
    mapping(address => uint) public allowances;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You're not the owner");
        _;
    }
    
    modifier onlyAllowanced() {
        if(msg.sender != owner) {
            require(allowances[msg.sender] > 0, "You don't have an allowance");
        }
        _;
    }
}