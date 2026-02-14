// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/TripExperience.sol";
import "../src/TripMarketplace.sol";

contract Deploy3 is Script {
    function run() external {
        address xpAddr = 0xd0ABad931Ff7400Be94de98dF8982535c8Ad3f6F;
        address tripAddr = 0x116F752CA5C8723ab466458DeeE8EB4E853a3934;
        vm.startBroadcast();
        TripMarketplace market = new TripMarketplace(xpAddr, tripAddr);
        console.log("TripMarketplace:", address(market));
        TripExperience(xpAddr).setMinter(address(market), true);
        vm.stopBroadcast();
    }
}
