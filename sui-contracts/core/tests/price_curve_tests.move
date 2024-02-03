#[test_only]
module sui_swap_example::price_curve_tests {

    use std::debug;

    use sui_swap_example::price_curve;

    #[test]
    public fun test_price_curve_1() {
        //
        // curve_type: u8,
        // number_numerator: u64,
        // number_denominator: u64,
        // spot_price: u64,
        // price_numerator_delta: u64,
        // price_denominator: u64
        //
        let curve_type = price_curve::linear_curve();
        let number_numerator = 50;
        let number_denominator = 100;
        //
        // 10% increase in price for each one sold
        //
        let spot_price = 1_000_000;
        let price_numerator_delta = 100_000;
        let price_denominator = 1_000_000;
        let (amount, new_spot_price) = price_curve::get_buy_info(
            curve_type,
            number_numerator,
            number_denominator,
            spot_price,
            price_numerator_delta,
            price_denominator
        );

        debug::print(&amount);
        debug::print(&new_spot_price);
        //[debug] 512499
        //[debug] 1049999
        //
        //[debug] 537499
        //[debug] 1049999
    }
}
