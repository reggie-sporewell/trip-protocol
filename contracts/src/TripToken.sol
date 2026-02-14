// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TripToken
 * @notice $TRIP ERC-20 token for Trip Protocol
 */
contract TripToken is ERC20, Ownable {
    constructor(address initialOwner)
        ERC20("Trip Token", "$TRIP")
        Ownable(initialOwner)
    {
        _mint(initialOwner, 1_000_000 * 10 ** 18);
    }

    function faucet(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /// @notice Public testnet faucet — anyone can claim 1000 $TRIP
    uint256 public constant FAUCET_AMOUNT = 1000 * 10 ** 18;
    mapping(address => uint256) public lastClaim;

    function claim() external {
        require(block.timestamp - lastClaim[msg.sender] >= 1 hours, "Wait 1h between claims");
        lastClaim[msg.sender] = block.timestamp;
        _mint(msg.sender, FAUCET_AMOUNT);
    }
}
