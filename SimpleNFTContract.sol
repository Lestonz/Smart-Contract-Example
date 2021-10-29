pragma solidity ^0.8.9;

/**
 Simple Upload to Opensea NFT Contract
 I got help from Moralis this Link : 'https://www.youtube.com/watch?v=tBMk1iZa85Y&t=4564s'

 *It may not work because of the NFT Files link, but if you add the link you will get for your own files, it will work.
 writer of @lestonz
 */

//import ERC1155 token contract from OpenZeppelin.
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
//import Ownable Contract from OpenZeppelin.
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

//Create simple NFT Contract and we import out other Contracts.
contract NFTContract is ERC1155, Ownable {
    
    
    // Define 2 art or photo ext. You can add more NFT files.
    // I use 2 type files
    uint256 public constant ARTWORK = 0;
    uint256 public constant PHOTO = 1;
    
    
    // Most important thing upload your files some link(ipfs). I prefer moralis.
    // We define the NFT files that we have uploaded to the ERC 1155 contract as json
    // You should add your link.
    constructor() ERC1155("https://sw2r60a1bu9c.moralishost.com/{id}.json") {
        
        //If the Mint function is called by anyone other than the contract creator, it will cause no change.
        _mint(msg.sender, ARTWORK, 1, "");
        _mint(msg.sender, PHOTO, 2, "");

    }
    
    //It comes from Ownable Contract. Defines who can make changes about NFT files.
    function mint(address account, uint256 id,uint256 amount) public onlyOwner{
        _mint(account, id, amount, "");
    }
    
    // Destroy or delete function.
    function burn(address account, uint256 id,uint256 amount) public{
        
        //It says that only the NFT owner can perform this operation.
        require(msg.sender == account);
        _burn(account, id, amount);
    }
} 