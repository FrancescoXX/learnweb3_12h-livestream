// SPDX-License-Identifier: MIT
  pragma solidity ^0.8.0;

  import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";
  import "./ICryptoDevs.sol";

  contract CryptoDevToken is ERC20, Ownable {
      uint256 public constant tokenPrice = 0.001 ether;
      uint256 public constant tokensPerNFT = 10 * 10**18;
      uint256 public constant maxTotalSupply = 10000 * 10**18;
      ICryptoDevs CryptoDevsNFT;
      
      mapping(uint256 => bool) public tokenIdsClaimed;

      constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
          CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
      }

      function mint(uint256 amount) public payable {
          uint256 _requiredAmount = tokenPrice * amount;
          require(msg.value >= _requiredAmount, "Ether sent is incorrect");
          uint256 amountWithDecimals = amount * 10**18;
          require(
              (totalSupply() + amountWithDecimals) <= maxTotalSupply,
              "Exceeds the max total supply available."
          );
          _mint(msg.sender, amountWithDecimals);
      }

      function claim() public {
          address sender = msg.sender;
          uint256 balance = CryptoDevsNFT.balanceOf(sender);
          require(balance > 0, "You dont own any Crypto Dev NFT's");
          uint256 amount = 0;
          for (uint256 i = 0; i < balance; i++) {
              uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
              if (!tokenIdsClaimed[tokenId]) {
                  amount += 1;
                  tokenIdsClaimed[tokenId] = true;
              }
          }
          _mint(msg.sender, amount * tokensPerNFT);
      }

      function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
      }

      receive() external payable {}
      fallback() external payable {}
  }