#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_add_liquidity_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use smartinscription::movescription;
    use smartinscription::movescription::Movescription;

    use sui_swap_example::liquidity_added;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token_aggregate;
    use sui_swap_example::liquidity_util;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    const ENotSameTick: u64 = 10;
    const EAddInvalidLiquidity: u64 = 100;

    #[lint_allow(self_transfer)]
    public(friend) fun verify<Y>(
        x_movescription: &Movescription,
        y_amount: &Balance<Y>,
        expected_liquidity: u64,
        token_pair: &token_pair::TokenPair<Y>,
        ctx: &mut TxContext,
    ): token_pair::LiquidityAdded {
        assert!(
            movescription::tick(x_movescription) == movescription::tick(token_pair::borrow_x_reserve(token_pair)),
            ENotSameTick
        );
        let x_token_type = string::from_ascii(movescription::tick(x_movescription));

        let total_liquidity = token_pair::total_liquidity(token_pair);
        let x_reserve = movescription::amount(token_pair::borrow_x_reserve(token_pair));
        let y_reserve = balance::value(token_pair::borrow_y_reserve(token_pair));
        let x_amount_i = movescription::amount(x_movescription);
        let y_amount_i = balance::value(y_amount);
        let liquidity_amount_added = liquidity_util::calculate_liquidity(
            total_liquidity,
            x_reserve,
            y_reserve,
            x_amount_i,
            y_amount_i
        );
        assert!(liquidity_amount_added > 0, EAddInvalidLiquidity);
        assert!(liquidity_amount_added >= expected_liquidity, EAddInvalidLiquidity);

        // mint first, so that we can emit its id in the event
        let liquidity_token = liquidity_token_aggregate::mint<Y>(x_token_type, liquidity_amount_added, ctx);
        let liquidity_token_id = liquidity_token::id(&liquidity_token);
        transfer::public_transfer(liquidity_token, tx_context::sender(ctx));

        token_pair::new_liquidity_added(
            token_pair,
            expected_liquidity,
            tx_context::sender(ctx),
            x_token_type, //string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            x_amount_i,
            y_amount_i,
            liquidity_amount_added,
            liquidity_token_id,
        )
    }

    public(friend) fun mutate<Y>(
        liquidity_added: &token_pair::LiquidityAdded,
        x_movescription: Movescription,
        y_amount: Balance<Y>,
        token_pair: &mut token_pair::TokenPair<Y>,
        _ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        //let provider = liquidity_added::provider(liquidity_added);
        //let x_token_type = liquidity_added::x_token_type(liquidity_added);
        //let y_token_type = liquidity_added::y_token_type(liquidity_added);
        // let x_amount = liquidity_added::x_amount(liquidity_added);
        // let y_amount = liquidity_added::y_amount(liquidity_added);
        let liquidity_amount_added = liquidity_added::liquidity_amount(liquidity_added);

        //let id = token_pair::id(token_pair);
        let total_liquidity = token_pair::total_liquidity(token_pair);
        token_pair::set_total_liquidity(
            token_pair,
            total_liquidity + liquidity_amount_added,
        );
        let x_reserve = token_pair::borrow_mut_x_reserve(token_pair);
        //sui::balance::join(x_reserve, x_amount);
        movescription::merge(x_reserve, x_movescription);
        let y_reserve = token_pair::borrow_mut_y_reserve(token_pair);
        sui::balance::join(y_reserve, y_amount);
    }
}
