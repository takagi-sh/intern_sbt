// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract SharedNFT2 is ERC721A, Ownable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(
      string memory name,
      string memory symbol
      ) ERC721A(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    //MAIN PART
    //Ascending Order of mint
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    function mint(address to, address from) public onlyRole(MINTER_ROLE) {
        require(from == owner(), "Only the NFT owner can mint new NFTs");
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(to, newTokenId);
    }

    mapping (uint256 => address) private _tokenOwners;

    // Returns the number of tokens owned by a given address
    //Following function is already defined in ERC721
    // function balanceOf(address owner) public view returns (uint256) {
    //     uint256 count = 0;
    //     for (uint256 i = 0; i < _tokenIds.current(); i++) {
    //         if (_tokenOwners[i] == owner) {
    //             count++;
    //         }
    //     }
    //     return count;
    // }

    // Returns true if the specified address owns more than one token
    function ownerOf(address owner) public view returns (bool) {
        return balanceOf(owner) > 0;
    }
    
    //Old OwnerOf
    // // Returns the address of the current owner of the NFT
    // function ownerOf(
    //   uint256 tokenId
    //   ) public view override returns (address) {
    //     return _tokenOwners[tokenId];
    // }

    //end of main part

    // // Mint new NFT
    // function mint(
    //   address to, 
    //   uint256 tokenId
    //   ) public onlyRole(MINTER_ROLE) {
    //     _mint(to, tokenId);
    // }

    // Check if an account is the owner of a specific token
    function _isOwner(
      address account,
      uint256 tokenId
      ) internal view returns (bool) {
        return ownerOf(tokenId) == account;
    }

    // Allow current owner of the token to transfer it to another address
    function transferFromCurrentOwner(address to, uint256 tokenId) public {
        require(_isOwner(msg.sender, tokenId), "Sender is not the current owner of the token");
        transferFrom(msg.sender, to, tokenId);
    }
}
