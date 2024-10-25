// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract CoinfairNFT is ERC721, Ownable{
    using Address for address payable;

    string public constant AUTHORS = "Coinfair";

    mapping(address => address) public parentAddress;

    mapping(address => uint256) public level; 

    mapping(address => uint256[]) public waitingClaim;

    mapping(address => uint256) public totalMint;

    mapping(address => uint256) public addrToNftId;
    
    uint256 public mintCost = 1 wei; 
    uint256 public claimCost = 1 wei; 
    uint256 public maxMintAmount = 500;
    uint256 public total;

    string public l1Uri = "";
    string public l2Uri = "";
    string public l3Uri = "";

    address internal CoinfairAddr;

    event Claim(address indexed minter, address indexed claimer);

    modifier onlyCoinfair() {
        require(msg.sender == CoinfairAddr,"CoinfairNFT:Only Coinfair");
        _;
    }

    constructor() ERC721("CoinfairNFT", "CF_NFT") Ownable(msg.sender){
        CoinfairAddr = msg.sender;
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(from == address(this), "CoinfairNFT:SBT");
        if (to == address(0)) {
            revert ERC721InvalidReceiver(address(0));
        }

        address previousOwner = _update(to, tokenId, _msgSender());
        if (previousOwner != from) {
            revert ERC721IncorrectOwner(from, tokenId, previousOwner);
        }
    }

    function getMCInfo(address minter) public view returns(uint256,uint256){
        require(totalMint[minter] >= waitingClaim[minter].length, "CoinfairNFT:Unexpected Error");
        return (totalMint[minter] - waitingClaim[minter].length, totalMint[minter]);
    }

    function getTwoParentAddress(address sonAddress)public view returns(address, address){
        return (parentAddress[sonAddress],parentAddress[parentAddress[sonAddress]]);
    }

    function mint(uint256 mintAmount) public payable{
        require(msg.value >= mintAmount * mintCost, "CoinfairNFT:Incorrect ETH amount");
        require (mintAmount > 0 && mintAmount <= maxMintAmount,"CoinfairNFT:Invalid mint amount");

        totalMint[msg.sender] += mintAmount;

        for(uint256 i = 0; i < mintAmount; i++){
            total += 1;
            waitingClaim[msg.sender].push(total);
            _mint(address(this), total);
        }

        uint256 overPayAmount = msg.value - mintAmount * mintCost;
        if (overPayAmount > 0){
            payable(msg.sender).sendValue(overPayAmount);
        }
    }

    function claim(address parent) public payable{
        require((parentAddress[parent] != msg.sender) && 
            (parentAddress[parentAddress[parent]] != msg.sender) &&
            (parent != msg.sender)
            , "CoinfairNFT:Loop inhibit");
        require(msg.value >= claimCost, "CoinfairNFT:Incorrect ETH amount");
        require(balanceOf(msg.sender) == 0 && parentAddress[msg.sender] == address(0), "CoinfairNFT:Already claimed");
        require(waitingClaim[parent].length > 0,"CoinfairNFT:No remaining nft is available for collection");

        addrToNftId[msg.sender] = waitingClaim[parent][waitingClaim[parent].length - 1];
        waitingClaim[parent].pop();
        parentAddress[msg.sender] = parent;

        emit Claim(parent, msg.sender);

        _safeTransfer(address(this), msg.sender, addrToNftId[msg.sender]);
        uint256 overPayAmount = msg.value - claimCost;
        if (overPayAmount > 0){
            payable(msg.sender).sendValue(overPayAmount);
        }
    }

    function setLevel(address aimAddress, uint256 newLevel) public onlyCoinfair{
        require(newLevel <= 2, "CoinfairNFT:Invalid new level");
        level[aimAddress] = newLevel;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        address owner = ownerOf(tokenId);
        if (owner == address(this)) {
            revert("CoinfairNFT:Not claimed");
        }

        uint256 tokenLevel = level[parentAddress[owner]];

        if(tokenLevel == 0){
            return l1Uri;
        }else if(tokenLevel == 1){
            return l2Uri;
        }else if(tokenLevel == 2){
            return l3Uri;
        } else {
            return "CoinfairNFT:Invalid level";
        }
    }

    function setCoinfairAddr(address CoinfairAddr_) public onlyCoinfair {
        CoinfairAddr = CoinfairAddr_;
    }

    function setL1Uri(string memory newUri) public onlyCoinfair {
        require(
            keccak256(bytes(newUri)) != keccak256(bytes(l2Uri)) &&
            keccak256(bytes(newUri)) != keccak256(bytes(l3Uri))
        );
        l1Uri = newUri;
    }

    function setL2Uri(string memory newUri) public onlyCoinfair {
        require(
            keccak256(bytes(newUri)) != keccak256(bytes(l1Uri)) &&
            keccak256(bytes(newUri)) != keccak256(bytes(l3Uri))
        );
        l2Uri = newUri;
    }

    function setL3Uri(string memory newUri) public onlyCoinfair {
        require(
            keccak256(bytes(newUri)) != keccak256(bytes(l1Uri)) &&
            keccak256(bytes(newUri)) != keccak256(bytes(l2Uri))
        );
        l3Uri = newUri;
    }


    function setMintCost(uint256 newCost) public onlyCoinfair {
        mintCost = newCost;
    }

    function setClaimCost(uint256 newCost) public onlyCoinfair {
        claimCost = newCost;
    }

    function collectTreasury() public onlyCoinfair {
        require(address(this).balance > 0, "CoinfairNFT:Zero ETH");
        payable(msg.sender).sendValue(address(this).balance);
    }

}