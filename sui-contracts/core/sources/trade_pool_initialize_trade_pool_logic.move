#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::trade_pool_initialize_trade_pool_logic {
    use std::option;
    use std::string;
    use std::type_name;

    use sui::balance::{Self, Balance};
    use sui::object::{Self, ID};
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::exchange_aggregate;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::liquidity_token_aggregate;
    use sui_swap_example::pool_type;
    use sui_swap_example::price_curve;
    use sui_swap_example::trade_pool;
    use sui_swap_example::trade_pool_initialized;

    friend sui_swap_example::trade_pool_aggregate;

    const EInvalidPriceCurveType: u64 = 1;

    const EInvalidExchangeRateNumerator: u64 = 11;
    const EInvalidExchangeRateDenominator: u64 = 12;
    const EInvalidPriceDeltaXAmount: u64 = 13;
    const EInvalidPriceDeltaDenominator: u64 = 14;

    public(friend) fun verify<X: key + store, Y>(
        exchange: &mut Exchange,
        x: &X,
        x_amount: u64,
        y_amount: &Balance<Y>,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        ctx: &mut TxContext,
    ): trade_pool::TradePoolInitialized {
        assert!(exchange_rate_numerator > 0, EInvalidExchangeRateNumerator);

        assert!(exchange_rate_denominator > 0, EInvalidExchangeRateDenominator);
        assert!(price_delta_x_amount > 0, EInvalidPriceDeltaXAmount);
        assert!(price_delta_denominator > 0, EInvalidPriceDeltaDenominator);
        assert!(price_curve::is_valid_curve_type(price_curve_type), EInvalidPriceCurveType);

        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));

        trade_pool::new_trade_pool_initialized<X, Y>(
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
            x_amount,
            balance::value(y_amount),
            option::none(),
            object::id(x),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        trade_pool_initialized: &mut trade_pool::TradePoolInitialized,
        x: X,
        y_amount: Balance<Y>,
        exchange: &mut Exchange,
        ctx: &mut TxContext,
    ): (trade_pool::TradePool<X, Y>, LiquidityToken<X, Y>) {
        let x_amount = trade_pool_initialized::x_amount(trade_pool_initialized);
        let exchange_rate_numerator = trade_pool_initialized::exchange_rate_numerator(trade_pool_initialized);
        let exchange_rate_denominator = trade_pool_initialized::exchange_rate_denominator(trade_pool_initialized);
        let price_curve_type = trade_pool_initialized::price_curve_type(trade_pool_initialized);
        let price_delta_x_amount = trade_pool_initialized::price_delta_x_amount(trade_pool_initialized);
        let price_delta_numerator = trade_pool_initialized::price_delta_numerator(trade_pool_initialized);
        let price_delta_denominator = trade_pool_initialized::price_delta_denominator(trade_pool_initialized);

        let x_id = object::id(&x);
        let x_reserve = object_table::new<ID, X>(ctx);
        object_table::add(&mut x_reserve, x_id, x);
        let x_amounts = table::new<ID, u64>(ctx);
        table::add(&mut x_amounts, x_id, x_amount);
        let x_total_amount = x_amount;

        //let liquidity_token_id = trade_pool_initialized::liquidity_token_id(trade_pool_initialized);

        let liquidity_token = liquidity_token_aggregate::mint<X, Y>(ctx);
        let liquidity_token_id = object::id(&liquidity_token);
        trade_pool::set_trade_pool_initialized_liquidity_token_id(trade_pool_initialized, liquidity_token_id);

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
