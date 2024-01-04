module sui_swap_example::token_pair_service {

    use sui::balance::Balance;
    use sui::coin::{Self, Coin};
    use sui::object::ID;
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;

    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::liquidity_token_aggregate;
    use sui_swap_example::token_pair::TokenPair;
    use sui_swap_example::token_pair_aggregate;

    public entry fun initialize_liquidity<X: key + store, Y>(
        exchange: &mut Exchange,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        //let x_amount_b = split_up_and_into_balance(x_coin, x_amount, ctx);
        let y_amount_b = split_up_and_into_balance(y_coin, y_amount, ctx);
        token_pair_aggregate::initialize_liquidity(
            exchange,
            x,
            0, //todo x_amount
            y_amount_b,
            ctx,
        )
    }

    public entry fun add_liquidity<X: key + store, Y>(
        token_pair: &mut TokenPair<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        //let x_amount_b = split_up_and_into_balance(x_coin, x_amount, ctx);
        let y_amount_b = split_up_and_into_balance(y_coin, y_amount, ctx);
        token_pair_aggregate::add_liquidity(
            token_pair,
            liquidity_token,
            x,
            0, //todo x_amount
            y_amount_b,
            ctx,
        )
    }

    public entry fun remove_liquidity<X: key + store, Y>(
        token_pair: &mut TokenPair<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x_id: ID,
        y_coin: &mut Coin<Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        // let liquidity_token_r =
        //     if (amount != 0 && amount < liquidity_token::amount(&liquidity_token)) {
        //         liquidity_token_aggregate::split(liquidity_token, amount, ctx)
        //     } else {
        //         liquidity_token
        //     };
        let (x, y_balance) = token_pair_aggregate::remove_liquidity(
            token_pair,
            liquidity_token,
            x_id,
            ctx,
        );
        transfer::public_transfer(x, tx_context::sender(ctx));
        coin::join(y_coin, coin::from_balance(y_balance, ctx));
    }

    public entry fun swap_x<X: key + store, Y>(
        token_pair: &mut TokenPair<X, Y>,
        x: X,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        //let x_amount_b = split_up_and_into_balance(x_coin, x_amount, ctx);
        let y_amount_b = token_pair_aggregate::swap_x(
            token_pair,
            x,
            0, //todo x_amount
            expected_y_amount_out,
            ctx,
        );
        coin::join(y_coin, coin::from_balance(y_amount_b, ctx));
    }

    public entry fun swap_y<X: key + store, Y>(
        token_pair: &mut TokenPair<X, Y>,
        y_coin: Coin<Y>,
        y_amount: u64,
        x_id: ID,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = split_up_and_into_balance(y_coin, y_amount, ctx);
        let x = token_pair_aggregate::swap_y(
            token_pair,
            y_amount_b,
            x_id,
            ctx,
        );
        transfer::public_transfer(x, tx_context::sender(ctx));
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
