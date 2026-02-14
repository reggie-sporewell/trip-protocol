// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/TripExperience.sol";

contract Deploy1 is Script {
    function run() external {
        vm.startBroadcast();
        TripExperience xp = new TripExperience(msg.sender);
        console.log("TripExperience:", address(xp));
        vm.stopBroadcast();
    }
}
