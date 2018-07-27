var ProductAuction = artifacts.require("./ProductAuction");
var ProductAuctionBidding = artifacts.require("./ProductAuctionBidding");
//var med1 = artifacts.require("./med1");
module.exports = function(deployer) {
  deployer.deploy(ProductAuction).then(
     DeployedContract =>{
     deployer.deploy(ProductAuctionBidding,DeployedContract.address);
     }
  )
};