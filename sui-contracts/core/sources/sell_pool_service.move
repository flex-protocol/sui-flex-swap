module sui_swap_example::sell_pool_service {
    use sui::coin::Coin;
    use sui::object::ID;
    use sui::transfer;
    use sui::tx_context::Self;

    use sui_swap_example::coin_util;
    use sui_swap_example::trade_pool::TradePool;
    use sui_swap_example::trade_pool_aggregate;

    public entry fun buy_x<X: key + store, Y>(
        sell_pool: &mut TradePool<X, Y>,
        y_coin: Coin<Y>,
        y_amount: u64,
        x_id: ID,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = coin_util::split_up_and_into_balance(y_coin, y_amount, ctx);
        let x = trade_pool_aggregate::buy_x(sell_pool, y_amount_b, x_id, ctx);
        transfer::public_transfer(x, tx_context::sender(ctx));
    }
}
