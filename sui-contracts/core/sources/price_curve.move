module sui_swap_example::price_curve {
    use std::fixed_point32;
    use std::fixed_point32::FixedPoint32;

    use sui_swap_example::fixed_point32_util;

    const EInvalidCurveType: u64 = 10;
    const EMultiplierLessThanOne: u64 = 11;

    const LINEAR_CURVE: u8 = 0;
    const EXPONENTIAL_CURVE: u8 = 1;

    public fun linear_curve(): u8 {
        LINEAR_CURVE
    }

    public fun exponential_curve(): u8 {
        EXPONENTIAL_CURVE
    }

    public fun is_valid_curve_type(curve_type: u8): bool {
        curve_type == LINEAR_CURVE || curve_type == EXPONENTIAL_CURVE
    }

    public fun get_buy_info(
        curve_type: u8,
        number_numerator: u64,
        number_denominator: u64,
        spot_price: u64,
        start_price: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): (u64, u64) {
        assert!(is_valid_curve_type(curve_type), EInvalidCurveType);
        let number_of_items = fixed_point32::create_from_rational(number_numerator, number_denominator);
        if (curve_type == LINEAR_CURVE) {
            let delta = get_linear_curve_price_delta(start_price, price_delta_numerator, price_delta_denominator);
            get_linear_curve_buy_info(
                number_of_items,
                spot_price,
                delta,
            )
        } else {
            let multiplier = get_expontential_curve_price_multiplier(price_delta_numerator, price_delta_denominator);
            get_expontential_curve_buy_info(
                number_of_items,
                spot_price,
                multiplier,
            )
        }
    }

    public fun get_sell_info(
        curve_type: u8,
        number_numerator: u64,
        number_denominator: u64,
        spot_price: u64,
        start_price: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): (u64, u64) {
        let number_of_items = fixed_point32::create_from_rational(number_numerator, number_denominator);
        if (curve_type == LINEAR_CURVE) {
            assert!(is_valid_curve_type(curve_type), EInvalidCurveType);
            let delta = get_linear_curve_price_delta(start_price, price_delta_numerator, price_delta_denominator);
            get_linear_curve_sell_info(
                number_of_items,
                spot_price,
                delta,
            )
        } else {
            let multiplier = get_expontential_curve_price_multiplier(price_delta_numerator, price_delta_denominator);
            get_expontential_curve_sell_info(
                number_of_items,
                spot_price,
                multiplier,
            )
        }
    }

    fun get_linear_curve_buy_info(
        number_of_items: FixedPoint32,
        spot_price: u64,
        delta: u64,
    ): (u64, u64) {
        //
        // new_spot_price = spot_price + delta * number_of_items
        //
        let new_spot_price = spot_price + fixed_point32::multiply_u64(delta, number_of_items);

        // ~~
        // // amount = number_of_items * (spot_price + new_spot_price) / 2;
        // //
        // let amount = fixed_point32::multiply_u64(spot_price + new_spot_price, number_of_items) / 2;
        // ~~
        //
        // If we want to be consistent with the Solidity version (to avoid arbitraging):
        //
        // amount =
        //     number_of_items * spot_price +
        //     (number_of_items * (number_of_items + 1) * delta) / 2;
        //
        // let number_of_items_plus_one = fixed_point32::create_from_rational(
        //     number_numerator + number_denominator,
        //     number_denominator
        // );
        let number_of_items_plus_one = fixed_point32_util::plus_one(number_of_items);
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


    fun get_linear_curve_sell_info(
        number_of_items: FixedPoint32,
        spot_price: u64,
        delta: u64,
    ): (u64, u64) {
        // We first calculate the change in spot price after selling all of the items
        let total_price_decrease = fixed_point32::multiply_u64(delta, number_of_items);
        let new_spot_price = if (spot_price < total_price_decrease) {
            // If the current spot price is less than the total amount that the spot price should change by...
            // We calculate how many items we can sell into the linear curve until the spot price reaches 0
            let number_of_items_till_zero_price = fixed_point32::create_from_rational(spot_price, delta);
            number_of_items = number_of_items_till_zero_price;
            0
        } else {
            // Otherwise, the current spot price is greater than or equal to the total amount that the spot price changes
            // The new spot price is just the change between spot price and the total price change
            spot_price - total_price_decrease
        };
        let amount = fixed_point32::multiply_u64(spot_price + new_spot_price, number_of_items) / 2;
        (amount, new_spot_price)
    }

    fun get_linear_curve_price_delta(
        start_price: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): u64 {
        let delta = fixed_point32::multiply_u64(start_price, fixed_point32::create_from_rational(
            price_delta_numerator,
            price_delta_denominator
        ));
        delta
    }

    fun get_expontential_curve_buy_info(
        number_of_items: FixedPoint32,
        spot_price: u64,
        multiplier: FixedPoint32,
    ): (u64, u64) {
        assert!(fixed_point32_util::greater_or_equal_than_one(multiplier), EMultiplierLessThanOne);

        let (n, f) = fixed_point32_util::integer_and_fractional(number_of_items);
        let multiplier_pow_n = fixed_point32_util::pow(multiplier, n);

        let buy_spot_price = fixed_point32::multiply_u64(spot_price, multiplier);

        // If the user buys n items, then the total cost is equal to:
        // buy_spot_price + (multiplier * buy_spot_price) + (multiplier^2 * buy_spot_price) + ... (multiplier^(numItems - 1) * buy_spot_price)
        // This is equal to buy_spot_price * (multiplier^n - 1) / (multiplier - 1)

        let amount = fixed_point32::multiply_u64(
            buy_spot_price,
            fixed_point32_util::divide(
                fixed_point32_util::minus_one(multiplier_pow_n),
                fixed_point32_util::minus_one(multiplier)
            )
        );

        // For an exponential curve, the spot price is multiplied by delta for each item bought
        let new_spot_price = fixed_point32::multiply_u64(spot_price, multiplier_pow_n);
        amount = amount + fixed_point32::multiply_u64(new_spot_price, fixed_point32::create_from_raw_value(f));
        (amount, new_spot_price)
    }

    fun get_expontential_curve_sell_info(
        number_of_items: FixedPoint32,
        spot_price: u64,
        multiplier: FixedPoint32,
    ): (u64, u64) {
        assert!(fixed_point32_util::greater_or_equal_than_one(multiplier), EMultiplierLessThanOne);
        let inv_multiplier = fixed_point32_util::reciprocal(multiplier);
        let (n, f) = fixed_point32_util::integer_and_fractional(number_of_items);
        let inv_multiplier_pow_n = fixed_point32_util::pow(inv_multiplier, n);
        //std::debug::print(&inv_multiplier);
        //std::debug::print(&inv_multiplier_pow_n);
        // If the user sells n items, then the total revenue is equal to:
        // spot_price + ((1 / multiplier) * spot_price) + ((1 / multiplier)^2 * spot_price) + ... ((1 / multiplier)^(numItems - 1) * spot_price)
        // This is equal to spot_price * (1 - (1 / multiplier^n)) / (1 - (1 / multiplier))
        let amount = fixed_point32::multiply_u64(
            spot_price,
            fixed_point32_util::divide(
                fixed_point32_util::one_minus(inv_multiplier_pow_n),
                fixed_point32_util::one_minus(inv_multiplier)
            )
        );

        let new_spot_price = fixed_point32::multiply_u64(spot_price, inv_multiplier_pow_n);
        amount = amount + fixed_point32::multiply_u64(new_spot_price, fixed_point32::create_from_raw_value(f));
        (amount, new_spot_price)
    }

    fun get_expontential_curve_price_multiplier(
        price_delta_numerator: u64,
        price_delta_denominator: u64
    ): FixedPoint32 {
        fixed_point32_util::plus_one(fixed_point32::create_from_rational(
            price_delta_numerator,
            price_delta_denominator
        ))
    }
}
