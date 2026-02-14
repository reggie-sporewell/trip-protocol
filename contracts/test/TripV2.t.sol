// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/TripExperience.sol";
import "../src/TripToken.sol";
import "../src/TripMarketplace.sol";

contract TripV2Test is Test {
    TripExperience xp;
    TripToken token;
    TripMarketplace market;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        xp = new TripExperience(address(this));
        token = new TripToken(address(this));
        market = new TripMarketplace(address(xp), address(token));
        xp.setMinter(address(market), true);
    }

    function testMintAndConsume() public {
        bytes32 hash = keccak256(abi.encodePacked("LSD"));
        uint256 id = xp.mintPill(alice, hash, "Blue Pill #1", 1, 50, 80, 72, false, false);

        // Before consume, hidden fields should be zeroed
        TripExperience.Substance memory s = xp.getSubstance(id);
        assertEq(s.actualPotency, 0);
        assertFalse(s.consumed);

        // Consume
        vm.prank(alice);
        xp.consume(id, "LSD", "");

        s = xp.getSubstance(id);
        assertTrue(s.consumed);
        assertEq(s.actualPotency, 72);
    }

    function testTokenFaucet() public {
        token.faucet(alice, 1000e18);
        assertEq(token.balanceOf(alice), 1000e18);
    }

    function testMarketplace() public {
        bytes32 hash = keccak256(abi.encodePacked("DMT"));
        uint256 id = xp.mintPill(alice, hash, "Spirit Molecule", 2, 80, 100, 95, false, true);

        vm.startPrank(alice);
        xp.approve(address(market), id);
        market.listPill(id, 1 ether);
        vm.stopPrank();

        vm.deal(bob, 2 ether);
        vm.prank(bob);
        market.buyPill{value: 1 ether}(id);

        assertEq(xp.ownerOf(id), bob);
    }
}
