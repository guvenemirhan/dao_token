// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ballot/governance.sol";


abstract contract Parliament is Ballot{
   constructor()
    {
        _usedFunds= 0;
        candidateList.push(address(_msgSender()));
        electionTime= block.timestamp+(oneMonth);
        earlyElection=0;
        treasury=0;
        _president=_msgSender();

    }
    modifier onlyPresident() {
        require(_msgSender()==_president,"You are not president");
        require(block.timestamp<=electionTime,"Your presidency is over.");
        _;
    }
    modifier onlyParliament() {
        require(ministers.length>0,"The government was not formed.");
        bool isMinister = false;
        for(uint i = 0 ; i < ministers.length; i++){
            if(address(_msgSender())==ministers[i]) isMinister=true;
        }
        require(_msgSender()==_president || isMinister,"You are not president or minister.");
        require(block.timestamp<=electionTime,"Your presidency is over.");
        _;
    }

   function candidate()external {
        for(uint i =0; i<presidentList.length;i++){
            if(address(_msgSender())==presidentList[i]){ revert("You can not be president a second time");}}
        require(isStaked(address(_msgSender())),"You are did not stake.");
        candidateList.push(address(_msgSender()));
       
   }

    function electionResult() external {
        require(typeofVote==1, "Do not found election");
        (uint id, )=getWinner();
        _president= candidateList[id];
        presidentList.push(_president);
        }
    function useFunds(uint256 amount) external onlyPresident{
        require(amount<=DAOTOKEN.balanceOf(address(this)));
        require(amount<=(DAOTOKEN.balanceOf(address(this))-(_usedFunds)),"Insufficient balance.");
        _usedFunds += amount;
        DAOTOKEN.transfer(_msgSender(), amount);

    }
    function appointMinister(address[] calldata _ministers) external onlyPresident {
        require(_ministers.length==4,"Wrong number of ministers.");
        for(uint i = 0 ; i <_ministers.length ; i++){
            ministers[i]=_ministers[i];
        }
    }
    function startParliamentaryVote(uint8 _time, uint8 _timeType, uint8 _choiceNumber) external onlyParliament {
        startVoting(_time,_timeType,_choiceNumber,0);
    }
}
