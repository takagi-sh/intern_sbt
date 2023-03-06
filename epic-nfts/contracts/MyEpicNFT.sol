// MyEpicNFT.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// いくつかの OpenZeppelin のコントラクトをインポートします。
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// utils ライブラリをインポートして文字列の処理を行います。
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


// Base64.solコントラクトからSVGとJSONをBase64に変換する関数をインポートします。
import { Base64 } from "./libraries/Base64.sol";

// インポートした OpenZeppelin のコントラクトを継承しています。
// 継承したコントラクトのメソッドにアクセスできるようになります。
contract MyEpicNFT is ERC721URIStorage, Ownable {
  // OpenZeppelin　が　tokenIds　を簡単に追跡するために提供するライブラリを呼び出しています
  using Counters for Counters.Counter;
  // _tokenIdsを初期化（_tokenIds = 0）
  Counters.Counter private _tokenIds;

  // // SVGコードを作成します。
  // // 変更されるのは、表示される単語だけです。
  // // すべてのNFTにSVGコードを適用するために、baseSvg変数を作成します。
  // string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // // 3つの配列 string[] に、それぞれランダムな単語を設定しましょう。
  // string[] firstWords = ["super", "irritating", "binary", "very", "barely", "surprisingly"];
  // string[] secondWords = ["cold", "hot", "cool", "cute", "warm", "wild"];
  // string[] thirdWords = ["cat", "dog", "bird", "sauna", "horse", "flog"];

  // Max batch size for minting one time
  uint256 private _maxBatchSize;
  // Mapping from token Id to hashed credential ID
  mapping(uint256 => string) private _ownedCredential;
  // Mapping from hashed credential Id to owner possession flag
  mapping(string => mapping(address => bool)) private _credentialOwnerships;


event NewEpicNFTMinted(address sender, uint256 tokenId);

  // NFT トークンの名前とそのシンボルを渡します。
  constructor(string memory _name,string memory _symbol,uint256 _newMaxBatchSize) ERC721 (_name, _symbol) {
    _maxBatchSize = _newMaxBatchSize;
  }

  // ユーザーが NFT を取得するために実行する関数です。
  function makeAnEpicNFT(string memory _description,
        string memory _imageURI,
        string memory _externalURI) internal view onlyOwner returns(string memory){
    // 現在のtokenIdを取得します。tokenIdは0から始まります。
    uint256 newItemId = _tokenIds.current();
   
   
   
    uint256 requestNum = _toAddresses.length;

    require(requestNum > 0, "The _toAddresses is empty.");
    require(
        requestNum <= getMaxBatchSize(),
        "The length of _toAddresses must be less than or equal to _maxBatchSize."
    );
    require(
        requestNum == _imageURIs.length,
        "The length of _toAddresses and _imageURIs are NOT same."
    );
    require(
        requestNum == _externalURIs.length,
        "The length of _toAddresses and _externalURIs are NOT same."
    );
	  // // NFTに出力されるテキストをターミナルに出力します。
	  // console.log("\n----- SVG data -----");
    // console.log(finalSvg);
    // console.log("--------------------\n");

    // JSONファイルを所定の位置に取得し、base64としてエンコードします。
    bytes memory _attributes = abi.encodePacked('"attributes": []');
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                  '{"name": "',
                name(),
                '",'
                '"description": "',
                _description,
                '",'
                '"image": "',
                _imageURI,
                '",',
                '"external_url": "',
                _externalURI,
                '",',
                string(_attributes),
                "}"
                )
            )
        )
    );

    // msg.sender を使って NFT を送信者に Mint します。
    _safeMint(msg.sender, newItemId);

    // tokenURIを更新します。
 	  // NFTがいつ誰に作成されたかを確認します。
	  console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // 次の NFT が Mint されるときのカウンターをインクリメントする。
    _tokenIds.increment();

    emit NewEpicNFTMinted(msg.sender, newItemId);
    return string(abi.encodePacked("data:application/json;base64,", json));
  }

// function mintAndTransfer(
//         string memory _credentialId,
//         string memory _description,
//         address[] memory _toAddresses,
//         string[] memory _imageURIs,
//         string[] memory _externalURIs
//     ) public onlyOwner {
//         uint256 requestNum = _toAddresses.length;
//         require(requestNum > 0, "The _toAddresses is empty.");
//         require(
//             requestNum <= getMaxBatchSize(),
//             "The length of _toAddresses must be less than or equal to _maxBatchSize."
//         );
//         require(
//             requestNum == _imageURIs.length,
//             "The length of _toAddresses and _imageURIs are NOT same."
//         );
//         require(
//             requestNum == _externalURIs.length,
//             "The length of _toAddresses and _externalURIs are NOT same."
//         );
//         for (uint i = 0; i < requestNum; i++) {
//             address _to = _toAddresses[i];
//             bool hasCredential = _credentialOwnerships[_credentialId][_to];
//             require(
//                 !hasCredential,
//                 "One or more recipient has had already the same credential."
//             );
//             require(_to != owner(), "_toAddresses must NOT be included OWNER.");
//         }

//         // put the next token ID down in the variable before the bulk mint
//         uint256 startTokenId = _nextTokenId();
//         _safeMint(owner(), requestNum);

//         // do bulk transfer to each specified address only for the minted tokens
//         uint256 tokenId = startTokenId;
//         for (uint i = 0; i < requestNum; i++) {
//             // update the credential ID mapping
//             _ownedCredential[tokenId] = _credentialId;
//             // transfer to the specified address
//             safeTransferFrom(owner(), _toAddresses[i], tokenId);
//             // update the token URI
//             _setTokenURI(
//                 tokenId,
//                 generateTokenURI(_description, _imageURIs[i], _externalURIs[i])
//             );
//             tokenId += 1;
//         }
//     }


// =============================================================
    //   The followings are copied from ERC721URIStorage.sol
    // =============================================================

    // Optional mapping for token URIs
  // mapping(uint256 => string) private _tokenURIs;

  // /**
  //   * @dev See {IERC721Metadata-tokenURI}.
  //   */
  // function tokenURI(uint256 tokenId)
  //     public
  //     view
  //     override
  //     returns (string memory)
  // {
  //     require(_exists(tokenId));
  //     string memory _tokenURI = _tokenURIs[tokenId];
  //     string memory base = _baseURI();

  //     // If there is no base URI, return the token URI.
  //     if (bytes(base).length == 0) {
  //         return _tokenURI;
  //     }
  //     // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
  //     if (bytes(_tokenURI).length > 0) {
  //         return string(abi.encodePacked(base, _tokenURI));
  //     }

  //     return super.tokenURI(tokenId);
  // }

  // /**
  //   * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
  //   *
  //   * Requirements:
  //   *
  //   * - `tokenId` must exist.
  //   */

  // function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
  //       require(_exists(tokenId), "URI set of nonexistent token");
  //       _tokenURIs[tokenId] = _tokenURI;
  //   }
  function transferOwnership(address newOwner) public override onlyOwner {
        // Banned for transfering ownership to a user who has this token already,
        // because to make sure that the status of credential ID mappings will not be complicated.
        //require(balanceOf(newOwner) == 0, "newOwner's balance must be zero.");
        super.transferOwnership(newOwner);
    }

  
}