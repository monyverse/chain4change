// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

//See more at OpenZeppelin:https://docs.openzeppelin.com/contracts/4.x/erc721
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol"; //alows for console.logs in a solidity contract"

contract ChangeNFT721 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public maxNFTs;
    uint256 public remainingMintableNFTs;

    struct myNFT {
        address owner;
        string tokenURI;
        uint256 tokenId;
    }

    myNFT[] public nftCollection;

    /* tokenURI
    {
        "name": "Chain4Change 2022"
        "description": "Chain4Change MMORPG Multiplayer Metaverse and limited to 100 players "
        "image": //IPFS pinned file content CID (can be any mime type)
        "other data like version, strenth, etc....": ""
    }
    */
    event NewChangeNFTMinted(
        address indexed sender,
        uint256 indexed tokenId,
        string tokenURI,
        uint256 remainingMintableNFTs
    );

    //This sets our collection details. Anything minted by this contract will fall under this header
    constructor() ERC721("Change NFTs 2022", "Chain4Change Metaverse") {
        console.log("This is my ERC721 NFT contract");
        maxNFTs = 100; //set a limit to number of nft's that are mintable
        remainingMintableNFTs = 100;
    }

    function mintMyNFT(string memory ipfsURI) public {
        require(_tokenIds.current() < maxNFTs);
        uint256 newItemId = _tokenIds.current();

        myNFT memory newNFT = myNFT({
            owner: msg.sender,
            tokenURI: ipfsURI,
            tokenId: newItemId
        });

        _safeMint(msg.sender, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, ipfsURI);

        _tokenIds.increment();

        remainingMintableNFTs = maxNFTs - _tokenIds.current();

        nftCollection.push(newNFT);

        emit NewChangeNFTMinted(
            msg.sender,
            newItemId,
            ipfsURI,
            remainingMintableNFTs
        );
    }

    /**
     * @notice helper function to display NFTs for frontends
     */
    function getNFTCollection() public view returns (myNFT[] memory) {
        return nftCollection;
    }

    function getRemainingMintableNFTs() public view returns (uint256) {
        return remainingMintableNFTs;
    }
}
