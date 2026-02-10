// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TripToken
 * @author trip-protocol
 * @notice Mock ERC-20 token for $TRIP on testnet
 * @dev Mintable by owner for testing purposes
 */
contract TripToken is ERC20, Ownable {
    /// @notice Emitted when tokens are minted
    event Minted(address indexed to, uint256 amount);

    /// @notice Contract constructor
    /// @param initialOwner Address that will own the contract and can mint
    constructor(address initialOwner) 
        ERC20("Trip Token", "TRIP") 
        Ownable(initialOwner) 
    {
        // Mint initial supply to owner (1 million TRIP)
        _mint(initialOwner, 1_000_000 * 10**18);
    }

    /**
     * @notice Mint new tokens (owner only, for testnet)
     * @param to Recipient address
     * @param amount Amount to mint (in wei)
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }

    /**
     * @notice Faucet function - anyone can claim 1000 TRIP (testnet only)
     * @dev Rate limiting should be added for production
     */
    function faucet() external {
        _mint(msg.sender, 1000 * 10**18);
        emit Minted(msg.sender, 1000 * 10**18);
    }
}
