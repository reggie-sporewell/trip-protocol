// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {TripExperience} from "../src/TripExperience.sol";

/**
 * @title Deploy
 * @notice Deployment script for TripExperience NFT contract
 * @dev Run with: forge script script/Deploy.s.sol --rpc-url monad_testnet --broadcast --account claude-monad
 */
contract Deploy is Script {
    function run() external {
        // Hardcode the deployer address to ensure consistency
        address deployer = 0x6B3c6c0Bf46246823EF9cF4eBa5032F3A6fa9d3C;
        
        console.log("Deploying TripExperience...");
        console.log("Owner will be:", deployer);
        
        vm.startBroadcast();
        
        TripExperience trip = new TripExperience(deployer);
        
        vm.stopBroadcast();
        
        console.log("TripExperience deployed at:", address(trip));
        console.log("Owner:", trip.owner());
    }
}
