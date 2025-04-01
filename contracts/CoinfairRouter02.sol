// Mozilla Public License 2.0

pragma solidity =0.6.6;
// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}

// File: contracts\interfaces\ICoinfairRouter01.sol

pragma solidity =0.6.6;

interface ICoinfairWarmRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        address to,
        uint deadline,
        bytes calldata cmd)external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        bytes calldata cmd,
        address to,
        uint deadline,
        uint fee
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        uint8 poolType,
        uint fee
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        uint8 poolType,
        uint fee
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        uint8 poolType,
        uint fee
    ) external returns (uint amountETH);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint exponentIn, uint exponentOut, uint fee, bool roolOver) external view returns (uint amountOut, uint amountFee);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint exponentIn, uint exponentOut, uint fee, bool roolOver) external view returns (uint amountIn, uint amountFee);
    function getAmountOutWithLiqFee(uint amountIn, uint reserveIn, uint reserveOut, uint exponentIn, uint exponentOut, uint fee, bool roolOver) external view returns (uint amountOut, uint amountFee);
    function getAmountInWithLiqFee(uint amountOut, uint reserveIn, uint reserveOut, uint exponentIn, uint exponentOut, uint fee, bool roolOver) external view returns (uint amountIn, uint amountFee);
    function getAmountsOut(uint amountIn, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath) external view returns (uint[] memory amounts,uint[] memory amountFees);
    function getAmountsIn(uint amountOut, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath) external view returns (uint[] memory amounts,uint[] memory amountFees);
}

// File: contracts\interfaces\ICoinfairRouter02.sol

pragma solidity =0.6.6;

interface ICoinfairHotRouter{
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    ) external;
}

// File: contracts\interfaces\ICoinfairFactory.sol

pragma solidity =0.6.6;

interface ICoinfairFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function getPair(address tokenA, address tokenB, uint8 poolType, uint fee) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB,uint256 exponentA,uint256 exponentB,uint fee) external returns (address pair);

    function feeToSetter() external view returns (address);
    function setFeeToSetter(address) external;
    function setFeeTo(address) external;
    function setFeeToWeight(uint8) external;

    function hotRouterAddress() external view returns (address);

    function feeTo() external view returns (address);

    function feeToWeight() external view returns (uint8);

    function CoinfairTreasury() external view returns(address);
    
    function WETH()external view returns(address);
}

// File: contracts\libraries\SafeMath.sol

pragma solidity =0.6.6;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }

}

// File: contracts\interfaces\ICoinfairPair.sol

pragma solidity =0.6.6;

interface ICoinfairPair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function nonces(address owner) external view returns (uint);

    event Mint(address indexed sender, uint acmount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function getExponents() external view returns (uint256 exponent0, uint256 exponent1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
    function getFee() external view returns (uint);
    function getPoolType() external view returns (uint8);
    function getProjectCommunityAddress()external view returns (address);
    function getRoolOver()external view returns (bool);
    function isPoolFeeOn()external view returns (uint);
    function setIsPoolFeeOn(uint) external;
    function setRoolOver(bool) external;
    function setProjectCommunityAddress(address)external;

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, uint fee ,address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address, uint256, uint256,uint,uint8) external;
    
}

pragma solidity =0.6.6;

library CoinfairLibrary {
    using SafeMath for uint;

    uint private constant pow128 = 2 ** 128;
    uint private constant pow64 = 2 ** 64;

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt_new(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log_2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        //unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        //}
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log_2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        //unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        //}
        return result;
    }


    function gcd(uint256 a, uint256 b) internal pure returns (uint256) {
        while (b > 0) {
            uint256 temp=b;
            b = a%b;
            a = temp;
        }
        return a;
    }

    // Calculate a/b power of n
    function exp(uint256 n, uint256 a, uint256 b) public pure returns (uint256) {
        if (a == b) {
            return n;
        }
        uint256 g = gcd(a, b);
        a = a/g;
        b = b/g;
        if(a==1 && b == 4){
            return sqrt_new(sqrt_new( n * pow128) * pow64);
        }

        if(a ==4 && b ==1){
             return n * n  / pow64 * n / pow64 * n / pow128;
        }

        if(a == 1 && b == 32){
            return sqrt_new(sqrt_new(sqrt_new(sqrt_new(sqrt_new(n * pow128) * pow64) * pow64) * pow64) * pow64);
        }

        if(a == 32 && b == 1){
            uint q = n * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            q = q * n / pow64;
            return q * n / pow128;
        }

        return n;
    }

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'CoinfairLibrary: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'CoinfairLibrary: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB, uint8 poolType, uint fee) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1, poolType, fee)),
                hex'4033205ecf07ac298f1fa57534ce414e1812664b4e71735477e7603edb6bfddf' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB,uint8 poolType, uint fee) internal view returns (uint reserveA, uint reserveB) {
        address token0 = ICoinfairPair(pairFor(factory, tokenA, tokenB, poolType, fee)).token0();
        (uint reserve0, uint reserve1,) = ICoinfairPair(pairFor(factory, tokenA, tokenB, poolType, fee)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // fetches and sorts the exponents for a pair
    function getExponents(address factory, address tokenA, address tokenB, uint8 poolType, uint fee) internal view returns (uint exponentA, uint exponentB) {
        address token0 = ICoinfairPair(pairFor(factory, tokenA, tokenB, poolType, fee)).token0();
        (uint256 exponent0, uint256 exponent1,) = ICoinfairPair(pairFor(factory, tokenA, tokenB, poolType, fee)).getExponents();
        (exponentA, exponentB) = tokenA == token0 ? (exponent0, exponent1) : (exponent1, exponent0);
    }

    // fetches and sorts the exponents for a pair
    function getDecimals(address tokenA, address tokenB) internal view returns (uint decimalsA, uint decimalsB) {
        (decimalsA, decimalsB) = (IERC20(tokenA).decimals(), IERC20(tokenB).decimals());
    }

    // given some amount of an asset and pair reserves, returns the amount of another asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'CoinfairLibrary: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'CoinfairLibrary: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    // Based on the K conservation formula, when the amountIn A token is entered, how many B tokens need to be returned after deducting the service charge, and the result is rounded down
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint256 exponentIn, uint256 exponentOut, uint fee, bool tokenDir) public pure returns (uint amountOut, uint amountOutFee) {
        require(amountIn > 0, 'CoinfairLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'CoinfairLibrary: INSUFFICIENT_LIQUIDITY');

        if (exponentIn < exponentOut || (exponentIn == exponentOut && tokenDir)){
            // Round up the result of exp to make the output smaller
            uint256 K = (exp(reserveIn, exponentIn, 32).add(1)).mul(exp(reserveOut, exponentOut, 32).add(1));
            uint256 amountInReal = amountIn.mul(uint256(1000).sub(fee))/1000;
            // Here * 1000-ICoinfairFactory(factory).fee/1000 will be taken down to make the output smaller
            uint256 denominator = exp(reserveIn.add(amountInReal), exponentIn, 32); 
            // Round up here to make the output smaller
            uint256 tmp = K.add(denominator-1)/denominator; 
            // Round up here to make the output smaller
            tmp = exp(tmp, 32, exponentOut).add(1); 
            amountOut = reserveOut.sub(tmp);
            amountOutFee = amountIn.sub(amountInReal);
        }
        else{
            // Round up the result of exp to make the output smaller
            uint256 K = (exp(reserveIn, exponentIn, 32).add(1)).mul(exp(reserveOut, exponentOut, 32).add(1));
            // Here * 1000-ICoinfairFactory(factory).fee/1000 will be taken down to make the output smaller
            uint256 denominator = exp(reserveIn.add(amountIn), exponentIn, 32); 
            // Round up here to make the output smaller
            uint256 tmp = K.add(denominator-1)/denominator; 
            // Round up here to make the output smaller
            tmp = exp(tmp, 32, exponentOut).add(1);
            uint256 amountOutTotal = reserveOut.sub(tmp);
            amountOut = amountOutTotal.mul(uint256(1000).sub(fee))/1000;
            amountOutFee = amountOutTotal.sub(amountOut);
        }

    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    // Based on the K conservation formula, if you want to replace the amountOut B token, how many A tokens need to be input when the service charge is included, and the result is rounded up
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint256 exponentIn, uint256 exponentOut, uint fee, bool tokenDir) public pure returns (uint amountIn, uint amountInFee) {
        require(amountOut > 0, 'CoinfairLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'CoinfairLibrary: INSUFFICIENT_LIQUIDITY');
        if (exponentIn < exponentOut || (exponentIn == exponentOut && tokenDir)){
            // Round up the result of exp to make the input larger
            uint256 K = (exp(reserveIn, exponentIn, 32).add(1)).mul(exp(reserveOut, exponentOut, 32).add(1));
            // The exp result itself is rounded down, and the input becomes larger
            uint256 denominator = exp(reserveOut.sub(amountOut), exponentOut, 32);
            // The result is rounded up to make the input larger
            uint256 tmp = K.add(denominator-1)/denominator;
            // The result is rounded up to make the input larger
            tmp = exp(tmp, 32, exponentIn).add(1);
            tmp = tmp.sub(reserveIn);
            // The result is rounded up to make the input larger
            amountIn = tmp.mul(1000).add(uint256(999).sub(fee)) / (uint256(1000).sub(fee));
            amountInFee = amountIn.sub(tmp);
        }else{
            // Round up the result of exp to make the input larger
            uint256 K = (exp(reserveIn, exponentIn, 32).add(1)).mul(exp(reserveOut, exponentOut, 32).add(1));
            uint amountOutTotal = amountOut.mul(uint256(1000).add(fee))/1000;
            // The exp result itself is rounded down, and the input becomes larger
            uint256 denominator = exp(reserveOut.sub(amountOutTotal), exponentOut, 32);
            // The result is rounded up to make the input larger
            uint256 tmp = K.add(denominator-1)/denominator;
            // The result is rounded up to make the input larger
            tmp = exp(tmp, 32, exponentIn).add(1);
            amountIn = tmp.sub(reserveIn);
            amountInFee = amountOutTotal.sub(amountOut);

        }
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    // Based on the K conservation formula, when the amountIn A token is entered, how many B tokens need to be returned after deducting the service charge, and the result is rounded down
    function getAmountOutWithLiqFee(uint amountIn, uint reserveIn, uint reserveOut, uint256 exponentIn, uint256 exponentOut, uint fee, bool tokenDir) public pure returns (uint amountOut, uint amountOutFee) {
        require(amountIn > 0, 'CoinfairLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'CoinfairLibrary: INSUFFICIENT_LIQUIDITY');

        if (exponentIn < exponentOut || (exponentIn == exponentOut && tokenDir)){
            // Round up the result of exp to make the output smaller
            uint256 K = (exp(reserveIn, exponentIn, 32).add(1)).mul(exp(reserveOut, exponentOut, 32).add(1));
            uint256 amountInReal = amountIn.mul(uint256(1000).sub(fee))/1000;
            uint256 amountInWithFee = amountInReal.mul(997)/1000;
            // Here * 1000-ICoinfairFactory(factory).fee/1000 will be taken down to make the output smaller
            uint256 denominator = exp(reserveIn.add(amountInWithFee), exponentIn, 32); 
            // Round up here to make the output smaller
            uint256 tmp = K.add(denominator-1)/denominator; 
            // Round up here to make the output smaller
            tmp = exp(tmp, 32, exponentOut).add(1); 
            amountOut = reserveOut.sub(tmp);
            amountOutFee = amountIn.sub(amountInReal);
        }
        else{
            // Round up the result of exp to make the output smaller
            uint256 K = (exp(reserveIn, exponentIn, 32).add(1)).mul(exp(reserveOut, exponentOut, 32).add(1));
            // Here * 1000-ICoinfairFactory(factory).fee/1000 will be taken down to make the output smaller
            uint256 amountInWithFee = amountIn.mul(997)/1000;
            uint256 denominator = exp(reserveIn.add(amountInWithFee), exponentIn, 32); 
            // Round up here to make the output smaller
            uint256 tmp = K.add(denominator-1)/denominator; 
            // Round up here to make the output smaller
            tmp = exp(tmp, 32, exponentOut).add(1);
            uint256 amountOutTotal = reserveOut.sub(tmp);
            amountOut = amountOutTotal.mul(uint256(1000).sub(fee))/1000;
            amountOutFee = amountOutTotal.sub(amountOut);
        }

    }
    
    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    // Based on the K conservation formula, if you want to replace the amountOut B token, how many A tokens need to be input when the service charge is included, and the result is rounded up
    function getAmountInWithLiqFee(uint amountOut, uint reserveIn, uint reserveOut, uint256 exponentIn, uint256 exponentOut, uint fee, bool tokenDir) public pure returns (uint amountIn, uint amountInFee) {
        require(amountOut > 0, 'CoinfairLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'CoinfairLibrary: INSUFFICIENT_LIQUIDITY');
        if (exponentIn < exponentOut || (exponentIn == exponentOut && tokenDir)){
            // Round up the result of exp to make the input larger
            uint256 K = (exp(reserveIn, exponentIn, 32).add(1)).mul(exp(reserveOut, exponentOut, 32).add(1));
            // The exp result itself is rounded down, and the input becomes larger
            uint256 denominator = exp(reserveOut.sub(amountOut), exponentOut, 32);
            // The result is rounded up to make the input larger
            uint256 tmp = K.add(denominator-1)/denominator;
            // The result is rounded up to make the input larger
            tmp = exp(tmp, 32, exponentIn).add(1);
            tmp = tmp.sub(reserveIn);
            // The result is rounded up to make the input larger
            uint amountInTotal = tmp.mul(1000).add(uint256(999).sub(fee)) / (uint256(1000).sub(fee));
            amountIn = amountInTotal.mul(1000)/997;
            amountInFee = amountInTotal.sub(tmp);
        }else{
            // Round up the result of exp to make the input larger
            uint256 K = (exp(reserveIn, exponentIn, 32).add(1)).mul(exp(reserveOut, exponentOut, 32).add(1));
            uint amountOutTotal = amountOut.mul(uint256(1000).add(fee))/1000;
            // The exp result itself is rounded down, and the input becomes larger
            uint256 denominator = exp(reserveOut.sub(amountOutTotal), exponentOut, 32);
            // The result is rounded up to make the input larger
            uint256 tmp = K.add(denominator-1)/denominator;
            // The result is rounded up to make the input larger
            tmp = exp(tmp, 32, exponentIn).add(1);
            amountIn = tmp.sub(reserveIn).mul(1000)/997;
            amountInFee = amountOutTotal.sub(amountOut);
        }
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path, uint8[] memory poolTypePath, uint[] memory feePath) internal view returns (uint[] memory amounts,uint[] memory amountsFee){
        require(path.length >= 2, 'CoinfairLibrary: INVALID_PATH');
        require(path.length == poolTypePath.length + 1, 'Coinfair: INVALID_LENGTH');
        amounts = new uint[](path.length);
        amountsFee = new uint[](path.length - 1);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            require(ICoinfairFactory(factory).getPair(path[i], path[i + 1], poolTypePath[i], feePath[i]) != address(0), 'Coinfair:NO_PAIR');
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1], poolTypePath[i], feePath[i]);
            (uint256 exponentIn, uint256 exponentOut) = getExponents(factory, path[i], path[i + 1], poolTypePath[i], feePath[i]);
            //(uint256 decimalsIn, uint256 decimalsOut) = getDecimals(path[i], path[i + 1]);
            // uint _fee = ICoinfairPair(ICoinfairFactory(factory).getPair(path[i], path[i + 1], poolTypePath[i], feePath[i])).getFee();
            bool roolOver = ICoinfairPair(ICoinfairFactory(factory).getPair(path[i], path[i + 1], poolTypePath[i], feePath[i])).getRoolOver();
            bool tokenDir = roolOver == (ICoinfairPair(ICoinfairFactory(factory).getPair(path[i], path[i + 1], poolTypePath[i], feePath[i])).token0() == path[i]);
            if(ICoinfairPair(ICoinfairFactory(factory).getPair(path[i], path[i + 1], poolTypePath[i], feePath[i])).isPoolFeeOn() > 0){
                (amounts[i + 1], amountsFee[i]) = getAmountOutWithLiqFee(amounts[i], reserveIn, reserveOut, exponentIn, exponentOut, feePath[i], tokenDir);
            }else{
                (amounts[i + 1], amountsFee[i]) = getAmountOut(amounts[i], reserveIn, reserveOut, exponentIn, exponentOut, feePath[i], tokenDir);
            }
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path, uint8[] memory poolTypePath, uint[] memory feePath) internal view returns (uint[] memory amounts,uint[] memory amountsFee) {
        require(path.length >= 2, 'CoinfairLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amountsFee = new uint[](path.length - 1);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            require(ICoinfairFactory(factory).getPair(path[i - 1], path[i], poolTypePath[i - 1],feePath[i - 1]) != address(0), 'Coinfair:NO_PAIR');
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i], poolTypePath[i - 1], feePath[i - 1]);
            (uint256 exponentIn, uint256 exponentOut) = getExponents(factory, path[i - 1], path[i], poolTypePath[i - 1], feePath[i - 1]);
            //(uint256 decimalsIn, uint256 decimalsOut) = getDecimals(path[i - 1], path[i]);
            // uint _fee = ICoinfairPair(ICoinfairFactory(factory).getPair(path[i - 1], path[i], poolTypePath[i - 1],feePath[i - 1])).getFee();
            bool roolOver = ICoinfairPair(ICoinfairFactory(factory).getPair(path[i - 1], path[i], poolTypePath[i - 1],feePath[i - 1])).getRoolOver();
            bool tokenDir = roolOver == (ICoinfairPair(ICoinfairFactory(factory).getPair(path[i - 1], path[i], poolTypePath[i - 1], feePath[i - 1])).token0() == path[i - 1]);
            if(ICoinfairPair(ICoinfairFactory(factory).getPair(path[i - 1], path[i], poolTypePath[i - 1],feePath[i - 1])).isPoolFeeOn() > 0){
                (amounts[i - 1], amountsFee[i - 1]) = getAmountInWithLiqFee(amounts[i], reserveIn, reserveOut, exponentIn, exponentOut, feePath[i - 1], tokenDir);
            }else{
                (amounts[i - 1], amountsFee[i - 1]) = getAmountIn(amounts[i], reserveIn, reserveOut, exponentIn, exponentOut, feePath[i - 1], tokenDir);
            }
        }
    }
}

// File: contracts\interfaces\IERC20.sol

pragma solidity =0.6.6;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

// File: contracts\interfaces\IWETH.sol

pragma solidity =0.6.6;

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
    function balanceOf(address) external view returns (uint);
}

interface ICoinfairTreasury {
    
    event CollectFee(
        address token, 
        address indexed parent, 
        address indexed grandParent, 
        address indexed communityAddress,
        uint parentAmount, 
        uint grandParentAmount, 
        uint communityAddressAmount,
        address owner
    );

    event WithdrawFee(address indexed token, address indexed owner, uint amount);

    function collectFee(address token, address owner, uint amount, address pair) external;

    function withdrawFee(address token) external;

    function setRatio(uint, uint , uint, uint, uint) external;

    function setProjectCommunityAddress(address pair, address newProjectCommunityAddress) external;

    function setIsPoolFeeOn(address pair, uint newIsPoolFeeOn) external;

    function setRoolOver(address pair, bool newRoolOver) external;
}

// File: contracts\CoinfairWarmRouter.sol

pragma solidity =0.6.6;

contract CoinfairWarmRouter is ICoinfairWarmRouter {
    using SafeMath for uint;

    string public constant AUTHORS = "@CoinfairGlobal";

    address public immutable override factory;
    address public immutable override WETH;

    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'CoinfairRouter: EXPIRED');
        _;
    }

    constructor(address _factory) public {
        require(_factory != address(0));
        factory = _factory;
        WETH = 0x2cA88A998f9689fF2b2927F2b433298e28Ddae5e;
    }

    receive() external payable {
        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
    }

    // **** ADD LIQUIDITY ****
    // cmd = abi.encode(tokenA, tokenB, exponentA, exponentB, _fee)
    function _addLiquidity(
        bytes memory _addLiquidityCmd,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin
    ) internal virtual returns (uint, uint, uint8, uint) {
        (uint reserveA, uint reserveB, uint8 _poolType, uint _fee) = _addLiquidityAssist_(_addLiquidityCmd);
        uint amountA;
        uint amountB;
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint amountBOptimal = CoinfairLibrary.quote(amountADesired, reserveA, reserveB);
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, 'CoinfairRouter: INSUFFICIENT_B_AMOUNT');
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint amountAOptimal = CoinfairLibrary.quote(amountBDesired, reserveB, reserveA);
                assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, 'CoinfairRouter: INSUFFICIENT_A_AMOUNT');
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }

        return (amountA, amountB, _poolType, _fee);
    }

    function _addLiquidityAssist_(bytes memory _addLiquidityCmd)internal virtual returns(uint reserveA, uint reserveB, uint8 poolType, uint fee){
        (address tokenA, address tokenB, uint256 exponentA, uint256 exponentB, uint _fee) = abi.decode(_addLiquidityCmd,(address, address, uint256, uint256, uint));
        fee = _fee;

        if(tokenA < tokenB){
            if(exponentA == 32 && exponentB == 32){poolType=1;}
            else if (exponentA == 32 && exponentB == 8){poolType = 2;}
            else if (exponentA == 8 && exponentB == 32){poolType = 3;}
            else if (exponentA == 32 && exponentB == 1){poolType = 4;}
            else if (exponentA == 1 && exponentB == 32){poolType = 5;}
        }else{
            if(exponentA == 32 && exponentB == 32){poolType=1;}
            else if (exponentA == 32 && exponentB == 8){poolType = 3;}
            else if (exponentA == 8 && exponentB == 32){poolType = 2;}
            else if (exponentA == 32 && exponentB == 1){poolType = 5;}
            else if (exponentA == 1 && exponentB == 32){poolType = 4;}
        }
        
        // create the pair if it doesn't exist yet
        if (ICoinfairFactory(factory).getPair(tokenA, tokenB, poolType, _fee) == address(0)) {
            ICoinfairTreasury(ICoinfairFactory(factory).CoinfairTreasury()).setProjectCommunityAddress(
                ICoinfairFactory(factory).createPair(tokenA, tokenB, exponentA, exponentB, _fee),
                msg.sender);
        }


        (reserveA, reserveB) = CoinfairLibrary.getReserves(factory, tokenA, tokenB, poolType, _fee);
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        address to,
        uint deadline,
        // cmd = abi.encode(uint amountADesired,uint amountBDesired,uint amountAMin,uint amountBMin,uint8 swapN,uint fee);
        bytes calldata addLiquidityCmd) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {

        uint8 poolType;
        uint fee;
        (amountA, amountB, poolType, fee) = _addLiquidityAssist(tokenA,tokenB,addLiquidityCmd);
        // require(amountA > 0 && amountB > 0,"You have to have the token to prove it's not a dos attack");
        address pair = CoinfairLibrary.pairFor(factory, tokenA, tokenB, poolType, fee);
        TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
        TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
        liquidity = ICoinfairPair(pair).mint(to);
    }

    function _addLiquidityAssist(address tokenA, address tokenB, bytes memory addLiquidityCmd)internal returns(uint,uint,uint8,uint){
        (uint amountADesired,uint amountBDesired,uint amountAMin,uint amountBMin,uint8 swapN,uint fee) = abi.decode(addLiquidityCmd,(uint,uint,uint,uint,uint8,uint));
        require(fee == 1 || fee == 3 || fee == 5 || fee == 10, "ERROR FEE");
        bytes memory _addLiquidityCmd;
        if(swapN == 1){
            _addLiquidityCmd = abi.encode(tokenA, tokenB, 32, 32, fee);
        }else if(swapN == 2){
            _addLiquidityCmd = abi.encode(tokenA, tokenB, 32, 8, fee);
        }else if(swapN == 4){
            _addLiquidityCmd = abi.encode(tokenA, tokenB, 32, 1, fee);
        }else{
            revert();
        }
        return _addLiquidity(_addLiquidityCmd, amountADesired, amountBDesired, amountAMin, amountBMin);
    }

    function addLiquidityETH(
        address token,
        // cmd = abi.encode(uint amountTokenDesired,uint amountTokenMin,uint amountETHMin,uint8 swapN)
        bytes calldata addLiquidityETHCmd,
        address to,
        uint deadline,
        uint fee
    ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) { 
        uint8 poolType;
        (amountToken, amountETH, poolType,) = _addLiquidityETHAssist(token,fee,addLiquidityETHCmd);
        // require(amountToken > 0,"You have to have the token to prove it's not a dos attack");
        address pair = CoinfairLibrary.pairFor(factory, token, WETH, poolType, fee);
        TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
        IWETH(WETH).deposit{value: amountETH}();
        assert(IWETH(WETH).transfer(pair, amountETH));
        liquidity = ICoinfairPair(pair).mint(to);
        // refund dust eth, if any
        if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
    }

    function _addLiquidityETHAssist(address token, uint fee, bytes memory addLiquidityETHCmd)internal returns(uint,uint,uint8,uint){
        (uint amountTokenDesired,uint amountTokenMin,uint amountETHMin,uint8 swapN) = abi.decode(addLiquidityETHCmd,(uint,uint,uint,uint8));
        require(fee == 1 || fee == 3 || fee == 5 || fee == 10, "ERROR FEE");
        bytes memory _addLiquidityCmd;
        if(swapN == 1){
            _addLiquidityCmd = abi.encode(token, WETH, 32, 32, fee);
        }else if(swapN == 2){
            // sequence == 0 && swapN == 2;
            _addLiquidityCmd = abi.encode(token, WETH, 32, 8, fee);
        }else if(swapN == 3){
            // sequence != 0 && swapN == 2;
            _addLiquidityCmd = abi.encode(token, WETH, 8, 32, fee);
        }else if(swapN == 4){
            // sequence == 0 && swapN == 3;
            _addLiquidityCmd = abi.encode(token, WETH, 32, 1, fee);
        }else if(swapN == 5){
            // sequence != 0 && swapN == 3;
            _addLiquidityCmd = abi.encode(token, WETH, 1, 32, fee);
        }else{
            revert();
        }
        return _addLiquidity(_addLiquidityCmd, amountTokenDesired,msg.value,amountTokenMin,amountETHMin);
    }

    // **** REMOVE LIQUIDITY ****
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        uint8 poolType,
        uint fee
    ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
        address pair = CoinfairLibrary.pairFor(factory, tokenA, tokenB, poolType, fee);
        ICoinfairPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair

        (amountA, amountB) = _removeLiquidityAssist(pair, to, tokenA, tokenB);

        require(amountA >= amountAMin, 'CoinfairRouter: INSUFFICIENT_A_AMOUNT');
        require(amountB >= amountBMin, 'CoinfairRouter: INSUFFICIENT_B_AMOUNT');
    }

    function _removeLiquidityAssist(address pair, address to, address tokenA, address tokenB)internal returns(uint amountA, uint amountB){
        (uint amount0, uint amount1) = ICoinfairPair(pair).burn(to);
        (address token0,) = CoinfairLibrary.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
    }
    
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        uint8 poolType, 
        uint fee
    ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
        (amountToken, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline,
            poolType,
            fee
        );
        TransferHelper.safeTransfer(token, to, amountToken);
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        uint8 poolType,
        uint fee
    ) public virtual override ensure(deadline) returns (uint amountETH) {
        (, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline,
            poolType,
            fee
        );
        TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    // **** LIBRARY FUNCTIONS ****
    function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
        return CoinfairLibrary.quote(amountA, reserveA, reserveB);
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint exponentIn, uint exponentOut,uint fee, bool roolOver)
        public
        view
        virtual
        override
        returns (uint amountOut,uint amountFee)
    {   
        return CoinfairLibrary.getAmountOut(amountIn, reserveIn, reserveOut, exponentIn, exponentOut, fee, roolOver);
    }

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint exponentIn, uint exponentOut,uint fee, bool roolOver)
        public
        view
        virtual
        override
        returns (uint amountIn,uint amountFee)
    {
        return CoinfairLibrary.getAmountIn(amountOut, reserveIn, reserveOut, exponentIn, exponentOut, fee, roolOver);
    }

    function getAmountOutWithLiqFee(uint amountIn, uint reserveIn, uint reserveOut, uint exponentIn, uint exponentOut,uint fee, bool roolOver)
        public
        view
        virtual
        override
        returns (uint amountOut,uint amountFee)
    {   
        return CoinfairLibrary.getAmountOutWithLiqFee(amountIn, reserveIn, reserveOut, exponentIn, exponentOut, fee, roolOver);
    }

    function getAmountInWithLiqFee(uint amountOut, uint reserveIn, uint reserveOut, uint exponentIn, uint exponentOut,uint fee, bool roolOver)
        public
        view
        virtual
        override
        returns (uint amountIn,uint amountFee)
    {
        return CoinfairLibrary.getAmountInWithLiqFee(amountOut, reserveIn, reserveOut, exponentIn, exponentOut, fee, roolOver);
    }

    function getAmountsOut(uint amountIn, address[] memory path, uint8[] memory poolTypePath, uint[] memory feePath)
        public
        view
        virtual
        override
        returns (uint[] memory amounts,uint[] memory amountFees)
    {
        return CoinfairLibrary.getAmountsOut(factory, amountIn, path, poolTypePath, feePath);
    }

    function getAmountsIn(uint amountOut, address[] memory path, uint8[] memory poolTypePath, uint[] memory feePath)
        public
        view
        virtual
        override
        returns (uint[] memory amounts,uint[] memory amountFees)
    {
        return CoinfairLibrary.getAmountsIn(factory, amountOut, path, poolTypePath, feePath);
    }
}


// File: contracts\CoinfairHotRouter.sol

pragma solidity =0.6.6;

contract CoinfairHotRouter is ICoinfairHotRouter {
    using SafeMath for uint;

    string public constant AUTHORS = "@CoinfairGlobal";

    address public immutable override factory;
    address public immutable override WETH;

    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'CoinfairRouter: EXPIRED');
        _;
    }

    constructor(address _factory) public {
        require(_factory != address(0));
        factory = _factory;
        WETH = 0x2cA88A998f9689fF2b2927F2b433298e28Ddae5e;
    }

    receive() external payable {
        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
    }

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pair
    function _swap(uint[] memory amounts, uint[] memory amountsFee, address[] memory path, uint8[] memory poolTypePath, uint[] memory feePath, address _to) internal virtual {
        for (uint i; i < path.length - 1; i++) {
            // (address input, address output) = (path[i], path[i + 1]);
            (address token0,) = CoinfairLibrary.sortTokens(path[i], path[i + 1]);
            uint amountOut = amounts[i + 1];
            (uint amount0Out, uint amount1Out) = path[i] == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
            address to = i < path.length - 2 ? CoinfairLibrary.pairFor(factory, path[i + 1], path[i + 2], poolTypePath[i + 1], feePath[i + 1]) : _to;
        
            ICoinfairPair(CoinfairLibrary.pairFor(factory, path[i], path[i + 1], poolTypePath[i], feePath[i])).swap(
                amount0Out, amount1Out, amountsFee[i], to, new bytes(0)
            );
        }
    }

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
        uint[] memory amountFee;
        (amounts , amountFee) = CoinfairLibrary.getAmountsOut(factory, amountIn, path, poolTypePath, feePath);
        require(amounts[amounts.length - 1] >= amountOutMin, 'CoinfairRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        
        _safeTransferFromAssist(path, poolTypePath, feePath, amounts);
        
        _swap(amounts, amountFee , path, poolTypePath, feePath, to);
    }

    function _safeTransferFromAssist(
        address[] memory path,
        uint8[] memory poolTypePath,
        uint[] memory feePath,
        uint[] memory amounts
    ) internal {
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, CoinfairLibrary.pairFor(factory, path[0], path[1], poolTypePath[0], feePath[0]), amounts[0]
        );
    }

    function swapTokensForExactTokens( 
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
         uint[] memory amountFee;
        (amounts,amountFee) = CoinfairLibrary.getAmountsIn(factory, amountOut, path, poolTypePath, feePath);
        require(amounts[0] <= amountInMax, 'CoinfairRouter: EXCESSIVE_INPUT_AMOUNT');
        _safeTransferFromAssist(path, poolTypePath, feePath, amounts);
        _swap(amounts, amountFee, path, poolTypePath, feePath, to);
    }

    function _swapTokensForExactTokensAssist(
        address[] memory path,
        uint8[] memory poolTypePath,
        uint[] memory feePath,
        uint[] memory amounts
    ) internal {
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, CoinfairLibrary.pairFor(factory, path[0], path[1], poolTypePath[0], feePath[0]), amounts[0]
        );
    }

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath, address to, uint deadline)
        external
        virtual
        override
        payable
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[0] == WETH, 'CoinfairRouter: INVALID_PATH');
         uint[] memory amountFee;
        (amounts,amountFee) = CoinfairLibrary.getAmountsOut(factory, msg.value, path, poolTypePath, feePath);
        require(amounts[amounts.length - 1] >= amountOutMin, 'CoinfairRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(CoinfairLibrary.pairFor(factory, path[0], path[1], poolTypePath[0], feePath[0]), amounts[0]));
        _swap(amounts, amountFee, path, poolTypePath, feePath, to);
    }

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath, address to, uint deadline)
        external
        virtual
        override
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[path.length - 1] == WETH, 'CoinfairRouter: INVALID_PATH');
        uint[] memory amountFee;
        (amounts,amountFee) = CoinfairLibrary.getAmountsIn(factory, amountOut, path, poolTypePath, feePath);
        require(amounts[0] <= amountInMax, 'CoinfairRouter: EXCESSIVE_INPUT_AMOUNT');
        _safeTransferFromAssist(path, poolTypePath, feePath, amounts);

        // _swap(amounts, amountFee, path, poolTypePath, feePath, address(this));
        // IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        // TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
        _swap(amounts, amountFee, path, poolTypePath, feePath, to);
        TransferHelper.safeTransferFrom(WETH, to, address(this), amounts[amounts.length - 1]);
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath, address to, uint deadline)
        external
        virtual
        override
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[path.length - 1] == WETH, 'CoinfairRouter: INVALID_PATH');
        uint[] memory amountFee;
        (amounts ,amountFee)= CoinfairLibrary.getAmountsOut(factory, amountIn, path, poolTypePath, feePath);
        require(amounts[amounts.length - 1] >= amountOutMin, 'CoinfairRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        _safeTransferFromAssist(path, poolTypePath, feePath, amounts);

        // _swap(amounts, amountFee, path, poolTypePath, feePath, address(this));
        // IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        // TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
        _swap(amounts, amountFee, path, poolTypePath, feePath, to);
        TransferHelper.safeTransferFrom(WETH, to, address(this), amounts[amounts.length - 1]);
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    function swapETHForExactTokens(uint amountOut, address[] calldata path, uint8[] calldata poolTypePath, uint[] calldata feePath, address to, uint deadline)
        external
        virtual
        override
        payable
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[0] == WETH, 'CoinfairRouter: INVALID_PATH');
         uint[] memory amountFee;
        (amounts, amountFee)= CoinfairLibrary.getAmountsIn(factory, amountOut, path, poolTypePath, feePath);
        require(amounts[0] <= msg.value, 'CoinfairRouter: EXCESSIVE_INPUT_AMOUNT');
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(CoinfairLibrary.pairFor(factory, path[0], path[1], poolTypePath[0], feePath[0]), amounts[0]));
        _swap(amounts, amountFee,path, poolTypePath, feePath, to);
        // refund dust eth, if any
        if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
    }

    // **** SWAP (supporting fee-on-transfer tokens) ****
    // requires the initial amount to have already been sent to the first pair
    function _swapSupportingFeeOnTransferTokens(address[] memory path, uint8[] memory poolTypePath, uint[] memory feePath, address _to) internal virtual {
        for (uint i; i < path.length - 1; i++) {
            // (address input, address output) = (path[i], path[i + 1]);
            (address token0,) = CoinfairLibrary.sortTokens(path[i], path[i + 1]);
            ICoinfairPair pair = ICoinfairPair(CoinfairLibrary.pairFor(factory, path[i], path[i + 1], poolTypePath[i], feePath[i]));
            
            (uint amountOutput,uint amountFee) = _swapSupportingFeeOnTransferTokensAssist(pair, path[i], token0, pair.getFee(), pair.getRoolOver() == (path[i] == token0));

            (uint amount0Out, uint amount1Out) = path[i] == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
            address to = i < path.length - 2 ? CoinfairLibrary.pairFor(factory, path[i + 1], path[i + 2], poolTypePath[i + 1], feePath[i + 1]) : _to;
            pair.swap(amount0Out, amount1Out, amountFee , to, new bytes(0));
        }
    }

    function _swapSupportingFeeOnTransferTokensAssist(ICoinfairPair pair, address input,address token0,uint fee, bool roolOver) internal view returns(uint amountOutput,uint amountFee){
        uint reserveInput;
        uint reserveOutput;
        uint256 exponentA;
        uint256 exponentB;
        {
            (uint reserve0, uint reserve1,) = pair.getReserves();
            (reserveInput, reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        }
        uint amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
        {
            (uint256 exponent0, uint256 exponent1,) = pair.getExponents();
            (exponentA, exponentB) = input == token0 ? (exponent0, exponent1) : (exponent1, exponent0);
        }
        //(uint256 decimalsA, uint256 decimalsB) = (IERC20(input).decimals(), IERC20(output).decimals());
        (amountOutput, amountFee) = CoinfairLibrary.getAmountOut(amountInput, reserveInput, reserveOutput, exponentA, exponentB, fee, roolOver);
            
    }

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    ) external virtual override ensure(deadline) {
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, CoinfairLibrary.pairFor(factory, path[0], path[1], poolTypePath[0], feePath[0]), amountIn
        );
        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(path, poolTypePath, feePath, to);
        require(
            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
            'CoinfairRouter: INSUFFICIENT_OUTPUT_AMOUNT'
        );
    }
    
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    )
        external
        virtual
        override
        payable
        ensure(deadline)
    {
        require(path[0] == WETH, 'CoinfairRouter: INVALID_PATH');
        uint amountIn = msg.value;
        IWETH(WETH).deposit{value: amountIn}();
        assert(IWETH(WETH).transfer(CoinfairLibrary.pairFor(factory, path[0], path[1], poolTypePath[0], feePath[0]), amountIn));
        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(path, poolTypePath, feePath, to);
        _swapExactETHForTokensSupportingFeeOnTransferTokensAssist(path, to, balanceBefore, amountOutMin);
    }

    function _swapExactETHForTokensSupportingFeeOnTransferTokensAssist(address[] memory path, address to, uint balanceBefore, uint amountOutMin) internal view{
        require(
            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
            'CoinfairRouter: INSUFFICIENT_OUTPUT_AMOUNT'
        );
    }
    
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        uint8[] calldata poolTypePath,
        uint[] calldata feePath,
        address to,
        uint deadline
    )
        external
        virtual
        override
        ensure(deadline)
    {
        require(path[path.length - 1] == WETH, 'CoinfairRouter: INVALID_PATH');
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, CoinfairLibrary.pairFor(factory, path[0], path[1], poolTypePath[0], feePath[0]), amountIn
        );
        // _swapSupportingFeeOnTransferTokens(path, poolTypePath, feePath, address(this));
        // uint amountOut = IERC20(WETH).balanceOf(address(this));
        // require(amountOut >= amountOutMin, 'CoinfairRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        // IWETH(WETH).withdraw(amountOut);
        // TransferHelper.safeTransferETH(to, amountOut);
        uint amountBefore = IWETH(WETH).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(path, poolTypePath, feePath, to);
        uint amountAfter = IWETH(WETH).balanceOf(to);
        require(amountAfter >= amountBefore);
        uint amountOut = amountAfter.sub(amountBefore);
        TransferHelper.safeTransferFrom(WETH, to, address(this), amountOut);
        require(amountOut >= amountOutMin, 'CoinfairRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        IWETH(WETH).withdraw(amountOut);
        TransferHelper.safeTransferETH(to, amountOut);
    }
}
