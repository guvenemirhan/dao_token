// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../Management/staking/staking.sol";

abstract contract Ballot is Staking{
    
    constructor()
       
    {
        isOpenedVote=0;
    }
    modifier votingTime() {
        require(block.timestamp>=startTime && block.timestamp<=endTime, "Voting is close."); //modifying for voting periods
        _;
    }

    modifier isopenedVote() {
        require(isOpenedVote==0,"There is already a vote");
        _;
    }

    //function triggering "startVote" function for Type0 voting. 
    //Only token holders can use.
    function startVote(uint8 _time, uint8 _timeType, uint _choiceNumber) external { 
        DAOTOKEN.transferFrom(_msgSender(),address(this),.1 ether);
        startVoting(_time,_timeType,_choiceNumber,0);
    }
    //params:
    //voteTime(with timeType): Voting time
    //timeType: 0:minute, 1: hour 2: day, 3: month 4: year
    //choiceNumber: number of choices 
    //voteType is typeofVote 
    function startVoting(uint8 voteTime, uint8 timeType, uint choiceNumber,uint8 voteType) internal isopenedVote{
        require(timeType<=4 && timeType>=0,"Wrong time type.");
        require(DAOTOKEN.balanceOf(_msgSender())>=0,"You can not start voting.");
        numberofChoices = choiceNumber;
        startTime=uint64(block.timestamp);
        if(timeType==0) endTime= oneMinute*(voteTime)+(startTime);
        else if(timeType==1) endTime= oneHour*(voteTime)+(startTime);
        else if(timeType==2) endTime = oneDay*(voteTime)+(startTime);
        else if(timeType==3) endTime = oneMonth*(voteTime)+(startTime);
        else endTime = oneYear*(voteTime)+(startTime);
        if(counter>0){
        for(uint i=0; i<=counter;i++){
            delete _votes[i];
        }
        for(uint k=0; k<=numberofChoices;k++){
            delete _votenumber[k];
        }
        counter=0;
        }
        typeofVote=voteType;
        isOpenedVote=1;
    }


    //returns voting results
    function getWinner() public view returns(uint winner,uint votes) {
        require(block.timestamp>=endTime,"Voting is not over yet.");
        votes = 0;
        for (uint i = 1; i <=numberofChoices; i++) {
            if (_votenumber[i] > votes) {
                votes = _votenumber[i];
                winner = i;
            }
        }
        
        
    }

    function finishVoting() external {
        require(block.timestamp>=endTime && isOpenedVote==1,"You can not");
        isOpenedVote=0;
    }
    
    function getVote(uint choice) external votingTime{
        require(DAOTOKEN.balanceOf(_msgSender())>=0,"You are not authorized to vote.");
        require(choice>0 && choice<=numberofChoices,"Wrong Choice.");
        _votes[counter].voted = true;
        _votes[counter].vote = choice;
        _votenumber[choice] += 1;
        counter +=1;
    }


}
