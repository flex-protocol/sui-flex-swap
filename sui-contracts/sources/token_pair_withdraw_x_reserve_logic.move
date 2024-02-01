#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_withdraw_x_reserve_logic {
    use std::string;
    use std::type_name;

    use sui::balance::Balance;
    use sui::object;
    use sui::tx_context::TxContext;

    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::token_pair;
    use sui_swap_example::x_reserve_withdrawn;

    friend sui_swap_example::token_pair_aggregate;

    public(friend) fun verify<X, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        x_amount: u64,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::X_ReserveWithdrawn {
        let liquidity_token_id = object::id(liquidity_token);

        token_pair::new_x_reserve_withdrawn(
            token_pair,
            liquidity_token_id,
            x_amount,
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
        )
    }

    public(friend) fun mutate<X, Y>(
        x_reserve_withdrawn: &token_pair::X_ReserveWithdrawn,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): Balance<X> {
        let liquidity_token_id = x_reserve_withdrawn::liquidity_token_id(x_reserve_withdrawn);
        let x_amount = x_reserve_withdrawn::x_amount(x_reserve_withdrawn);
        let x_token_type = x_reserve_withdrawn::x_token_type(x_reserve_withdrawn);
        let y_token_type = x_reserve_withdrawn::y_token_type(x_reserve_withdrawn);
        let id = token_pair::id(token_pair);
        // ...
        sui::balance::zero()//todo
    }
}
