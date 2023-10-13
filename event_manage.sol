// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract event_contract{
    struct Event{
    address organiser;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemain;

    }
    mapping (uint=>Event) public events;
    mapping (address=>mapping (uint=>uint)) public tickets;
    uint public nextId;
    
    function createEvent(string memory name,uint date,uint price,uint ticketCount) public{
        require(date>block.timestamp,"you have organize future base");
        require(ticketCount>0,"you can organize event more than 0 ticket");
    
        events[nextId]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }  
    function buyTicket(uint id,uint quantity) external payable   {
      require(events[id].date!=0,"event does not exist");
       require(events[id].date>block.timestamp,"event has occured");
       Event storage _event =events[id];
       require(msg.value==(_event.price*quantity),"there is not enough");
       require(_event.ticketRemain>=quantity,"not enough ticket");
       _event.ticketRemain-=quantity;
       tickets[msg.sender][id]+=quantity;


    }
}   