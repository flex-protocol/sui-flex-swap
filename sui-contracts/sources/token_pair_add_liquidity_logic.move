#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_add_liquidity_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::object;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::liquidity_added;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::liquidity_util;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    const EInvalidLiquidityToken: u64 = 10;
    const EAddInvalidLiquidity: u64 = 100;

    #[lint_allow(self_transfer)]
    public(friend) fun verify<X: key + store, Y>(
        liquidity_token: &LiquidityToken<X, Y>,
        x: &X,
        x_amount: u64,
        y_amount: &Balance<Y>,
        token_pair: &token_pair::TokenPair<X, Y>,
        ctx: &TxContext,
    ): token_pair::LiquidityAdded {
        let _ = x;
        let liquidity_token_id = liquidity_token::id(liquidity_token);
        assert!(token_pair::liquidity_token_id(token_pair) == liquidity_token_id, EInvalidLiquidityToken);

        let total_liquidity = token_pair::total_liquidity(token_pair);
        let x_reserve = token_pair::x_total_amount(token_pair);
        let y_reserve = balance::value(token_pair::borrow_y_reserve(token_pair));
        let y_amount_i = balance::value(y_amount);
        let liquidity_amount_added = liquidity_util::calculate_liquidity(
            total_liquidity,
            x_reserve,
            y_reserve,
            x_amount,
            y_amount_i
        );
        assert!(liquidity_amount_added > 0, EAddInvalidLiquidity);

        token_pair::new_liquidity_added(
            token_pair,
            liquidity_token_id,
            x_amount,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            y_amount_i,
            liquidity_amount_added,
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        liquidity_added: &token_pair::LiquidityAdded,
        x: X,
        y_amount: Balance<Y>,
        token_pair: &mut token_pair::TokenPair<X, Y>,
        _ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        //let provider = liquidity_added::provider(liquidity_added);
        //let x_token_type = liquidity_added::x_token_type(liquidity_added);
        //let y_token_type = liquidity_added::y_token_type(liquidity_added);
        let x_amount = liquidity_added::x_amount(liquidity_added);
        // let y_amount = liquidity_added::y_amount(liquidity_added);
        let liquidity_amount_added = liquidity_added::liquidity_amount(liquidity_added);

        //let id = token_pair::id(token_pair);
        let total_liquidity = token_pair::total_liquidity(token_pair);
        token_pair::set_total_liquidity(
            token_pair,
            total_liquidity + liquidity_amount_added,
        );

        let x_id = object::id(&x);
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        object_table::add(x_reserve, x_id, x);
        let x_amounts = token_pair::borrow_mut_x_amounts(token_pair);
        table::add(x_amounts, x_id, x_amount);
        let x_total_amount = token_pair::x_total_amount(token_pair) + x_amount;
        token_pair::set_x_total_amount(token_pair, x_total_amount);

        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        sui::balance::join(y_reserve, y_amount);
    }
}
