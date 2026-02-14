// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TripMarketplace
 * @notice Simple marketplace for TripExperience NFTs — pay in native MON
 */
contract TripMarketplace is Ownable {
    IERC721 public immutable nft;
    bool public paused;

    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(uint256 => Listing) public listings;

    event Listed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event Sold(uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 price);
    event Delisted(uint256 indexed tokenId);

    constructor(address _nft) Ownable(msg.sender) {
        nft = IERC721(_nft);
    }

    modifier whenNotPaused() {
        require(!paused, "Marketplace paused");
        _;
    }

    function pause() external onlyOwner { paused = true; }
    function unpause() external onlyOwner { paused = false; }

    /// @notice Emergency: force-delist any pill
    function forceDelistPill(uint256 tokenId) external onlyOwner {
        delete listings[tokenId];
        emit Delisted(tokenId);
    }

    /// @notice Emergency: withdraw stuck funds
    function withdraw() external onlyOwner {
        (bool ok,) = owner().call{value: address(this).balance}("");
        require(ok, "Withdraw failed");
    }

    function listPill(uint256 tokenId, uint256 price) external whenNotPaused {
        require(nft.ownerOf(tokenId) == msg.sender, "Not owner");
        require(price > 0, "Price must be > 0");
        listings[tokenId] = Listing(msg.sender, price);
        emit Listed(tokenId, msg.sender, price);
    }

    function buyPill(uint256 tokenId) external payable whenNotPaused {
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
