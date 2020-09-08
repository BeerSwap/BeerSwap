pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract BeerBar is ERC20("BeerBar", "xBEER"){
    using SafeMath for uint256;
    IERC20 public beer;

    constructor(IERC20 _beer) public {
        beer = _beer;
    }

    // Enter the bar. Pay some BEERs. Earn some shares.
    function enter(uint256 _amount) public {
        uint256 totalBeer = beer.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalBeer == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalBeer);
            _mint(msg.sender, what);
        }
        beer.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your BEERs.
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(beer.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        beer.transfer(msg.sender, what);
    }
}