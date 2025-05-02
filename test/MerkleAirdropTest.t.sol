// SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdop} from "../src/MerkleAirdrop.sol";
import {ERC20Mock} from "./mock/ERC20Mock.sol";

contract MerkleAirdopTest is Test {
    MerkleAirdop private merkleAirdrop;
    ERC20Mock private token;
    address private user = makeAddr("user");

    bytes32 private merkleRoot =
        0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 public amunt = 25000000000000000000;
    bytes32 proofOne =
        0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo =
        0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public proofs = [proofOne, proofTwo];

    function setUp() public {
        token = new ERC20Mock("Token", "TKN", 0, user);
        merkleAirdrop = new MerkleAirdop(merkleRoot, token);
        token.mint(address(merkleAirdrop), (amunt * 4));
    }

    function test_UsersCanClaim() public {
        uint256 initialBalance = token.balanceOf(user);
        vm.prank(user);
        merkleAirdrop.claim(user, amunt, proofs);
        uint256 finalBalance = token.balanceOf(user);
        assertEq(finalBalance, initialBalance + amunt);
    }
}
