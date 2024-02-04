#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_initialize_liquidity_logic {
    use std::string;
    use std::type_name;

    use sui::balance::{Self, Balance};
    use sui::object::{Self, ID};
    use sui::object_table;
    use sui::table;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::exchange_aggregate;
    use sui_swap_example::liquidity_initialized;
    use sui_swap_example::liquidity_token_aggregate;
    use sui_swap_example::liquidity_util;
    use sui_swap_example::token_pair;

    friend sui_swap_example::token_pair_aggregate;

    const EAddInvalidLiquidity: u64 = 100;
    //const EInconsistentAmount: u64 = 101;
    const EInvalidFeeRate: u64 = 102;

    const DEFAULT_FEE_NUMERATOR: u64 = 3;
    const DEFAULT_FEE_DENOMINATOR: u64 = 1000;

    #[lint_allow(self_transfer)]
    public(friend) fun verify<X: key + store, Y>(
        exchange: &mut Exchange,
        x: &X,
        x_amount: u64,
        y_amount: &Balance<Y>,
        fee_numerator: u64,
        fee_denominator: u64,
        ctx: &mut TxContext,
    ): token_pair::LiquidityInitialized {
        let _ = x;
        let total_liquidity = 0;
        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        let y_amount_i = balance::value(y_amount);
        let liquidity_amount = liquidity_util::calculate_liquidity(total_liquidity, 0, 0, x_amount, y_amount_i);
        assert!(liquidity_amount > 0, EAddInvalidLiquidity);

        // mint first, so that we can emit its id in the event
        let liquidity_token = liquidity_token_aggregate::mint<X, Y>(ctx);
        let liquidity_token_id = object::id(&liquidity_token);
        transfer::public_transfer(liquidity_token, tx_context::sender(ctx));

        let fee_numerator = if (fee_denominator == 0) { DEFAULT_FEE_NUMERATOR } else { fee_numerator };
        let fee_denominator = if (fee_denominator == 0) { DEFAULT_FEE_DENOMINATOR } else { fee_denominator };
        assert!(fee_denominator > fee_numerator, EInvalidFeeRate);
        token_pair::new_liquidity_initialized<X, Y>(
            object::id(exchange),
            x_amount,
            fee_numerator,
            fee_denominator,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            y_amount_i,
            liquidity_amount,
            liquidity_token_id,
            object::id(x),
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        liquidity_initialized: &token_pair::LiquidityInitialized,
        x: X,
        y_amount: Balance<Y>,
        exchange: &mut Exchange,
        ctx: &mut TxContext,
    ): token_pair::TokenPair<X, Y> {
        let x_amount = liquidity_initialized::x_amount(liquidity_initialized);
        let liquidity_amount = liquidity_initialized::liquidity_amount(liquidity_initialized);

        let x_id = object::id(&x);
        let x_reserve = object_table::new<ID, X>(ctx);
        object_table::add(&mut x_reserve, x_id, x);
        let x_amounts = table::new<ID, u64>(ctx);
        table::add(&mut x_amounts, x_id, x_amount);
        let x_total_amount = x_amount;

        let liquidity_token_id = liquidity_initialized::liquidity_token_id(liquidity_initialized);

        let token_pair = token_pair::new_token_pair(
            x_reserve,
            x_amounts,
            x_total_amount,
            liquidity_amount,
            liquidity_token_id,
            liquidity_initialized::fee_numerator(liquidity_initialized),
            liquidity_initialized::fee_denominator(liquidity_initialized),
            ctx,
        );
        exchange_aggregate::add_token_pair<X, Y>(exchange, token_pair::id(&token_pair), ctx);

        let y_reserve = token_pair::borrow_mut_y_reserve(&mut token_pair);
        sui::balance::join(y_reserve, y_amount);
        token_pair
    }
}
