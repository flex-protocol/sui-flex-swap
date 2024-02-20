module sui_swap_core::buy_pool_service {
    use sui::coin::Coin;
    use sui::transfer;
    use sui::tx_context;

    use sui_swap_core::coin_util;
    use sui_swap_core::exchange::Exchange;
    use sui_swap_core::trade_pool;
    use sui_swap_core::trade_pool_aggregate;

    public entry fun initialize_buy_pool<X: key + store, Y>(
        exchange: &mut Exchange,
        y_coin: Coin<Y>,
        y_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = coin_util::split_up_and_into_balance(y_coin, y_amount, ctx);
        let (trade_pool, liquidity_token) = trade_pool_aggregate::initialize_buy_pool<X, Y>(
            exchange,
            y_amount_b,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            ctx,
        );
        trade_pool::share_object(trade_pool);
        transfer::public_transfer(liquidity_token, tx_context::sender(ctx));
    }
}
