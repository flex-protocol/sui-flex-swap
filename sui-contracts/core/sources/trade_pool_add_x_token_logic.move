#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_core::trade_pool_add_x_token_logic {
    use std::string;
    use std::type_name;

    use sui::object;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_core::liquidity_token;
    use sui_swap_core::liquidity_token::LiquidityToken;
    use sui_swap_core::trade_pool;
    use sui_swap_core::trade_pool::TradePool;
    use sui_swap_core::pool_x_token_added;

    friend sui_swap_core::trade_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        x: &X,
        x_amount: u64,
        pool: &trade_pool::TradePool<X, Y>,
        ctx: &TxContext,
    ): trade_pool::PoolXTokenAdded {
        let _ = x;
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(trade_pool::liquidity_token_id(pool) == liquidity_token_id, EInvalidLiquidityToken);
        //let y_reserve_amount = balance::value(trade_pool::borrow_y_reserve(trade_pool));
        trade_pool::new_pool_x_token_added(
            pool,
            liquidity_token_id,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            x_amount,
            object::id(x),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        pool_x_token_added: &trade_pool::PoolXTokenAdded,
        x: X,
        trade_pool: &mut trade_pool::TradePool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let x_amount = pool_x_token_added::x_amount(pool_x_token_added);

        let _x_total_amount = add_x_token(trade_pool, x, x_amount);
    }

    fun add_x_token<X: key + store, Y>(trade_pool: &mut TradePool<X, Y>, x: X, x_amount: u64): u64 {
        let x_id = object::id(&x);
        let x_reserve = trade_pool::borrow_mut_x_reserve(trade_pool);
        object_table::add(x_reserve, x_id, x);
        let x_amounts = trade_pool::borrow_mut_x_amounts(trade_pool);
        table::add(x_amounts, x_id, x_amount);
        let x_total_amount = trade_pool::x_total_amount(trade_pool) + x_amount;
        trade_pool::set_x_total_amount(trade_pool, x_total_amount);
        x_total_amount
    }
}
