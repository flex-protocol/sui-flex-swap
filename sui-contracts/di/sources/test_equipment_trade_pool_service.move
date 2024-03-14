module sui_swap_di::test_equipment_trade_pool_service {
    use sui::coin::Coin;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use example_tokens::equipment::Equipment;
    use nft_service_impl::test_equipment_service_impl as ns;
    use sui_swap_core::exchange::Exchange;
    use sui_swap_core::nft_service_config::NftServiceConfig;
    use sui_swap_core::trade_pool;
    use sui_swap_core::trade_pool_service_process;

    #[lint_allow(self_transfer)]
    public fun initialize_trade_pool<Y>(
        _nft_service_config: &NftServiceConfig,
        exchange: &mut Exchange,
        x: Equipment,
        y_coin: Coin<Y>,
        y_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = trade_pool_service_process::initialize_trade_pool(exchange, x, y_coin, y_amount, exchange_rate_numerator, exchange_rate_denominator, price_curve_type, price_delta_x_amount, price_delta_numerator, price_delta_denominator, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        let (trade_pool, liquidity_token) = trade_pool_service_process::initialize_trade_pool_get_x_amount_callback(exchange, get_x_amount_rsp, _ctx);
        trade_pool::share_object(trade_pool);
        transfer::public_transfer(liquidity_token, tx_context::sender(_ctx));
    }

}