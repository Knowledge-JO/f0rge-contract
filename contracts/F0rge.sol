// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.20;

import "./token.sol";
import "./nft.sol";

contract F0rge {
    NFT[] public tokens; //
    mapping(uint => address) public indexToContract; //
    mapping(uint => address) public indexToOwner; //

    event TokenCreated(address indexed tokenAddress, string name, string symbol, uint256 totalSupply);
    event NFTCreated(address owner, address tokenContract); //
    event NFTMinted(address owner, address tokenContract, uint amount); //

    function createToken(string memory name, string memory symbol, uint256 totalSupply, uint _holdingCap) external {
        token newToken = new token(name, symbol, totalSupply, _holdingCap);
        emit TokenCreated(address(newToken), name, symbol, totalSupply);
    }

    function teamAllocation(address teamWallet, uint256 amount, address tokenAddress) public {
        require(teamWallet != address(0), "Enter a valid amount");
        require(amount < 0, "Enter a value greater than 0");
        token(tokenAddress).transfer(teamWallet, amount);
    }

    function maxtokensPertransaction(uint maxtoks, uint256 totalSupply) internal view {
        require(maxtoks < totalSupply);    
    }

    function sniperAutoBurn() public {

    }

    function buyTax() public {

    }

    function sellTax() public  {
        
    }

    function mintNFT( uint _index, string memory _name, uint256 amount) public {

        uint id = getIdByName(_index, _name);
        tokens[_index].mint(indexToOwner[_index], id, amount);
        emit NFTMinted(tokens[_index].owner(), address(tokens[_index]), amount);
    }


    function getCountNFTbyIndex(uint256 _index, uint256 _id) public view returns (uint amount) {
        return tokens[_index].balanceOf(indexToOwner[_index], _id);
    }

    function getCountNFTbyName(uint256 _index, string calldata _name) public view returns (uint amount) 
    {
        uint id = getIdByName(_index, _name);
        return tokens[_index].balanceOf(indexToOwner[_index], id);
    }

    function getIdByName(uint _index, string memory _name) public view returns (uint) {
        return tokens[_index].nametoId(_name);
    }

    function getNameById(uint _index, uint _id) public view returns (string memory) {
        return tokens[_index].idtoName(_id);
    }

    function getNFTbyIndexandId(uint _index, uint _id) public view returns (address _contract, address _owner, string memory _uri, uint supply) {
       NFT nft = tokens[_index];
        return(address(nft), nft.owner(), nft.uri(_id), nft.balanceOf(indexToOwner[_index], _id));
    }    
}