const Migrations = artifacts.require("DAO");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
