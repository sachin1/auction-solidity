pragma solidity ^0.4.4;

contract ProductAuction {
    
    struct ProductAuctionDetail {
        uint256 productId;
        string productname;
        uint256 minimumBidValue;
        address owner;
    }
    
    uint256 auctionCount;
    
    mapping(uint256 => ProductAuctionDetail) productAuctionList;
    
    function saveProductAuctionDetails(uint256 productId, string productname, uint256 minimumBidValue) public returns (uint256) {
        auctionCount = auctionCount + 1;
        productAuctionList[auctionCount] = ProductAuctionDetail(productId,productname,minimumBidValue, msg.sender);
        return auctionCount;
        
    }
    
    function getProductAuctionInfoById(uint256 id) public view returns (string, uint256) {
        ProductAuctionDetail storage auctionInfo = productAuctionList[id];
        return (auctionInfo.productname, auctionInfo.minimumBidValue);
    }
}


contract ProductAuctionBidding {
  
    struct AuctionHighestBidder {
        address highestBidder;
        uint256 highestBidValue;
    }
    
    //Add few default auctions in constructor
    function ProductBidding() {
        ProductAuction auction = new ProductAuction();
        auction.saveProductAuctionDetails(1, "Mobile 1", 100);
        auction.saveProductAuctionDetails(2, "Mobile 2", 200);
        auction.saveProductAuctionDetails(3, "Mobile 3", 300);
    }
    
    /*Highest Bidder details for particular auction id*/
    mapping (uint256 => AuctionHighestBidder) auctionHighestBidder;
    
    /*auction_id -> User_Address -> Bid Amount - Storing bids for given auction id */
    mapping (uint256 => mapping (address => uint256)) auctionBidsByUserList;
    
    /*User Address --> auction_id -> BidValue  - User can bid for many auctions*/
    mapping (address => mapping (uint256 => uint256)) userBidsForAuctionList;
    
    function createTestRecordsForBidding() {
        ProductAuction auction = new ProductAuction();
        auction.saveProductAuctionDetails(1, "Mobile 1", 100);
        auction.saveProductAuctionDetails(2, "Mobile 2", 200);
        auction.saveProductAuctionDetails(3, "Mobile 3", 300);
    }
    
    function saveUserBidForAuction(uint256 auctionId, uint256 bidValue) public returns (uint256) {
        AuctionHighestBidder bidder = auctionHighestBidder[auctionId];
        if (bidder.highestBidValue < bidValue) {
            bidder.highestBidValue = bidValue;
            bidder.highestBidder = msg.sender;
            auctionHighestBidder[auctionId] = bidder;
        }
        auctionBidsByUserList[auctionId][msg.sender] = bidValue;
        userBidsForAuctionList[msg.sender][auctionId] = bidValue;
        return bidValue;
    }
    
    /*
    This function gives me details of higher bidder at any point of time
    */
    function getHighestBidderByAuctionId(uint256 auctionId) public returns (address, uint256) {
        AuctionHighestBidder storage bidder = auctionHighestBidder[auctionId];
        return (bidder.highestBidder, bidder.highestBidValue);
    }
    
    /*
    Announce the winner and deactivate auction
    Need help - how to disable cross contract communication
    */
    function announceWinnerForAuction(uint256 auctionId) public returns (address, uint256) {
        AuctionHighestBidder storage bidder = auctionHighestBidder[auctionId];
        //Deduct coin amount from his wallet..TO DO: take help from mentor
        //learn how to delete bid from system -- To do: take help from mentor
       // auctionHighestBidder[auctionId] = 0; 
        //auctionBidsByUserList[auctionId] = 0;
        return (bidder.highestBidder, bidder.highestBidValue);
    }
    
 
    /*
        Get Auction details by auction id -- not working unless we solve problem of cross 
        contract communication
    */
    function getAuctionDetailsByAuctionId(uint256 auctionId) public returns (string, uint256) {
        ProductAuction auction = new ProductAuction();
        string memory productname;
        uint256 bidValue;
        (productname, bidValue) = auction.getProductAuctionInfoById(auctionId);
        return (productname, bidValue);
    }
    /*
    Below functionality needs to be fixed - 
    I should be able to return the list of bidders by Product Id.
    */
    function getBidListByProductId(uint256 productId) public returns (uint256) {
        mapping (address => uint256) userList= auctionBidsByUserList[productId];
        return userList[msg.sender];
    }
}