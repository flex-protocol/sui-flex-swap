module sui_swap_example::buy_pool_service {
    use sui::coin::{Self, Coin};
    use sui::object::ID;
    use sui::transfer;
    use sui::tx_context;

    use sui_swap_example::buy_pool::{Self, BuyPool};
    use sui_swap_example::buy_pool_aggregate;
    use sui_swap_example::coin_util;
    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;

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
        let (buy_pool, liquidity_token) = buy_pool_aggregate::initialize_buy_pool<X, Y>(
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
        buy_pool::share_object(buy_pool);
        transfer::public_transfer(liquidity_token, tx_context::sender(ctx));
    }

    public entry fun remove_x_token<X: key + store, Y>(
        buy_pool: &mut BuyPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x_id: ID,
        ctx: &mut tx_context::TxContext,
    ) {
        let x = buy_pool_aggregate::remove_x_token(buy_pool, liquidity_token, x_id, ctx);
        transfer::public_transfer(x, tx_context::sender(ctx));
    }

    public entry fun deposit_y_reserve<X: key + store, Y>(
        buy_pool: &mut BuyPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        y_coin: Coin<Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = coin_util::split_up_and_into_balance(y_coin, y_amount, ctx);
        buy_pool_aggregate::deposit_y_reserve(buy_pool, liquidity_token, y_amount_b, ctx);
    }

    public entry fun withdraw_y_reserve<X: key + store, Y>(
        buy_pool: &mut BuyPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        y_amount: u64,
        y_coin: &mut Coin<Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_balance = buy_pool_aggregate::withdraw_y_reserve(buy_pool, liquidity_token, y_amount, ctx);
        coin::join(y_coin, coin::from_balance(y_balance, ctx));
    }
}
