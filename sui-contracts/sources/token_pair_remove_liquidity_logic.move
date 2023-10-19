module sui_swap_example::token_pair_remove_liquidity_logic {
    use std::string;
    use std::type_name;
    use sui::balance;
    use sui::tx_context::{Self, TxContext};
    use sui_swap_example::liquidity::{Self, Liquidity};
    use sui_swap_example::liquidity_removed;
    use sui_swap_example::token_pair;
    use sui::balance::Balance;

    friend sui_swap_example::token_pair_aggregate;

    public(friend) fun verify<X, Y>(
        liquidity_amount: u64,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::LiquidityRemoved {
        token_pair::new_liquidity_removed(
            token_pair,
            liquidity_amount,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            0, //todo calculate x_amount
            0, //todo calculate y_amount
        )
    }

    public(friend) fun mutate<X, Y>(
        liquidity_removed: &token_pair::LiquidityRemoved,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): (Balance<X>, Balance<Y>) {
        let liquidity_amount = liquidity_removed::liquidity_amount(liquidity_removed);
        let provider = liquidity_removed::provider(liquidity_removed);
        let x_token_type = liquidity_removed::x_token_type(liquidity_removed);
        let y_token_type = liquidity_removed::y_token_type(liquidity_removed);
        let x_amount = liquidity_removed::x_amount(liquidity_removed);
        let y_amount = liquidity_removed::y_amount(liquidity_removed);
        let id = token_pair::id(token_pair);
        (balance::zero<X>(), balance::zero<Y>())//todo
    }

}
