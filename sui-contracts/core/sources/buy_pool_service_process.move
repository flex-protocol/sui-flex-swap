module sui_swap_example::buy_pool_service_process {
    use sui::coin;
    use sui::coin::Coin;
    use sui::object;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use sui_swap_example::buy_pool::BuyPool;
    use sui_swap_example::buy_pool_aggregate;
    use sui_swap_example::nft_service;

    const EMismatchedObjectId: u64 = 10;

    struct SellXGetX_AmountContext {
        buy_pool_id: sui::object::ID,
        y_coin_id: sui::object::ID,
        expected_y_amount_out: u64,
    }

    public fun sell_x<X: key + store, Y>(
        buy_pool: &mut BuyPool<X, Y>,
        x: X,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        _ctx: &mut TxContext,
    ): nft_service::GetAmountRequest<X, SellXGetX_AmountContext> {
        let buy_pool_id = object::id(buy_pool);
        let y_coin_id = object::id(y_coin);
        let get_x_amount_context = SellXGetX_AmountContext {
            buy_pool_id,
            y_coin_id,
            expected_y_amount_out,
        };
        let get_x_amount_request = nft_service::new_get_amount_request<X, SellXGetX_AmountContext>(
            x,
            get_x_amount_context,
        );
        get_x_amount_request
    }

    #[allow(unused_assignment)]
    public fun sell_x_get_x_amount_callback<X: key + store, Y, NS>(
        buy_pool: &mut BuyPool<X, Y>,
        y_coin: &mut Coin<Y>,
        get_x_amount_response: nft_service::GetAmountResponse<X, NS, SellXGetX_AmountContext>,
        _ctx: &mut TxContext,
    ) {
        let (x_amount, get_x_amount_request) = nft_service::unpack_get_amount_respone(get_x_amount_response);
        let (x, get_x_amount_context) = nft_service::unpack_get_amount_request(get_x_amount_request);
        let SellXGetX_AmountContext {
            buy_pool_id,
            y_coin_id,
            expected_y_amount_out,
        } = get_x_amount_context;
        assert!(object::id(buy_pool) == buy_pool_id, EMismatchedObjectId);
        assert!(object::id(y_coin) == y_coin_id, EMismatchedObjectId);
        internal_sell_x(buy_pool, x, x_amount, y_coin, expected_y_amount_out, _ctx);
    }

    fun internal_sell_x<X: key + store, Y>(
        buy_pool: &mut BuyPool<X, Y>,
        x: X,
        x_amount: u64,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let y_amount_b = buy_pool_aggregate::sell_x(
            buy_pool,
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
module xxx_di_package_id::buy_pool_service_process {
    use sui::tx_context::TxContext;
    use sui_swap_example::buy_pool_service_process;
    use sui_swap_example::nft_service_config::NftServiceConfig;
    use ns_impl_package_id::ns_nft_service_impl as ns;

    public fun sell_x<X: key + store, Y>(
        _nft_service_config: &NftServiceConfig,
        buy_pool: &mut BuyPool<X, Y>,
        x: X,
        y_coin: &mut Coin<Y>,
        expected_y_amount_out: u64,
        _ctx: &TxContext,
    ) {
        let get_x_amount_req = buy_pool_service_process::sell_x(buy_pool, x, y_coin, expected_y_amount_out, _ctx);
        let get_x_amount_rsp = ns::get_amount(_nft_service_config, get_x_amount_req);
        buy_pool_service_process::sell_x_get_x_amount_callback(buy_pool, y_coin, get_x_amount_rsp, _ctx)
    }

}
*/
