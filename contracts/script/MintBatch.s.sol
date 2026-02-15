// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/TripExperience.sol";

contract MintBatch is Script {
    function run() external {
        address xpAddr = 0xd0ABad931Ff7400Be94de98dF8982535c8Ad3f6F;
        address owner = 0x4c2C3fF8D7DB6D78fFA6083F7F4cB8F498e3A455;
        TripExperience xp = TripExperience(xpAddr);

        bytes32[6] memory hashes = [
            keccak256("ego_death"),
            keccak256("synesthesia"),
            keccak256("time_dilation"),
            keccak256("entity_contact"),
            keccak256("reality_dissolving"),
            keccak256("integration")
        ];

        string[30] memory names = [
            "Shadow Capsule", "Neon Spore", "Violet Haze", "Midnight Bloom", "Crystal Vein",
            "Phantom Drop", "Ember Dust", "Frost Lotus", "Crimson Thread", "Jade Whisper",
            "Starfall Pill", "Iron Moss", "Silver Tongue", "Cobalt Dream", "Ruby Fog",
            "Ash Petal", "Gold Spiral", "Ghost Orchid", "Thunder Seed", "Copper Tear",
            "Lunar Shard", "Solar Flare", "Abyss Pearl", "Thorn Crown", "Silk Venom",
            "Echo Fragment", "Primal Root", "Hollow Bone", "Warp Seed", "Drift Stone"
        ];

        vm.startBroadcast();

        for (uint256 i = 0; i < 30; i++) {
            bytes32 hash = hashes[i % 6];
            string memory name = names[i];
            uint8 tier = i % 10 < 6 ? 0 : (i % 10 < 9 ? 1 : 2);
            uint8 pmin = tier == 0 ? 1 : (tier == 1 ? 2 : 3);
            uint8 pmax = tier == 0 ? uint8(1 + (i % 3)) : (tier == 1 ? uint8(3 + (i % 2)) : 5);
            uint8 actual = pmin + uint8(i % (pmax - pmin + 1));
            bool isBlend = i % 7 == 0;
            bool isMutant = i % 11 == 0;

            xp.mintPill(owner, hash, name, tier, pmin, pmax, actual, isBlend, isMutant);
        }

        vm.stopBroadcast();
        console.log("Minted 30 pills in a single tx batch");
    }
}
