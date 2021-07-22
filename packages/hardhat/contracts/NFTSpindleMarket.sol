// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract NFTSpindleMarket {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemSold;
    
    address payable owner;
    uint256 listingPrice = 0.020 ether;
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    struct MarketItem {
        uint itemId;
        address spindleNFTContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }
    
    // Fetching MarketItem with Id
    mapping (uint256 => MarketItem) private idToItem;
    
    event ItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );
    
    function getListingPrice(uint256 _newListingPrice) public view returns (uint256) {
        require(_newListingPrice > listingPrice, 'Price must be greater than or equal to listingPrice');
        return _newListingPrice;
    }
    
    function createMarketItem(address nftContract, uint256 tokenId, uint256 price) public payable {
        require(price > 0, "Price must be greater than 0");
        // require(msg.sender == listingPrice, "Price must be equal to listingPrice");
        
        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        
        idToItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );
        
        IERC721(nftContract).safeTransferFrom(msg.sender, address(this), tokenId);
        
        emit ItemCreated(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            price,
            false
        );
    }
    
    
    function soldMarketItem(address nftContract, uint256 itemId) public payable {
        uint256 price = idToItem[itemId].price;
        uint256 tokenId = idToItem[itemId].tokenId;
        
        require(msg.value == price, "Please submit the selling price");
        
        idToItem[itemId].seller.transfer(msg.value);
        IERC721(nftContract).safeTransferFrom(address(this), msg.sender, tokenId);
        idToItem[itemId].owner = payable(msg.sender);
        idToItem[itemId].sold = true;
        _itemSold.increment();
        payable(owner).transfer(listingPrice);
    }
    
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint itemCount = _itemIds.current();
        uint unsoldItemCount = _itemIds.current() - _itemSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i++) {
          if (idToItem[i + 1].owner == address(0)) {
            uint currentId = i + 1;
            MarketItem storage currentItem = idToItem[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;
          }
        }
        return items;
  }

 
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
      if (idToItem[i + 1].owner == msg.sender) {
        itemCount += 1;
      }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint i = 0; i < totalItemCount; i++) {
      if (idToItem[i + 1].owner == msg.sender) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }

  /* Returns only items a user has created */
  function fetchItemsCreated() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
      if (idToItem[i + 1].seller == msg.sender) {
        itemCount += 1;
      }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint i = 0; i < totalItemCount; i++) {
      if (idToItem[i + 1].seller == msg.sender) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
}