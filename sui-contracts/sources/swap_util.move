module sui_swap_example::swap_util {
    //use sui::math;

    const FEE_NUMERATOR: u64 = 3;
    const FEE_DENOMINATOR: u64 = 1000;

    const EInsufficientInputAmount: u64 = 100;

    public fun swap(x_reserve: u64, y_reserve: u64, x_amount_in: u64, expected_y_amount_out: u64): u64 {
        let y_amount_out: u128;
        let k = (x_reserve as u128) * (y_reserve as u128);
        y_amount_out = k / (x_amount_in as u128);
        let y_fee = y_amount_out * (FEE_NUMERATOR as u128) / (FEE_DENOMINATOR as u128);
        if (y_amount_out >= (expected_y_amount_out as u128) + y_fee) {
            y_amount_out = y_amount_out - y_fee;
        } else {
            y_amount_out = (expected_y_amount_out as u128);
            let x_amount_needed = k / y_amount_out;
            let x_fee = (x_amount_in as u128) * (FEE_NUMERATOR as u128) / (FEE_DENOMINATOR as u128);
            assert!((x_amount_in as u128) > x_amount_needed + x_fee, EInsufficientInputAmount);
        };
        (y_amount_out as u64)
    }
}
