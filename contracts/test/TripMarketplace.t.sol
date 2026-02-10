// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {TripExperience} from "../src/TripExperience.sol";
import {TripToken} from "../src/TripToken.sol";
import {TripMarketplace} from "../src/TripMarketplace.sol";

contract TripMarketplaceTest is Test {
    TripExperience public nft;
    TripToken public token;
    TripMarketplace public marketplace;

    address public owner = address(1);
    address public seller = address(2);
    address public buyer = address(3);
    address public feeRecipient = address(4);

    uint256 public constant INITIAL_BALANCE = 10_000 * 10**18;
    uint256 public constant LIST_PRICE = 100 * 10**18;
    uint256 public constant PROTOCOL_FEE_BPS = 250; // 2.5%

    function setUp() public {
        vm.startPrank(owner);
        
        // Deploy contracts
        nft = new TripExperience(owner);
        token = new TripToken(owner);
        marketplace = new TripMarketplace(
            address(nft),
            address(token),
            owner,
            feeRecipient,
            PROTOCOL_FEE_BPS
        );

        // Mint NFT to seller
        nft.mint(
            seller,
            "ipfs://test",
            "Ego Death",
            "ego_death",
            5,
            86400
        );

        // Give buyer some $TRIP
        token.mint(buyer, INITIAL_BALANCE);

        vm.stopPrank();
    }

    // ============ Listing Tests ============

    function test_List() public {
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        vm.stopPrank();

        TripMarketplace.Listing memory listing = marketplace.getListing(0);
        assertEq(listing.seller, seller);
        assertEq(listing.price, LIST_PRICE);
        assertTrue(listing.active);
    }

    function test_List_EmitsEvent() public {
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        
        vm.expectEmit(true, true, false, true);
        emit TripMarketplace.Listed(0, seller, LIST_PRICE);
        
        marketplace.list(0, LIST_PRICE);
        vm.stopPrank();
    }

    function test_List_RevertIfNotOwner() public {
        vm.prank(buyer);
        vm.expectRevert(TripMarketplace.NotTokenOwner.selector);
        marketplace.list(0, LIST_PRICE);
    }

    function test_List_RevertIfZeroPrice() public {
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        
        vm.expectRevert(TripMarketplace.PriceCannotBeZero.selector);
        marketplace.list(0, 0);
        vm.stopPrank();
    }

    function test_List_RevertIfAlreadyListed() public {
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        
        vm.expectRevert(TripMarketplace.AlreadyListed.selector);
        marketplace.list(0, LIST_PRICE * 2);
        vm.stopPrank();
    }

    // ============ Delist Tests ============

    function test_Delist() public {
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        marketplace.delist(0);
        vm.stopPrank();

        TripMarketplace.Listing memory listing = marketplace.getListing(0);
        assertFalse(listing.active);
    }

    function test_Delist_EmitsEvent() public {
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        
        vm.expectEmit(true, true, false, false);
        emit TripMarketplace.Delisted(0, seller);
        
        marketplace.delist(0);
        vm.stopPrank();
    }

    function test_Delist_RevertIfNotSeller() public {
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        vm.stopPrank();

        vm.prank(buyer);
        vm.expectRevert(TripMarketplace.NotTokenOwner.selector);
        marketplace.delist(0);
    }

    function test_Delist_RevertIfNotListed() public {
        vm.prank(seller);
        vm.expectRevert(TripMarketplace.ListingNotActive.selector);
        marketplace.delist(0);
    }

    // ============ Buy Tests ============

    function test_Buy() public {
        // List NFT
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        vm.stopPrank();

        // Buy NFT
        vm.startPrank(buyer);
        token.approve(address(marketplace), LIST_PRICE);
        marketplace.buy(0);
        vm.stopPrank();

        // Verify ownership transferred
        assertEq(nft.ownerOf(0), buyer);

        // Verify listing inactive
        assertFalse(marketplace.isListed(0));

        // Verify payment
        uint256 fee = (LIST_PRICE * PROTOCOL_FEE_BPS) / 10000;
        uint256 sellerProceeds = LIST_PRICE - fee;
        assertEq(token.balanceOf(seller), sellerProceeds);
        assertEq(token.balanceOf(feeRecipient), fee);
        assertEq(token.balanceOf(buyer), INITIAL_BALANCE - LIST_PRICE);
    }

    function test_Buy_EmitsEvent() public {
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        vm.stopPrank();

        uint256 fee = (LIST_PRICE * PROTOCOL_FEE_BPS) / 10000;

        vm.startPrank(buyer);
        token.approve(address(marketplace), LIST_PRICE);
        
        vm.expectEmit(true, true, true, true);
        emit TripMarketplace.Sold(0, seller, buyer, LIST_PRICE, fee);
        
        marketplace.buy(0);
        vm.stopPrank();
    }

    function test_Buy_RevertIfNotListed() public {
        vm.startPrank(buyer);
        token.approve(address(marketplace), LIST_PRICE);
        
        vm.expectRevert(TripMarketplace.ListingNotActive.selector);
        marketplace.buy(0);
        vm.stopPrank();
    }

    function test_Buy_RevertIfBuyingOwnListing() public {
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        token.approve(address(marketplace), LIST_PRICE);
        
        vm.expectRevert(TripMarketplace.CannotBuyOwnListing.selector);
        marketplace.buy(0);
        vm.stopPrank();
    }

    function test_Buy_ZeroFee() public {
        // Set fee to 0
        vm.prank(owner);
        marketplace.setProtocolFee(0);

        // List NFT
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        vm.stopPrank();

        // Buy NFT
        vm.startPrank(buyer);
        token.approve(address(marketplace), LIST_PRICE);
        marketplace.buy(0);
        vm.stopPrank();

        // Seller gets full amount
        assertEq(token.balanceOf(seller), LIST_PRICE);
        assertEq(token.balanceOf(feeRecipient), 0);
    }

    // ============ Admin Tests ============

    function test_SetProtocolFee() public {
        vm.prank(owner);
        marketplace.setProtocolFee(500); // 5%
        assertEq(marketplace.protocolFeeBps(), 500);
    }

    function test_SetProtocolFee_RevertIfTooHigh() public {
        vm.prank(owner);
        vm.expectRevert(TripMarketplace.FeeTooHigh.selector);
        marketplace.setProtocolFee(1001); // > 10%
    }

    function test_SetProtocolFee_RevertIfNotOwner() public {
        vm.prank(buyer);
        vm.expectRevert();
        marketplace.setProtocolFee(500);
    }

    function test_SetFeeRecipient() public {
        address newRecipient = address(5);
        vm.prank(owner);
        marketplace.setFeeRecipient(newRecipient);
        assertEq(marketplace.feeRecipient(), newRecipient);
    }

    // ============ View Tests ============

    function test_IsListed() public {
        assertFalse(marketplace.isListed(0));

        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, LIST_PRICE);
        vm.stopPrank();

        assertTrue(marketplace.isListed(0));
    }

    // ============ Fuzz Tests ============

    function testFuzz_List_AnyPrice(uint256 price) public {
        vm.assume(price > 0);
        vm.assume(price < type(uint256).max / 10000); // Prevent overflow in fee calc

        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, price);
        vm.stopPrank();

        TripMarketplace.Listing memory listing = marketplace.getListing(0);
        assertEq(listing.price, price);
    }

    function testFuzz_Buy_FeeCalculation(uint256 price, uint256 feeBps) public {
        vm.assume(price > 0);
        vm.assume(price < 1e30); // Reasonable price
        vm.assume(feeBps <= 1000); // Max 10%

        // Set fee
        vm.prank(owner);
        marketplace.setProtocolFee(feeBps);

        // Mint enough tokens
        vm.prank(owner);
        token.mint(buyer, price);

        // List
        vm.startPrank(seller);
        nft.approve(address(marketplace), 0);
        marketplace.list(0, price);
        vm.stopPrank();

        // Buy
        vm.startPrank(buyer);
        token.approve(address(marketplace), price);
        marketplace.buy(0);
        vm.stopPrank();

        // Verify
        uint256 expectedFee = (price * feeBps) / 10000;
        uint256 expectedSellerProceeds = price - expectedFee;
        assertEq(token.balanceOf(seller), expectedSellerProceeds);
    }
}
