module sui_swap_example::token_pair_service_process {
    use sui::coin;
    use sui::coin::Coin;
    use sui::object;
    use sui::tx_context::{Self, TxContext};

    use sui_swap_example::coin_util;
    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::nft_service;
    use sui_swap_example::token_pair::TokenPair;
    use sui_swap_example::token_pair_aggregate;

    const EMismatchedObjectId: u64 = 10;

    #[lint_allow(coin_field)]
    struct InitializeLiquidityGetX_AmountContext<phantom Y> {
        exchange_id: sui::object::ID,
        y_coin: Coin<Y>,
        y_amount: u64,
    }

    public fun initialize_liquidity<X: key + store, Y>(
        exchange: &mut Exchange,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        _ctx: &mut TxContext,
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

    #[lint_allow(coin_field)]
    struct AddLiquidityGetX_AmountContext<phantom Y> {
        token_pair_id: sui::object::ID,
        liquidity_token_id: sui::object::ID,
        y_coin: Coin<Y>,
        y_amount: u64,
    }

    public fun add_liquidity<X: key + store, Y>(
        token_pair: &mut TokenPair<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        _ctx: &mut TxContext,
    ): nft_service::GetAmountRequest<X, AddLiquidityGetX_AmountContext<Y>> {
        let token_pair_id = object::id(token_pair);
        let liquidity_token_id = object::id(liquidity_token);
        let get_x_amount_context = AddLiquidityGetX_AmountContext {
            token_pair_id,
            liquidity_token_id,
            y_coin,
            y_amount,
        };
        let get_x_amount_request = nft_service::new_get_amount_request<X, AddLiquidityGetX_AmountContext<Y>>(
            x,
            get_x_amount_context,
        );
        get_x_amount_request
    }

    #[allow(unused_assignment)]
    public fun add_liquidity_get_x_amount_callback<X: key + store, Y, NS>(
        token_pair: &mut TokenPair<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        get_x_amount_response: nft_service::GetAmountResponse<X, NS, AddLiquidityGetX_AmountContext<Y>>,
        _ctx: &mut TxContext,
    ) {
        let (x_amount, get_x_amount_request) = nft_service::unpack_get_amount_respone(get_x_amount_response);
        let (x, get_x_amount_context) = nft_service::unpack_get_amount_request(get_x_amount_request);
        let AddLiquidityGetX_AmountContext {
            token_pair_id,
            liquidity_token_id,
            y_coin,
            y_amount,
        } = get_x_amount_context;
        assert!(object::id(token_pair) == token_pair_id, EMismatchedObjectId);
        assert!(object::id(liquidity_token) == liquidity_token_id, EMismatchedObjectId);
        internal_add_liquidity(token_pair, liquidity_token, x, x_amount, y_coin, y_amount, _ctx);
    }

    struct SwapXGetX_AmountContext {
        token_pair_id: sui::object::ID,
        y_coin_id: sui::object::ID,
        expected_y_amount_out: u64,
    }

    public fun swap_x<X: key + store, Y>(
        token_pair: &mut TokenPair<X, Y>,
        x: X,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        _ctx: &mut TxContext,
    ): nft_service::GetAmountRequest<X, SwapXGetX_AmountContext> {
        let token_pair_id = object::id(token_pair);
        let y_coin_id = object::id(y_coin);
        let get_x_amount_context = SwapXGetX_AmountContext {
            token_pair_id,
            y_coin_id,
            expected_y_amount_out,
        };
        let get_x_amount_request = nft_service::new_get_amount_request<X, SwapXGetX_AmountContext>(
            x,
            get_x_amount_context,
        );
        get_x_amount_request
    }

    #[allow(unused_assignment)]
    public fun swap_x_get_x_amount_callback<X: key + store, Y, NS>(
        token_pair: &mut TokenPair<X, Y>,
        y_coin: &mut Coin<Y>,
        get_x_amount_response: nft_service::GetAmountResponse<X, NS, SwapXGetX_AmountContext>,
        _ctx: &mut TxContext,
    ) {
        let (x_amount, get_x_amount_request) = nft_service::unpack_get_amount_respone(get_x_amount_response);
        let (x, get_x_amount_context) = nft_service::unpack_get_amount_request(get_x_amount_request);
        let SwapXGetX_AmountContext {
            token_pair_id,
            y_coin_id,
            expected_y_amount_out,
        } = get_x_amount_context;
        assert!(object::id(token_pair) == token_pair_id, EMismatchedObjectId);
        assert!(object::id(y_coin) == y_coin_id, EMismatchedObjectId);
        internal_swap_x(token_pair, x, x_amount, y_coin, expected_y_amount_out, _ctx);
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

    public fun initialize_liquidity<X: key + store, Y>(
        _nft_service_config: &NftServiceConfig,
        exchange: &mut Exchange,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        _ctx: &TxContext,
    ) {
        let get_x_amount_req = token_pair_service_process::initialize_liquidity(exchange, x, y_coin, y_amount, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        token_pair_service_process::initialize_liquidity_get_x_amount_callback(exchange, get_x_amount_rsp, _ctx)
    }

    public fun add_liquidity<X: key + store, Y>(
        _nft_service_config: &NftServiceConfig,
        token_pair: &mut TokenPair<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        _ctx: &TxContext,
    ) {
        let get_x_amount_req = token_pair_service_process::add_liquidity(token_pair, liquidity_token, x, y_coin, y_amount, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        token_pair_service_process::add_liquidity_get_x_amount_callback(token_pair, liquidity_token, get_x_amount_rsp, _ctx)
    }

    public fun swap_x<X: key + store, Y>(
        _nft_service_config: &NftServiceConfig,
        token_pair: &mut TokenPair<X, Y>,
        x: X,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        _ctx: &TxContext,
    ) {
        let get_x_amount_req = token_pair_service_process::swap_x(token_pair, x, y_coin, expected_y_amount_out, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        token_pair_service_process::swap_x_get_x_amount_callback(token_pair, y_coin, get_x_amount_rsp, _ctx)
    }

}
*/
