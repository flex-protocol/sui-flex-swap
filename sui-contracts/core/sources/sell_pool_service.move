module sui_swap_example::sell_pool_service {
    use sui::coin;
    use sui::coin::Coin;
    use sui::object::ID;
    use sui::transfer;
    use sui::tx_context::Self;

    use sui_swap_example::coin_util;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::sell_pool::SellPool;
    use sui_swap_example::sell_pool_aggregate;

    public entry fun remove_x_token<X: key + store, Y>(
        sell_pool: &mut SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x_id: ID,
        ctx: &mut tx_context::TxContext,
    ) {
        let x = sell_pool_aggregate::remove_x_token(sell_pool, liquidity_token, x_id, ctx);
        transfer::public_transfer(x, tx_context::sender(ctx));
    }

    public entry fun withdraw_y_reserve<X: key + store, Y>(
        sell_pool: &mut SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        y_amount: u64,
        y_coin: &mut Coin<Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_balance = sell_pool_aggregate::withdraw_y_reserve(sell_pool, liquidity_token, y_amount, ctx);
        coin::join(y_coin, coin::from_balance(y_balance, ctx));
    }

    public entry fun buy_x<X: key + store, Y>(
        sell_pool: &mut SellPool<X, Y>,
        y_coin: Coin<Y>,
        y_amount: u64,
        x_id: ID,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = coin_util::split_up_and_into_balance(y_coin, y_amount, ctx);
        let x = sell_pool_aggregate::buy_x(sell_pool, y_amount_b, x_id, ctx);
        transfer::public_transfer(x, tx_context::sender(ctx));
    }
}
