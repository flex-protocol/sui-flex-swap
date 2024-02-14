#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::buy_pool_sell_x_logic {
    use std::string;
    use std::type_name;
    use sui::balance;

    use sui::balance::Balance;
    use sui::object;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::buy_pool;
    use sui_swap_example::buy_pool_x_swapped_for_y;
    use sui_swap_example::price_curve;

    friend sui_swap_example::buy_pool_aggregate;

    const EInsufficientYAmountOut: u64 = 10;
    const EInsufficientYReserve: u64 = 11;

    public(friend) fun verify<X: key + store, Y>(
        x: &X,
        x_amount: u64,
        expected_y_amount_out: u64,
        buy_pool: &buy_pool::BuyPool<X, Y>,
        ctx: &TxContext,
    ): buy_pool::BuyPoolXSwappedForY {
        let _ = x;
        //let x_reserve_amount = buy_pool::x_total_amount(buy_pool);
        let y_reserve_amount = balance::value(buy_pool::borrow_y_reserve(buy_pool));
        assert!(y_reserve_amount >= expected_y_amount_out, EInsufficientYReserve);

        let price_curve_type = buy_pool::price_curve_type(buy_pool);
        //x_amount, //number_numerator: u64,
        let price_delta_x_amount = buy_pool::price_delta_x_amount(buy_pool); //number_denominator: u64,
        let exchange_rate_numerator = buy_pool::exchange_rate_numerator(buy_pool); //spot_price: u64,
        let start_exchange_rate_numerator = buy_pool::start_exchange_rate_numerator(buy_pool);
        let price_delta_numerator = buy_pool::price_delta_numerator(buy_pool);
        let price_delta_denominator = buy_pool::price_delta_denominator(buy_pool);

        let (y_amount_out_numerator, new_exchange_rate_numerator) = price_curve::get_sell_info(
            price_curve_type,
            x_amount, // <- number_numerator: u64,
            price_delta_x_amount,
            exchange_rate_numerator,
            start_exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );

        let exchange_rate_denominator = buy_pool::exchange_rate_denominator(buy_pool);
        let y_amount_out = y_amount_out_numerator / exchange_rate_denominator;
        assert!(y_amount_out >= expected_y_amount_out, EInsufficientYAmountOut);
        if (y_amount_out > y_reserve_amount) {
            y_amount_out = y_reserve_amount;
        };

        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        buy_pool::new_buy_pool_x_swapped_for_y(
            buy_pool,
            x_amount,
            expected_y_amount_out,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            y_amount_out,
            object::id(x),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        x_swapped_for_y: &buy_pool::BuyPoolXSwappedForY,
        x: X,
        buy_pool: &mut buy_pool::BuyPool<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): Balance<Y> {
        let x_amount = buy_pool_x_swapped_for_y::x_amount(x_swapped_for_y);
        let y_amount = buy_pool_x_swapped_for_y::y_amount(x_swapped_for_y);

        let x_id = object::id(&x);
        let x_reserve = buy_pool::borrow_mut_x_reserve(buy_pool);
        object_table::add(x_reserve, x_id, x);
        let x_amounts = buy_pool::borrow_mut_x_amounts(buy_pool);
        table::add(x_amounts, x_id, x_amount);
        let x_total_amount = buy_pool::x_total_amount(buy_pool);
        buy_pool::set_x_total_amount(buy_pool, x_total_amount + x_amount);

        let y_reserve = buy_pool::borrow_mut_y_reserve(buy_pool);
        sui::balance::split(y_reserve, y_amount)
    }
}
