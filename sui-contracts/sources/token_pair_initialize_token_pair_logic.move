#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_initialize_token_pair_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::object::Self;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui_swap_example::token_pair_initialized;

    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::exchange_aggregate;
    use sui_swap_example::liquidity_token_aggregate;
    use sui_swap_example::token_pair;
    use sui_swap_example::token_util;

    friend sui_swap_example::token_pair_aggregate;

    const EAddInvalidLiquidity: u64 = 100;

    public(friend) fun verify<X, Y>(
        exchange: &mut Exchange,
        y_amount: &Balance<Y>,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        ctx: &mut TxContext,
    ): token_pair::TokenPairInitialized {
        token_util::assert_type_less_than<X, Y>();
        let y_amount_i = balance::value(y_amount);
        //let liquidity_amount = liquidity_util::calculate_liquidity(total_liquidity, 0, 0, x_amount_i, y_amount_i);
        //assert!(liquidity_amount > 0, EAddInvalidLiquidity);

        // mint first, so that we can emit its id in the event
        let liquidity_token = liquidity_token_aggregate::mint<X, Y>(
            //liquidity_amount,
            ctx,
        );
        let liquidity_token_id = object::id(&liquidity_token);
        transfer::public_transfer(liquidity_token, tx_context::sender(ctx));

        token_pair::new_token_pair_initialized<X, Y>(
            object::id(exchange),
            exchange_rate_numerator,
            exchange_rate_denominator,
            tx_context::sender(ctx),
            string::from_ascii(type_name::into_string(type_name::get<X>())),
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            0,
            y_amount_i,
            liquidity_token_id,
        )
    }

    public(friend) fun mutate<X, Y>(
        token_pair_initialized: &token_pair::TokenPairInitialized,
        y_amount: Balance<Y>,
        exchange: &mut Exchange,
        ctx: &mut TxContext,
    ): token_pair::TokenPair<X, Y> {
        let exchange_rate_numerator = token_pair::token_pair_initialized_exchange_rate_numerator(token_pair_initialized);
        let exchange_rate_denominator = token_pair::token_pair_initialized_exchange_rate_denominator(token_pair_initialized);

        let token_pair = token_pair::new_token_pair(
            exchange_rate_numerator,
            exchange_rate_denominator,
            ctx,
        );
        //
        exchange_aggregate::add_token_pair<X, Y>(exchange, token_pair::id(&token_pair), ctx);
        //
        //let x_reserve = token_pair::borrow_mut_x_reserve(&mut token_pair);
        //sui::balance::join(x_reserve, x_amount);
        let y_reserve = token_pair::borrow_mut_y_reserve(&mut token_pair);
        sui::balance::join(y_reserve, y_amount);
        token_pair
    }
}
