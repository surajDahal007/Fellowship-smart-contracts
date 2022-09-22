//SPDX-License-Identifier:MIT

pragma solidity ^0.5.0;

contract EventTickets {

     address public owner;

    uint   TICKET_PRICE = 100 wei;

    struct Event{
        string description;
        string websiteUrl;
        uint totalTickets;
        uint sales;
        mapping (address => uint) buyers;
        bool isOpen;
    }

    Event myEvent;

    event LogBuyTickets(address purchaser, uint tickets);
    event LogGetRefund(address requester, uint tickets);
    event LogEndSale(address owner, uint balance);

    modifier onlyOwner(){ 
        require(
            msg.sender == owner,
            "Only owner can call this."
        ); 
        _;
      }
     
    constructor (string memory _description, string memory _websiteUrl, uint _totalTickets) public {
        owner = msg.sender;
        myEvent.description = _description;
        myEvent.websiteUrl = _websiteUrl;
        myEvent.totalTickets = _totalTickets;
        myEvent.isOpen = true;
        myEvent.sales = 0;
    }

    function readEvent() public view
    returns(string memory description, string memory website, uint totalTickets, uint sales, bool isOpen) 
    {
        return (myEvent.description, myEvent.websiteUrl, myEvent.totalTickets, myEvent.sales, myEvent.isOpen);
    }


    function getBuyerTicketCount(address buyer) public view returns(uint tickets)
    {
      tickets = myEvent.buyers[buyer];
      return tickets;
    }
     

    function buyTickets(uint tickets) payable external {
        require(myEvent.isOpen==true);
        require(msg.value >= tickets*TICKET_PRICE);
        require( tickets <= (myEvent.totalTickets - myEvent.sales) );
        

        myEvent.buyers[msg.sender] = tickets;
        myEvent.sales = myEvent.sales + tickets;
        msg.sender.transfer(msg.value - tickets*TICKET_PRICE);
        emit LogBuyTickets(msg.sender,tickets);
    }
    

    function getRefund() public {
        require(myEvent.buyers[msg.sender]!=0 );
        

        uint ticketsPurchased = myEvent.buyers[msg.sender];
        myEvent.sales = myEvent.sales -  ticketsPurchased;
        msg.sender.transfer(ticketsPurchased*TICKET_PRICE);
        emit LogGetRefund(msg.sender,ticketsPurchased);
    }
    
    function endSale() public payable{
        require(msg.sender==owner); 

        myEvent.isOpen = false;
        msg.sender.transfer(myEvent.sales*TICKET_PRICE);
        emit LogEndSale(msg.sender,myEvent.sales*TICKET_PRICE);

    }
}