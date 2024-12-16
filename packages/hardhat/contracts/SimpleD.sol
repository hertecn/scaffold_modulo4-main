// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract SimpleD  {
    IERC20  tk1;        //definimos interface
    IERC20  tk2;
    address public owner;      

    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event RemoveLiquidity(address indexed provider, uint256 amountA, uint256 amountB);
    event SwapAforB(address indexed trader, uint256 amountAIn, uint256 amountBOut);
    event SwapBforA(address indexed trader, uint256 amountBIn, uint256 amountAOut);

    constructor(address _tokenA, address _tokenB){
        tk1 = IERC20(_tokenA);
        tk2 = IERC20(_tokenB); 
        owner=msg.sender;   //creador del contrato

    }

    function addLiquidity(uint256 amountA, uint256 amountB) public{     
       require(tk1.transferFrom(owner, address(this), amountA), "TokenA transfer failed");//solo agrega
       require(tk2.transferFrom(owner, address(this), amountB), "TokenB transfer failed");//liquidez el owner
        emit LiquidityAdded(owner, amountA, amountB);
    }

    function swapAforB(uint256 amountAIn) public{
       require(amountAIn > 0, "The amount of TokenA must be greater than 0");

       uint256 tokenA;
       uint256 tokenB;

        tokenA = tk1.balanceOf(address(this)); // Reserva actual de TokenA
        tokenB = tk2.balanceOf(address(this)); // Reserva actual de TokenB

        require(tokenA > 0 && tokenB > 0, "The pool does not have enough liquidity");
        
        uint256 amountBOut = tokenB - (tokenA * tokenB) / (tokenA + amountAIn); //Calcula cuanto de tokenB tiene q pasar

        require(amountBOut > 0, "The output amount of token B must be greater than 0");
        require(amountBOut <= tokenB, "The contract does not have enough TokenB");

        require(tk1.transferFrom(msg.sender, address(this), amountAIn), "TokenA transfer failed");// Transfiere TokenA del usuario al contrato(antes hay q aprovarlo)

        require(tk2.transfer(msg.sender, amountBOut), "TokenB transfer failed");   // Transfiere TokenB del contrato al usuario
        emit SwapAforB(msg.sender, amountAIn, amountBOut);
    }

    function swapBforA(uint256 amountBIn) public {
        require(amountBIn > 0, "The amount of TokenB must be greater than 0");

        uint256 tokenA;
        uint256 tokenB;
        tokenA = tk1.balanceOf(address(this));// Reserva actual de TokenA
        tokenB = tk2.balanceOf(address(this));// Reserva actual de TokenB

        require(tokenA > 0 && tokenB > 0, "The pool does not have enough liquidity");

        uint256 amountAOut = tokenA - (tokenA * tokenB) / (tokenB + amountBIn);//Calcula cuanto de tokenA debe pasar

        require(amountAOut > 0, "The output amount of token A must be greater than 0");
        require(amountAOut <= tokenA, "The contract does not have enough tokenA");

      
        require(tk2.transferFrom(msg.sender, address(this), amountBIn), "TokenB transfer failed");  // Transfiere TokenB del usuario al contrato(antes hay q aprobar)

        require(tk1.transfer(msg.sender, amountAOut), "TokenA transfer failed");   // Transfiere TokenA desde el contrato al usuario

        emit SwapBforA(msg.sender, amountBIn, amountAOut);
 }


    function removeLiquidity(uint256 amountA, uint256 amountB) public {
               
        require(tk1.transfer(owner,  amountA), "TokenA transfer failed");//solo quita
        require(tk2.transfer(owner, amountB), "TokenB transfer failed");//liquidez el owner
        emit RemoveLiquidity(owner, amountA, amountB);
}


    function getPrice(address _token)public view returns(uint256){
        require(_token == address(tk1) || _token == address(tk2), "Token not supported");

        uint256 reserveA = tk1.balanceOf(address(this));
        uint256 reserveB = tk2.balanceOf(address(this));

        require(reserveA > 0 && reserveB > 0, "Insufficient reserves");

        uint256 precio;

        if (_token == address(tk1)) {
           precio = (reserveB * (10 ** 18)) / reserveA;  // Precio de tokenA en relacion a tokenB
        } else {
            precio = (reserveA * (10 ** 18)) / reserveB;  // Precio de tokenB en relacion a tokenA
        }

        return precio;
        }


   // function Owner() public view returns (address) {
  //      return owner;
  //      }
  

}

