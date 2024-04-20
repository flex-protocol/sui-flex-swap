package org.test.suiswapexample.sui.contract.utils;

import java.math.BigInteger;

public class LiquidityUtil {

    //const MINIMUM_LIQUIDITY: u128 = 1000;
    public static final BigInteger MINIMUM_LIQUIDITY = BigInteger.valueOf(1000);

    private LiquidityUtil() {
    }

    /*
    public fun calculate_liquidity(
        total_supplied: u64,
        x_reserve: u64,
        y_reserve: u64,
        x_amount: u64,
        y_amount: u64
    ): u64
    {
        let liquidity = if (total_supplied == 0) {
            math::sqrt_u128((x_amount as u128) * (y_amount as u128)) - MINIMUM_LIQUIDITY
        } else {
            let x_liquidity = (x_amount as u128) * (total_supplied as u128) / (x_reserve as u128);
            let y_liquidity = (y_amount as u128) * (total_supplied as u128) / (y_reserve as u128);
            // use smaller one.
            if (x_liquidity < y_liquidity) {
                x_liquidity
            } else {
                y_liquidity
            }
        };
        (liquidity as u64)
    }
     */
    public static BigInteger calculateLiquidity(BigInteger total_supplied, BigInteger x_reserve, BigInteger y_reserve,
                                                BigInteger x_amount, BigInteger y_amount) {
        BigInteger liquidity = BigInteger.ZERO;
        if (total_supplied.equals(BigInteger.ZERO)) {
            // sqrt BigInteger "x_amount.multiply(y_amount)"
            liquidity = sqrt(x_amount.multiply(y_amount));
            if (liquidity.compareTo(MINIMUM_LIQUIDITY) >= 0) {
                liquidity = liquidity.subtract(MINIMUM_LIQUIDITY);
            } else {
                //throw new IllegalArgumentException("liquidity is less than MINIMUM_LIQUIDITY");
                liquidity = BigInteger.ZERO;
            }
        } else {
            BigInteger x_liquidity = x_amount.multiply(total_supplied).divide(x_reserve);
            BigInteger y_liquidity = y_amount.multiply(total_supplied).divide(y_reserve);
            if (x_liquidity.compareTo(y_liquidity) < 0) {
                liquidity = x_liquidity;
            } else {
                liquidity = y_liquidity;
            }
        }
        return liquidity;
    }

    /*
    public fun get_pair_amounts(
        total_supplied: u64,
        x_reserve: u64,
        y_reserve: u64,
        liquidity: u64
    ): (u64, u64)
    {
        let x_amount = (liquidity as u128) * (x_reserve as u128) / (total_supplied as u128);
        let y_amount = (liquidity as u128) * (y_reserve as u128) / (total_supplied as u128);
        ((x_amount as u64), (y_amount as u64))
    }
     */
    public static BigInteger[] getPairAmounts(BigInteger total_supplied,
                                              BigInteger x_reserve, BigInteger y_reserve,
                                              BigInteger liquidity) {
        BigInteger x_amount = liquidity.multiply(x_reserve).divide(total_supplied);
        BigInteger y_amount = liquidity.multiply(y_reserve).divide(total_supplied);
        return new BigInteger[]{x_amount, y_amount};
    }

    public static BigInteger sqrt(BigInteger x) {
        BigInteger div = BigInteger.ZERO.setBit(x.bitLength() / 2);
        BigInteger div2 = div;
        // Loop until we hit the same value twice in a row, or wind up alternating.
        for (; ; ) {
            BigInteger y = div.add(x.divide(div)).shiftRight(1);
            if (y.equals(div) || y.equals(div2))
                return y;
            div2 = div;
            div = y;
        }
    }

//    public static void main(String[] args) {
//        BigInteger number = new BigInteger("121");
//        BigInteger squareRoot = sqrt(number);
//        System.out.println("The square root of " + number + " is " + squareRoot);
//    }

}
