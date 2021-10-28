pragma solidity ^0.8.9;


/**
 Decentral Bank Contract 
 We can use the staking feature,
 deposit feature, Issue feature in this decentralized bank 
 by transferring the LST Token and stable Token we created 
 to our bank.
 writer of @lestonz
*/

// We are calling the 2 Token contracts with "import" keyword
// we have created to be able to use them in this contract.
import './LST.sol';
import './Tether.sol';


contract DecentralBank {

    //Create state variable Name of Bank
    string public name = 'Decentral Bank';
    //Create state variable owner
    address public owner;

    //Define Tether Contract as state variable
    Tether public tether;
    //Define LST Contract as state variable
    LST public lst;

    // Create stakers list
    address[] public stakers;

    //Mapping is a reference type as arrays and structs.
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    // Define tokens pamameters
    constructor (LST _lst, Tether _tether) public {
        lst = _lst;
        tether = _tether;
        owner = msg.sender;

    }

    // Staking function
    function depositTokens(uint _amount ) public {
        
        // Require staking amount to be greater than zero
        require(_amount > 0, 'amount cannot be 0' );

        // Transfer tether tokens to this contract address for staking
        tether.transferFrom(msg.sender,address(this) , _amount);

        // Update Staking Balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // Update Staking Balance
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;

    }

    // Issue rewards
    function issueTokens() public {
        
        //Require the owner to issue tokens only
        require(msg.sender == owner, 'caller must be the owner' );
            
            //Provides as many For loops as stakers
            for(uint i=1; i<stakers.length; i++){
                address recipient = stakers[i];
                // /9 to create percentage incentive for stakers - 
                uint balance = stakingBalance[recipient] /9;
                
                if (balance > 0) {
                    lst.transfer(recipient, balance);
                }
            }
        
    }

    // Unstake tokens
    function unstakeTokens() public {
        
      uint balance = stakingBalance[msg.sender];
      // Require the amount to be greater than zero
      require(balance > 0, 'staking balance cannot be less than zero');

      // Transfer the tokens to the specified contract address from our bank
      tether.transfer(msg.sender, balance);

      // Reset staking balance
      stakingBalance[msg.sender] = 0;

      // Update Staking Status
      isStaking[msg.sender] = false;

    }
}