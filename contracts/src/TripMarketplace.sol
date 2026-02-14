// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title TripMarketplace
 * @notice Simple marketplace for TripExperience NFTs — pay in native MON
 */
contract TripMarketplace {
    IERC721 public immutable nft;

    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(uint256 => Listing) public listings;

    event Listed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event Sold(uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 price);
    event Delisted(uint256 indexed tokenId);

    constructor(address _nft) {
        nft = IERC721(_nft);
    }

    function listPill(uint256 tokenId, uint256 price) external {
        require(nft.ownerOf(tokenId) == msg.sender, "Not owner");
        require(price > 0, "Price must be > 0");
        listings[tokenId] = Listing(msg.sender, price);
        emit Listed(tokenId, msg.sender, price);
    }

    function buyPill(uint256 tokenId) external payable {
        Listing memory l = listings[tokenId];
        require(l.price > 0, "Not listed");
        require(msg.value == l.price, "Wrong price");
        delete listings[tokenId];
        nft.transferFrom(l.seller, msg.sender, tokenId);
        (bool ok,) = l.seller.call{value: msg.value}("");
        require(ok, "Transfer failed");
        emit Sold(tokenId, l.seller, msg.sender, l.price);
    }

    function delistPill(uint256 tokenId) external {
        require(listings[tokenId].seller == msg.sender, "Not seller");
        delete listings[tokenId];
        emit Delisted(tokenId);
    }
}
