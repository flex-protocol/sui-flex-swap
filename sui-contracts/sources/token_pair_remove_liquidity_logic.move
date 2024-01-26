#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_remove_liquidity_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::object::ID;
    use sui::object_table;
    use sui::table;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::liquidity_removed;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::liquidity_token_aggregate;
    use sui_swap_example::liquidity_util;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    //const EInconsistentLiquidityAmount: u64 = 100;
    const EInconsistentXAmount: u64 = 101;

    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        x_id: ID,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::LiquidityRemoved {
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(token_pair::liquidity_token_id(token_pair) == liquidity_token_id, EInvalidLiquidityToken);

        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let total_liquidity = token_pair::total_liquidity(token_pair);
        let x_reserve = token_pair::x_total_amount(token_pair);
        let y_reserve = balance::value(token_pair::borrow_y_reserve(token_pair));
        let liquidity_amount = 0; //todo removed liquidity amount
        let (x_amount, y_amount) = liquidity_util::get_pair_amounts(
            total_liquidity,
            x_reserve,
            y_reserve,
            liquidity_amount,
        );
        token_pair::new_liquidity_removed(
            token_pair,
            liquidity_token_id,
            x_id,
            tx_context::sender(ctx),
            x_token_type,
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            x_amount,
            y_amount,
            liquidity_amount,
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        liquidity_removed: &token_pair::LiquidityRemoved,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): (X, Balance<Y>) {
        let liquidity_amount_removed = liquidity_removed::liquidity_amount(liquidity_removed);
        //liquidity_token_aggregate::destroy(liquidity_token, ctx);

        let x_id = liquidity_removed::x_id(liquidity_removed);
        let x_amount = liquidity_removed::x_amount(liquidity_removed);
        let x_amounts = token_pair::borrow_mut_x_amounts(token_pair);
        assert!(x_amount == table::remove(x_amounts, x_id), EInconsistentXAmount);

        let total_liquidity = token_pair::total_liquidity(token_pair);
        token_pair::set_total_liquidity(
            token_pair,
            total_liquidity - liquidity_amount_removed,
        );
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        let x = object_table::remove<ID, X>(x_reserve, x_id);
        let x_total_amount = token_pair::total_liquidity(token_pair);
        token_pair::set_x_total_amount(token_pair, x_total_amount - x_amount);

        let y_amount = liquidity_removed::y_amount(liquidity_removed);
        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);

        let y_out = balance::split(y_reserve, y_amount);
        (x, y_out)
    }
}
