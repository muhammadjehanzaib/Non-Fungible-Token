//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract testBasicNFT is Test {
    DeployBasicNFT deployBasicNft;
    BasicNFT basicNft;
    address public holder = makeAddr("holder");
    uint256 public constant STARTING_BALANCE = 10 ether;
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() external {
        deployBasicNft = new DeployBasicNFT();
        basicNft = deployBasicNft.run();
        vm.deal(holder, STARTING_BALANCE);
    }

    function testNameIsCorrect() external view {
        // assertEq(basicNft.name(),"Dogie");
        assert(keccak256(abi.encodePacked(basicNft.name())) == keccak256(abi.encodePacked("Dogie")));
    }

    function testSymbolIsCorrect() external view {
        assertEq(basicNft.symbol(), "Dog");
    }

    function testHavingNFTbalance() external {
        vm.prank(holder);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(holder) == 1);
    }

    function testSymbolByUsingKeccakHash() external view {
        assertEq(keccak256(abi.encodePacked(basicNft.symbol())), keccak256(abi.encodePacked("Dog")));
    }

    function testMultipleNFT() external {
        vm.prank(holder);
        basicNft.mintNft(PUG);
        vm.prank(holder);
        basicNft.mintNft("ipfs://another-uri");

        assertEq(basicNft.balanceOf(holder), 2);
    }

    function testOwnership() external {
        vm.startPrank(holder);
        basicNft.mintNft(PUG);
        basicNft.mintNft("ipfs://another-uri");
        vm.stopPrank();
        assertEq(basicNft.ownerOf(0), holder);
        assertEq(basicNft.ownerOf(1), holder);

    }
}
