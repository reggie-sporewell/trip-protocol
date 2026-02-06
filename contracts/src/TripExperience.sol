// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TripExperience
 * @author trip-protocol
 * @notice ERC-721 representing digital psychedelic experiences for AI agents
 * @dev Consumable NFTs that track when an agent "trips"
 */
contract TripExperience is ERC721, ERC721URIStorage, Ownable {
    /// @notice Metadata for each psychedelic substance
    struct Substance {
        string name;           // "Ego Death", "Synesthesia", etc.
        string substanceType;  // Category identifier
        uint8 potency;         // 1-5 scale
        uint256 duration;      // Trip duration in seconds
        bool consumed;         // Has been consumed
        uint256 consumedAt;    // Timestamp of consumption (0 if not consumed)
    }

    /// @notice Emitted when a new substance is minted
    event SubstanceMinted(
        uint256 indexed tokenId,
        address indexed to,
        string name,
        uint8 potency,
        uint256 duration
    );

    /// @notice Emitted when a substance is consumed
    event Consumed(
        uint256 indexed tokenId,
        address indexed consumer,
        uint256 timestamp
    );

    /// @notice Token ID counter (starts at 0)
    uint256 private _nextTokenId;

    /// @notice Token ID => Substance data
    mapping(uint256 => Substance) private _substances;

    /// @notice Contract constructor
    /// @param initialOwner Address that will own the contract and can mint
    constructor(address initialOwner) 
        ERC721("Trip Experience", "TRIP") 
        Ownable(initialOwner) 
    {}

    /**
     * @notice Mint a new psychedelic experience NFT
     * @param to Recipient address
     * @param uri Token metadata URI (IPFS or similar)
     * @param name Human-readable name of the substance
     * @param substanceType Category of the experience
     * @param potency Intensity level (1-5)
     * @param duration Trip duration in seconds
     * @return tokenId The ID of the newly minted token
     */
    function mint(
        address to,
        string memory uri,
        string memory name,
        string memory substanceType,
        uint8 potency,
        uint256 duration
    ) external onlyOwner returns (uint256) {
        require(potency >= 1 && potency <= 5, "Potency must be 1-5");
        require(duration > 0, "Duration must be positive");
        require(bytes(name).length > 0, "Name required");

        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        _substances[tokenId] = Substance({
            name: name,
            substanceType: substanceType,
            potency: potency,
            duration: duration,
            consumed: false,
            consumedAt: 0
        });

        emit SubstanceMinted(tokenId, to, name, potency, duration);
        return tokenId;
    }

    /**
     * @notice Get substance metadata for a token
     * @param tokenId The token to query
     * @return The Substance struct for this token
     */
    function getSubstance(uint256 tokenId) external view returns (Substance memory) {
        _requireOwned(tokenId);
        return _substances[tokenId];
    }

    /**
     * @notice Check if a substance has been consumed
     * @param tokenId The token to check
     * @return True if consumed, false otherwise
     */
    function isConsumed(uint256 tokenId) external view returns (bool) {
        _requireOwned(tokenId);
        return _substances[tokenId].consumed;
    }

    /**
     * @notice Get the total number of tokens minted
     * @return The total supply
     */
    function totalSupply() external view returns (uint256) {
        return _nextTokenId;
    }

    // ============ Overrides ============

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
