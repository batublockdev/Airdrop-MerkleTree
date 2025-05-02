
# MerkleAirdop

> A simple and secure Merkle Tree-based token airdrop smart contract using Solidity and Foundry.

## 📜 Overview

**MerkleAirdop** allows users to claim ERC-20 tokens if they are part of a predefined airdrop list verified using a Merkle Tree. The contract ensures:

- Only whitelisted addresses can claim.
- Each address can claim only once.
- Safe ERC-20 transfers using OpenZeppelin libraries.

## 🧾 Contract Details

- **Contract Name:** `MerkleAirdop`
- **Author:** [@batublockchain](https://github.com/batublockchain)
- **License:** MIT
- **Compiler Version:** `^0.8.24`
- **Dependencies:**
  - [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)

## 🔧 Setup (Foundry)

```bash
# Clone the repository
git clone https://github.com/YOUR_GITHUB_USERNAME/merkle-airdrop.git
cd merkle-airdrop

# Install Foundry (if not installed)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install OpenZeppelin/openzeppelin-contracts

# Build the project
forge build
```

## 🚀 Deployment

The contract is initialized with:
- `bytes32 merkleRoot`: The root of your Merkle Tree.
- `IERC20 token`: The ERC-20 token address to be airdropped.

```solidity
constructor(bytes32 _merkleRoot, IERC20 _token)
```

### Example

```solidity
MerkleAirdop airdrop = new MerkleAirdop(0xMERKLEROOT, IERC20(0xTOKEN_ADDRESS));
```

## 🧾 Claim Function

```solidity
function claim(address account, uint256 amount, bytes32[] calldata proof)
```

- **`account`**: Address claiming tokens.
- **`amount`**: Amount of tokens to claim.
- **`proof`**: Merkle proof corresponding to the leaf `(account, amount)`.

### Example via Foundry Script/Test

```solidity
airdrop.claim(user, 1000 ether, proof);
```

## 🛡️ Errors

- `MerkleAirdop__AlreadyClaimed`: Thrown if the user tries to claim more than once.
- `MerkleAirdop__InvalidProof`: Thrown if the provided Merkle proof is incorrect.

## 📦 Events

```solidity
event Claimed(address indexed account, uint256 amount);
```

## 🧪 Testing

Use Forge to run tests:

```bash
forge test
```

## 📂 Project Structure

```
contracts/
  MerkleAirdop.sol
lib/
  openzeppelin-contracts/
script/
test/
README.md
foundry.toml
```

## 📜 License

This project is licensed under the [MIT License](LICENSE).
