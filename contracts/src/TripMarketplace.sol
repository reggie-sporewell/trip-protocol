// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title TripMarketplace
 * @author trip-protocol
 * @notice Marketplace for trading TripExperience NFTs with $TRIP tokens
 * @dev Supports listing, delisting, and purchasing NFTs
 */
contract TripMarketplace is Ownable, ReentrancyGuard {
    /// @notice The TripExperience NFT contract
    IERC721 public immutable tripExperience;

    /// @notice The $TRIP token contract
    IERC20 public immutable tripToken;

    /// @notice Protocol fee in basis points (250 = 2.5%)
    uint256 public protocolFeeBps;

    /// @notice Fee recipient address
    address public feeRecipient;

    /// @notice Listing data structure
    struct Listing {
        address seller;
        uint256 tokenId;
        uint256 price;      // in $TRIP (18 decimals)
        bool active;
    }

    /// @notice Token ID => Listing
    mapping(uint256 => Listing) private _listings;

    /// @notice Emitted when an NFT is listed
    event Listed(
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price
    );

    /// @notice Emitted when an NFT is sold
    event Sold(
        uint256 indexed tokenId,
        address indexed seller,
        address indexed buyer,
        uint256 price,
        uint256 fee
    );

    /// @notice Emitted when a listing is cancelled
    event Delisted(uint256 indexed tokenId, address indexed seller);

    /// @notice Emitted when protocol fee is updated
    event ProtocolFeeUpdated(uint256 oldFee, uint256 newFee);

    /// @notice Emitted when fee recipient is updated
    event FeeRecipientUpdated(address oldRecipient, address newRecipient);

    /// @notice Error when caller doesn't own the NFT
    error NotTokenOwner();

    /// @notice Error when listing doesn't exist or isn't active
    error ListingNotActive();

    /// @notice Error when caller is the seller (can't buy own listing)
    error CannotBuyOwnListing();

    /// @notice Error when price is zero
    error PriceCannotBeZero();

    /// @notice Error when fee exceeds maximum (10%)
    error FeeTooHigh();

    /// @notice Error when NFT is already listed
    error AlreadyListed();

    /// @notice Maximum protocol fee (10%)
    uint256 public constant MAX_FEE_BPS = 1000;

    /**
     * @notice Contract constructor
     * @param _tripExperience Address of TripExperience NFT contract
     * @param _tripToken Address of $TRIP token contract
     * @param _initialOwner Address of contract owner
     * @param _feeRecipient Address to receive protocol fees
     * @param _protocolFeeBps Initial protocol fee in basis points
     */
    constructor(
        address _tripExperience,
        address _tripToken,
        address _initialOwner,
        address _feeRecipient,
        uint256 _protocolFeeBps
    ) Ownable(_initialOwner) {
        if (_protocolFeeBps > MAX_FEE_BPS) revert FeeTooHigh();
        
        tripExperience = IERC721(_tripExperience);
        tripToken = IERC20(_tripToken);
        feeRecipient = _feeRecipient;
        protocolFeeBps = _protocolFeeBps;
    }

    /**
     * @notice List an NFT for sale
     * @dev Caller must own the NFT and have approved this contract
     * @param tokenId The NFT token ID to list
     * @param price The price in $TRIP tokens (18 decimals)
     */
    function list(uint256 tokenId, uint256 price) external {
        if (price == 0) revert PriceCannotBeZero();
        if (tripExperience.ownerOf(tokenId) != msg.sender) revert NotTokenOwner();
        if (_listings[tokenId].active) revert AlreadyListed();

        _listings[tokenId] = Listing({
            seller: msg.sender,
            tokenId: tokenId,
            price: price,
            active: true
        });

        emit Listed(tokenId, msg.sender, price);
    }

    /**
     * @notice Cancel a listing
     * @dev Only the seller can delist
     * @param tokenId The NFT token ID to delist
     */
    function delist(uint256 tokenId) external {
        Listing storage listing = _listings[tokenId];
        if (!listing.active) revert ListingNotActive();
        if (listing.seller != msg.sender) revert NotTokenOwner();

        listing.active = false;

        emit Delisted(tokenId, msg.sender);
    }

    /**
     * @notice Purchase a listed NFT
     * @dev Caller must have approved $TRIP tokens for this contract
     * @param tokenId The NFT token ID to purchase
     */
    function buy(uint256 tokenId) external nonReentrant {
        Listing storage listing = _listings[tokenId];
        if (!listing.active) revert ListingNotActive();
        if (listing.seller == msg.sender) revert CannotBuyOwnListing();

        address seller = listing.seller;
        uint256 price = listing.price;

        // Mark as inactive before transfers (CEI pattern)
        listing.active = false;

        // Calculate fee
        uint256 fee = (price * protocolFeeBps) / 10000;
        uint256 sellerProceeds = price - fee;

        // Transfer $TRIP from buyer to seller
        tripToken.transferFrom(msg.sender, seller, sellerProceeds);

        // Transfer fee to recipient (if any)
        if (fee > 0 && feeRecipient != address(0)) {
            tripToken.transferFrom(msg.sender, feeRecipient, fee);
        }

        // Transfer NFT from seller to buyer
        tripExperience.transferFrom(seller, msg.sender, tokenId);

        emit Sold(tokenId, seller, msg.sender, price, fee);
    }

    /**
     * @notice Get listing details
     * @param tokenId The NFT token ID
     * @return The Listing struct
     */
    function getListing(uint256 tokenId) external view returns (Listing memory) {
        return _listings[tokenId];
    }

    /**
     * @notice Check if a token is listed
     * @param tokenId The NFT token ID
     * @return True if listed and active
     */
    function isListed(uint256 tokenId) external view returns (bool) {
        return _listings[tokenId].active;
    }

    /**
     * @notice Update protocol fee (owner only)
     * @param newFeeBps New fee in basis points
     */
    function setProtocolFee(uint256 newFeeBps) external onlyOwner {
        if (newFeeBps > MAX_FEE_BPS) revert FeeTooHigh();
        uint256 oldFee = protocolFeeBps;
        protocolFeeBps = newFeeBps;
        emit ProtocolFeeUpdated(oldFee, newFeeBps);
    }

    /**
     * @notice Update fee recipient (owner only)
     * @param newRecipient New fee recipient address
     */
    function setFeeRecipient(address newRecipient) external onlyOwner {
        address oldRecipient = feeRecipient;
        feeRecipient = newRecipient;
        emit FeeRecipientUpdated(oldRecipient, newRecipient);
    }
}
