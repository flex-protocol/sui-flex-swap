module sui_swap_core::trade_pool_service_process {
    use sui::coin::Coin;
    use sui::object;
    use sui::tx_context;
    use sui::tx_context::TxContext;

    use sui_swap_utils::coin_util;
    use sui_swap_core::exchange::Exchange;
    use sui_swap_core::liquidity_token::LiquidityToken;
    use sui_swap_core::nft_service;
    use sui_swap_core::trade_pool;
    use sui_swap_core::trade_pool_aggregate;

    const EMismatchedObjectId: u64 = 10;

    #[lint_allow(coin_field)]
    struct InitializeTradePoolGetX_AmountContext<phantom Y> {
        exchange_id: sui::object::ID,
        y_coin: Coin<Y>,
        y_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
    }

    public fun initialize_trade_pool<X: key + store, Y>(
        exchange: &mut Exchange,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        _ctx: &mut TxContext,
    ): nft_service::GetAmountRequest<X, InitializeTradePoolGetX_AmountContext<Y>> {
        let exchange_id = object::id(exchange);
        let get_x_amount_context = InitializeTradePoolGetX_AmountContext {
            exchange_id,
            y_coin,
            y_amount,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
        };
        let get_x_amount_request = nft_service::new_get_amount_request<X, InitializeTradePoolGetX_AmountContext<Y>>(
            x,
            get_x_amount_context,
        );
        get_x_amount_request
    }

    #[allow(unused_assignment)]
    public fun initialize_trade_pool_get_x_amount_callback<X: key + store, Y, NS>(
        exchange: &mut Exchange,
        get_x_amount_response: nft_service::GetAmountResponse<X, NS, InitializeTradePoolGetX_AmountContext<Y>>,
        _ctx: &mut TxContext,
    ): (trade_pool::TradePool<X, Y>, LiquidityToken<X, Y>) {
        let (x_amount, get_x_amount_request) = nft_service::unpack_get_amount_respone(get_x_amount_response);
        let (x, get_x_amount_context) = nft_service::unpack_get_amount_request(get_x_amount_request);
        let InitializeTradePoolGetX_AmountContext {
            exchange_id,
            y_coin,
            y_amount,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
        } = get_x_amount_context;
        assert!(object::id(exchange) == exchange_id, EMismatchedObjectId);
        internal_initialize_trade_pool(
            exchange,
            x,
            x_amount,
            y_coin,
            y_amount,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            _ctx,
        )
    }

    fun internal_initialize_trade_pool<X: key + store, Y>(
        exchange: &mut Exchange,
        x: X,
        x_amount: u64,
        y_coin: Coin<Y>,
        y_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        ctx: &mut tx_context::TxContext,
    ): (trade_pool::TradePool<X, Y>, LiquidityToken<X, Y>) {
        let y_amount_b = coin_util::split_up_and_into_balance(y_coin, y_amount, ctx);
        trade_pool_aggregate::initialize_trade_pool<X, Y>(
            exchange,
            x,
            x_amount,
            y_amount_b,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            ctx,
        )
    }
}
//
// The boilerplate code that does "Dependency Injection".
//
/*
module xxx_di_package_id::trade_pool_service_process {
    use sui::tx_context::TxContext;
    use sui_swap_core::trade_pool_service_process;
    use sui_swap_core::nft_service_config::NftServiceConfig;
    use ns_impl_package_id::ns_nft_service_impl as ns;

    public fun initialize_trade_pool<X: key + store, Y>(
        _nft_service_config: &NftServiceConfig,
        exchange: &mut Exchange,
        x: X,
        y_coin: Coin<Y>,
        y_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        _ctx: &TxContext,
    ) {
        let get_x_amount_req = trade_pool_service_process::initialize_trade_pool(exchange, x, y_coin, y_amount, exchange_rate_numerator, exchange_rate_denominator, price_curve_type, price_delta_x_amount, price_delta_numerator, price_delta_denominator, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        trade_pool_service_process::initialize_trade_pool_get_x_amount_callback(exchange, get_x_amount_rsp, _ctx)
    }

}
*/
