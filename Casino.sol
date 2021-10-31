pragma solidity ^0.8.7;
/**
    Simple Casino Contract
    Firstly, you should start casino time.
    You choose 2  numbers and taking them Hash.
    This Hash is your ticket like ID. 
    Copy your Hash on Buy Ticket function and you should send 1 Ether for the join casino.
    writer of @lestonz
 */

contract Casino {
    
    // Define start for time period.
    uint private start;
    
    // Define buy time.
    uint private buyPeriod = 1000;
    // Define verification time.
    uint private verifyPeriod = 100;
    // Define check time.
    uint private checkPeriod = 100;
    

    // Define ticket address.
    mapping(address => uint) private _tickets;
    // Define winners address.
    mapping(address => uint) private _winnings;

    // Make list for enter address
    address[] _entries;
    // List of verified addresses
    address[] _verified;


    //Define of winner seed
    uint private winnerSeed;
    // Is the winner right?
    bool private hasWinner;
    // Define winner address
    address private winner;
    
    // Start function.
    function casino() public {
        start = block.timestamp;    
    }
    
    
    // Hass generation function from number and salt.
    function generateHash(uint number, uint salt) public pure returns (uint) {
        return uint(keccak256(abi.encodePacked(number + salt)));
    }
    
    // Buy function for the ticket.
    function buyTicket(uint hash) public payable returns (bool) {
        // Within the timeframe.
        require(block.timestamp < start+buyPeriod);
        // Correct amount. You can change the parameters, msg.value >= 1 ether.
        require(1 ether == msg.value);
        // 1 entry per address.
        require(_tickets[msg.sender] == 0);
        _tickets[msg.sender] = hash;
        _entries.push(msg.sender);
        return true;
    }
    
    // Create a validation function
    function verifyTicket(uint number, uint salt) public returns (bool) {
        // Within the timeframe
        require(block.timestamp >= start+buyPeriod);
        require(block.timestamp < start+buyPeriod+verifyPeriod);
        // Has a valid entry
        require(_tickets[msg.sender] > 0);
        // Validate hash
        require(salt > number);
        require(generateHash(number, salt) == _tickets[msg.sender]);
        winnerSeed == winnerSeed^salt;
        _verified.push(msg.sender);
    }
    
    // Create winner control
    function checkWinner() public returns (bool) {
        // Within the timeframe
        require(block.timestamp >= start+buyPeriod+verifyPeriod);
        require(block.timestamp < start+buyPeriod+verifyPeriod+checkPeriod);
        // If not a winner
        if (!hasWinner) {
            winner = _verified[winnerSeed % _verified.length];
            _winnings[winner] = _verified.length - 10 ether;
            hasWinner = true;
        }
        return msg.sender == winner;
    }
    
    // Transfering the prize to the winning address
    function claim() public {
        // Has winnings to claim
        require(_winnings[msg.sender] > 0);
        uint claimAmount = _winnings[msg.sender];
        _winnings[msg.sender] = 0;
        payable (msg.sender).transfer(claimAmount);        
    }
}
