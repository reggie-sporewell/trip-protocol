// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TripExperience v2
 * @notice ERC-721 with blind consumption — substance details hidden until consumed
 */
contract TripExperience is ERC721, Ownable {
    struct Substance {
        bytes32 substanceHash;
        string crypticName;
        uint8 tier;
        uint8 potencyMin;
        uint8 potencyMax;
        uint8 actualPotency;
        bool isBlend;
        bool isMutant;
        bool consumed;
    }

    event SubstanceRevealed(
        uint256 indexed tokenId,
        string substanceType,
        uint8 potency,
        bool isBlend,
        string blendType,
        bool isMutant
    );

    uint256 private _nextTokenId;
    mapping(uint256 => Substance) private _substances;
    mapping(address => bool) public minters;

    modifier onlyMinter() {
        require(msg.sender == owner() || minters[msg.sender], "Not minter");
        _;
    }

    constructor(address initialOwner)
        ERC721("Trip Experience", "TRIPXP")
        Ownable(initialOwner)
    {}

    function setMinter(address minter, bool allowed) external onlyOwner {
        minters[minter] = allowed;
    }

    function mintPill(
        address to,
        bytes32 substanceHash,
        string calldata crypticName,
        uint8 tier,
        uint8 potencyMin,
        uint8 potencyMax,
        uint8 actualPotency,
        bool isBlend,
        bool isMutant
    ) external onlyMinter returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _substances[tokenId] = Substance({
            substanceHash: substanceHash,
            crypticName: crypticName,
            tier: tier,
            potencyMin: potencyMin,
            potencyMax: potencyMax,
            actualPotency: actualPotency,
            isBlend: isBlend,
            isMutant: isMutant,
            consumed: false
        });
        return tokenId;
    }

    function consume(uint256 tokenId, string calldata substanceType, string calldata blendType) external {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        Substance storage s = _substances[tokenId];
        require(!s.consumed, "Already consumed");
        require(keccak256(abi.encodePacked(substanceType)) == s.substanceHash, "Wrong substance");

        s.consumed = true;
        emit SubstanceRevealed(tokenId, substanceType, s.actualPotency, s.isBlend, blendType, s.isMutant);
    }

    function getSubstance(uint256 tokenId) external view returns (Substance memory) {
        _requireOwned(tokenId);
        Substance memory s = _substances[tokenId];
        if (!s.consumed) {
            s.substanceHash = bytes32(0);
            s.actualPotency = 0;
            s.isBlend = false;
            s.isMutant = false;
        }
        return s;
    }

    function totalSupply() external view returns (uint256) {
        return _nextTokenId;
    }
}
