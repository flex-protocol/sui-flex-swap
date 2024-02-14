// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::buy_pool {
    use std::option::{Self, Option};
    use std::string::String;
    use sui::balance::Balance;
    use sui::event;
    use sui::object::{Self, ID, UID};
    use sui::object_table::ObjectTable;
    use sui::table::Table;
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct BUY_POOL has drop {}

    friend sui_swap_example::buy_pool_initialize_buy_pool_logic;
    friend sui_swap_example::buy_pool_update_exchange_rate_logic;
    friend sui_swap_example::buy_pool_remove_x_token_logic;
    friend sui_swap_example::buy_pool_withdraw_y_reserve_logic;
    friend sui_swap_example::buy_pool_destroy_logic;
    friend sui_swap_example::buy_pool_aggregate;

    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    const EInappropriateVersion: u64 = 103;
    const EEmptyObjectID: u64 = 107;

    /// Not the right admin for the object
    const ENotAdmin: u64 = 0;
    /// Migration is not an upgrade
    const ENotUpgrade: u64 = 1;
    /// Calling functions from the wrong package version
    const EWrongSchemaVersion: u64 = 2;

    const SCHEMA_VERSION: u64 = 0;

    struct AdminCap has key {
        id: UID,
    }


    fun init(otw: BUY_POOL, ctx: &mut TxContext) {
        sui::package::claim_and_keep(otw, ctx)
    }

    public fun assert_schema_version<X: key + store, Y>(buy_pool: &BuyPool<X, Y>) {
        assert!(buy_pool.schema_version == SCHEMA_VERSION, EWrongSchemaVersion);
    }

    struct BuyPool<phantom X: key + store, phantom Y> has key {
        id: UID,
        version: u64,
        schema_version: u64,
        admin_cap: ID,
        x_reserve: ObjectTable<ID, X>,
        x_amounts: Table<ID, u64>,
        x_total_amount: u64,
        y_reserve: Balance<Y>,
        liquidity_token_id: ID,
        x_bought_amount: u64,
        start_exchange_rate_numerator: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
    }

    public fun id<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): object::ID {
        object::uid_to_inner(&buy_pool.id)
    }

    public fun version<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u64 {
        buy_pool.version
    }

    public fun borrow_x_reserve<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): &ObjectTable<ID, X> {
        &buy_pool.x_reserve
    }

    public(friend) fun borrow_mut_x_reserve<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>): &mut ObjectTable<ID, X> {
        &mut buy_pool.x_reserve
    }

    public fun borrow_x_amounts<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): &Table<ID, u64> {
        &buy_pool.x_amounts
    }

    public(friend) fun borrow_mut_x_amounts<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>): &mut Table<ID, u64> {
        &mut buy_pool.x_amounts
    }

    public fun x_total_amount<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u64 {
        buy_pool.x_total_amount
    }

    public(friend) fun set_x_total_amount<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, x_total_amount: u64) {
        buy_pool.x_total_amount = x_total_amount;
    }

    public fun borrow_y_reserve<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): &Balance<Y> {
        &buy_pool.y_reserve
    }

    public(friend) fun borrow_mut_y_reserve<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>): &mut Balance<Y> {
        &mut buy_pool.y_reserve
    }

    public fun liquidity_token_id<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): ID {
        buy_pool.liquidity_token_id
    }

    public(friend) fun set_liquidity_token_id<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, liquidity_token_id: ID) {
        buy_pool.liquidity_token_id = liquidity_token_id;
    }

    public fun x_bought_amount<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u64 {
        buy_pool.x_bought_amount
    }

    public(friend) fun set_x_bought_amount<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, x_bought_amount: u64) {
        buy_pool.x_bought_amount = x_bought_amount;
    }

    public fun start_exchange_rate_numerator<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u64 {
        buy_pool.start_exchange_rate_numerator
    }

    public(friend) fun set_start_exchange_rate_numerator<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, start_exchange_rate_numerator: u64) {
        buy_pool.start_exchange_rate_numerator = start_exchange_rate_numerator;
    }

    public fun exchange_rate_numerator<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u64 {
        buy_pool.exchange_rate_numerator
    }

    public(friend) fun set_exchange_rate_numerator<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, exchange_rate_numerator: u64) {
        buy_pool.exchange_rate_numerator = exchange_rate_numerator;
    }

    public fun exchange_rate_denominator<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u64 {
        buy_pool.exchange_rate_denominator
    }

    public(friend) fun set_exchange_rate_denominator<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, exchange_rate_denominator: u64) {
        buy_pool.exchange_rate_denominator = exchange_rate_denominator;
    }

    public fun price_curve_type<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u8 {
        buy_pool.price_curve_type
    }

    public(friend) fun set_price_curve_type<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, price_curve_type: u8) {
        buy_pool.price_curve_type = price_curve_type;
    }

    public fun price_delta_x_amount<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u64 {
        buy_pool.price_delta_x_amount
    }

    public(friend) fun set_price_delta_x_amount<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, price_delta_x_amount: u64) {
        buy_pool.price_delta_x_amount = price_delta_x_amount;
    }

    public fun price_delta_numerator<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u64 {
        buy_pool.price_delta_numerator
    }

    public(friend) fun set_price_delta_numerator<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, price_delta_numerator: u64) {
        buy_pool.price_delta_numerator = price_delta_numerator;
    }

    public fun price_delta_denominator<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): u64 {
        buy_pool.price_delta_denominator
    }

    public(friend) fun set_price_delta_denominator<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, price_delta_denominator: u64) {
        buy_pool.price_delta_denominator = price_delta_denominator;
    }

    public fun admin_cap<X: key + store, Y>(buy_pool: &BuyPool<X, Y>): ID {
        buy_pool.admin_cap
    }

    public(friend) fun new_buy_pool<X: key + store, Y>(
        x_reserve: ObjectTable<ID, X>,
        x_amounts: Table<ID, u64>,
        x_total_amount: u64,
        liquidity_token_id: ID,
        x_bought_amount: u64,
        start_exchange_rate_numerator: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        ctx: &mut TxContext,
    ): BuyPool<X, Y> {
        let admin_cap = AdminCap {
            id: object::new(ctx),
        };
        let admin_cap_id = object::id(&admin_cap);
        transfer::transfer(admin_cap, sui::tx_context::sender(ctx));
        BuyPool {
            id: object::new(ctx),
            version: 0,
            schema_version: SCHEMA_VERSION,
            admin_cap: admin_cap_id,
            x_reserve,
            x_amounts,
            x_total_amount,
            y_reserve: sui::balance::zero(),
            liquidity_token_id,
            x_bought_amount,
            start_exchange_rate_numerator,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
        }
    }

    entry fun migrate<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>, a: &AdminCap) {
        assert!(buy_pool.admin_cap == object::id(a), ENotAdmin);
        assert!(buy_pool.schema_version < SCHEMA_VERSION, ENotUpgrade);
        buy_pool.schema_version = SCHEMA_VERSION;
    }

    struct BuyPoolInitialized has copy, drop {
        id: option::Option<object::ID>,
        exchange_id: ID,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        y_amount: u64,
        liquidity_token_id: Option<ID>,
    }

    public fun buy_pool_initialized_id(buy_pool_initialized: &BuyPoolInitialized): option::Option<object::ID> {
        buy_pool_initialized.id
    }

    public(friend) fun set_buy_pool_initialized_id(buy_pool_initialized: &mut BuyPoolInitialized, id: object::ID) {
        buy_pool_initialized.id = option::some(id);
    }

    public fun buy_pool_initialized_exchange_id(buy_pool_initialized: &BuyPoolInitialized): ID {
        buy_pool_initialized.exchange_id
    }

    public fun buy_pool_initialized_exchange_rate_numerator(buy_pool_initialized: &BuyPoolInitialized): u64 {
        buy_pool_initialized.exchange_rate_numerator
    }

    public fun buy_pool_initialized_exchange_rate_denominator(buy_pool_initialized: &BuyPoolInitialized): u64 {
        buy_pool_initialized.exchange_rate_denominator
    }

    public fun buy_pool_initialized_price_curve_type(buy_pool_initialized: &BuyPoolInitialized): u8 {
        buy_pool_initialized.price_curve_type
    }

    public fun buy_pool_initialized_price_delta_x_amount(buy_pool_initialized: &BuyPoolInitialized): u64 {
        buy_pool_initialized.price_delta_x_amount
    }

    public fun buy_pool_initialized_price_delta_numerator(buy_pool_initialized: &BuyPoolInitialized): u64 {
        buy_pool_initialized.price_delta_numerator
    }

    public fun buy_pool_initialized_price_delta_denominator(buy_pool_initialized: &BuyPoolInitialized): u64 {
        buy_pool_initialized.price_delta_denominator
    }

    public fun buy_pool_initialized_provider(buy_pool_initialized: &BuyPoolInitialized): address {
        buy_pool_initialized.provider
    }

    public fun buy_pool_initialized_x_token_type(buy_pool_initialized: &BuyPoolInitialized): String {
        buy_pool_initialized.x_token_type
    }

    public fun buy_pool_initialized_y_token_type(buy_pool_initialized: &BuyPoolInitialized): String {
        buy_pool_initialized.y_token_type
    }

    public fun buy_pool_initialized_y_amount(buy_pool_initialized: &BuyPoolInitialized): u64 {
        buy_pool_initialized.y_amount
    }

    public fun buy_pool_initialized_liquidity_token_id(buy_pool_initialized: &BuyPoolInitialized): Option<ID> {
        buy_pool_initialized.liquidity_token_id
    }

    public(friend) fun set_buy_pool_initialized_liquidity_token_id(buy_pool_initialized: &mut BuyPoolInitialized, liquidity_token_id: ID) {
        buy_pool_initialized.liquidity_token_id = option::some(liquidity_token_id);
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_buy_pool_initialized<X: key + store, Y>(
        exchange_id: ID,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        y_amount: u64,
        liquidity_token_id: Option<ID>,
    ): BuyPoolInitialized {
        BuyPoolInitialized {
            id: option::none(),
            exchange_id,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            provider,
            x_token_type,
            y_token_type,
            y_amount,
            liquidity_token_id,
        }
    }

    struct BuyPoolExchangeRateUpdated has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        start_exchange_rate_numerator: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
    }

    public fun buy_pool_exchange_rate_updated_id(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): object::ID {
        buy_pool_exchange_rate_updated.id
    }

    public fun buy_pool_exchange_rate_updated_liquidity_token_id(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): ID {
        buy_pool_exchange_rate_updated.liquidity_token_id
    }

    public fun buy_pool_exchange_rate_updated_start_exchange_rate_numerator(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): u64 {
        buy_pool_exchange_rate_updated.start_exchange_rate_numerator
    }

    public fun buy_pool_exchange_rate_updated_exchange_rate_numerator(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): u64 {
        buy_pool_exchange_rate_updated.exchange_rate_numerator
    }

    public fun buy_pool_exchange_rate_updated_exchange_rate_denominator(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): u64 {
        buy_pool_exchange_rate_updated.exchange_rate_denominator
    }

    public fun buy_pool_exchange_rate_updated_price_delta_x_amount(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): u64 {
        buy_pool_exchange_rate_updated.price_delta_x_amount
    }

    public fun buy_pool_exchange_rate_updated_price_delta_numerator(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): u64 {
        buy_pool_exchange_rate_updated.price_delta_numerator
    }

    public fun buy_pool_exchange_rate_updated_price_delta_denominator(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): u64 {
        buy_pool_exchange_rate_updated.price_delta_denominator
    }

    public fun buy_pool_exchange_rate_updated_provider(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): address {
        buy_pool_exchange_rate_updated.provider
    }

    public fun buy_pool_exchange_rate_updated_x_token_type(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): String {
        buy_pool_exchange_rate_updated.x_token_type
    }

    public fun buy_pool_exchange_rate_updated_y_token_type(buy_pool_exchange_rate_updated: &BuyPoolExchangeRateUpdated): String {
        buy_pool_exchange_rate_updated.y_token_type
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_buy_pool_exchange_rate_updated<X: key + store, Y>(
        buy_pool: &BuyPool<X, Y>,
        liquidity_token_id: ID,
        start_exchange_rate_numerator: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
    ): BuyPoolExchangeRateUpdated {
        BuyPoolExchangeRateUpdated {
            id: id(buy_pool),
            version: version(buy_pool),
            liquidity_token_id,
            start_exchange_rate_numerator,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            provider,
            x_token_type,
            y_token_type,
        }
    }

    struct BuyPoolXTokenRemoved has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        x_id: ID,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
    }

    public fun buy_pool_x_token_removed_id(buy_pool_x_token_removed: &BuyPoolXTokenRemoved): object::ID {
        buy_pool_x_token_removed.id
    }

    public fun buy_pool_x_token_removed_liquidity_token_id(buy_pool_x_token_removed: &BuyPoolXTokenRemoved): ID {
        buy_pool_x_token_removed.liquidity_token_id
    }

    public fun buy_pool_x_token_removed_x_id(buy_pool_x_token_removed: &BuyPoolXTokenRemoved): ID {
        buy_pool_x_token_removed.x_id
    }

    public fun buy_pool_x_token_removed_provider(buy_pool_x_token_removed: &BuyPoolXTokenRemoved): address {
        buy_pool_x_token_removed.provider
    }

    public fun buy_pool_x_token_removed_x_token_type(buy_pool_x_token_removed: &BuyPoolXTokenRemoved): String {
        buy_pool_x_token_removed.x_token_type
    }

    public fun buy_pool_x_token_removed_y_token_type(buy_pool_x_token_removed: &BuyPoolXTokenRemoved): String {
        buy_pool_x_token_removed.y_token_type
    }

    public fun buy_pool_x_token_removed_x_amount(buy_pool_x_token_removed: &BuyPoolXTokenRemoved): u64 {
        buy_pool_x_token_removed.x_amount
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_buy_pool_x_token_removed<X: key + store, Y>(
        buy_pool: &BuyPool<X, Y>,
        liquidity_token_id: ID,
        x_id: ID,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
    ): BuyPoolXTokenRemoved {
        BuyPoolXTokenRemoved {
            id: id(buy_pool),
            version: version(buy_pool),
            liquidity_token_id,
            x_id,
            provider,
            x_token_type,
            y_token_type,
            x_amount,
        }
    }

    struct BuyPoolYReserveWithdrawn has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        y_amount: u64,
        x_token_type: String,
        y_token_type: String,
    }

    public fun buy_pool_y_reserve_withdrawn_id(buy_pool_y_reserve_withdrawn: &BuyPoolYReserveWithdrawn): object::ID {
        buy_pool_y_reserve_withdrawn.id
    }

    public fun buy_pool_y_reserve_withdrawn_liquidity_token_id(buy_pool_y_reserve_withdrawn: &BuyPoolYReserveWithdrawn): ID {
        buy_pool_y_reserve_withdrawn.liquidity_token_id
    }

    public fun buy_pool_y_reserve_withdrawn_y_amount(buy_pool_y_reserve_withdrawn: &BuyPoolYReserveWithdrawn): u64 {
        buy_pool_y_reserve_withdrawn.y_amount
    }

    public fun buy_pool_y_reserve_withdrawn_x_token_type(buy_pool_y_reserve_withdrawn: &BuyPoolYReserveWithdrawn): String {
        buy_pool_y_reserve_withdrawn.x_token_type
    }

    public fun buy_pool_y_reserve_withdrawn_y_token_type(buy_pool_y_reserve_withdrawn: &BuyPoolYReserveWithdrawn): String {
        buy_pool_y_reserve_withdrawn.y_token_type
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_buy_pool_y_reserve_withdrawn<X: key + store, Y>(
        buy_pool: &BuyPool<X, Y>,
        liquidity_token_id: ID,
        y_amount: u64,
        x_token_type: String,
        y_token_type: String,
    ): BuyPoolYReserveWithdrawn {
        BuyPoolYReserveWithdrawn {
            id: id(buy_pool),
            version: version(buy_pool),
            liquidity_token_id,
            y_amount,
            x_token_type,
            y_token_type,
        }
    }

    struct BuyPoolDestroyed has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
    }

    public fun buy_pool_destroyed_id(buy_pool_destroyed: &BuyPoolDestroyed): object::ID {
        buy_pool_destroyed.id
    }

    public fun buy_pool_destroyed_liquidity_token_id(buy_pool_destroyed: &BuyPoolDestroyed): ID {
        buy_pool_destroyed.liquidity_token_id
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_buy_pool_destroyed<X: key + store, Y>(
        buy_pool: &BuyPool<X, Y>,
        liquidity_token_id: ID,
    ): BuyPoolDestroyed {
        BuyPoolDestroyed {
            id: id(buy_pool),
            version: version(buy_pool),
            liquidity_token_id,
        }
    }


    public(friend) fun transfer_object<X: key + store, Y>(buy_pool: BuyPool<X, Y>, recipient: address) {
        assert!(buy_pool.version == 0, EInappropriateVersion);
        transfer::transfer(buy_pool, recipient);
    }

    public(friend) fun update_version_and_transfer_object<X: key + store, Y>(buy_pool: BuyPool<X, Y>, recipient: address) {
        update_object_version(&mut buy_pool);
        transfer::transfer(buy_pool, recipient);
    }

    #[lint_allow(share_owned)]
    public fun share_object<X: key + store, Y>(buy_pool: BuyPool<X, Y>) {
        assert!(buy_pool.version == 0, EInappropriateVersion);
        transfer::share_object(buy_pool);
    }

    #[lint_allow(freeze_wrapped)]
    public(friend) fun freeze_object<X: key + store, Y>(buy_pool: BuyPool<X, Y>) {
        assert!(buy_pool.version == 0, EInappropriateVersion);
        transfer::freeze_object(buy_pool);
    }

    #[lint_allow(freeze_wrapped)]
    public(friend) fun update_version_and_freeze_object<X: key + store, Y>(buy_pool: BuyPool<X, Y>) {
        update_object_version(&mut buy_pool);
        transfer::freeze_object(buy_pool);
    }

    public(friend) fun update_object_version<X: key + store, Y>(buy_pool: &mut BuyPool<X, Y>) {
        buy_pool.version = buy_pool.version + 1;
        //assert!(buy_pool.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_buy_pool<X: key + store, Y>(buy_pool: BuyPool<X, Y>) {
        let BuyPool {
            id,
            version: _version,
            schema_version: _,
            admin_cap: _,
            x_reserve,
            x_amounts,
            x_total_amount: _x_total_amount,
            y_reserve,
            liquidity_token_id: _liquidity_token_id,
            x_bought_amount: _x_bought_amount,
            start_exchange_rate_numerator: _start_exchange_rate_numerator,
            exchange_rate_numerator: _exchange_rate_numerator,
            exchange_rate_denominator: _exchange_rate_denominator,
            price_curve_type: _price_curve_type,
            price_delta_x_amount: _price_delta_x_amount,
            price_delta_numerator: _price_delta_numerator,
            price_delta_denominator: _price_delta_denominator,
        } = buy_pool;
        object::delete(id);
        sui::object_table::destroy_empty(x_reserve);
        sui::table::destroy_empty(x_amounts);
        sui::balance::destroy_zero(y_reserve);
    }

    public(friend) fun emit_buy_pool_initialized(buy_pool_initialized: BuyPoolInitialized) {
        assert!(std::option::is_some(&buy_pool_initialized.id), EEmptyObjectID);
        event::emit(buy_pool_initialized);
    }

    public(friend) fun emit_buy_pool_exchange_rate_updated(buy_pool_exchange_rate_updated: BuyPoolExchangeRateUpdated) {
        event::emit(buy_pool_exchange_rate_updated);
    }

    public(friend) fun emit_buy_pool_x_token_removed(buy_pool_x_token_removed: BuyPoolXTokenRemoved) {
        event::emit(buy_pool_x_token_removed);
    }

    public(friend) fun emit_buy_pool_y_reserve_withdrawn(buy_pool_y_reserve_withdrawn: BuyPoolYReserveWithdrawn) {
        event::emit(buy_pool_y_reserve_withdrawn);
    }

    public(friend) fun emit_buy_pool_destroyed(buy_pool_destroyed: BuyPoolDestroyed) {
        event::emit(buy_pool_destroyed);
    }

}
