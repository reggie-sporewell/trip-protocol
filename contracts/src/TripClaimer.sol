// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TripClaimer
 * @notice Free pill claim contract. Owner deposits pills, anyone can claim one.
 *         One claim per address. Owner must setApprovalForAll on the NFT contract.
 */
contract TripClaimer is Ownable {
    IERC721 public immutable nft;
    address public immutable gifter;
    
    mapping(address => bool) public hasClaimed;
    uint256[] public availablePills;
    uint256 public claimCount;

    event PillClaimed(address indexed claimer, uint256 indexed tokenId);
    event PillsDeposited(uint256 count);

    constructor(address _nft, address _gifter) Ownable(msg.sender) {
        nft = IERC721(_nft);
        gifter = _gifter;
    }

    /// @notice Owner adds token IDs available for claiming
    function depositPills(uint256[] calldata tokenIds) external onlyOwner {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            availablePills.push(tokenIds[i]);
        }
        emit PillsDeposited(tokenIds.length);
    }

    /// @notice Claim a random pill (one per address)
    function claim() external {
        require(!hasClaimed[msg.sender], "Already claimed");
        require(availablePills.length > 0, "No pills available");

        hasClaimed[msg.sender] = true;
        
        // Take the last pill (gas efficient)
        uint256 tokenId = availablePills[availablePills.length - 1];
        availablePills.pop();
        claimCount++;

        nft.transferFrom(gifter, msg.sender, tokenId);
        emit PillClaimed(msg.sender, tokenId);
    }

    /// @notice How many pills are left
    function remaining() external view returns (uint256) {
        return availablePills.length;
    }
}
