module sui_swap_di::test_equipment_sell_pool_service {
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use example_tokens::equipment::Equipment;
    use nft_service_impl::test_equipment_service_impl as ns;
    use nft_service_impl::test_equipment_service_impl::TestEquipmentServiceImpl;
    use sui_swap_core::exchange::Exchange;
    use sui_swap_core::liquidity_token::LiquidityToken;
    use sui_swap_core::nft_service_config::NftServiceConfig;
    use sui_swap_core::trade_pool::{Self, TradePool};
    use sui_swap_core::sell_pool_service_process;

    #[lint_allow(self_transfer)]
    public fun initialize_sell_pool<Y>(
        _nft_service_config: &NftServiceConfig,
        exchange: &mut Exchange,
        x: Equipment,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = sell_pool_service_process::initialize_sell_pool<Equipment, Y>(
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
        let (sell_pool, liquidity_token) = sell_pool_service_process::initialize_sell_pool_get_x_amount_callback<Equipment, Y, TestEquipmentServiceImpl>(
            exchange,
            get_x_amount_rsp,
            _ctx
        );
        trade_pool::share_object(sell_pool);
        transfer::public_transfer(liquidity_token, tx_context::sender(_ctx));
    }

    public fun add_x_token<Y>(
        _nft_service_config: &NftServiceConfig,
        sell_pool: &mut TradePool<Equipment, Y>,
        liquidity_token: &LiquidityToken<Equipment, Y>,
        x: Equipment,
        _ctx: &mut TxContext,
    ) {
        let get_x_amount_req = sell_pool_service_process::add_x_token(sell_pool, liquidity_token, x, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        sell_pool_service_process::add_x_token_get_x_amount_callback(sell_pool, liquidity_token, get_x_amount_rsp, _ctx)
    }
}