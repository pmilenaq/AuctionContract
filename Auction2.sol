
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Auction Contract
 * @notice Implements a simple auction system where users can place bids.
 * @dev The contract allows for bidding, auction management, and withdrawal of funds.
 */
contract Auction {
    /// @dev The address of the contract owner
    address private owner;

    /// @dev Timestamp when auction bidding ends
    uint256 private auctionEndTime;

    /// @dev Flag indicating auction completion status
    bool private auctionEnded;

    /// @dev Amount of the current highest bid
    uint256 private highestBid;

    /// @dev Address of the highest bidder
    address private highestBidder;

    /// @dev Mapping of bids from each address
    mapping(address => uint256) private bids;

    /// @dev List of all participants in the auction
    address[] private bidders;

    // Events
    /**
     * @dev Emitted when a new bid is placed
     * @param bidder The address of the bidder (indexed for filtering)
     * @param amount The amount of the new bid
     */
    event NewBid(address indexed bidder, uint256 amount);

    /**
     * @dev Emitted when the auction concludes
     * @param winner The address of the winning bidder
     * @param amount The final winning bid amount
     */
    event AuctionEnded(address winner, uint256 amount);

    /**
     * @dev Emitted when a bidder withdraws their funds
     * @param bidder The address of the bidder withdrawing funds
     * @param amount The amount withdrawn
     */
    event Withdraw(address indexed bidder, uint256 amount);

    // Modifiers
    /**
     * @dev Modifier to restrict function access to the contract owner
     * @custom:reverts NotOwner if called by non-owner
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "No es el propietario");
        _;
    }

    /**
     * @dev Modifier to restrict functions to only when the auction is active
     * @custom:reverts AuctionEnded if auction has already ended
     */
    modifier auctionActive() {
        require(block.timestamp < auctionEndTime, "Subasta finalizada");
        _;
    }

    /**
     * @dev Modifier to restrict functions to only when the auction has not ended
     * @custom:reverts AuctionNotEnded if auction has already ended
     */
    modifier auctionNotEnded() {
        require(!auctionEnded, "Subasta ya finalizada");
        _;
    }

    // Reentrancy guard
    bool private locked;

    /**
     * @dev Modifier to prevent reentrancy attacks
     * @custom:reverts ReentranciaNoPermitida if reentrant call is detected
     */
    modifier noReentrancy() {
        require(!locked, "Reentrancia no permitida");
        locked = true;
        _;
        locked = false;
    }

    /**
     * @dev Constructor to initialize the auction
     * @param _biddingTime The duration of the auction in seconds
     */
    constructor(uint256 _biddingTime) {
        owner = msg.sender; // Set the contract owner
        auctionEndTime = block.timestamp + _biddingTime; // Set the auction end time
    }

    /**
     * @notice Places a new bid in the auction
     * @dev Requirements:
     *      - Auction must be active
     *      - Bid must be at least 5% higher than the current highest bid
     */
    function placeBid() public payable auctionActive {
        require(msg.value > highestBid + (highestBid * 5 / 100), "Oferta muy baja");

        // Refund the previous highest bidder
        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid; // Store previous highest bid for refund
        }

        highestBidder = msg.sender; // Update the highest bidder
        highestBid = msg.value; // Update the highest bid
        bidders.push(msg.sender); // Add the new bidder to the list

        emit NewBid(msg.sender, msg.value); // Emit the event for the new bid

        // Extend the auction time if the bid is placed in the last 10 minutes
        if (auctionEndTime - block.timestamp < 10 minutes) {
            auctionEndTime += 10 minutes;
        }
    }

    /**
     * @notice Ends the auction and distributes funds
     * @dev Requirements:
     *      - Only callable by the owner
     *      - Auction must not have already ended
     */
    function endAuction() public onlyOwner auctionNotEnded {
        auctionEnded = true; // Mark the auction as ended
        emit AuctionEnded(highestBidder, highestBid); // Emit the auction ended event

        // Distribute funds to the highest bidder
        payable(owner).transfer(highestBid); // Transfer the highest bid amount to the owner

        // Refund non-winning bidders
        uint256 length = bidders.length; // Store the length of bidders array
        for (uint i = 0; i < length; i++) {
            address bidder = bidders[i];
            if (bidder != highestBidder && bids[bidder] > 0) {
                uint256 refundAmount = bids[bidder];
                bids[bidder] = 0; // Reset the bid for the bidder
                payable(bidder).transfer(refundAmount); // Transfer the refund amount
                emit Withdraw(bidder, refundAmount); // Emit the withdraw event
            }
        }
    }

    /**
     * @notice Allows bidders to withdraw their funds
     * @dev Requirements:
     *      - Auction must have ended
     *      - Caller must not be the highest bidder
     */
    function withdraw() public noReentrancy {
        require(auctionEnded, "Subasta no terminada");
        require(msg.sender != highestBidder, "El mejor postor no puede retirar fondos");
        require(bids[msg.sender] > 0, "No tienes fondos para retirar");

        uint256 amount = bids[msg.sender]; // Get the amount for the sender
        bids[msg.sender] = 0; // Reset the sender's bid to prevent reentrancy

        // Transfer the amount to the sender
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount); // Emit the withdraw event
    }
}