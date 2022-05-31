// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";
import "../parliament/parliament.sol";
abstract contract Judge is  Parliament{


    constructor()
    {

        judgeElectionTime= block.timestamp+(oneMonth);
        judge=_msgSender();

    }
    modifier electionPeriod() {
        uint nextTime= electionTime+(oneMonth);
        require(block.timestamp>=nextTime || earlyElection==0 || address(_msgSender())== judge, "Voting is close.");
        _;
    }
    modifier judgeElectionPeriod() {
        uint nextTime= electionTime+(oneMonth);
        require(block.timestamp>=nextTime, "Voting is close.");
        _;
    }
    modifier onlyJudge() {
        require(address(_msgSender())==judge, "You do not have permission to access this function.");
        _;
    }

   function election(uint8 voteTime, uint8 timeType ) external electionPeriod{
       if(electionTime<block.timestamp){ earlyElection=1;}
       uint candiates = candidateList.length;
       startVoting(voteTime, timeType, candiates,1);
   }
    function judgeElection(uint8 voteTime, uint8 timeType ) external judgeElectionPeriod{
       uint candiates = _judgecandiates.length;
       startVoting(voteTime, timeType, candiates,2);
   }
    function judgeCandidate()external {
        require(isStaked(address(_msgSender())),"You are did not stake.");
        _judgecandiates.push(address(_msgSender()));
       } 
   function judgeElectionResult() public {
        require(typeofVote==2, "Do not found election");
        (uint id,)=getWinner();
        judge= _judgecandiates[id];
        }
    function pauseTransactions()external onlyJudge{
        if(isPause==0){
            isPause=1;
        }
        else{
            isPause=0;
        }
    }
}
