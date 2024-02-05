module sui_swap_example::price_curve {
    use std::fixed_point32;
    use std::fixed_point32::FixedPoint32;

    const EInvalidCurveType: u64 = 10;

    const LINEAR_CURVE: u8 = 0;
    const EXPONENTIAL_CURVE: u8 = 1;

    public fun linear_curve(): u8 {
        LINEAR_CURVE
    }

    public fun exponential_curve(): u8 {
        EXPONENTIAL_CURVE
    }

    public fun is_valid_curve_type(curve_type: u8): bool {
        curve_type == LINEAR_CURVE //|| curve_type == EXPONENTIAL_CURVE
    }

    public fun get_buy_info(
        curve_type: u8,
        number_numerator: u64,
        number_denominator: u64,
        spot_price: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): (u64, u64) {
        assert!(is_valid_curve_type(curve_type), EInvalidCurveType);
        let number_of_items = fixed_point32::create_from_rational(number_numerator, number_denominator);
        get_linear_curve_buy_info(
            number_of_items,
            spot_price,
            price_delta_numerator,
            price_delta_denominator
        )
    }

    fun get_linear_curve_buy_info(
        number_of_items: FixedPoint32,
        spot_price: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): (u64, u64) {
        //
        // new_spot_price = spot_price + delta * number_of_items
        //
        let delta = fixed_point32::multiply_u64(spot_price, fixed_point32::create_from_rational(
            price_delta_numerator,
            price_delta_denominator
        ));
        let new_spot_price = spot_price + fixed_point32::multiply_u64(delta, number_of_items);

        // ~~
        // // amount = number_of_items * (spot_price + new_spot_price) / 2;
        // //
        // let amount = fixed_point32::multiply_u64(spot_price + new_spot_price, number_of_items) / 2;
        // ~~
        //
        // If want to be consistent with the Solidity version:
        //
        // amount =
        //     number_of_items * spot_price +
        //     (number_of_items * (number_of_items + 1) * delta) / 2;
        //
        // let number_of_items_plus_one = fixed_point32::create_from_rational(
        //     number_numerator + number_denominator,
        //     number_denominator
        // );
        let number_of_items_plus_one = fixed_point32::create_from_raw_value(
            fixed_point32::get_raw_value(number_of_items) + (1 << 32)
        );
        let amount = fixed_point32::multiply_u64(spot_price, number_of_items) +
            fixed_point32::multiply_u64(
                fixed_point32::multiply_u64(
                    delta,
                    number_of_items
                ),
                number_of_items_plus_one
            ) / 2;
        (amount, new_spot_price)
    }
}
