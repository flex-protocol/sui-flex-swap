module sui_swap_di::movescription_swap_service {
    use sui::coin::Coin;
    use sui::tx_context::TxContext;
    use nft_service_impl::movescription_service_impl as ns;
    use smartinscription::movescription::Movescription;
    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::nft_service_config::NftServiceConfig;
    use sui_swap_example::token_pair::TokenPair;
    use sui_swap_example::token_pair_service_process;

    public fun initialize_liquidity<Y>(
        _nft_service_config: &NftServiceConfig,
        exchange: &mut Exchange,
        x: Movescription,
        y_coin: Coin<Y>,
        y_amount: u64,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = token_pair_service_process::initialize_liquidity(exchange, x, y_coin, y_amount, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        token_pair_service_process::initialize_liquidity_get_x_amount_callback(exchange, get_x_amount_rsp, _ctx)
    }

    public fun add_liquidity<Y>(
        _nft_service_config: &NftServiceConfig,
        token_pair: &mut TokenPair<Movescription, Y>,
        liquidity_token: &mut LiquidityToken<Movescription, Y>,
        x: Movescription,
        y_coin: Coin<Y>,
        y_amount: u64,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = token_pair_service_process::add_liquidity(
            token_pair,
            liquidity_token,
            x,
            y_coin,
            y_amount,
            _ctx
        );
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        token_pair_service_process::add_liquidity_get_x_amount_callback(
            token_pair,
            liquidity_token,
            get_x_amount_rsp,
            _ctx
        )
    }

    public fun swap_x<Y>(
        _nft_service_config: &NftServiceConfig,
        token_pair: &mut TokenPair<Movescription, Y>,
        x: Movescription,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = token_pair_service_process::swap_x(token_pair, x, y_coin, expected_y_amount_out, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        token_pair_service_process::swap_x_get_x_amount_callback(token_pair, y_coin, get_x_amount_rsp, _ctx)
    }
}
