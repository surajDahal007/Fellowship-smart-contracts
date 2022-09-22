// SPDX-License-Identifier:MIT

pragma solidity ^0.8.10;

contract SupplyChain {

  /* set owner */
  address public owner;

  /* Add a variable called skuCount to track the most recent sku # */
  uint256 public skuCount;

  /* Add a line that creates a public mapping that maps the SKU (a number) to an Item.
     Call this mappings items
  */

  mapping(uint => Item) items;

  /* Add a line that creates an enum called State. This should have 4 states
    ForSale
    Sold
    Shipped
    Received
    (declaring them in this order is important for testing)
  */
  enum State {ForSale,Sold,Shipped,Received}

  /* Create a struct named Item.
    Here, add a name, sku, price, state, seller, and buyer
    We've left you to figure out what the appropriate types are,
    if you need help you can ask around :)
    Be sure to add "payable" to addresses that will be handling value transfer
  */
  struct Item{
      string name;
      uint sku;
      uint price;
      State status;
      address payable seller;
      address payable buyer; 
  }

  /* Create 4 events with the same name as each possible State (see above)
    Prefix each event with "Log" for clarity, so the forSale event will be called "LogForSale"
    Each event should accept one argument, the sku */

    event LogForSale(uint sku);
    event LogSold(uint sku);
    event LogShipped(uint sku);
    event LogRecieved(uint sku);

/* Create a modifer that checks if the msg.sender is the owner of the contract */
modifier onlyOwner{
   require(owner == msg.sender,"caller is not owner");
   _;
}

  modifier verifyCaller (address _address) { 
    require (msg.sender == _address);
     _;
     }

   

  modifier paidEnough(uint _price) { 
    require(msg.value >= _price,"insufficient amount");
   
     _;
    
     }


  modifier checkValue(uint _sku) {
    if(msg.value > items[_sku].price){


    uint _price = items[_sku].price;
    payable(items[_sku].seller).transfer(msg.value - _price);
     
    }

    else{
       payable(items[_sku].seller).transfer(msg.value);
    }
    _;

  }

  /* For each of the following modifiers, use what you learned about modifiers
   to give them functionality. For example, the forSale modifier should require
   that the item with the given sku has the state ForSale. 
   Note that the uninitialized Item.State is 0, which is also the index of the ForSale value,
   so checking that Item.State == ForSale is not sufficient to check that an Item is for sale.
   Hint: What item properties will be non-zero when an Item has been added?
   */
  modifier forSale(uint _sku){
    require(items[_sku].status == State.ForSale,"Item is not on sale");
    require(items[_sku].price !=0,"Sale price can't be zero");
    _;
  }
  modifier sold(uint _sku){
     require(items[_sku].status == State.Sold,"Item is not sold");
     _;
  }
  
    modifier shipped(uint _sku){
     require(items[_sku].status == State.Shipped,"Item is not shipped");
     _;
  }

     modifier recieved(uint _sku){
     require(items[_sku].status == State.Received,"Item is not returned");
     _;
  }
  


  constructor()  {
    /* Here, set the owner as the person who instantiated the contract */
    owner=msg.sender;
    skuCount=0;
    
  }

  function addItem(string memory _name, uint _price) public returns(bool){
    emit LogForSale(skuCount);
    items[skuCount] = Item({name: _name, sku: skuCount, price: _price, status: State.ForSale, seller: payable(msg.sender) ,buyer: payable(address(0))});
    skuCount = skuCount + 1;
    return true;
  }

  /* Add a keyword so the function can be paid. This function should transfer money
    to the seller, set the buyer as the person who called this transaction, and set the state
    to Sold. Be careful, this function should use 3 modifiers to check if the item is for sale,
    if the buyer paid enough, and check the value after the function is called to make sure the buyer is
    refunded any excess ether sent. Remember to call the event associated with this function!*/

  function buyItem(uint _sku) public forSale(_sku) paidEnough(items[_sku].price) checkValue(_sku) payable {
     require( items[_sku].seller != msg.sender,"Being seller, you can't buy yourself");
    items[_sku].status=State.Sold;
    items[_sku].buyer=payable(msg.sender);
    payable(msg.sender).transfer(address(this).balance);
    emit LogSold(_sku);

  }

  /* Add 2 modifiers to check if the item is sold already, and that the person calling this function
  is the seller. Change the state of the item to shipped. Remember to call the event associated with this function!*/
  function shipItem (uint sku) public sold(sku) verifyCaller(msg.sender) {
    require( items[sku].seller == msg.sender,"you are not the seller");
    items[sku].status=State.Shipped;
    emit LogShipped(sku);
  }

  /* Add 2 modifiers to check if the item is shipped already, and that the person calling this function
  is the buyer. Change the state of the item to received. Remember to call the event associated with this function!*/
  function receiveItem(uint sku) public  shipped(sku) verifyCaller(msg.sender){
     require(items[sku].buyer == msg.sender ,"you are not the buyer");
     items[sku].status=State.Received;
     emit LogRecieved(sku);
  }

  /* We have these functions completed so we can run tests, just ignore it :) */
  function fetchItem(uint _sku) public view returns (string memory name, uint sku, uint price, uint status, address seller, address buyer) {
    name = items[_sku].name;
    sku = items[_sku].sku;
    price = items[_sku].price;
    status = uint(items[_sku].status);
    seller = items[_sku].seller;
    buyer = items[_sku].buyer;
    return (name, sku, price, status, seller, buyer);
  }

}