module sui_swap_example::swap_util {

    const MIN_X_FEE: u128 = 1;
    const MIN_Y_FEE: u128 = 1;

    const EInsufficientInputAmount: u64 = 100;

    public fun swap(x_reserve: u64, y_reserve: u64, x_amount_in: u64, expected_y_amount_out: u64,
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
        if (y_amount_out >= (expected_y_amount_out as u128) + y_fee) {
            y_amount_out = y_amount_out - y_fee;
        } else {
            y_amount_out = (expected_y_amount_out as u128);
            let x_amount_needed = k / ((y_reserve as u128) - y_amount_out) - (x_reserve as u128);
            //std::debug::print(&x_amount_needed);
            let x_fee = (x_amount_in as u128) * (fee_numerator as u128) / (fee_denominator as u128);
            if (x_fee < MIN_X_FEE) {
                x_fee = MIN_X_FEE;
            };
            //std::debug::print(&x_fee);
            assert!((x_amount_in as u128) >= x_amount_needed + x_fee, EInsufficientInputAmount);
        };
        //std::debug::print(&(((x_reserve as u128) + (x_amount_in as u128)) * ((y_reserve as u128) - y_amount_out)));
        assert!(
            ((x_reserve as u128) + (x_amount_in as u128)) * ((y_reserve as u128) - y_amount_out) >= k,
            EInsufficientInputAmount
        ); //paranoid check
        (y_amount_out as u64)
    }
}
