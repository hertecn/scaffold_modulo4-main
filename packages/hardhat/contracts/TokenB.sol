// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract TokenB is  ERC20 {

    constructor() ERC20("TokenB", "TB"){    //creamos token
       _mint(msg.sender, 10000 *10 ** decimals());  
    }

}