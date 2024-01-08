#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_remove_liquidity_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use smartinscription::movescription;

    use sui_swap_example::liquidity_removed;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::liquidity_token_aggregate;
    use sui_swap_example::liquidity_util;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    const EInconsistentLiquidityAmount: u64 = 1;

    public(friend) fun verify<Y>(
        liquidity_token: &LiquidityToken<Y>,
        token_pair: &token_pair::TokenPair<Y>,
        ctx: &TxContext,
    ): token_pair::LiquidityRemoved {
        let x_token_type = string::from_ascii(movescription::tick(token_pair::borrow_x_reserve(token_pair)));
        let liquidity_amount = liquidity_token::amount(liquidity_token);
        let total_liquidity = token_pair::total_liquidity(token_pair);
        let x_reserve = movescription::amount(token_pair::borrow_x_reserve(token_pair));
        let y_reserve = balance::value(token_pair::borrow_y_reserve(token_pair));
        let (x_amount, y_amount) = liquidity_util::get_pair_amounts(
            total_liquidity,
            x_reserve,
            y_reserve,
            liquidity_amount
        );
        token_pair::new_liquidity_removed(
            token_pair,
            liquidity_amount,
            liquidity_token::id(liquidity_token),
            tx_context::sender(ctx),
            x_token_type,
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            x_amount,
            y_amount,
        )
    }

    public(friend) fun mutate<Y>(
        liquidity_removed: &token_pair::LiquidityRemoved,
        liquidity_token: LiquidityToken<Y>,
        token_pair: &mut token_pair::TokenPair<Y>,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ): Balance<Y> {
        let liquidity_amount_removed = liquidity_removed::liquidity_amount(liquidity_removed);
        assert!(liquidity_amount_removed == liquidity_token::amount(&liquidity_token), EInconsistentLiquidityAmount);
        liquidity_token_aggregate::destroy(liquidity_token, ctx);

        let x_amount = liquidity_removed::x_amount(liquidity_removed);
        let y_amount = liquidity_removed::y_amount(liquidity_removed);
        let total_liquidity = token_pair::total_liquidity(token_pair);
        token_pair::set_total_liquidity(
            token_pair,
            total_liquidity - liquidity_amount_removed,
        );
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        movescription::split(x_reserve, x_amount, ctx);
        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        let y_out = balance::split(y_reserve, y_amount);
        y_out
    }
}
