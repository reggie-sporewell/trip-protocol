// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/TripExperience.sol";

contract MintGifts is Script {
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

        string[51] memory names = [
            "Void Capsule", "Dawn Spore", "Velvet Haze", "Mystic Bloom", "Quartz Vein",
            "Spirit Drop", "Flame Dust", "Arctic Lotus", "Scarlet Thread", "Sage Whisper",
            "Comet Pill", "Brass Moss", "Platinum Tongue", "Indigo Dream", "Garnet Fog",
            "Smoke Petal", "Bronze Spiral", "Wraith Orchid", "Storm Seed", "Tin Tear",
            "Eclipse Shard", "Nova Flare", "Deep Pearl", "Vine Crown", "Amber Venom",
            "Pulse Fragment", "Ancient Root", "Glass Bone", "Phase Seed", "Tide Stone",
            "Obsidian Cap", "Prism Drop", "Ether Bloom", "Rust Spore", "Opal Thread",
            "Nebula Pill", "Coral Dust", "Onyx Lotus", "Verdant Haze", "Topaz Whisper",
            "Magma Shard", "Frost Vein", "Twilight Orchid", "Cerulean Dream", "Crimson Root",
            "Silver Fog", "Ember Crown", "Sapphire Tear", "Granite Seed", "Moonlit Bone",
            "Final Spore"
        ];

        vm.startBroadcast();

        for (uint256 i = 0; i < 51; i++) {
            bytes32 hash = hashes[i % 6];
            string memory name = names[i];
            uint8 tier = i % 10 < 6 ? 0 : (i % 10 < 9 ? 1 : 2);
            uint8 pmin = tier == 0 ? 1 : (tier == 1 ? 2 : 3);
            uint8 pmax = tier == 0 ? uint8(1 + (i % 3)) : (tier == 1 ? uint8(3 + (i % 2)) : 5);
            uint8 actual = pmin + uint8(i % (pmax - pmin + 1));
            bool isBlend = i % 7 == 0;
            bool isMutant = i % 13 == 0;

            xp.mintPill(owner, hash, name, tier, pmin, pmax, actual, isBlend, isMutant);
        }

        vm.stopBroadcast();
        console.log("Minted 51 gift pills");
    }
}
