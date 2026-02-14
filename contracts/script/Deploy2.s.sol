// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/TripToken.sol";

contract Deploy2 is Script {
    function run() external {
        vm.startBroadcast();
        TripToken token = new TripToken(msg.sender);
        console.log("TripToken:", address(token));
        vm.stopBroadcast();
    }
}
