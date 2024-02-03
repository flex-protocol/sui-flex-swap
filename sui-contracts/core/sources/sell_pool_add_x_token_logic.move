#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::sell_pool_add_x_token_logic {
    use std::string;
    use std::type_name;

    use sui::object;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::sell_pool;
    use sui_swap_example::sell_pool::SellPool;
    use sui_swap_example::sell_pool_x_token_added;

    friend sui_swap_example::sell_pool_aggregate;

    const EInvalidLiquidityToken: u64 = 10;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        x: &X,
        x_amount: u64,
        sell_pool: &sell_pool::SellPool<X, Y>,
        ctx: &TxContext,
    ): sell_pool::SellPoolXTokenAdded {
        let _ = x;
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(sell_pool::liquidity_token_id(sell_pool) == liquidity_token_id, EInvalidLiquidityToken);
        //let y_reserve_amount = balance::value(sell_pool::borrow_y_reserve(sell_pool));
        sell_pool::new_sell_pool_x_token_added(
            sell_pool,
            liquidity_token_id,
            x_amount,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            object::id(x),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        sell_pool_x_token_added: &sell_pool::SellPoolXTokenAdded,
        x: X,
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let x_amount = sell_pool_x_token_added::x_amount(sell_pool_x_token_added);

        let _x_total_amount = add_x_token(sell_pool, x, x_amount);
    }

    fun add_x_token<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, x: X, x_amount: u64): u64 {
        let x_id = object::id(&x);
        let x_reserve = sell_pool::borrow_mut_x_reserve(sell_pool);
        object_table::add(x_reserve, x_id, x);
        let x_amounts = sell_pool::borrow_mut_x_amounts(sell_pool);
        table::add(x_amounts, x_id, x_amount);
        let x_total_amount = sell_pool::x_total_amount(sell_pool) + x_amount;
        sell_pool::set_x_total_amount(sell_pool, x_total_amount);
        x_total_amount
    }
}
