// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
abstract contract Staking is ERC20 {
    uint8 private constant _NOT_ENTERED = 1;
    uint8 private constant _ENTERED = 2;
    uint8 private _status;
    uint8 internal isOpenedVote; //voting controller
    uint8 internal earlyElection;
    uint8 internal treasury;
    uint8 internal typeofVote; //Type0: general voting & parliamentary vote / Type1: presidintial election / Type2: judge vote 
    //unix timestamp values
    uint8 internal oneMinute=60;
    uint16 internal oneHour= 3600;
    uint32 internal oneDay=86400;
    uint32 internal oneMonth=2592000;
    uint32 internal oneYear=31536000;
    //
    uint64 internal startTime; // voting start time
    uint64 internal endTime; //voting end time
    uint64 internal counter; //counter for voting
    uint256 internal judgeElectionTime;
    uint256 internal electionTime;
    uint256 internal _usedFunds;
    uint256 internal numberofChoices= 1; //number of options in voting
    uint256 internal amount = 1 ether;
    address internal owner;
    address internal president; // President wallet address
    address internal _president;
    address[] internal candidateList; 
    address[] internal presidentList;
    address[] internal _judgecandiates;    
    address[] internal ministers;
    mapping (uint256 => uint256) internal _votenumber; // choice => number of votes
    mapping (uint256 => Voter) internal _votes; // voter id => vote 
    mapping (address => uint256) internal _stakers; 
    struct Voter {
        bool voted;  
        uint vote;   
    }
    IERC20 public immutable DAOTOKEN = IERC20(address(this));

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    } 

    function stake() external nonReentrant{
        require(_stakers[_msgSender()]==0,"You're already staked.");
        DAOTOKEN.transferFrom(_msgSender(),address(this),amount);
        _stakers[_msgSender()]= block.timestamp;
    }
    function claim() external nonReentrant{
        require(_stakers[_msgSender()]!=0,"You did not stake.");
        require(block.timestamp-(_stakers[_msgSender()])>=31536000);
        require(DAOTOKEN.balanceOf(address(this))>=amount,"Insufficient balance.");
        _stakers[_msgSender()]=0;
        DAOTOKEN.transfer(_msgSender(),amount);


    }
    function isStaked(address staker) public view returns(bool result){
        result=_stakers[staker]>0;
    }
}

