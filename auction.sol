// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8;
contract Buy{
    struct Auction{
        uint id;
        address payable seller;
        string name;
        string description;
        uint min;
        uint bestOfferId;
        uint[] offerIds;

    }
    struct Offer{
        uint id;
        uint auctionId;
        address payable buyer;
        uint price;
    }
    // all auction value stored 
    mapping (uint=>Auction)private auctions;
    mapping (uint=>Offer) private offers;
    mapping (address=>uint) private auctionList;
    mapping (address=>uint[]) private offerList;

// variable to stored data
    uint private  newAuctionId=1;
    uint private  newOfferId=1;

  
    //calldata is read variable and low cost of gas.like as memory 
// here we create Auction 
function createAuction(string calldata _name, string calldata _description,uint _min) external {
require(_min>0,"min value must be greater than 0");

uint[]memory offerIds=new uint[](0);

auctions[newAuctionId]=Auction(newAuctionId,payable(msg.sender),_name,_description,_min,0,offerIds);
auctionList[msg.sender].push(newAuctionId);
newAuctionId++;
}


// we create Offer for Auction
function createOffer(uint _auctionId) external payable { 
    Auction storage auction=auctions[_auctionId];
    Offer storage bestOffer=offers[auction.bestOfferId];

    require(msg.value>=auction.min && msg.value>bestOffer.price,"msg.value must be greater than 0 and match with best offers");
    auction.bestOfferId=newOfferId;
    auction.offerIds.push(newOfferId);

    offers[newOfferId]=Offer(newOfferId,_auctionId,payable(msg.sender),msg.value);
    offerList[msg.sender].push(newOfferId);
    newOfferId++;
}
// tranaction ether validation
 function tranaction(uint _auctionId) external view {
     Auction storage auction=auctions[_auctionId];
     Offer storage bestOffer=offers[auction.bestOfferId];

     for(uint i=0;i<auction.offerIds.length;i++){
        uint offerId=auction.offerIds[i];


        if(offerId!=auction.bestOfferId){
            Offer storage offer=offers[offerId];
            offer.buyer.transfer(offer.price);
        }
     }
         auction.seller.transfer(bestOffer.price);
 }
}
