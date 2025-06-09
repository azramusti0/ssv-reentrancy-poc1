# SSV Reentrancy PoCs

This repository contains two Proof of Concepts for a reentrancy vulnerability in SSVOperators.

## 1. real-poc
- Forked mainnet test using the real deployed SSV contract.
- Reentrancy logic is structurally present, but fails due to `msg.sender != operator.owner`.

## 2. mock-poc
- Mock contract with access control removed.
- Reentrancy attack succeeds and drains 5 ETH.
- Proves that if access control is bypassed or misconfigured, the system can be fully exploited.

## How to run
```bash
cd mock-poc   # or real-poc
npm install
npx hardhat test
