//// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Multisig {
    event Deposit(address indexed sender,uint256 amount); 
    event Submit(uint256 indexed txId);
    event Approve(address indexed owner,uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Exectute(uint indexed txId);

    address[] public owners;
    mapping(address => bool) public isOwner; // mapping to check if the address is owner
    uint public required; //how many need to approve


    // but we can map it into a double mapping
    struct Transaction{
        address to; // where to send // we need this
        uint value;// how much to send //we dont need this
        bytes data; // data to send // we dont need this
        bool executed;// if the transaction is executed // we need this
    }

    Transaction[] private transaction;
    mapping(uint => mapping(address => bool)) public approved;
    modifier onlyOwner() {
        require(isOwner[msg.sender],"not owner");
        _;
        
    }

    modifier txExist(uint _txId){
        require (_txId < transaction.length,"tx does not exist");
        _;
    }

    modifier notApprove(uint _txId){
        require(approved[_txId][msg.sender] == false,"txId already approved");
        _;
    }
    modifier notExecuted(uint _txId){
        require(!transaction[_txId].executed,"tx already executed");
        _;
    }

    constructor(address[] memory _owners,uint _requried) {
        require(_owners.length>0,"owners required");
        require(_requried > 0 && _requried <= _owners.length,"invalid required number of owners");

        for (uint i;i < _owners.length;i++){
            address owner = _owners[i];
            require(owner != address(0),"invalid owner");
            require(isOwner[owner] == false,"owner is not unqiue");
            isOwner[owner] = true;
            owners.push(owner);
                 }
            required = _requried;
    }

    receive() external payable{
        emit Deposit(msg.sender,msg.value);

    }

    function submit(address _to,uint _value,bytes calldata _data) 
    external onlyOwner{
        transaction.push(Transaction(_to,_value,_data,false));
        emit Submit(transaction.length -1);
    }

    function approve(uint _txId) external
     onlyOwner
     txExist(_txId)
     notApprove(_txId)
     notExecuted(_txId)
     {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender,_txId);


     }
     function getApprovelCount(uint _txId) public view returns(uint count){
        for (uint i;i < owners.length;i++){
            if (approved[_txId][owners[i]]){
                count +=1;
            }

        }

     }

     function execute(uint _txId) external txExist(_txId) notExecuted(_txId){
        require(getApprovelCount(_txId) >= required,"approvels not fullfilled");
        Transaction storage transactions = transaction[_txId];
        transactions.executed = true;
        (bool success,) = transactions.to.call{
            value: transactions.value}(transactions.data);
            require(success,"tx failed");
            emit Exectute(_txId);
        } 



    function getTransactionCount() external view returns(uint256){
        return transaction.length;
    }

    function getSpecificTransactionReport(uint256 index) external view returns(address,uint256,bool){
        Transaction memory tx1 = transaction[index];
        return (tx1.to,tx1.value,tx1.executed);
    }
    

     }






