// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/TripExperience.sol";
import "../src/TripToken.sol";
import "../src/TripMarketplace.sol";

contract DeployV2 is Script {
    function run() external {
        vm.startBroadcast();

        TripExperience xp = new TripExperience(msg.sender);
        console.log("TripExperience:", address(xp));

        TripToken token = new TripToken(msg.sender);
        console.log("TripToken:", address(token));

        TripMarketplace market = new TripMarketplace(address(xp), address(token));
        console.log("TripMarketplace:", address(market));

        // Grant marketplace minter role
        xp.setMinter(address(market), true);

        vm.stopBroadcast();
    }
}
