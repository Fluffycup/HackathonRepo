// deploy/00_deploy_your_contract.js

// const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("equityContract", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    // args: [ "Hello", ethers.utils.parseEther("1.5") ],
    log: true,
  });


  await deploy("PsuedoStableCoin", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    // args: [ "Hello", ethers.utils.parseEther("1.5") ],
    log: true,
  });

  await deploy("HomeContract", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    //args: [ "0x8A791620dd6260079BF849Dc5567aDC3F2FdC318", "0x8A791620dd6260079BF849Dc5567aDC3F2FdC318" ],
    log: true,
  });
  
    // Getting a previously deployed contract
    //const yourContract = await ethers.getContract("NostraERC20", deployer);
    //await YourContract.setPurpose("Hello");
  
    //To take ownership of yourContract using the ownable library uncomment next line and add the 
    //address you want to be the owner. 
    //await yourContract.transferOwnership("0x9e39Db853C9eDA78A283B332a915AEfe8E344Aa4");

    //const yourContract = await ethers.getContractAt('NostraERC20', "0x9e39Db853C9eDA78A283B332a915AEfe8E344Aa4") //<-- if you want to instantiate a version of a contract at a specific address!
 

  /*
  //If you want to send value to an address from the deployer
  const deployerWallet = ethers.provider.getSigner()
  await deployerWallet.sendTransaction({
    to: "0x34aA3F359A9D614239015126635CE7732c18fDF3",
    value: ethers.utils.parseEther("0.001")
  })
  */

  /*
  //If you want to send some ETH to a contract on deploy (make your constructor payable!)
  const yourContract = await deploy("YourContract", [], {
  value: ethers.utils.parseEther("0.05")
  });
  */

  /*
  //If you want to link a library into your contract:
  // reference: https://github.com/austintgriffith/scaffold-eth/blob/using-libraries-example/packages/hardhat/scripts/deploy.js#L19
  const yourContract = await deploy("YourContract", [], {}, {
   LibraryName: **LibraryAddress**
  });
  */
};
module.exports.tags = ["YourContract"];