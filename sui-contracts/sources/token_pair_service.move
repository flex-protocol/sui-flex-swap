module sui_swap_example::token_pair_service {

    use sui::balance::Balance;
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use smartinscription::movescription::Movescription;

    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::token_pair::TokenPair;
    use sui_swap_example::token_pair_aggregate;

    public entry fun initialize_liquidity<Y>(
        publisher: &sui::package::Publisher,
        exchange: &mut Exchange,
        x_movescription: Movescription,
        y_coin: Coin<Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        //let x_amount_b = split_up_and_into_balance(x_coin, x_amount, ctx);
        let y_amount_b = split_up_and_into_balance(y_coin, y_amount, ctx);
        token_pair_aggregate::initialize_liquidity(
            publisher,
            exchange,
            x_movescription,
            y_amount_b,
            ctx,
        )
    }

    public entry fun add_liquidity<Y>(
        token_pair: &mut TokenPair<Y>,
        x_movescription: Movescription,
        y_coin: Coin<Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        //let x_amount_b = split_up_and_into_balance(x_coin, x_amount, ctx);
        let y_amount_b = split_up_and_into_balance(y_coin, y_amount, ctx);
        token_pair_aggregate::add_liquidity(
            token_pair,
            x_movescription,
            y_amount_b,
            ctx,
        )
    }

    public entry fun remove_liquidity<Y>(
        token_pair: &mut TokenPair<Y>,
        liquidity_token: LiquidityToken<Y>,
        y_coin: &mut Coin<Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_balance = token_pair_aggregate::remove_liquidity(
            token_pair,
            liquidity_token,
            ctx,
        );
        //coin::join(x_coin, coin::from_balance(x_balance, ctx));
        coin::join(y_coin, coin::from_balance(y_balance, ctx));
    }

    public entry fun swap_x<Y>(
        token_pair: &mut TokenPair<Y>,
        x_movescription: Movescription,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        //let x_amount_b = split_up_and_into_balance(x_coin, x_amount, ctx);
        let y_amount_b = token_pair_aggregate::swap_x(
            token_pair,
            x_movescription,
            expected_y_amount_out,
            ctx,
        );
        coin::join(y_coin, coin::from_balance(y_amount_b, ctx));
    }

    public entry fun swap_y<Y>(
        token_pair: &mut TokenPair<Y>,
        y_coin: Coin<Y>,
        y_amount: u64,
        expected_x_amount_out: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = split_up_and_into_balance(y_coin, y_amount, ctx);
        token_pair_aggregate::swap_y(
            token_pair,
            y_amount_b,
            expected_x_amount_out,
            ctx,
        );
    }

    #[lint_allow(self_transfer)]
    fun split_up_and_into_balance<T>(coin: Coin<T>, amount: u64, ctx: &mut TxContext): Balance<T> {
        if (coin::value(&coin) == amount) {
            coin::into_balance(coin)
        } else {
            let s = coin::into_balance(coin::split(&mut coin, amount, ctx));
            transfer::public_transfer(coin, tx_context::sender(ctx));
            s
        }
    }
}
