#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_core::trade_pool_remove_x_token_logic {
    use std::string;
    use std::type_name;

    use sui::object::ID;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_core::liquidity_token;
    use sui_swap_core::liquidity_token::LiquidityToken;
    use sui_swap_core::trade_pool;
    use sui_swap_core::pool_x_token_removed;

    friend sui_swap_core::trade_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EInvalidXTokenId: u64 = 11;
    const EInconsistentXAmount: u64 = 101;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        x_id: ID,
        pool: &trade_pool::TradePool<X, Y>,
        ctx: &TxContext,
    ): trade_pool::PoolXTokenRemoved {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(trade_pool::liquidity_token_id(pool) == liquidity_token_id, EInvalidLiquidityToken);

        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        //let x_reserve_amount = trade_pool::x_total_amount(trade_pool);

        let x_amounts = trade_pool::borrow_x_amounts(pool);
        assert!(table::contains(x_amounts, x_id), EInvalidXTokenId);
        let x_amount = *table::borrow(x_amounts, x_id);

        trade_pool::new_pool_x_token_removed(
            pool,
            liquidity_token_id,
            x_id,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            x_amount,
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        pool_x_token_removed: &trade_pool::PoolXTokenRemoved,
        pool: &mut trade_pool::TradePool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): X {
        let x_id = pool_x_token_removed::x_id(pool_x_token_removed);
        let x_amount = pool_x_token_removed::x_amount(pool_x_token_removed);

        let (x, _x_total_amount) = remove_x_token<X, Y>(
            pool,
            x_id,
            x_amount
        );
        x
    }

    fun remove_x_token<X: key + store, Y>(
        trade_pool: &mut trade_pool::TradePool<X, Y>,
        x_id: ID,
        x_amount: u64
    ): (X, u64) {
        let x_amounts = trade_pool::borrow_mut_x_amounts(trade_pool);
        assert!(x_amount == table::remove(x_amounts, x_id), EInconsistentXAmount);
        let x_reserve = trade_pool::borrow_mut_x_reserve(trade_pool);
        let x = object_table::remove(x_reserve, x_id);
        let x_total_amount = trade_pool::x_total_amount(trade_pool);
        x_total_amount = x_total_amount - x_amount;
        trade_pool::set_x_total_amount(trade_pool, x_total_amount);
        (x, x_total_amount)
    }
}
