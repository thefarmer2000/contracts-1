// SPDX-License-Identifier: MIT

pragma solidity >0.6.6;

import "./BEP20.sol";

contract FrostToken is BEP20 {
    using SafeMath for uint256;
    uint256 public constant maxSupply = 99_999_999e18;

    constructor() BEP20('FrostSwap', 'FROST') {
        _mint(msg.sender, 100_000e18);
    }

    /// @notice Creates `_amount` token to token address. Must only be called by the owner (MasterChef).
    function mint(uint256 _amount) public override onlyOwner returns (bool) {
        return mintFor(address(this), _amount);
    }

    function mintFor(address _address, uint256 _amount) public onlyOwner returns (bool) {
        _mint(_address, _amount);
        require(totalSupply() <= maxSupply, "reach max supply");
        return true;
    }

    // Safe frost transfer function, just in case if rounding error causes pool to not have enough FROST.
    function safeCakeTransfer(address _to, uint256 _amount) public onlyOwner {
        uint256 frostBal = balanceOf(address(this));
        if (_amount > frostBal) {
            _transfer(address(this), _to, frostBal);
        } else {
            _transfer(address(this), _to, _amount);
        }
    }
}
