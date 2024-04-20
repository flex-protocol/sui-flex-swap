package org.test.suiswapexample.sui.contract.utils;

import java.math.BigInteger;

public class SwapUtil {
    public static final BigInteger MIN_Y_FEE = BigInteger.ONE;

    private SwapUtil() {
    }

    /*
    const MIN_X_FEE: u128 = 1;
    const MIN_Y_FEE: u128 = 1;

    public fun swap(x_reserve: u64, y_reserve: u64, x_amount_in: u64,
                    fee_numerator: u64, fee_denominator: u64
    ): u64 {
        let y_amount_out: u128;
        let k = (x_reserve as u128) * (y_reserve as u128);
        //std::debug::print(&k);
        y_amount_out = (y_reserve as u128) - k / ((x_reserve as u128) + (x_amount_in as u128));
        //std::debug::print(&y_amount_out);
        let y_fee = y_amount_out * (fee_numerator as u128) / (fee_denominator as u128);
        if (y_fee < MIN_Y_FEE) {
            y_fee = MIN_Y_FEE;
        };
        //std::debug::print(&y_fee);
        if (y_amount_out >= y_fee) {
            y_amount_out = y_amount_out - y_fee;
        } else {
            y_amount_out = 0;
        };
        (y_amount_out as u64)
    }
     */

    public static BigInteger calculateSwapAmountOut(BigInteger x_reserve, BigInteger y_reserve,
                                                    BigInteger x_amount_in,
                                                    BigInteger fee_numerator, BigInteger fee_denominator) {
        BigInteger y_amount_out;
        BigInteger k = x_reserve.multiply(y_reserve);
        y_amount_out = y_reserve.subtract(k.divide(x_reserve.add(x_amount_in)));
        BigInteger y_fee = y_amount_out.multiply(fee_numerator).divide(fee_denominator);
        if (y_fee.compareTo(MIN_Y_FEE) < 0) {
            y_fee = MIN_Y_FEE;
        }
        if (y_amount_out.compareTo(y_fee) >= 0) {
            y_amount_out = y_amount_out.subtract(y_fee);
        } else {
            y_amount_out = BigInteger.ZERO;
        }
        return y_amount_out;
    }
}
