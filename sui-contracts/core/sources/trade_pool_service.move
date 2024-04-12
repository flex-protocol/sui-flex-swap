module sui_swap_core::trade_pool_service {

    use sui::coin;
    use sui::coin::Coin;
    use sui::object::ID;
    use sui::transfer;
    use sui::tx_context;

    use sui_swap_utils::coin_util;
    use sui_swap_core::liquidity_token::LiquidityToken;
    use sui_swap_core::exchange::Exchange;
    use sui_swap_core::trade_pool::{Self, TradePool};
    use sui_swap_core::trade_pool_aggregate;

    public entry fun initialize_trade_pool_with_empty_x_reserve<X: key + store, Y>(
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
        let (trade_pool, liquidity_token) = trade_pool_aggregate::initialize_trade_pool_with_empty_x_reserve<X, Y>(
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

    public entry fun remove_x_token<X: key + store, Y>(
        pool: &mut TradePool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x_id: ID,
        ctx: &mut tx_context::TxContext,
    ) {
        let x = trade_pool_aggregate::remove_x_token(pool, liquidity_token, x_id, ctx);
        transfer::public_transfer(x, tx_context::sender(ctx));
    }

    public entry fun deposit_y_reserve<X: key + store, Y>(
        pool: &mut TradePool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        y_coin: Coin<Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = coin_util::split_up_and_into_balance(y_coin, y_amount, ctx);
        trade_pool_aggregate::deposit_y_reserve(pool, liquidity_token, y_amount_b, ctx);
    }

    public entry fun withdraw_y_reserve<X: key + store, Y>(
        pool: &mut TradePool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        y_amount: u64,
        y_coin: &mut Coin<Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_balance = trade_pool_aggregate::withdraw_y_reserve(pool, liquidity_token, y_amount, ctx);
        coin::join(y_coin, coin::from_balance(y_balance, ctx));
    }
}
