pragma solidity ^0.5.7;

contract PayOut {
    address owner;
    uint fortune;
    bool deceased;
    
    constructor () payable public {
      
        owner = msg.sender; // msg sender represents address that is being called
        fortune = msg.value; // msg value tell us how much ether sent
        deceased = false;
    }
    
    
    // create modifier so the only person who call the contract is the owner (sözleşmeyi arayan tek kişi sahibidir)
    modifier onlyOwner {
        require(msg.sender == owner);
        _; // run this modifier
        
    }
 
 
 
    // create modifier so that we only allocate funds if friend's gramps deceased (sadece arkadaşın büyükbabası vefat ederse fon tahsis ettiğimizi)
      modifier mustBeDeceased {
        
        require(deceased == true);
        _; // run this modifier
        
    }
    
    //list of family Wallets
    address payable [] familyWallets;
    
    //iteration iterating - looping through - when we map through we iterate through key store value 
    // yineleme yineleme - döngüleme - eşleme yaptığımızda anahtar deposu değeri boyunca yineleniriz
    
    // map through inheritance
    mapping (address => uint) inheritance;
    
    //inheritance = miras for each address
    
    function setInheritance (address payable wallet, uint amount) public onlyOwner {
        
        // to add Wallets to the family Wallets .push(javascript)
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
        
    }  
    
    // pay each family member based on their wallet address
    function payout() private mustBeDeceased {
        for (uint i = 0; i<familyWallets.length; i++) {
            
            // trasfering the funds from contract address to reciever address
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
        }
    }
    
    // oracle switch simulation
    function hasDeceased() public onlyOwner {
        deceased = true;
        payout();
    }
    
}





