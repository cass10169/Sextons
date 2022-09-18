const hre = require("hardhat");

const main = async () => {

  const Manager = await hre.ethers.getContractFactory("Manager");
  const manager = await Manager.deploy();

  await manager.deployed();

  console.log("Manager deployed to:", manager.address);
}


const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

runMain();
