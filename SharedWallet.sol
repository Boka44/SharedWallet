pragma solidity ^0.8.1;

import "./WalletPermissions.sol";

contract SharedWallet is WalletPermissions{
    
    event MoenySent(address indexed _to, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    uint public totalAmount;
    
    struct Transaction {
        bool isDeposit;
        address user;
        uint amount;
        uint timestamp;
    }
    
    uint totalTransactions;
    
    mapping(uint => Transaction) public transactions;
    
    constructor() {
        owner = msg.sender;
    }
    
    function getEthBalance() view public returns(uint){
        return address(this).balance;
    }
    
    function deposit() public payable {
        transactions[totalTransactions + 1] = Transaction(true, msg.sender, msg.value, block.timestamp);
        totalAmount += msg.value;
        totalTransactions++;
        emit MoneyReceived(msg.sender, msg.value);
    }
    
    receive() external payable {
        deposit();
    }
    
    fallback() external payable {
        deposit();
    }
    
    function withdraw(address payable _to, uint _amount) public onlyAllowanced {
        if(msg.sender != owner) {
             require(allowances[msg.sender] >= _amount,"Your allowance is too low");
        }
        assert(totalAmount - _amount >= 0);
        transactions[totalTransactions + 1] = Transaction(false, msg.sender, _amount, block.timestamp);
        totalAmount -= _amount;
        totalTransactions++;
        // assuming that their allowance is a total amount that they can access:
        if(msg.sender != owner) {
            allowances[msg.sender] -= _amount;
        }
        _to.transfer(_amount);
        emit MoenySent(_to, _amount);
    }
    
    function changeAllowance(address _user, uint _allowance) public onlyOwner {
        allowances[_user] = _allowance;
    }
}