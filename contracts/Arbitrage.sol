// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 <= 0.8.13;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/lib/contracts/libraries/Babylonian.sol';
import '@uniswap/lib/contracts/libraries/TransferHelper.sol';

import '@uniswap/v2-periphery/contracts/libraries/UniswapV2LiquidityMathLibrary.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IERC20.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';
import '@uniswap/v2-periphery/contracts/libraries/SafeMath.sol';
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';


interface IDODO {
    function flashLoan(
        uint256 baseAmount,
        uint256 quoteAmount,
        address assetTo,
        bytes calldata data
    ) external;

    function _BASE_TOKEN_() external view returns (address);
}


contract Arbitrage {

    IUniswapV2Router02 public immutable buyRouter;
    IUniswapV2Router02 public immutable sellRouter;

    address public owner;
    // It's easy to get lost so here is the basic route of the FlashLoan
    // dodoFlashLoan() => IDODO._BASE_TOKEN_() => DDPFlashLoanCall() => _FlashLoanCallBack()

    function dodoFlashLoan(
    address flashLoanPool, //You will make a flashloan from this DODOV2 pool
    address loanToken,
    uint256 loanAmount,
    
    // These are extra parameters we want to send through the dodoFlashLoan() function. 
    // These will be passed back from IDODO _BASE_TOKEN_() function to 
    // the correct ***FlashLoanCall() function based on the pool address provided.

    address token1,
    uint256 balanceBefore, 
    address buyRouter,
    address sellRouter

    ) internal  {

        // Custom Structured Data
        bytes memory data = abi.encode(flashLoanPool, loanToken, loanAmount, token1, balanceBefore, buyRouter, sellRouter);

        //DODO 
        address flashLoanBase = IDODO(flashLoanPool)._BASE_TOKEN_();
        if(flashLoanBase == loanToken) {
            IDODO(flashLoanPool).flashLoan(loanAmount, 0, address(this), data);
        } else {
            IDODO(flashLoanPool).flashLoan(0, loanAmount, address(this), data);
        }
    }

    function executeTrade(
        address _flashLoanPool,
        address _token0,
        address _token1,
        uint256 _flashAmount,
        address _buyRouter,
        address _sellRouter
    ) external {
        //Set Extra Variables for Custom Data
        uint256 balanceBefore = IERC20(_token0).balanceOf(address(this));

        //Call FlashLoan with required and extra parameters. That have been sent by executeTrade() parameters.
        // On execution the dodoFlashLoan should trigger callback function based on the Factory Contract
        // that contains the pool specified by _flashLoanPool
        dodoFlashLoan(_flashLoanPool, _token0, _flashAmount, _token1, balanceBefore, _buyRouter, _sellRouter); 
    }

    // swaps an amount of either token such that the trade is profit-maximizing, given an external true price
    // true price is expressed in the ratio of token A to token B
    // caller must approve this contract to spend whichever token is intended to be swapped
    function getMaxSwap(
        address tokenA,
        address tokenB,
        uint256 truePriceTokenA,
        uint256 truePriceTokenB,
        uint256 maxSpendTokenA,
        uint256 maxSpendTokenB,
        address router,
        address factory
    ) public returns (amountIn) {
        // true price is expressed as a ratio, so both values must be non-zero
        require(truePriceTokenA != 0 && truePriceTokenB != 0, "ExampleSwapToPrice: ZERO_PRICE");
        // caller can specify 0 for either if they wish to swap in only one direction, but not both
        require(maxSpendTokenA != 0 || maxSpendTokenB != 0, "ExampleSwapToPrice: ZERO_SPEND");


        bool aToB;
        uint256 amountIn;
        {
            (uint256 reserveA, uint256 reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
            (aToB, amountIn) = UniswapV2LiquidityMathLibrary.computeProfitMaximizingTrade(
                truePriceTokenA, truePriceTokenB,
                reserveA, reserveB
            );
        }

        require(amountIn > 0, 'ExampleSwapToPrice: ZERO_AMOUNT_IN');

        // spend up to the allowance of the token in
        uint256 maxSpend = aToB ? maxSpendTokenA : maxSpendTokenB;
        if (amountIn > maxSpend) {
            amountIn = maxSpend;
        }

        address tokenIn = aToB ? tokenA : tokenB;
        address tokenOut = aToB ? tokenB : tokenA;

        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        return amountIn;
    }

    function DVMFlashLoanCall(
        address sender, 
        uint256 baseAmount, 
        uint256 quoteAmount,
        bytes calldata data
        ) external {
        _flashLoanCallBack(sender, baseAmount, quoteAmount, data);
    }

    //Note: CallBack function executed by DODOV2(DPP) flashLoan pool
    function DPPFlashLoanCall(
        address sender,
        uint256 baseAmount,
        uint256 quoteAmount,
        bytes calldata data
           ) external {
        _flashLoanCallBack(sender, baseAmount, quoteAmount, data);
    }

    //Note: CallBack function executed by DODOV2(DSP) flashLoan pool
    function DSPFlashLoanCall(
        address sender, 
        uint256 baseAmount, 
        uint256 quoteAmount,
        bytes calldata data
         ) external {
        _flashLoanCallBack(sender,baseAmount,quoteAmount,data);
    }


    function _flashLoanCallBack(
        address sender, 
        uint256, 
        uint256,
        bytes calldata data
        ) internal {
        (
            address flashLoanPool,
            address token0,
            uint256 flashAmount,
            address token1,
            uint256 balanceBefore,
            address _buyRouter,
            address _sellRouter
        ) = abi.decode(data, (address, address, uint256, address, uint256, address, address));

        uint256 balanceAfter = IERC20(token0).balanceOf(address(this));

        require(
            sender == address(this) && msg.sender == flashLoanPool, 
            "HANDLE_FLASH_DENIED"
        );

        // Make sure that there is enough tokens in 
        // the msg.senderaccount.
        require(balanceAfter - balanceBefore == flashAmount, "contract did not get the loan");

        // Set an in-memory array variable called path that 
        // will hold two addresses in an Array.
        address[] memory path = new address[](2);

        path[0] = token0;
        path[1] = token1;

        _swapOnBuyExchange(path, flashAmount, 0, _buyRouter);

        path[0] = token1;
        path[1] = token0;

        _swapOnSellExchange(
            path,
            IERC20(token1).balanceOf(address(this)),
            (flashAmount + 1),
            _sellRouter
        );      

        uint256 arbitrageReturns = IERC20(token0).balanceOf(address(this) - (flashAmount + 1));
        uint256 swapyardfee = arbitrageReturns.mul(997);
        uint256 profit = arbitrageReturns - swapyardfee;

        // Withdraw Profit
        IERC20(token0).transfer(owner, profit);
        
        // Payback Flashloan
        IERC20(token0).transfer(flashLoanPool, flashAmount);
    }

    // -- INTERNAL FUNCTIONS -- //

    function _swapOnSellExchange(
        address[] memory _path,
        uint256 _amountIn,
        uint256 _amountOut,
        address _sellRouter
    ) internal {

        sellRouter = IUniswapV2Router02(_sellRouter); 

        require(
            // Get Approval For Swap
            IERC20(_path[0]).approve(address(sellRouter), _amountIn),
            "Sell Exchange approval failed."
        );

        //Perform the Swap
        sellRouter.swapExactTokensForTokens(
            _amountIn,
            _amountOut,
            _path,
            address(this),
            (block.timestamp + 1200)
        );
    }

    function _swapOnBuyExchange(
        address[] memory _path,
        uint256 _amountIn,
        uint256 _amountOut,
        address _buyRouter
    ) internal {

        buyRouter = IUniswapV2Router02(_buyRouter); 

        require(
            //Get Approval for Swap
            IERC20(_path[0]).approve(address(buyRouter), _amountIn),
            "Buy Exchange approval failed."
        );

        buyRouter.swapExactTokensForTokens(
            _amountIn,
            _amountOut,
            _path,
            address(this),
            (block.timestamp + 1200)
        );
    }
}