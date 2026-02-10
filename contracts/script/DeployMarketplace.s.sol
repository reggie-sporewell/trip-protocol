// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {TripToken} from "../src/TripToken.sol";
import {TripMarketplace} from "../src/TripMarketplace.sol";

contract DeployMarketplaceScript is Script {
    // Existing TripExperience contract on Monad testnet
    address constant TRIP_EXPERIENCE = 0x8E9257e777c64e30E373f7359ABF8301d749A521;
    
    // Protocol fee: 2.5%
    uint256 constant PROTOCOL_FEE_BPS = 250;

    function run() external {
        vm.startBroadcast();

        // Get deployer address
        address deployer = msg.sender;
        console.log("Deployer:", deployer);

        // Deploy TripToken
        TripToken token = new TripToken(deployer);
        console.log("TripToken deployed at:", address(token));

        // Deploy TripMarketplace
        TripMarketplace marketplace = new TripMarketplace(
            TRIP_EXPERIENCE,
            address(token),
            deployer,
            deployer, // fee recipient = deployer for now
            PROTOCOL_FEE_BPS
        );
        console.log("TripMarketplace deployed at:", address(marketplace));

        vm.stopBroadcast();

        // Summary
        console.log("");
        console.log("=== Deployment Summary ===");
        console.log("TripExperience (existing):", TRIP_EXPERIENCE);
        console.log("TripToken:", address(token));
        console.log("TripMarketplace:", address(marketplace));
        console.log("Protocol Fee:", PROTOCOL_FEE_BPS, "bps (2.5%)");
    }
}
