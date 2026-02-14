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
}
