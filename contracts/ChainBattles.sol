// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    struct Stats {
        uint256 Level;
        uint256 Speed;
        uint256 Strength;
        uint256 Life;
    }
    mapping(uint256 => Stats) public tokenIdToStats;
    uint256 initialNumber = 1;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(tokenId),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Life: ",
            getLife(tokenId),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength: ",
            getStrength(tokenId),
            "</text>",
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            getSpeed(tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToStats[tokenId].Level;
        return levels.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 speed = tokenIdToStats[tokenId].Speed;
        return speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToStats[tokenId].Strength;
        return strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 life = tokenIdToStats[tokenId].Life;
        return life.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function createRandom(uint256 number) public returns (uint256) {
        return uint256(keccak256(abi.encodePacked(initialNumber++))) % number;
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);
        tokenIdToStats[newItemId].Life = 100;

        tokenIdToStats[newItemId].Strength = 20;

        tokenIdToStats[newItemId].Speed = 25;
        tokenIdToStats[newItemId].Level = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function upgrade(uint256 tokenId) public {
        require(_exists(tokenId));
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this NFT to train it!"
        );
        uint256 currentLevel = tokenIdToStats[tokenId].Level;
        tokenIdToStats[tokenId].Level = currentLevel + 1;
        uint256 currentStrength = tokenIdToStats[tokenId].Strength;
        tokenIdToStats[tokenId].Strength =
            currentStrength +
            createRandom(currentStrength);
        uint256 currentSpeed = tokenIdToStats[tokenId].Speed;
        tokenIdToStats[tokenId].Speed =
            currentSpeed +
            createRandom(currentSpeed);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function damage(uint256 tokenId) public {
        require(_exists(tokenId));
        uint256 currentLife = tokenIdToStats[tokenId].Life;
        require(currentLife > 0, "This Nft is already Dead");
        tokenIdToStats[tokenId].Life = currentLife - 10;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
