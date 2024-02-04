module sui_swap_di::movescription_sell_pool_service {
    use sui::tx_context::TxContext;
    use nft_service_impl::movescription_service_impl as ns;
    use nft_service_impl::movescription_service_impl::MovescriptionServiceImpl;
    use smartinscription::movescription::Movescription;
    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::nft_service_config::NftServiceConfig;
    use sui_swap_example::sell_pool::SellPool;
    use sui_swap_example::sell_pool_service_process;

    public fun initialize_sell_pool<Y>(
        _nft_service_config: &NftServiceConfig,
        exchange: &mut Exchange,
        x: Movescription,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = sell_pool_service_process::initialize_sell_pool<Movescription, Y>(
            exchange,
            x,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            _ctx
        );
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        sell_pool_service_process::initialize_sell_pool_get_x_amount_callback<Movescription, Y, MovescriptionServiceImpl>(
            exchange,
            get_x_amount_rsp,
            _ctx
        )
    }

    public fun add_x_token<Y>(
        _nft_service_config: &NftServiceConfig,
        sell_pool: &mut SellPool<Movescription, Y>,
        liquidity_token: &LiquidityToken<Movescription, Y>,
        x: Movescription,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = sell_pool_service_process::add_x_token(sell_pool, liquidity_token, x, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        sell_pool_service_process::add_x_token_get_x_amount_callback(sell_pool, liquidity_token, get_x_amount_rsp, _ctx)
    }
}