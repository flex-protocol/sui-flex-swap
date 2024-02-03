#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module sui_swap_example::sell_pool_buy_x_logic {
    use std::string;
    use std::type_name;

    use sui::balance;
    use sui::balance::Balance;
    use sui::object::ID;
    use sui::object_table;
    use sui::table;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::price_curve;
    use sui_swap_example::sell_pool;
    use sui_swap_example::sell_pool_y_swapped_for_x;

    friend sui_swap_example::sell_pool_aggregate;

    const EInvalidXTokenId: u64 = 11;
    const EInsufficientYAmount: u64 = 100;
    const EInconsistentXAmount: u64 = 101;

    public(friend) fun verify<X: key + store, Y>(
        y_amount: &Balance<Y>,
        x_id: ID,
        sell_pool: &sell_pool::SellPool<X, Y>,
        ctx: &TxContext,
    ): sell_pool::SellPoolYSwappedForX {
        let x_amounts = sell_pool::borrow_x_amounts(sell_pool);
        assert!(table::contains(x_amounts, x_id), EInvalidXTokenId);
        let x_amount = *table::borrow(x_amounts, x_id);
        //let x_reserve_amount = sell_pool::x_total_amount(sell_pool);
        //let y_reserve_amount = balance::value(sell_pool::borrow_y_reserve(sell_pool));
        let y_amount_in = balance::value(y_amount);

        let price_curve_type = sell_pool::price_curve_type(sell_pool);
        //x_amount, //number_numerator: u64,
        let price_delta_x_amount = sell_pool::price_delta_x_amount(sell_pool); //number_denominator: u64,
        let exchange_rate_numerator = sell_pool::exchange_rate_numerator(sell_pool); //spot_price: u64,
        let price_delta_numerator = sell_pool::price_delta_numerator(sell_pool);
        let price_delta_denominator = sell_pool::price_delta_denominator(sell_pool);

        let (y_amount_required, new_exchange_rate_numerator) = price_curve::get_buy_info(
            price_curve_type,
            x_amount, // <- number_numerator: u64,
            price_delta_x_amount,
            exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );
        assert!(y_amount_in >= y_amount_required, EInsufficientYAmount);

        let x_token_type = string::from_ascii(type_name::into_string(type_name::get<X>()));
        let y_token_type = string::from_ascii(type_name::into_string(type_name::get<Y>()));
        sell_pool::new_sell_pool_y_swapped_for_x(
            sell_pool,
            x_id,
            tx_context::sender(ctx),
            x_token_type,
            y_token_type,
            x_amount,
            balance::value(y_amount),
            new_exchange_rate_numerator,
        )
    }

    public(friend) fun mutate<X: key + store, Y>(
        sell_pool_y_swapped_for_x: &sell_pool::SellPoolYSwappedForX,
        y_amount: Balance<Y>,
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        _ctx: &TxContext, // modify the reference to mutable if needed
    ): X {
        //let sender = sell_pool_y_swapped_for_x::sender(sell_pool_y_swapped_for_x);
        //let x_token_type = sell_pool_y_swapped_for_x::x_token_type(sell_pool_y_swapped_for_x);
        //let y_token_type = sell_pool_y_swapped_for_x::y_token_type(sell_pool_y_swapped_for_x);
        let x_amount = sell_pool_y_swapped_for_x::x_amount(sell_pool_y_swapped_for_x);
        //let y_amount = sell_pool_y_swapped_for_x::y_amount(sell_pool_y_swapped_for_x);
        let new_exchange_rate_numerator = sell_pool_y_swapped_for_x::new_exchange_rate_numerator(
            sell_pool_y_swapped_for_x
        );
        sell_pool::set_exchange_rate_denominator(sell_pool, new_exchange_rate_numerator);

        let y_reserve = sell_pool::borrow_mut_y_reserve(sell_pool);
        sui::balance::join(y_reserve, y_amount);

        let x_id = sell_pool_y_swapped_for_x::x_id(sell_pool_y_swapped_for_x);
        let (x, _x_total_amount) = remove_x_token<X, Y>(
            sell_pool,
            x_id,
            x_amount
        );
        x
    }

    fun remove_x_token<X: key + store, Y>(
        sell_pool: &mut sell_pool::SellPool<X, Y>,
        x_id: ID,
        x_amount: u64
    ): (X, u64) {
        let x_amounts = sell_pool::borrow_mut_x_amounts(sell_pool);
        assert!(x_amount == table::remove(x_amounts, x_id), EInconsistentXAmount);
        let x_reserve = sell_pool::borrow_mut_x_reserve(sell_pool);
        let x = object_table::remove(x_reserve, x_id);
        let x_total_amount = sell_pool::x_total_amount(sell_pool);
        x_total_amount = x_total_amount - x_amount;
        sell_pool::set_x_total_amount(sell_pool, x_total_amount);

        let x_sold_amount = sell_pool::x_sold_amount(sell_pool);
        x_sold_amount = x_sold_amount + x_amount;
        sell_pool::set_x_sold_amount(sell_pool, x_sold_amount);

        (x, x_total_amount)
    }
}
