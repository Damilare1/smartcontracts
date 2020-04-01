pragma solidity >=0.4.21 <0.7.0;

contract ItemManager is Ownable {
    
    enum SupplyChainState{Created, Paid, Delivered}
    
    struct S_Item{
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    mapping(uint => S_Item) public items;
    uint itemIndex;
    event SupplyChainStep(uint _index, uint _step, address _item);
    function createItem(string memory _identifier, uint _price) public onlyOwner{
        Item item = new Item(this, _price, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _price;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
    }
    
    function triggerPayment(uint _index) public payable {
        require(items[_index]._itemPrice == msg.value, "only full payment accepted");
        require(items[_index]._state == SupplyChainState.Created, "item is further in the chain"); 
        emit SupplyChainStep(_index, uint(items[_index]._state), address(items[_index]._item));
        items[_index]._state = SupplyChainState.Paid;
    }
    
    function triggerDelivery(uint _index) public onlyOwner {
        require(items[_index]._state == SupplyChainState.Paid, "item must be paid");
       items[_index]._state = SupplyChainState.Delivered;
       emit SupplyChainStep(_index, uint(items[_index]._state), address(items[_index]._item));
    }
}