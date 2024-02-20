module sui_swap_di::movescription_buy_pool_service {
    use sui::coin::Coin;
    use sui::tx_context::TxContext;
    use sui_swap_core::buy_pool_service_process;
    use sui_swap_core::nft_service_config::NftServiceConfig;
    use nft_service_impl::movescription_service_impl as ns;
    use smartinscription::movescription::Movescription;
    use sui_swap_core::trade_pool::TradePool;

    public fun sell_x<Y>(
        _nft_service_config: &NftServiceConfig,
        buy_pool: &mut TradePool<Movescription, Y>,
        x: Movescription,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = buy_pool_service_process::sell_x(buy_pool, x, y_coin, expected_y_amount_out, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        buy_pool_service_process::sell_x_get_x_amount_callback(buy_pool, y_coin, get_x_amount_rsp, _ctx)
    }

}
