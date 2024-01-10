// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::token_pair_aggregate {
    use smartinscription::movescription::Movescription;
    use sui::balance::Balance;
    use sui::tx_context;
    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::token_pair;
    use sui_swap_example::token_pair_add_liquidity_logic;
    use sui_swap_example::token_pair_initialize_liquidity_logic;
    use sui_swap_example::token_pair_remove_liquidity_logic;
    use sui_swap_example::token_pair_swap_x_logic;
    use sui_swap_example::token_pair_swap_y_logic;

    friend sui_swap_example::token_pair_service;

    const EInvalidPublisher: u64 = 50;

    #[allow(unused_mut_parameter)]
    public fun initialize_liquidity<Y>(
        publisher: &sui::package::Publisher,
        exchange: &mut Exchange,
        x_movescription: Movescription,
        y_amount: Balance<Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<token_pair::TokenPair<Y>>(publisher), EInvalidPublisher);
        let liquidity_initialized = token_pair_initialize_liquidity_logic::verify<Y>(
            exchange,
            &x_movescription,
            &y_amount,
            ctx,
        );
        let token_pair = token_pair_initialize_liquidity_logic::mutate<Y>(
            &liquidity_initialized,
            x_movescription,
            y_amount,
            exchange,
            ctx,
        );
        token_pair::set_liquidity_initialized_id(&mut liquidity_initialized, token_pair::id(&token_pair));
        token_pair::share_object(token_pair);
        token_pair::emit_liquidity_initialized(liquidity_initialized);
    }

    #[allow(unused_mut_parameter)]
    public fun add_liquidity<Y>(
        token_pair: &mut token_pair::TokenPair<Y>,
        x_movescription: Movescription,
        y_amount: Balance<Y>,
        expected_liquidity: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        token_pair::assert_schema_version(token_pair);
        let liquidity_added = token_pair_add_liquidity_logic::verify<Y>(
            &x_movescription,
            &y_amount,
            expected_liquidity,
            token_pair,
            ctx,
        );
        token_pair_add_liquidity_logic::mutate<Y>(
            &liquidity_added,
            x_movescription,
            y_amount,
            token_pair,
            ctx,
        );
        token_pair::update_object_version(token_pair);
        token_pair::emit_liquidity_added(liquidity_added);
    }

    #[allow(unused_mut_parameter)]
    public fun remove_liquidity<Y>(
        token_pair: &mut token_pair::TokenPair<Y>,
        liquidity_token: LiquidityToken<Y>,
        ctx: &mut tx_context::TxContext,
    ): Balance<Y> {
        token_pair::assert_schema_version(token_pair);
        let liquidity_removed = token_pair_remove_liquidity_logic::verify<Y>(
            &liquidity_token,
            token_pair,
            ctx,
        );
        let remove_liquidity_return = token_pair_remove_liquidity_logic::mutate<Y>(
            &liquidity_removed,
            liquidity_token,
            token_pair,
            ctx,
        );
        token_pair::update_object_version(token_pair);
        token_pair::emit_liquidity_removed(liquidity_removed);
        remove_liquidity_return
    }

    #[allow(unused_mut_parameter)]
    public fun swap_x<Y>(
        token_pair: &mut token_pair::TokenPair<Y>,
        x_movescription: Movescription,
        expected_y_amount_out: u64,
        ctx: &mut tx_context::TxContext,
    ): Balance<Y> {
        token_pair::assert_schema_version(token_pair);
        let x_swapped_for_y = token_pair_swap_x_logic::verify<Y>(
            &x_movescription,
            expected_y_amount_out,
            token_pair,
            ctx,
        );
        let swap_x_return = token_pair_swap_x_logic::mutate<Y>(
            &x_swapped_for_y,
            x_movescription,
            token_pair,
            ctx,
        );
        token_pair::update_object_version(token_pair);
        token_pair::emit_x_swapped_for_y(x_swapped_for_y);
        swap_x_return
    }

    #[allow(unused_mut_parameter)]
    public fun swap_y<Y>(
        token_pair: &mut token_pair::TokenPair<Y>,
        y_amount: Balance<Y>,
        expected_x_amount_out: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        token_pair::assert_schema_version(token_pair);
        let y_swapped_for_x = token_pair_swap_y_logic::verify<Y>(
            &y_amount,
            expected_x_amount_out,
            token_pair,
            ctx,
        );
        token_pair_swap_y_logic::mutate<Y>(
            &y_swapped_for_x,
            y_amount,
            token_pair,
            ctx,
        );
        token_pair::update_object_version(token_pair);
        token_pair::emit_y_swapped_for_x(y_swapped_for_x);
    }

}
