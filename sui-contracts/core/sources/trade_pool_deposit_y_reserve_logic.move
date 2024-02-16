#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::trade_pool_deposit_y_reserve_logic {
    use std::string;
    use std::type_name;

    use sui::balance::{Self, Balance};
    use sui::tx_context::TxContext;
    use sui_swap_example::pool_y_reserve_deposited;

    use sui_swap_example::trade_pool;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;

    friend sui_swap_example::trade_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        y_amount: &Balance<Y>,
        pool: &trade_pool::TradePool<X, Y>,
        ctx: &TxContext,
    ): trade_pool::PoolYReserveDeposited {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(trade_pool::liquidity_token_id(pool) == liquidity_token_id, EInvalidLiquidityToken);

        trade_pool::new_pool_y_reserve_deposited(
            pool,
            liquidity_token_id,
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            balance::value(y_amount),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        trade_pool_y_reserve_deposited: &trade_pool::PoolYReserveDeposited,
        y_amount: Balance<Y>,
        pool: &mut trade_pool::TradePool<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        //let liquidity_token_id = trade_pool_y_reserve_deposited::liquidity_token_id(trade_pool_y_reserve_deposited);
        //let x_token_type = trade_pool_y_reserve_deposited::x_token_type(trade_pool_y_reserve_deposited);
        //let y_token_type = trade_pool_y_reserve_deposited::y_token_type(trade_pool_y_reserve_deposited);
        let _y_amount_i = pool_y_reserve_deposited::y_amount(trade_pool_y_reserve_deposited);
        //let id = trade_pool::id(trade_pool);
        let y_reserve = trade_pool::borrow_mut_y_reserve(pool);
        sui::balance::join(y_reserve, y_amount);
    }
}
