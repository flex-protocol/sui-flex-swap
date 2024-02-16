module sui_swap_example::trade_pool_service {

    use sui::coin;
    use sui::coin::Coin;
    use sui::object::ID;
    use sui::transfer;
    use sui::tx_context;

    use sui_swap_example::coin_util;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::trade_pool::TradePool;
    use sui_swap_example::trade_pool_aggregate;

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
