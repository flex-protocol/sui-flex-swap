#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::token_pair_initialize_liquidity_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
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
    const EInconsistentAmount: u64 = 101;

    #[lint_allow(self_transfer)]
    public(friend) fun verify<X: key + store, Y>(
        exchange: &mut Exchange,
        x: &X,
        x_amount: u64,
        y_amount: &Balance<Y>,
        ctx: &mut TxContext,
    ): token_pair::LiquidityInitialized {
        let total_liquidity = 0;
        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        //let x_amount_i = movescription::amount(x_movescription);
        let y_amount_i = balance::value(y_amount);
        let liquidity_amount = liquidity_util::calculate_liquidity(total_liquidity, 0, 0, x_amount, y_amount_i);
        assert!(liquidity_amount > 0, EAddInvalidLiquidity);
        //token_util::assert_type_less_than<X, Y>();

        // mint first, so that we can emit its id in the event
        let liquidity_token = liquidity_token_aggregate::mint<X, Y>(ctx);
        let liquidity_token_id = object::id(&liquidity_token);
        transfer::public_transfer(liquidity_token, tx_context::sender(ctx));

        token_pair::new_liquidity_initialized<X, Y>(
            object::id(exchange),
            x_amount,
            tx_context::sender(ctx),
            x_token_type,
            string::from_ascii(type_name::into_string(type_name::get<Y>())),
            y_amount_i,
            liquidity_amount,
            liquidity_token_id,
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        liquidity_initialized: &token_pair::LiquidityInitialized,
        x: X,
        y_amount: Balance<Y>,
        exchange: &mut Exchange,
        ctx: &mut TxContext,
    ): token_pair::TokenPair<X, Y> {
        //let exchange_id = liquidity_initialized::exchange_id(liquidity_initialized);
        //let provider = liquidity_initialized::provider(liquidity_initialized);
        let x_token_type = liquidity_initialized::x_token_type(liquidity_initialized);
        //let y_token_type = liquidity_initialized::y_token_type(liquidity_initialized);
        let x_amount = liquidity_initialized::x_amount(liquidity_initialized);
        //assert!(x_amount == movescription::amount(&x_movescription), EInconsistentAmount);
        // let y_amount = liquidity_initialized::y_amount(liquidity_initialized);
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
