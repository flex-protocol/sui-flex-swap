module sui_swap_example::token_pair_service {
    use sui::balance::Balance;
    use sui::coin;
    use sui::coin::Coin;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::token_pair::TokenPair;
    use sui_swap_example::token_pair_aggregate;

    public entry fun initialize_token_pair<X, Y>(
        exchange: &mut Exchange,
        y_coin: Coin<Y>,
        y_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = split_up_and_into_balance(y_coin, y_amount, ctx);
        token_pair_aggregate::initialize_token_pair<X, Y>(
            exchange,
            y_amount_b,
            exchange_rate_numerator,
            exchange_rate_denominator,
            ctx,
        )
    }

    public entry fun deposit_y_reserve<X, Y>(
        token_pair: &mut TokenPair<X, Y>,
        y_coin: Coin<Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = split_up_and_into_balance(y_coin, y_amount, ctx);
        token_pair_aggregate::deposit_y_reserve(token_pair, y_amount_b, ctx);
    }

    public entry fun withdraw_x_reserve<X, Y>(
        token_pair: &mut TokenPair<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x_amount: u64,
        x_coin: &mut Coin<X>,
        ctx: &mut tx_context::TxContext,
    ) {
        let x_amount_b = token_pair_aggregate::withdraw_x_reserve(token_pair, liquidity_token, x_amount, ctx);
        coin::join(x_coin, coin::from_balance(x_amount_b, ctx));
    }

    public entry fun withdraw_y_reserve<X, Y>(
        token_pair: &mut TokenPair<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        y_amount: u64,
        y_coin: &mut Coin<Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = token_pair_aggregate::withdraw_y_reserve(token_pair, liquidity_token, y_amount, ctx);
        coin::join(y_coin, coin::from_balance(y_amount_b, ctx));
    }

    public entry fun swap_x<X, Y>(
        token_pair: &mut TokenPair<X, Y>,
        x_coin: Coin<X>,
        x_amount: u64,
        y_coin: &mut Coin<Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        let x_amount_b = split_up_and_into_balance(x_coin, x_amount, ctx);
        let y_amount_b = token_pair_aggregate::swap_x(
            token_pair,
            x_amount_b,
            ctx,
        );
        coin::join(y_coin, coin::from_balance(y_amount_b, ctx));
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
