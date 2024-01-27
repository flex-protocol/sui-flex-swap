module sui_swap_example::token_pair_service_process {
    use sui::coin;
    use sui::coin::Coin;
    use sui::object::{Self, ID};
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::coin_util;
    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::nft_service;
    use sui_swap_example::token_pair::TokenPair;
    use sui_swap_example::token_pair_aggregate;

    const EMismatchedObjectId: u64 = 10;

    struct InitializeLiquidityGetX_AmountContext<phantom Y> {
        exchange_id: ID,
        y_coin: Coin<Y>,
        y_amount: u64,
    }

    public fun initialize_liquidity<X: key + store, Y>(
        exchange: &mut Exchange,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        _ctx: &TxContext,
    ): nft_service::GetAmountRequest<X, InitializeLiquidityGetX_AmountContext<Y>> {
        let exchange_id = object::id(exchange);
        let get_x_amount_context = InitializeLiquidityGetX_AmountContext {
            exchange_id,
            y_coin,
            y_amount,
        };
        let get_x_amount_request = nft_service::new_get_amount_request<X, InitializeLiquidityGetX_AmountContext<Y>>(
            x,
            get_x_amount_context,
        );
        get_x_amount_request
    }

    #[allow(unused_assignment)]
    public fun initialize_liquidity_get_x_amount_callback<X: key + store, Y, NS>(
        exchange: &mut Exchange,
        get_x_amount_response: nft_service::GetAmountResponse<X, NS, InitializeLiquidityGetX_AmountContext<Y>>,
        _ctx: &mut TxContext,
    ) {
        let (x_amount, get_x_amount_request) = nft_service::unpack_get_amount_respone(get_x_amount_response);
        let (x, get_x_amount_context) = nft_service::unpack_get_amount_request(get_x_amount_request);
        let InitializeLiquidityGetX_AmountContext {
            exchange_id,
            y_coin,
            y_amount,
        } = get_x_amount_context;
        assert!(object::id(exchange) == exchange_id, EMismatchedObjectId);
        internal_initialize_liquidity(exchange, x, x_amount, y_coin, y_amount, _ctx)
    }

    fun internal_initialize_liquidity<X: key + store, Y>(
        exchange: &mut Exchange,
        x: X,
        x_amount: u64,
        y_coin: Coin<Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = coin_util::split_up_and_into_balance(y_coin, y_amount, ctx);
        token_pair_aggregate::initialize_liquidity(
            exchange,
            x,
            x_amount,
            y_amount_b,
            ctx,
        )
    }

    fun internal_add_liquidity<X: key + store, Y>(
        token_pair: &mut TokenPair<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x: X,
        x_amount: u64,
        y_coin: Coin<Y>,
        y_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = coin_util::split_up_and_into_balance(y_coin, y_amount, ctx);
        token_pair_aggregate::add_liquidity(
            token_pair,
            liquidity_token,
            x,
            x_amount,
            y_amount_b,
            ctx,
        )
    }

    fun internal_swap_x<X: key + store, Y>(
        token_pair: &mut TokenPair<X, Y>,
        x: X,
        x_amount: u64,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = token_pair_aggregate::swap_x(
            token_pair,
            x,
            x_amount,
            expected_y_amount_out,
            ctx,
        );
        coin::join(y_coin, coin::from_balance(y_amount_b, ctx));
    }
}
//
// The boilerplate code that does "Dependency Injection".
//
/*
module xxx_di_package_id::token_pair_service_process {
    use sui::tx_context::TxContext;
    use sui_swap_example::token_pair_service_process;
    use sui_swap_example::nft_service_config::NftServiceConfig;
    use ns_impl_package_id::ns_nft_service_impl as ns;

    public fun initialize_liquidity(
        _nft_service_config: &NftServiceConfig,
        exchange: UID,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        _ctx: &TxContext,
    ) {
        let get_x_amount_req = token_pair_service_process::initialize_liquidity(exchange, x, y_coin, y_amount, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        token_pair_service_process::initialize_liquidity_get_x_amount_callback(get_x_amount_rsp, _ctx)
    }

    public fun add_liquidity(
        token_pair: &TokenPair<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        _ctx: &TxContext,
    ) {
        token_pair_service_process::add_liquidity(token_pair, liquidity_token, x, y_coin, y_amount, _ctx)
    }

    public fun swap_x(
        token_pair: &TokenPair<X, Y>,
        x: X,
        y_coin: &Coin<Y>,
        expected_y_amount_out: u64,
        _ctx: &TxContext,
    ) {
        token_pair_service_process::swap_x(token_pair, x, y_coin, expected_y_amount_out, _ctx)
    }

}
*/
