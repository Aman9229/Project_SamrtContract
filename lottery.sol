// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

// Lottery System

contract Lottery{
    address public manager;
    address payable[] public participants; 
    
    constructor(){
       manager=msg.sender; // global variable

    }
     receive()external payable {   // participants send some value;
       require(msg.value==1 ether); 
        participants.push(payable(msg.sender));
    }
    function getBalance() public  view returns(uint){ 
         require(msg.sender==manager); 
         return address(this).balance;
    }
    function randomSelect() public view returns(uint){
       return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,participants.length))); // only testing project but not use actually
   
    }
    function selectWinner() public {
       require(msg.sender==manager);
       uint  r= randomSelect();
       require(participants.length>=3,"lottery is not valid");
       uint index= r % participants.length;
       address payable winner;
       winner=participants[index];
       winner.transfer(getBalance());
       participants= new address payable[](0);

    }
    function allparticipants() public  view returns (address payable [] memory){
      return participants;
    }
}
 