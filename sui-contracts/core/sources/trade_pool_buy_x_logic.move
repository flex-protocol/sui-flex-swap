#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_core::trade_pool_buy_x_logic {
    use std::string;
    use std::type_name;

    use sui::balance::{Self, Balance};
    use sui::object::ID;
    use sui::object_table;
    use sui::table;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_core::pool_type;
    use sui_swap_core::price_curve;
    use sui_swap_core::trade_pool;

    friend sui_swap_core::trade_pool_aggregate;

    const EInvalidXTokenId: u64 = 11;
    const EInvalidPoolType: u64 = 20;
    const EInsufficientYAmount: u64 = 100;
    const EInconsistentXAmount: u64 = 101;

    public(friend) fun verify<X: key + store, Y>(
        y_amount: &Balance<Y>,
        x_id: ID,
        pool: &trade_pool::TradePool<X, Y>,
        ctx: &TxContext,
    ): trade_pool::PoolYSwappedForX {
        assert!(pool_type::is_trade_pool_or_sell_pool(trade_pool::pool_type(pool)), EInvalidPoolType);
        let x_amounts = trade_pool::borrow_x_amounts(pool);
        assert!(table::contains(x_amounts, x_id), EInvalidXTokenId);
        let x_amount = *table::borrow(x_amounts, x_id);
        //let x_reserve_amount = trade_pool::x_total_amount(trade_pool);
        //let y_reserve_amount = balance::value(trade_pool::borrow_y_reserve(trade_pool));
        let y_amount_in = balance::value(y_amount);

        let price_curve_type = trade_pool::price_curve_type(pool);
        //x_amount,
        let price_delta_x_amount = trade_pool::price_delta_x_amount(pool); //number_denominator: u64,
        let exchange_rate_numerator = trade_pool::exchange_rate_numerator(pool); //spot_price: u64,
        let start_exchange_rate_numerator = trade_pool::start_exchange_rate_numerator(pool);
        let price_delta_numerator = trade_pool::price_delta_numerator(pool);
        let price_delta_denominator = trade_pool::price_delta_denominator(pool);

        let (y_amount_required_numerator, new_exchange_rate_numerator) = price_curve::get_buy_info(
            price_curve_type,
            x_amount,
            price_delta_x_amount,
            exchange_rate_numerator,
            start_exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );

        let exchange_rate_denominator = trade_pool::exchange_rate_denominator(pool);
        let y_amount_required = y_amount_required_numerator / exchange_rate_denominator;
        assert!(y_amount_in >= y_amount_required, EInsufficientYAmount);


        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        trade_pool::new_pool_y_swapped_for_x(
            pool,
            x_id,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            x_amount,
            y_amount_required, //y_amount_in, //Note: not to charge extra?
            new_exchange_rate_numerator,
        )
    }

    #[lint_allow(self_transfer)]
    public(friend) fun mutate<X: key + store, Y>(
        pool_y_swapped_for_x: &trade_pool::PoolYSwappedForX,
        y_amount: Balance<Y>,
        pool: &mut trade_pool::TradePool<X, Y>,
        _ctx: &mut TxContext, // modify the reference to mutable if needed
    ): X {
        let y_amount_required = trade_pool::pool_y_swapped_for_x_y_amount(pool_y_swapped_for_x);
        let y_amount_i = balance::value(&y_amount);
        assert!(y_amount_i >= y_amount_required, EInsufficientYAmount);
        if (y_amount_i > y_amount_required) {
            //Note: not to charge extra?
            let r = balance::split(&mut y_amount, y_amount_i - y_amount_required);
            let c = sui::coin::from_balance(r, _ctx);
            transfer::public_transfer(c, tx_context::sender(_ctx));
        };
        let x_amount = trade_pool::pool_y_swapped_for_x_x_amount(pool_y_swapped_for_x);
        let new_exchange_rate_numerator = trade_pool::pool_y_swapped_for_x_new_exchange_rate_numerator(
            pool_y_swapped_for_x
        );
        trade_pool::set_exchange_rate_numerator(pool, new_exchange_rate_numerator);

        let y_reserve = trade_pool::borrow_mut_y_reserve(pool);
        sui::balance::join(y_reserve, y_amount);

        let x_id = trade_pool::pool_y_swapped_for_x_x_id(pool_y_swapped_for_x);
        let (x, _x_total_amount) = remove_sold_x_token<X, Y>(
            pool,
            x_id,
            x_amount,
        );
        x
    }

    fun remove_sold_x_token<X: key + store, Y>(
        pool: &mut trade_pool::TradePool<X, Y>,
        x_id: ID,
        x_amount: u64
    ): (X, u64) {
        let x_amounts = trade_pool::borrow_mut_x_amounts(pool);
        assert!(x_amount == table::remove(x_amounts, x_id), EInconsistentXAmount);
        let x_reserve = trade_pool::borrow_mut_x_reserve(pool);
        let x = object_table::remove(x_reserve, x_id);
        let x_total_amount = trade_pool::x_total_amount(pool);
        x_total_amount = x_total_amount - x_amount;
        trade_pool::set_x_total_amount(pool, x_total_amount);

        let x_sold_amount = trade_pool::x_sold_amount(pool);
        x_sold_amount = x_sold_amount + x_amount;
        trade_pool::set_x_sold_amount(pool, x_sold_amount);

        (x, x_total_amount)
    }
}
