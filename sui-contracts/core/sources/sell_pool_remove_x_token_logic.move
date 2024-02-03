#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::sell_pool_remove_x_token_logic {
    use std::string;
    use std::type_name;

    use sui::object::ID;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::sell_pool;
    use sui_swap_example::sell_pool_x_token_removed;

    friend sui_swap_example::sell_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EInvalidXTokenId: u64 = 11;
    const EInconsistentXAmount: u64 = 101;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        x_id: ID,
        sell_pool: &sell_pool::SellPool<X, Y>,
        ctx: &TxContext,
    ): sell_pool::SellPoolXTokenRemoved {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(sell_pool::liquidity_token_id(sell_pool) == liquidity_token_id, EInvalidLiquidityToken);

        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        //let x_reserve_amount = sell_pool::x_total_amount(sell_pool);

        let x_amounts = sell_pool::borrow_x_amounts(sell_pool);
        assert!(table::contains(x_amounts, x_id), EInvalidXTokenId);
        let x_amount = *table::borrow(x_amounts, x_id);

        sell_pool::new_sell_pool_x_token_removed(
            sell_pool,
            liquidity_token_id,
            x_id,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            x_amount,
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        sell_pool_x_token_removed: &sell_pool::SellPoolXTokenRemoved,
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): X {
        let x_id = sell_pool_x_token_removed::x_id(sell_pool_x_token_removed);
        let x_amount = sell_pool_x_token_removed::x_amount(sell_pool_x_token_removed);

        let (x, _x_total_amount) = remove_x_token<X, Y>(
            sell_pool,
            x_id,
            x_amount
        );
        x
    }

    fun remove_x_token<X: key + store, Y>(
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        x_id: ID,
        x_amount: u64
    ): (X, u64) {
        let x_amounts = sell_pool::borrow_mut_x_amounts(sell_pool);
        assert!(x_amount == table::remove(x_amounts, x_id), EInconsistentXAmount);
        let x_reserve = sell_pool::borrow_mut_x_reserve(sell_pool);
        let x = object_table::remove(x_reserve, x_id);
        let x_total_amount = sell_pool::x_total_amount(sell_pool);
        x_total_amount = x_total_amount - x_amount;
        sell_pool::set_x_total_amount(sell_pool, x_total_amount);
        (x, x_total_amount)
    }
}
