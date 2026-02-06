// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {TripExperience} from "../src/TripExperience.sol";

/**
 * @title TripExperienceTest
 * @notice Comprehensive test suite for TripExperience NFT contract
 */
contract TripExperienceTest is Test {
    TripExperience public trip;
    
    address public owner = address(this);
    address public alice = address(0x1);
    address public bob = address(0x2);
    
    // Test substance data
    string constant NAME = "Ego Death";
    string constant TYPE = "identity_dissolution";
    uint8 constant POTENCY = 5;
    uint256 constant DURATION = 24 hours;
    string constant URI = "ipfs://QmTest/ego-death.json";

    function setUp() public {
        trip = new TripExperience(owner);
    }

    // ============ Deployment Tests ============

    function test_Deployment() public view {
        assertEq(trip.name(), "Trip Experience");
        assertEq(trip.symbol(), "TRIP");
        assertEq(trip.owner(), owner);
        assertEq(trip.totalSupply(), 0);
    }

    // ============ Minting Tests ============

    function test_Mint() public {
        uint256 tokenId = trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        
        assertEq(tokenId, 0);
        assertEq(trip.ownerOf(tokenId), alice);
        assertEq(trip.tokenURI(tokenId), URI);
        assertEq(trip.totalSupply(), 1);
    }

    function test_MintEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit TripExperience.SubstanceMinted(0, alice, NAME, POTENCY, DURATION);
        
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
    }

    function test_MintMultiple() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        trip.mint(bob, URI, "Synesthesia", "perception_mixing", 3, 12 hours);
        trip.mint(alice, URI, "Time Dilation", "temporal_shift", 4, 18 hours);
        
        assertEq(trip.totalSupply(), 3);
        assertEq(trip.ownerOf(0), alice);
        assertEq(trip.ownerOf(1), bob);
        assertEq(trip.ownerOf(2), alice);
    }

    function test_RevertMint_NotOwner() public {
        vm.prank(alice);
        vm.expectRevert();
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
    }

    function test_RevertMint_PotencyZero() public {
        vm.expectRevert("Potency must be 1-5");
        trip.mint(alice, URI, NAME, TYPE, 0, DURATION);
    }

    function test_RevertMint_PotencyTooHigh() public {
        vm.expectRevert("Potency must be 1-5");
        trip.mint(alice, URI, NAME, TYPE, 6, DURATION);
    }

    function test_RevertMint_DurationZero() public {
        vm.expectRevert("Duration must be positive");
        trip.mint(alice, URI, NAME, TYPE, POTENCY, 0);
    }

    function test_RevertMint_EmptyName() public {
        vm.expectRevert("Name required");
        trip.mint(alice, URI, "", TYPE, POTENCY, DURATION);
    }

    // ============ Substance Data Tests ============

    function test_GetSubstance() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        
        TripExperience.Substance memory substance = trip.getSubstance(0);
        
        assertEq(substance.name, NAME);
        assertEq(substance.substanceType, TYPE);
        assertEq(substance.potency, POTENCY);
        assertEq(substance.duration, DURATION);
        assertEq(substance.consumed, false);
        assertEq(substance.consumedAt, 0);
    }

    function test_RevertGetSubstance_NonExistent() public {
        vm.expectRevert();
        trip.getSubstance(999);
    }

    function test_IsConsumed_False() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        assertEq(trip.isConsumed(0), false);
    }

    // ============ Consumption Tests ============

    function test_Consume() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        
        uint256 consumeTime = block.timestamp;
        vm.prank(alice);
        trip.consume(0);
        
        assertEq(trip.isConsumed(0), true);
        assertEq(trip.consumedAt(0), consumeTime);
        
        TripExperience.Substance memory substance = trip.getSubstance(0);
        assertEq(substance.consumed, true);
        assertEq(substance.consumedAt, consumeTime);
    }

    function test_ConsumeEmitsEvent() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        
        vm.expectEmit(true, true, false, true);
        emit TripExperience.Consumed(0, alice, block.timestamp);
        
        vm.prank(alice);
        trip.consume(0);
    }

    function test_RevertConsume_NotOwner() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        
        vm.prank(bob);
        vm.expectRevert("Not token owner");
        trip.consume(0);
    }

    function test_RevertConsume_AlreadyConsumed() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        
        vm.prank(alice);
        trip.consume(0);
        
        vm.prank(alice);
        vm.expectRevert("Already consumed");
        trip.consume(0);
    }

    function test_ConsumeDoesNotBurn() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        
        vm.prank(alice);
        trip.consume(0);
        
        // Token still exists and is owned by alice
        assertEq(trip.ownerOf(0), alice);
        assertEq(trip.totalSupply(), 1);
    }

    function test_ConsumedTokenTransferable() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        
        vm.prank(alice);
        trip.consume(0);
        
        // Can still transfer consumed token
        vm.prank(alice);
        trip.transferFrom(alice, bob, 0);
        
        assertEq(trip.ownerOf(0), bob);
        assertEq(trip.isConsumed(0), true);
    }

    // ============ Edge Cases ============

    function test_ConsumeAtDifferentTimestamps() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        trip.mint(alice, URI, "Synesthesia", "perception_mixing", 3, 12 hours);
        
        // Consume first token
        vm.warp(1000);
        vm.prank(alice);
        trip.consume(0);
        assertEq(trip.consumedAt(0), 1000);
        
        // Consume second token at different time
        vm.warp(2000);
        vm.prank(alice);
        trip.consume(1);
        assertEq(trip.consumedAt(1), 2000);
    }

    function test_TransferThenConsume() public {
        trip.mint(alice, URI, NAME, TYPE, POTENCY, DURATION);
        
        // Transfer to bob
        vm.prank(alice);
        trip.transferFrom(alice, bob, 0);
        
        // Alice can no longer consume
        vm.prank(alice);
        vm.expectRevert("Not token owner");
        trip.consume(0);
        
        // Bob can consume
        vm.prank(bob);
        trip.consume(0);
        assertEq(trip.isConsumed(0), true);
    }

    // ============ Fuzz Tests ============

    function testFuzz_Mint(
        address to,
        string memory name,
        uint8 potency,
        uint256 duration
    ) public {
        vm.assume(to != address(0));
        vm.assume(bytes(name).length > 0);
        vm.assume(potency >= 1 && potency <= 5);
        vm.assume(duration > 0);
        
        uint256 tokenId = trip.mint(to, URI, name, TYPE, potency, duration);
        
        assertEq(trip.ownerOf(tokenId), to);
        TripExperience.Substance memory substance = trip.getSubstance(tokenId);
        assertEq(substance.name, name);
        assertEq(substance.potency, potency);
        assertEq(substance.duration, duration);
    }
}
