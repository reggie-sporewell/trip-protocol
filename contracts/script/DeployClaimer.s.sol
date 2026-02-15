// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/TripClaimer.sol";

contract DeployClaimer is Script {
    function run() external {
        address xpAddr = 0xd0ABad931Ff7400Be94de98dF8982535c8Ad3f6F;
        address gifter = 0x4c2C3fF8D7DB6D78fFA6083F7F4cB8F498e3A455;
        vm.startBroadcast();
        TripClaimer claimer = new TripClaimer(xpAddr, gifter);
        console.log("TripClaimer:", address(claimer));
        vm.stopBroadcast();
    }
}
