#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_initialize_liquidity_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::object::Self;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use smartinscription::movescription;
    use smartinscription::movescription::Movescription;
    use sui_swap_example::liquidity_token::x_token_type;

    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::exchange_aggregate;
    use sui_swap_example::liquidity_initialized;
    use sui_swap_example::liquidity_token_aggregate;
    use sui_swap_example::liquidity_util;
    use sui_swap_example::token_pair;
    use sui_swap_example::token_util;

    friend sui_swap_example::token_pair_aggregate;

    const EAddInvalidLiquidity: u64 = 100;

    #[lint_allow(self_transfer)]
    public(friend) fun verify<Y>(
        exchange: &mut Exchange,
        x_movescription: &Movescription,
        y_amount: &Balance<Y>,
        ctx: &mut TxContext,
    ): token_pair::LiquidityInitialized {
        //token_util::assert_type_less_than<X, Y>();
        let total_liquidity = 0;
        let x_token_type = string::from_ascii(movescription::tick(x_movescription));
        let x_amount_i = 0;//todo balance::value(x_amount);
        let y_amount_i = balance::value(y_amount);
        let liquidity_amount = liquidity_util::calculate_liquidity(total_liquidity, 0, 0, x_amount_i, y_amount_i);
        assert!(liquidity_amount > 0, EAddInvalidLiquidity);

        // mint first, so that we can emit its id in the event
        let liquidity_token = liquidity_token_aggregate::mint<Y>(x_token_type, liquidity_amount, ctx);
        let liquidity_token_id = object::id(&liquidity_token);
        transfer::public_transfer(liquidity_token, tx_context::sender(ctx));

        token_pair::new_liquidity_initialized<Y>(
            object::id(exchange),
            tx_context::sender(ctx),
            x_token_type,
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            x_amount_i,
            y_amount_i,
            liquidity_amount,
            liquidity_token_id,
        )
    }

    public(friend) fun mutate<Y>(
        liquidity_initialized: &token_pair::LiquidityInitialized,
        x_movescription: Movescription,
        y_amount: Balance<Y>,
        exchange: &mut Exchange,
        ctx: &mut TxContext,
    ): token_pair::TokenPair<Y> {
        //let exchange_id = liquidity_initialized::exchange_id(liquidity_initialized);
        //let provider = liquidity_initialized::provider(liquidity_initialized);
        let x_token_type = liquidity_initialized::x_token_type(liquidity_initialized);
        //let y_token_type = liquidity_initialized::y_token_type(liquidity_initialized);
        let x_amount = liquidity_initialized::x_amount(liquidity_initialized);
        //todo assert x_amount == movescription::...;
        // let y_amount = liquidity_initialized::y_amount(liquidity_initialized);
        let liquidity_amount = liquidity_initialized::liquidity_amount(liquidity_initialized);

        let token_pair = token_pair::new_token_pair(
            liquidity_amount,
            x_movescription,
            ctx,
        );
        //
        exchange_aggregate::add_token_pair<Y>(exchange, token_pair::id(&token_pair), x_token_type, ctx);
        //
        //let x_reserve = token_pair::borrow_mut_x_reserve(&mut token_pair);
        //sui::balance::join(x_reserve, x_amount);
        let y_reserve = token_pair::borrow_mut_y_reserve(&mut token_pair);
        sui::balance::join(y_reserve, y_amount);
        token_pair
    }
}
