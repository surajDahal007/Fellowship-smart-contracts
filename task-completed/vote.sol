//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract cityPoll {
    
        struct City{
            string _name;
            uint256 votecount;
        }

        mapping(string => City) public cities; 
        
        mapping(address => bool) public admin;

        mapping(address =>bool) hasVoted; 

        constructor(string memory _cityname,address _admin){
            admin[msg.sender]=true;
            cities[_cityname]._name=_cityname;
            admin[_admin]=true;
        }

        event cityadded(string name);
        event voted(string indexed name,address voter);

        function addCity(string memory name) public {
            require(admin[msg.sender],"Not authorized");
            cities[name]._name=name;
            emit cityadded(name);
           
        }

   

        function vote(string memory name) public {
            require(!hasVoted[msg.sender],"Already voted");
            cities[name].votecount ++;
            hasVoted[msg.sender]=true;
            emit voted(name,msg.sender);
    }
}
