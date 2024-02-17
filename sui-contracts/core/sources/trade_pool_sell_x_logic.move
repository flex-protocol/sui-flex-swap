#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::trade_pool_sell_x_logic {
    use std::string;
    use std::type_name;
    use sui::balance;

    use sui::balance::Balance;
    use sui::object;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};
    use sui_swap_example::pool_type;

    use sui_swap_example::trade_pool;
    use sui_swap_example::pool_x_swapped_for_y;
    use sui_swap_example::price_curve;

    friend sui_swap_example::trade_pool_aggregate;

    const EInsufficientYAmountOut: u64 = 10;
    const EInsufficientYReserve: u64 = 11;
    const EInvalidPoolType: u64 = 20;

    public(friend) fun verify<X: key + store, Y>(
        x: &X,
        x_amount: u64,
        expected_y_amount_out: u64,
        pool: &trade_pool::TradePool<X, Y>,
        ctx: &TxContext,
    ): trade_pool::PoolXSwappedForY {
        assert!(pool_type::is_trade_pool_or_buy_pool(trade_pool::pool_type(pool)), EInvalidPoolType);
        let _ = x;
        //let x_reserve_amount = trade_pool::x_total_amount(trade_pool);
        let y_reserve_amount = balance::value(trade_pool::borrow_y_reserve(pool));
        assert!(y_reserve_amount >= expected_y_amount_out, EInsufficientYReserve);

        let price_curve_type = trade_pool::price_curve_type(pool);
        //x_amount,
        let price_delta_x_amount = trade_pool::price_delta_x_amount(pool); //number_denominator: u64,
        let exchange_rate_numerator = trade_pool::exchange_rate_numerator(pool); //spot_price: u64,
        let start_exchange_rate_numerator = trade_pool::start_exchange_rate_numerator(pool);
        let price_delta_numerator = trade_pool::price_delta_numerator(pool);
        let price_delta_denominator = trade_pool::price_delta_denominator(pool);

        let (y_amount_out_numerator, new_exchange_rate_numerator) = price_curve::get_sell_info(
            price_curve_type,
            x_amount,
            price_delta_x_amount,
            exchange_rate_numerator,
            start_exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );

        let exchange_rate_denominator = trade_pool::exchange_rate_denominator(pool);
        let y_amount_out = y_amount_out_numerator / exchange_rate_denominator;
        assert!(y_amount_out >= expected_y_amount_out, EInsufficientYAmountOut);
        if (y_amount_out > y_reserve_amount) {
            y_amount_out = y_reserve_amount;
        };

        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        trade_pool::new_pool_x_swapped_for_y(
            pool,
            expected_y_amount_out,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            x_amount,
            y_amount_out,
            object::id(x),
            new_exchange_rate_numerator,
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        pool_x_swapped_for_y: &trade_pool::PoolXSwappedForY,
        x: X,
        pool: &mut trade_pool::TradePool<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): Balance<Y> {
        let x_amount = pool_x_swapped_for_y::x_amount(pool_x_swapped_for_y);
        let y_amount = pool_x_swapped_for_y::y_amount(pool_x_swapped_for_y);

        let new_exchange_rate_numerator = pool_x_swapped_for_y::new_exchange_rate_numerator(
            pool_x_swapped_for_y
        );
        trade_pool::set_exchange_rate_numerator(pool, new_exchange_rate_numerator);

        let x_id = object::id(&x);
        let x_reserve = trade_pool::borrow_mut_x_reserve(pool);
        object_table::add(x_reserve, x_id, x);
        let x_amounts = trade_pool::borrow_mut_x_amounts(pool);
        table::add(x_amounts, x_id, x_amount);
        let x_total_amount = trade_pool::x_total_amount(pool);
        trade_pool::set_x_total_amount(pool, x_total_amount + x_amount);

        let y_reserve = trade_pool::borrow_mut_y_reserve(pool);
        sui::balance::split(y_reserve, y_amount)
    }
}
