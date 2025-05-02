//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

/**
 * @title MerkleAirdop
 * @author @batublockchain
 * @notice This contract allows users to claim tokenns based on a Merkle tree
 * @dev The contract uses OpenZeppelin's SafeERC20 for safe token transfers
 * and MerkleProof for verifying the Merkle proof.
 * The contract is designed to be used as a part of an airdrop mechanism,
 * where users can claim their tokens by providing a valid Merkle proof.
 */

contract MerkleAirdop {
    error MerkleAirdop__InvalidProof();
    error MerkleAirdop__AlreadyClaimed();

    using SafeERC20 for IERC20;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_token;
    mapping(address => bool) private s_hasClaimed;

    event Claimed(address indexed account, uint256 amount);

    constructor(bytes32 _merkleRoot, IERC20 _token) {
        i_merkleRoot = _merkleRoot;
        i_token = _token;
    }

    /**
     * @notice Allows a user to claim their tokens based on a Merkle proof
     * @param account The address of the user claiming the tokens
     * @param amount The amount of tokens to claim
     * @param proof The Merkle proof to verify the claim
     * @dev The function checks if the user has already claimed their tokens,
     * verifies the Merkle proof, and transfers the tokens to the user
     * @dev The function emits a Claimed event after a successful claim
     */
    function claim(
        address account,
        uint256 amount,
        bytes32[] calldata proof
    ) external {
        if (s_hasClaimed[account]) {
            revert MerkleAirdop__AlreadyClaimed();
        }
        bytes32 leaf = keccak256(
            bytes.concat(keccak256(abi.encode(account, amount)))
        );
        if (!MerkleProof.verify(proof, i_merkleRoot, leaf)) {
            revert MerkleAirdop__InvalidProof();
        }
        s_hasClaimed[account] = true;
        emit Claimed(msg.sender, amount);
        i_token.safeTransfer(account, amount);
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getToken() external view returns (IERC20) {
        return i_token;
    }
}
