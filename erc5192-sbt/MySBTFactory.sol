// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC5192.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SBT is ERC5192 {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;
    bool public isLocked;
    address public owner;

    modifier onlyOwner {
        require(msg.sender == owner, "Only an owner can call");
        _;
    }

    constructor(address _owner, string memory _name, string memory _symbol, bool _isLocked)
        ERC5192(_name, _symbol, _isLocked) {
        owner = _owner;
        isLocked = _isLocked;
    }

    function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        if (isLocked) emit Locked(newItemId);

        return newItemId;
    }
}

contract MySBTFactory {
    SBT public sbt;
    string public tokenName = "My SBT";
    string public tokenSymbol = "SBT";
    bool public isLocked = true; 

    constructor() {
        sbt = new SBT(address(this), tokenName, tokenSymbol, isLocked);
    }

    function mint(address recipient, string memory tokenURI) public returns (uint256) {
        return sbt.mintNFT(recipient, tokenURI);
    }

    // only for testing. it will be reverted since a token is locked.
    function transferTest(address recipient, uint256 tokenId) public {
        sbt.transferFrom(msg.sender, recipient, tokenId); 
    }
}