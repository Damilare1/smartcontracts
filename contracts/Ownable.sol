pragma solidity >=0.4.21 <0.7.0;


contract Ownable {
    address payable _owner;

    constructor() public {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(isOwner(), "you are not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return (msg.sender == _owner);
    }
}
