// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Management/judge/judge.sol";
/**
 * Inheritance structure : staking => ballot => parliament => judge => daotoken
 */
contract DAO is Judge{



    constructor() ERC20("DAOTOKEN", "DAO",2000000 ether) //Name & symbol
    {
        owner= _msgSender();
    }
    modifier onlyOwner(){
        require(_msgSender()==owner,"You are not owner.");
        _;
    }
    function mint(address recipient_, uint256 amount_) external onlyOwner {
        _mint(recipient_, amount_);
    }


}