#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_remove_liquidity_logic {
    use std::string;
    use std::type_name;

    use sui::balance::{Self, Balance};
    use sui::object::ID;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::liquidity_removed;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EInvalidXTokenId: u64 = 11;
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
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        let total_liquidity = token_pair::total_liquidity(token_pair);
        let x_reserve_amount = token_pair::x_total_amount(token_pair);
        let y_reserve_amount = balance::value(token_pair::borrow_y_reserve(token_pair));

        let x_amounts = token_pair::borrow_x_amounts(token_pair);
        assert!(table::contains(x_amounts, x_id), EInvalidXTokenId);
        let x_amount = *table::borrow(x_amounts, x_id);

        let liquidity_amount =
            if (x_amount == x_reserve_amount) { total_liquidity }
            else { total_liquidity * x_amount / x_reserve_amount };
        let y_amount =
            if (x_amount == x_reserve_amount) { y_reserve_amount }
            else { y_reserve_amount * liquidity_amount / total_liquidity };

        token_pair::new_liquidity_removed(
            token_pair,
            liquidity_token_id,
            x_id,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            x_amount,
            y_amount,
            liquidity_amount,
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        liquidity_removed: &token_pair::LiquidityRemoved,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): (X, Balance<Y>) {
        let x_id = liquidity_removed::x_id(liquidity_removed);
        let x_amount = liquidity_removed::x_amount(liquidity_removed);

        let (x, _x_total_amount) = remove_x_token<X, Y>(
            token_pair,
            x_id,
            x_amount
        );

        let y_amount = liquidity_removed::y_amount(liquidity_removed);
        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        let y_out = balance::split(y_reserve, y_amount);

        let liquidity_amount_removed = liquidity_removed::liquidity_amount(liquidity_removed);
        let total_liquidity = token_pair::total_liquidity(token_pair);
        token_pair::set_total_liquidity(
            token_pair,
            total_liquidity - liquidity_amount_removed,
        );

        (x, y_out)
    }


    fun remove_x_token<X: key + store, Y>(
        token_pair: &mut token_pair::TokenPair<X, Y>,
        x_id: ID,
        x_amount: u64
    ): (X, u64) {
        let x_amounts = token_pair::borrow_mut_x_amounts(token_pair);
        assert!(x_amount == table::remove(x_amounts, x_id), EInconsistentXAmount);
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        let x = object_table::remove(x_reserve, x_id);
        let x_total_amount = token_pair::x_total_amount(token_pair);
        x_total_amount = x_total_amount - x_amount;
        token_pair::set_x_total_amount(token_pair, x_total_amount);
        (x, x_total_amount)
    }
}
