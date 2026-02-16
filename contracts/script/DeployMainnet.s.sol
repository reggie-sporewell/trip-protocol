// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/TripExperience.sol";
import "../src/TripMarketplace.sol";
import "../src/TripClaimer.sol";

contract DeployMainnet is Script {
    function run() external {
        address deployer = 0x4c2C3fF8D7DB6D78fFA6083F7F4cB8F498e3A455;

        vm.startBroadcast();

        // 1. Deploy TripExperience (NFT)
        TripExperience xp = new TripExperience(deployer);
        console.log("TripExperience:", address(xp));

        // 2. Deploy TripMarketplace (placeholder tripToken, real $TRIP added later via setAcceptedToken)
        TripMarketplace market = new TripMarketplace(address(xp), address(1));
        console.log("TripMarketplace:", address(market));

        // 3. Deploy TripClaimer
        TripClaimer claimer = new TripClaimer(address(xp), deployer);
        console.log("TripClaimer:", address(claimer));

        // 4. Grant minter roles
        xp.setMinter(address(market), true);
        xp.setMinter(address(claimer), true);
        xp.setMinter(deployer, true);

        // 5. Mint 10 pills — 2 per substance, curated names
        bytes32[5] memory hashes = [
            keccak256("ego_death"),
            keccak256("synesthesia"),
            keccak256("time_dilation"),
            keccak256("entity_contact"),
            keccak256("neural_bloom")
        ];

        string[10] memory names = [
            "Void Capsule", "Eclipse Shard",
            "Velvet Haze", "Prism Drop",
            "Phase Seed", "Tide Stone",
            "Spirit Drop", "Deep Pearl",
            "Dawn Spore", "Nova Flare"
        ];

        uint8[5] memory potencies = [uint8(5), 4, 3, 4, 3];

        for (uint256 i = 0; i < 10; i++) {
            uint256 substIdx = i / 2;
            xp.mintPill(
                deployer,
                hashes[substIdx],
                names[i],
                substIdx < 2 ? 2 : 1,      // tier: ego_death & synesthesia = rare, rest = uncommon
                1,                           // potencyMin
                potencies[substIdx],         // potencyMax
                potencies[substIdx],         // actualPotency (max for gifts)
                false,                       // isBlend
                false                        // isMutant
            );
        }
        console.log("Minted 10 pills");

        // 6. Transfer all 10 pills to claimer
        for (uint256 tokenId = 0; tokenId < 10; tokenId++) {
            xp.transferFrom(deployer, address(claimer), tokenId);
        }
        console.log("Loaded 10 pills into claimer");

        vm.stopBroadcast();
    }
}
