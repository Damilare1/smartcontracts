pragma solidity >=0.4.21 <0.7.0;

contract Item {
    uint public priceInWei;
    uint public index;
    uint public pricePaid;
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public{
        parentContract = _parentContract;
        priceInWei = _priceInWei;
        index = _index;
    }
    
    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
       (bool success, ) = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)",index));
       require(success, "The transaction wasn't successful, cancelling");
    }
    
    fallback () external {
        
    }
}