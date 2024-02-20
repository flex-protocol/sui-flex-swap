module sui_swap_core::token_pair_service {

    use sui::coin::{Self, Coin};
    use sui::object::ID;
    use sui::transfer;
    use sui::tx_context;
    use sui_swap_core::coin_util;
    use sui_swap_core::liquidity_token::LiquidityToken;
    use sui_swap_core::token_pair::TokenPair;
    use sui_swap_core::token_pair_aggregate;

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

    public entry fun swap_y<X: key + store, Y>(
        token_pair: &mut TokenPair<X, Y>,
        y_coin: Coin<Y>,
        y_amount: u64,
        x_id: ID,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = coin_util::split_up_and_into_balance(y_coin, y_amount, ctx);
        let x = token_pair_aggregate::swap_y(
            token_pair,
            y_amount_b,
            x_id,
            ctx,
        );
        transfer::public_transfer(x, tx_context::sender(ctx));
    }
}
