async function main() {
    const PropertyDeed = await ethers.getContractFactory("PropertyDeed")
  
    // Start deployment, returning a promise that resolves to a contract object
    const propertyDeed = await PropertyDeed.deploy()
    console.log("Contract deployed to address:", propertyDeed.address)
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })