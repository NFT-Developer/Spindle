// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// import "ipfs://QmQSKAspxf4FqfQLAomPsJB2jzF4ozyyq31J74oYq3D7Vm";

contract NFTSpindle is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;
    
    
    // Transact the tokens or changing the ownership of the tokens
    constructor(address marketplaceAddress) ERC721("SpindleNFT", "SPNL") {
        contractAddress = marketplaceAddress;
    }
    
    
    function safeMint(string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newSpindleNFT = _tokenIds.current();   
        
        _mint(msg.sender, newSpindleNFT);
        _setTokenURI(newSpindleNFT, tokenURI);
        setApprovalForAll(contractAddress, true);
    
        return newSpindleNFT;
    }
}