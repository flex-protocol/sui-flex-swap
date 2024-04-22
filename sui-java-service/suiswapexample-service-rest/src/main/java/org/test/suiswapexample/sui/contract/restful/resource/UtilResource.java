package org.test.suiswapexample.sui.contract.restful.resource;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.test.suiswapexample.sui.contract.utils.LiquidityUtil;
import org.test.suiswapexample.sui.contract.utils.SwapUtil;

import java.math.BigInteger;

@RequestMapping(path = "utils", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class UtilResource {

    @GetMapping(path = "calculateSwapAmountOut")
    public BigInteger calculateSwapAmountOut(@RequestParam BigInteger xReserve,
                                             @RequestParam BigInteger yReserve,
                                             @RequestParam BigInteger xAmountIn,
                                             @RequestParam BigInteger feeNumerator,
                                             @RequestParam BigInteger feeDenominator
    ) {
        return SwapUtil.calculateSwapAmountOut(xReserve, yReserve, xAmountIn, feeNumerator, feeDenominator);
    }

    @GetMapping(path = "calculateLiquidity")
    public BigInteger calculateLiquidity(@RequestParam BigInteger totalSupplied,
                                         @RequestParam BigInteger xReserve,
                                         @RequestParam BigInteger yReserve,
                                         @RequestParam BigInteger xAmount,
                                         @RequestParam BigInteger yAmount
    ) {
        return LiquidityUtil.calculateLiquidity(totalSupplied, xReserve, yReserve, xAmount, yAmount);
    }

    // Calculate the token pair amounts of Liquidity.
    @GetMapping(path = "calculateTokenPairAmountsOfLiquidity")
    public BigInteger[] calculateTokenPairAmountsOfLiquidity(@RequestParam BigInteger totalSupplied,
                                                             @RequestParam BigInteger xReserve,
                                                             @RequestParam BigInteger yReserve,
                                                             @RequestParam BigInteger liquidity
    ) {
        return LiquidityUtil.getPairAmounts(totalSupplied, xReserve, yReserve, liquidity);
    }

}
