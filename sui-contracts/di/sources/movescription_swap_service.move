module sui_swap_di::movescription_swap_service {
    use sui::coin;
    use sui::coin::Coin;
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use nft_service_impl::movescription_service_impl as ns;
    use smartinscription::movescription::Movescription;
    use sui_swap_example::exchange::Exchange;
    use sui_swap_example::liquidity_token::LiquidityToken;
    use sui_swap_example::nft_service_config::NftServiceConfig;
    use sui_swap_example::token_pair;
    use sui_swap_example::token_pair::TokenPair;
    use sui_swap_example::token_pair_service_process;

    #[lint_allow(self_transfer)]
    public fun initialize_liquidity_then_add<Y>(
        _nft_service_config: &NftServiceConfig,
        exchange: &mut Exchange,
        x_1: Movescription,
        x_2: Movescription,
        y_coin: Coin<Y>,
        y_amount: u64,
        fee_numerator: u64,
        fee_denominator: u64,
        _ctx: &mut TxContext,
    ) {
        let y_amount_1 = y_amount / 2;
        let y_amount_2 = y_amount - y_amount_1;
        let y_coin_1 = coin::split(&mut y_coin, y_amount_1, _ctx);
        let y_coin_2 = y_coin;
        let get_x_amount_req = token_pair_service_process::initialize_liquidity(exchange, x_1, y_coin_1, y_amount_1, fee_numerator, fee_denominator, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        let (token_pair, liquidity_token) = token_pair_service_process::initialize_liquidity_get_x_amount_callback(exchange, get_x_amount_rsp, _ctx);

        let get_x_amount_req = token_pair_service_process::add_liquidity(
            &mut token_pair,
            &liquidity_token,
            x_2,
            y_coin_2,
            y_amount_2,
            _ctx
        );
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        token_pair_service_process::add_liquidity_get_x_amount_callback(
            &mut token_pair,
            &liquidity_token,
            get_x_amount_rsp,
            _ctx
        );

        token_pair::share_object(token_pair);
        transfer::public_transfer(liquidity_token, tx_context::sender(_ctx));
    }

    #[lint_allow(self_transfer)]
    public fun initialize_liquidity<Y>(
        _nft_service_config: &NftServiceConfig,
        exchange: &mut Exchange,
        x: Movescription,
        y_coin: Coin<Y>,
        y_amount: u64,
        fee_numerator: u64,
        fee_denominator: u64,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = token_pair_service_process::initialize_liquidity(exchange, x, y_coin, y_amount, fee_numerator, fee_denominator, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        let (token_pair, liquidity_token) = token_pair_service_process::initialize_liquidity_get_x_amount_callback(exchange, get_x_amount_rsp, _ctx);
        token_pair::share_object(token_pair);
        transfer::public_transfer(liquidity_token, tx_context::sender(_ctx));
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
