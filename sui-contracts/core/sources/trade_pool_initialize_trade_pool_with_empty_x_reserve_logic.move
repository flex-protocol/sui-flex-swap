#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_core::trade_pool_initialize_trade_pool_with_empty_x_reserve_logic {
    use std::option;
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::object::{Self, ID};
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_core::exchange::Exchange;
    use sui_swap_core::exchange_aggregate;
    use sui_swap_core::liquidity_token::LiquidityToken;
    use sui_swap_core::liquidity_token_aggregate;
    use sui_swap_core::pool_type;
    use sui_swap_core::trade_pool;
    use sui_swap_core::trade_pool_util;

    friend sui_swap_core::trade_pool_aggregate;

    public(friend) fun verify<X: key + store, Y>(
        exchange: &mut Exchange,
        y_amount: &Balance<Y>,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        ctx: &mut TxContext,
    ): trade_pool::TradePoolWithEmptyXReserveInitialized {
        trade_pool_util::assert_trade_pool_initialize_exchange_rate_arguments(
            exchange_rate_numerator, exchange_rate_denominator, price_curve_type,
            price_delta_x_amount, price_delta_numerator, price_delta_denominator
        );

        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));

        trade_pool::new_trade_pool_with_empty_x_reserve_initialized<X, Y>(
            object::id(exchange),
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            balance::value(y_amount),
            option::none(),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        trade_pool_with_empty_x_reserve_initialized: &mut trade_pool::TradePoolWithEmptyXReserveInitialized,
        y_amount: Balance<Y>,
        exchange: &mut Exchange,
        ctx: &mut TxContext,
    ): (trade_pool::TradePool<X, Y>, LiquidityToken<X, Y>) {
        //let exchange_id = trade_pool::trade_pool_with_empty_x_reserve_initialized_exchange_id(trade_pool_with_empty_x_reserve_initialized);
        let exchange_rate_numerator = trade_pool::trade_pool_with_empty_x_reserve_initialized_exchange_rate_numerator(trade_pool_with_empty_x_reserve_initialized);
        let exchange_rate_denominator = trade_pool::trade_pool_with_empty_x_reserve_initialized_exchange_rate_denominator(trade_pool_with_empty_x_reserve_initialized);
        let price_curve_type = trade_pool::trade_pool_with_empty_x_reserve_initialized_price_curve_type(trade_pool_with_empty_x_reserve_initialized);
        let price_delta_x_amount = trade_pool::trade_pool_with_empty_x_reserve_initialized_price_delta_x_amount(trade_pool_with_empty_x_reserve_initialized);
        let price_delta_numerator = trade_pool::trade_pool_with_empty_x_reserve_initialized_price_delta_numerator(trade_pool_with_empty_x_reserve_initialized);
        let price_delta_denominator = trade_pool::trade_pool_with_empty_x_reserve_initialized_price_delta_denominator(trade_pool_with_empty_x_reserve_initialized);
        //let provider = trade_pool::trade_pool_with_empty_x_reserve_initialized_provider(trade_pool_with_empty_x_reserve_initialized);
        //let x_token_type = trade_pool::trade_pool_with_empty_x_reserve_initialized_x_token_type(trade_pool_with_empty_x_reserve_initialized);
        //let y_token_type = trade_pool::trade_pool_with_empty_x_reserve_initialized_y_token_type(trade_pool_with_empty_x_reserve_initialized);
        //let y_amount_i = trade_pool::trade_pool_with_empty_x_reserve_initialized_y_amount(trade_pool_with_empty_x_reserve_initialized);
        //let liquidity_token_id = trade_pool::trade_pool_with_empty_x_reserve_initialized_liquidity_token_id(trade_pool_with_empty_x_reserve_initialized);

        let x_reserve = object_table::new<ID, X>(ctx);
        let x_amounts = table::new<ID, u64>(ctx);
        let x_total_amount = 0;

        //let liquidity_token_id = buy_pool_initialized::liquidity_token_id(buy_pool_initialized);

        let liquidity_token = liquidity_token_aggregate::mint<X, Y>(ctx);
        let liquidity_token_id = object::id(&liquidity_token);
        trade_pool::set_trade_pool_with_empty_x_reserve_initialized_liquidity_token_id(
            trade_pool_with_empty_x_reserve_initialized,
            option::some(liquidity_token_id)
        );

        let start_exchange_rate_numerator = exchange_rate_numerator;
        let trade_pool = trade_pool::new_trade_pool<X, Y>(
            pool_type::trade_pool(),
            x_reserve,
            x_amounts,
            x_total_amount,
            liquidity_token_id,
            0,
            0,
            start_exchange_rate_numerator,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            ctx,
        );
        exchange_aggregate::add_trade_pool<X, Y>(exchange, trade_pool::id(&trade_pool), ctx);

        let y_reserve = trade_pool::borrow_mut_y_reserve(&mut trade_pool);
        sui::balance::join(y_reserve, y_amount);
        (trade_pool, liquidity_token)
    }
}
