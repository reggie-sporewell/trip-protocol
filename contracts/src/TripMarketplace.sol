// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TripMarketplace
 * @notice Marketplace for TripExperience NFTs — pay in native MON or $TRIP
 *         Designed to support any ERC-20 via swap routing later.
 */
contract TripMarketplace is Ownable {
    IERC721 public immutable nft;
    IERC20 public immutable tripToken;
    bool public paused;

    struct Listing {
        address seller;
        uint256 price;
        address paymentToken; // address(0) = native MON, otherwise ERC-20
    }

    mapping(uint256 => Listing) public listings;

    // Accepted ERC-20 tokens (TRIP is always accepted; owner can add more later)
    mapping(address => bool) public acceptedTokens;

    event Listed(uint256 indexed tokenId, address indexed seller, uint256 price, address paymentToken);
    event Sold(uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 price, address paymentToken);
    event Delisted(uint256 indexed tokenId);
    event TokenAccepted(address indexed token, bool accepted);

    constructor(address _nft, address _tripToken) Ownable(msg.sender) {
        nft = IERC721(_nft);
        tripToken = IERC20(_tripToken);
        acceptedTokens[_tripToken] = true;
    }

    modifier whenNotPaused() {
        require(!paused, "Marketplace paused");
        _;
    }

    function pause() external onlyOwner { paused = true; }
    function unpause() external onlyOwner { paused = false; }

    /// @notice Owner can accept/reject ERC-20 tokens for future swap support
    function setAcceptedToken(address token, bool accepted) external onlyOwner {
        acceptedTokens[token] = accepted;
        emit TokenAccepted(token, accepted);
    }

    /// @notice Emergency: force-delist any pill
    function forceDelistPill(uint256 tokenId) external onlyOwner {
        delete listings[tokenId];
        emit Delisted(tokenId);
    }

    /// @notice Emergency: withdraw stuck native funds
    function withdraw() external onlyOwner {
        (bool ok,) = owner().call{value: address(this).balance}("");
        require(ok, "Withdraw failed");
    }

    /// @notice Emergency: withdraw stuck ERC-20
    function withdrawToken(address token) external onlyOwner {
        uint256 bal = IERC20(token).balanceOf(address(this));
        require(bal > 0, "No balance");
        IERC20(token).transfer(owner(), bal);
    }

    /// @notice List a pill for sale. paymentToken = address(0) for MON, or an accepted ERC-20.
    function listPill(uint256 tokenId, uint256 price, address paymentToken) external whenNotPaused {
        require(nft.ownerOf(tokenId) == msg.sender, "Not owner");
        require(price > 0, "Price must be > 0");
        require(
            paymentToken == address(0) || acceptedTokens[paymentToken],
            "Token not accepted"
        );
        listings[tokenId] = Listing(msg.sender, price, paymentToken);
        emit Listed(tokenId, msg.sender, price, paymentToken);
    }

    /// @notice Backwards-compatible: list for native MON
    function listPill(uint256 tokenId, uint256 price) external whenNotPaused {
        require(nft.ownerOf(tokenId) == msg.sender, "Not owner");
        require(price > 0, "Price must be > 0");
        listings[tokenId] = Listing(msg.sender, price, address(0));
        emit Listed(tokenId, msg.sender, price, address(0));
    }

    /// @notice Buy a pill. If listed in MON, send msg.value. If listed in ERC-20, approve first.
    function buyPill(uint256 tokenId) external payable whenNotPaused {
        Listing memory l = listings[tokenId];
        require(l.price > 0, "Not listed");
        delete listings[tokenId];

        if (l.paymentToken == address(0)) {
            // Native MON payment
            require(msg.value == l.price, "Wrong price");
            nft.transferFrom(l.seller, msg.sender, tokenId);
            (bool ok,) = l.seller.call{value: msg.value}("");
            require(ok, "Transfer failed");
        } else {
            // ERC-20 payment (e.g. $TRIP)
            require(msg.value == 0, "No MON needed for token payment");
            IERC20 token = IERC20(l.paymentToken);
            require(token.transferFrom(msg.sender, l.seller, l.price), "Token transfer failed");
            nft.transferFrom(l.seller, msg.sender, tokenId);
        }

        emit Sold(tokenId, l.seller, msg.sender, l.price, l.paymentToken);
    }

    function delistPill(uint256 tokenId) external {
        require(listings[tokenId].seller == msg.sender, "Not seller");
        delete listings[tokenId];
        emit Delisted(tokenId);
    }
}
