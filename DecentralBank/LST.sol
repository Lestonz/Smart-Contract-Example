pragma solidity ^0.8.9;

/**
 Simple Token Contract
 writer of @lestonz
*/

contract Tether {
    //Name of Token
    string  public name = "Lestonz Tether Token";
    //Symbol of Token
    string  public symbol = "LUSDT";
    //Total of Token. If you want change to value.
    //You have to put as many zeros as the number of decimals.
    uint256 public totalSupply = 1000000000000000000000000; // 1 million tokens
    //Decimals number same of ETH and BTC but you can change.
    //This meaning 10^(-18)
    uint8   public decimals = 18;


    //Define of the transfer parameters. We call in functions with "emit" keyword.
    event Transfer(
        
        //The indexed parameters for logged events will allow you to search for
        //these events using the indexed parameters as filters.
        address indexed _from,
        address indexed _to, 
        //Amount of the transfer tokens.
        uint _value
    );

    //Define of the confirmation parameters. We call in functions with "emit" keyword.
    event Approval(
        
        //The indexed parameters for logged events will allow you to search for
        //these events using the indexed parameters as filters.
        address indexed _owner,
        address indexed _spender, 
        uint _value
    );

    //Mapping is a reference type as arrays and structs.
    mapping(address => uint256) public balanceOf;// balanceFirstAddress should be uint256.
    //Allowance means that we can grant approval to another contract or address to be able to transfer our ERC20 tokens.
    mapping(address => mapping(address => uint256)) public allowance; // Allocation address
    
    //All tokens are transferred to the deploying account
    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    //Tokens transfer function 
    function transfer(address _to, uint256 _value) public returns (bool success) {
        
        // Require that the value is greater or equal for transfer
        require(balanceOf[msg.sender] >= _value);
         // Transfer the amount and subtract the balance
        balanceOf[msg.sender] -= _value;
        // Add the balance
        balanceOf[_to] += _value;
        //Since we define an "event" keyword, we must call it with the help of "emit" keyword.
        emit Transfer(msg.sender, _to, _value);
        //"Return true" if slots inside this Function work correctly.
        return true;
    }
    
    
    //Define of the confirmation function
    function approve(address _spender, uint256 _value) public returns (bool success) {
        
        // Spender address and this sender address must be the same .
        allowance[msg.sender][_spender] = _value;
        //Since we define an "event" keyword, we must call it with the help of "emit" keyword.
        emit Approval(msg.sender, _spender, _value);
        //"Return true" if slots inside this Function work correctly.
        return true;
    }

    //Transfer function from another address to another address
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        
        //The amount of tokens you will send must be less than or equal to the balance and allowance.
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        // Add the balance for transferFrom
        balanceOf[_to] += _value;
        // Subtract the balance for transferFrom
        balanceOf[_from] -= _value;
        allowance[msg.sender][_from] -= _value;
        // We call event Transfer so use "emit"
        emit Transfer(_from, _to, _value);
        //"Return true" if slots inside this Function work correctly.
        return true;
    }
}