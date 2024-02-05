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

        spot_price = new_spot_price;
        let (amount, new_spot_price) = price_curve::get_sell_info(
            curve_type,
            number_numerator,
            number_denominator,
            spot_price,
            price_numerator_delta,
            price_denominator
        );
        debug::print(&amount);
        debug::print(&new_spot_price);

    }


    #[test]
    public fun test_price_curve_2() {
        //
        // Let's assume the following:
        //
        // * each NFT has the same value;
        // * the results returned by "nft_service::get_amount()",
        //   the "exchange_rate_denominator", and "price_delta_x_amount" of "SellPool" are all fixed to 1.
        //
        // Let us calculate the amount needed to buy 2 NFTs.
        //
        let price_curve_type = price_curve::linear_curve();
        let x_amount = 2; //number_numerator: u64,
        let price_delta_x_amount = 1; //number_denominator: u64,
        let exchange_rate_numerator = 10000; //spot_price: u64,
        let exchange_rate_denominator = 1;
        //
        // 10% increase in price for each one sold
        //
        let price_delta_numerator = 10;
        let price_delta_denominator = 100;

        let (y_amount_required_numerator, new_exchange_rate_numerator) = price_curve::get_buy_info(
            price_curve_type,
            x_amount, // <- number_numerator: u64,
            price_delta_x_amount,
            exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );
        let y_amount_required = y_amount_required_numerator / exchange_rate_denominator;
        debug::print(&y_amount_required);
        debug::print(&new_exchange_rate_numerator);
        let y_amount_in = 23000;
        assert!(y_amount_in >= y_amount_required, 1);

        exchange_rate_numerator = new_exchange_rate_numerator; //<- spot_price: u64,
        let (amount, new_spot_price) = price_curve::get_sell_info(
            price_curve_type,
            x_amount, // <- number_numerator: u64,
            price_delta_x_amount,
            exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );
        debug::print(&amount);
        debug::print(&new_spot_price);
    }

    //#[test]
    public fun test_rounding_up() {
        //ceil_val(a, b) = (a + b - 1) / b
        let number_numerator = 50;
        let number_denominator = 100;
        let number_of_items= (number_numerator + number_denominator - 1) / number_denominator;
        debug::print(&number_of_items);

        let number_numerator = 100;
        let number_denominator = 100;
        let number_of_items= (number_numerator + number_denominator - 1) / number_denominator;
        debug::print(&number_of_items);

        let number_numerator = 1;
        let number_denominator = 1;
        let number_of_items= (number_numerator + number_denominator - 1) / number_denominator;
        debug::print(&number_of_items);
    }
}
