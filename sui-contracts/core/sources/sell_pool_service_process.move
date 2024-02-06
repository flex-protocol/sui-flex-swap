module sui_swap_example::sell_pool_service_process {
    use sui::object;
    use sui::tx_context;
    use sui::tx_context::TxContext;

    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::nft_service;
    use sui_swap_example::sell_pool::{Self, SellPool};
    use sui_swap_example::sell_pool_aggregate;

    const EMismatchedObjectId: u64 = 10;

    struct InitializeSellPoolGetX_AmountContext {
        exchange_id: sui::object::ID,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
    }

    #[allow(unused_type_parameter)]
    public fun initialize_sell_pool<X: key + store, Y>(
        exchange: &mut Exchange,
        x: X,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        _ctx: &mut TxContext,
    ): nft_service::GetAmountRequest<X, InitializeSellPoolGetX_AmountContext> {
        let exchange_id = object::id(exchange);
        let get_x_amount_context = InitializeSellPoolGetX_AmountContext {
            exchange_id,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
        };
        let get_x_amount_request = nft_service::new_get_amount_request<X, InitializeSellPoolGetX_AmountContext>(
            x,
            get_x_amount_context,
        );
        get_x_amount_request
    }

    #[allow(unused_assignment)]
    public fun initialize_sell_pool_get_x_amount_callback<X: key + store, Y, NS>(
        exchange: &mut Exchange,
        get_x_amount_response: nft_service::GetAmountResponse<X, NS, InitializeSellPoolGetX_AmountContext>,
        _ctx: &mut TxContext,
    ):(sell_pool::SellPool<X, Y>, LiquidityToken<X, Y>) {
        let (x_amount, get_x_amount_request) = nft_service::unpack_get_amount_respone(get_x_amount_response);
        let (x, get_x_amount_context) = nft_service::unpack_get_amount_request(get_x_amount_request);
        let InitializeSellPoolGetX_AmountContext {
            exchange_id,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
        } = get_x_amount_context;
        assert!(object::id(exchange) == exchange_id, EMismatchedObjectId);
        internal_initialize_sell_pool<X, Y>(
            exchange,
            x,
            x_amount,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            _ctx,
        )
    }

    struct AddXTokenGetX_AmountContext {
        sell_pool_id: sui::object::ID,
        liquidity_token_id: sui::object::ID,
    }

    public fun add_x_token<X: key + store, Y>(
        sell_pool: &mut SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x: X,
        _ctx: &mut TxContext,
    ): nft_service::GetAmountRequest<X, AddXTokenGetX_AmountContext> {
        let sell_pool_id = object::id(sell_pool);
        let liquidity_token_id = object::id(liquidity_token);
        let get_x_amount_context = AddXTokenGetX_AmountContext {
            sell_pool_id,
            liquidity_token_id,
        };
        let get_x_amount_request = nft_service::new_get_amount_request<X, AddXTokenGetX_AmountContext>(
            x,
            get_x_amount_context,
        );
        get_x_amount_request
    }

    #[allow(unused_assignment)]
    public fun add_x_token_get_x_amount_callback<X: key + store, Y, NS>(
        sell_pool: &mut SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        get_x_amount_response: nft_service::GetAmountResponse<X, NS, AddXTokenGetX_AmountContext>,
        _ctx: &mut TxContext,
    ) {
        let (x_amount, get_x_amount_request) = nft_service::unpack_get_amount_respone(get_x_amount_response);
        let (x, get_x_amount_context) = nft_service::unpack_get_amount_request(get_x_amount_request);
        let AddXTokenGetX_AmountContext {
            sell_pool_id,
            liquidity_token_id,
        } = get_x_amount_context;
        assert!(object::id(sell_pool) == sell_pool_id, EMismatchedObjectId);
        assert!(object::id(liquidity_token) == liquidity_token_id, EMismatchedObjectId);
        internal_add_x_token(sell_pool, liquidity_token, x, x_amount, _ctx);
    }

    fun internal_initialize_sell_pool<X: key + store, Y>(
        exchange: &mut Exchange,
        x: X,
        x_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        ctx: &mut tx_context::TxContext,
    ): (sell_pool::SellPool<X, Y>, LiquidityToken<X, Y>) {
        sell_pool_aggregate::initialize_sell_pool<X, Y>(
            exchange,
            x,
            x_amount,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            ctx,
        )
    }

    fun internal_add_x_token<X: key + store, Y>(
        sell_pool: &mut SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x: X,
        x_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        sell_pool_aggregate::add_x_token(
            sell_pool,
            liquidity_token,
            x,
            x_amount,
            ctx,
        )
    }
}
//
// The boilerplate code that does "Dependency Injection".
//
/*
module xxx_di_package_id::sell_pool_service_process {
    use sui::tx_context::TxContext;
    use sui_swap_example::sell_pool_service_process;
    use sui_swap_example::nft_service_config::NftServiceConfig;
    use ns_impl_package_id::ns_nft_service_impl as ns;

    public fun initialize_sell_pool<X: key + store, Y>(
        _nft_service_config: &NftServiceConfig,
        exchange: &mut Exchange,
        x: X,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        _ctx: &TxContext,
    ) {
        let get_x_amount_req = sell_pool_service_process::initialize_sell_pool(exchange, x, exchange_rate_numerator, exchange_rate_denominator, price_curve_type, price_delta_x_amount, price_delta_numerator, price_delta_denominator, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        sell_pool_service_process::initialize_sell_pool_get_x_amount_callback(exchange, get_x_amount_rsp, _ctx)
    }

    public fun add_x_token<X: key + store, Y>(
        _nft_service_config: &NftServiceConfig,
        sell_pool: &mut SellPool<X, Y>,
        liquidity_token: &LiquidityToken<X, Y>,
        x: X,
        _ctx: &TxContext,
    ) {
        let get_x_amount_req = sell_pool_service_process::add_x_token(sell_pool, liquidity_token, x, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        sell_pool_service_process::add_x_token_get_x_amount_callback(sell_pool, liquidity_token, get_x_amount_rsp, _ctx)
    }

}
*/
