// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::sell_pool {
    use std::option::{Self, Option};
    use std::string::String;
    use sui::balance::Balance;
    use sui::event;
    use sui::object::{Self, ID, UID};
    use sui::object_table::ObjectTable;
    use sui::table::Table;
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct SELL_POOL has drop {}

    friend sui_swap_example::sell_pool_initialize_sell_pool_logic;
    friend sui_swap_example::sell_pool_update_exchange_rate_logic;
    friend sui_swap_example::sell_pool_add_x_token_logic;
    friend sui_swap_example::sell_pool_remove_x_token_logic;
    friend sui_swap_example::sell_pool_withdraw_y_reserve_logic;
    friend sui_swap_example::sell_pool_destroy_logic;
    friend sui_swap_example::sell_pool_buy_x_logic;
    friend sui_swap_example::sell_pool_aggregate;

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


    fun init(otw: SELL_POOL, ctx: &mut TxContext) {
        sui::package::claim_and_keep(otw, ctx)
    }

    public fun assert_schema_version<X: key + store, Y>(sell_pool: &SellPool<X, Y>) {
        assert!(sell_pool.schema_version == SCHEMA_VERSION, EWrongSchemaVersion);
    }

    struct SellPool<phantom X: key + store, phantom Y> has key {
        id: UID,
        version: u64,
        schema_version: u64,
        admin_cap: ID,
        x_reserve: ObjectTable<ID, X>,
        x_amounts: Table<ID, u64>,
        x_total_amount: u64,
        y_reserve: Balance<Y>,
        liquidity_token_id: ID,
        x_sold_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
    }

    public fun id<X: key + store, Y>(sell_pool: &SellPool<X, Y>): object::ID {
        object::uid_to_inner(&sell_pool.id)
    }

    public fun version<X: key + store, Y>(sell_pool: &SellPool<X, Y>): u64 {
        sell_pool.version
    }

    public fun borrow_x_reserve<X: key + store, Y>(sell_pool: &SellPool<X, Y>): &ObjectTable<ID, X> {
        &sell_pool.x_reserve
    }

    public(friend) fun borrow_mut_x_reserve<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>): &mut ObjectTable<ID, X> {
        &mut sell_pool.x_reserve
    }

    public fun borrow_x_amounts<X: key + store, Y>(sell_pool: &SellPool<X, Y>): &Table<ID, u64> {
        &sell_pool.x_amounts
    }

    public(friend) fun borrow_mut_x_amounts<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>): &mut Table<ID, u64> {
        &mut sell_pool.x_amounts
    }

    public fun x_total_amount<X: key + store, Y>(sell_pool: &SellPool<X, Y>): u64 {
        sell_pool.x_total_amount
    }

    public(friend) fun set_x_total_amount<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, x_total_amount: u64) {
        sell_pool.x_total_amount = x_total_amount;
    }

    public fun borrow_y_reserve<X: key + store, Y>(sell_pool: &SellPool<X, Y>): &Balance<Y> {
        &sell_pool.y_reserve
    }

    public(friend) fun borrow_mut_y_reserve<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>): &mut Balance<Y> {
        &mut sell_pool.y_reserve
    }

    public fun liquidity_token_id<X: key + store, Y>(sell_pool: &SellPool<X, Y>): ID {
        sell_pool.liquidity_token_id
    }

    public(friend) fun set_liquidity_token_id<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, liquidity_token_id: ID) {
        sell_pool.liquidity_token_id = liquidity_token_id;
    }

    public fun x_sold_amount<X: key + store, Y>(sell_pool: &SellPool<X, Y>): u64 {
        sell_pool.x_sold_amount
    }

    public(friend) fun set_x_sold_amount<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, x_sold_amount: u64) {
        sell_pool.x_sold_amount = x_sold_amount;
    }

    public fun exchange_rate_numerator<X: key + store, Y>(sell_pool: &SellPool<X, Y>): u64 {
        sell_pool.exchange_rate_numerator
    }

    public(friend) fun set_exchange_rate_numerator<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, exchange_rate_numerator: u64) {
        sell_pool.exchange_rate_numerator = exchange_rate_numerator;
    }

    public fun exchange_rate_denominator<X: key + store, Y>(sell_pool: &SellPool<X, Y>): u64 {
        sell_pool.exchange_rate_denominator
    }

    public(friend) fun set_exchange_rate_denominator<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, exchange_rate_denominator: u64) {
        sell_pool.exchange_rate_denominator = exchange_rate_denominator;
    }

    public fun price_curve_type<X: key + store, Y>(sell_pool: &SellPool<X, Y>): u8 {
        sell_pool.price_curve_type
    }

    public(friend) fun set_price_curve_type<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, price_curve_type: u8) {
        sell_pool.price_curve_type = price_curve_type;
    }

    public fun price_delta_x_amount<X: key + store, Y>(sell_pool: &SellPool<X, Y>): u64 {
        sell_pool.price_delta_x_amount
    }

    public(friend) fun set_price_delta_x_amount<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, price_delta_x_amount: u64) {
        sell_pool.price_delta_x_amount = price_delta_x_amount;
    }

    public fun price_delta_numerator<X: key + store, Y>(sell_pool: &SellPool<X, Y>): u64 {
        sell_pool.price_delta_numerator
    }

    public(friend) fun set_price_delta_numerator<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, price_delta_numerator: u64) {
        sell_pool.price_delta_numerator = price_delta_numerator;
    }

    public fun price_delta_denominator<X: key + store, Y>(sell_pool: &SellPool<X, Y>): u64 {
        sell_pool.price_delta_denominator
    }

    public(friend) fun set_price_delta_denominator<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, price_delta_denominator: u64) {
        sell_pool.price_delta_denominator = price_delta_denominator;
    }

    public fun admin_cap<X: key + store, Y>(sell_pool: &SellPool<X, Y>): ID {
        sell_pool.admin_cap
    }

    public(friend) fun new_sell_pool<X: key + store, Y>(
        x_reserve: ObjectTable<ID, X>,
        x_amounts: Table<ID, u64>,
        x_total_amount: u64,
        liquidity_token_id: ID,
        x_sold_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        ctx: &mut TxContext,
    ): SellPool<X, Y> {
        let admin_cap = AdminCap {
            id: object::new(ctx),
        };
        let admin_cap_id = object::id(&admin_cap);
        transfer::transfer(admin_cap, sui::tx_context::sender(ctx));
        SellPool {
            id: object::new(ctx),
            version: 0,
            schema_version: SCHEMA_VERSION,
            admin_cap: admin_cap_id,
            x_reserve,
            x_amounts,
            x_total_amount,
            y_reserve: sui::balance::zero(),
            liquidity_token_id,
            x_sold_amount,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
        }
    }

    entry fun migrate<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>, a: &AdminCap) {
        assert!(sell_pool.admin_cap == object::id(a), ENotAdmin);
        assert!(sell_pool.schema_version < SCHEMA_VERSION, ENotUpgrade);
        sell_pool.schema_version = SCHEMA_VERSION;
    }

    struct SellPoolInitialized has copy, drop {
        id: option::Option<object::ID>,
        exchange_id: ID,
        x_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        liquidity_token_id: Option<ID>,
        x_id: ID,
    }

    public fun sell_pool_initialized_id(sell_pool_initialized: &SellPoolInitialized): option::Option<object::ID> {
        sell_pool_initialized.id
    }

    public(friend) fun set_sell_pool_initialized_id(sell_pool_initialized: &mut SellPoolInitialized, id: object::ID) {
        sell_pool_initialized.id = option::some(id);
    }

    public fun sell_pool_initialized_exchange_id(sell_pool_initialized: &SellPoolInitialized): ID {
        sell_pool_initialized.exchange_id
    }

    public fun sell_pool_initialized_x_amount(sell_pool_initialized: &SellPoolInitialized): u64 {
        sell_pool_initialized.x_amount
    }

    public fun sell_pool_initialized_exchange_rate_numerator(sell_pool_initialized: &SellPoolInitialized): u64 {
        sell_pool_initialized.exchange_rate_numerator
    }

    public fun sell_pool_initialized_exchange_rate_denominator(sell_pool_initialized: &SellPoolInitialized): u64 {
        sell_pool_initialized.exchange_rate_denominator
    }

    public fun sell_pool_initialized_price_curve_type(sell_pool_initialized: &SellPoolInitialized): u8 {
        sell_pool_initialized.price_curve_type
    }

    public fun sell_pool_initialized_price_delta_x_amount(sell_pool_initialized: &SellPoolInitialized): u64 {
        sell_pool_initialized.price_delta_x_amount
    }

    public fun sell_pool_initialized_price_delta_numerator(sell_pool_initialized: &SellPoolInitialized): u64 {
        sell_pool_initialized.price_delta_numerator
    }

    public fun sell_pool_initialized_price_delta_denominator(sell_pool_initialized: &SellPoolInitialized): u64 {
        sell_pool_initialized.price_delta_denominator
    }

    public fun sell_pool_initialized_provider(sell_pool_initialized: &SellPoolInitialized): address {
        sell_pool_initialized.provider
    }

    public fun sell_pool_initialized_x_token_type(sell_pool_initialized: &SellPoolInitialized): String {
        sell_pool_initialized.x_token_type
    }

    public fun sell_pool_initialized_y_token_type(sell_pool_initialized: &SellPoolInitialized): String {
        sell_pool_initialized.y_token_type
    }

    public fun sell_pool_initialized_liquidity_token_id(sell_pool_initialized: &SellPoolInitialized): Option<ID> {
        sell_pool_initialized.liquidity_token_id
    }

    public(friend) fun set_sell_pool_initialized_liquidity_token_id(sell_pool_initialized: &mut SellPoolInitialized, liquidity_token_id: ID) {
        sell_pool_initialized.liquidity_token_id = option::some(liquidity_token_id);
    }

    public fun sell_pool_initialized_x_id(sell_pool_initialized: &SellPoolInitialized): ID {
        sell_pool_initialized.x_id
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_sell_pool_initialized<X: key + store, Y>(
        exchange_id: ID,
        x_amount: u64,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_curve_type: u8,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        liquidity_token_id: Option<ID>,
        x_id: ID,
    ): SellPoolInitialized {
        SellPoolInitialized {
            id: option::none(),
            exchange_id,
            x_amount,
            exchange_rate_numerator,
            exchange_rate_denominator,
            price_curve_type,
            price_delta_x_amount,
            price_delta_numerator,
            price_delta_denominator,
            provider,
            x_token_type,
            y_token_type,
            liquidity_token_id,
            x_id,
        }
    }

    struct SellPoolExchangeRateUpdated has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
    }

    public fun sell_pool_exchange_rate_updated_id(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): object::ID {
        sell_pool_exchange_rate_updated.id
    }

    public fun sell_pool_exchange_rate_updated_liquidity_token_id(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): ID {
        sell_pool_exchange_rate_updated.liquidity_token_id
    }

    public fun sell_pool_exchange_rate_updated_exchange_rate_numerator(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): u64 {
        sell_pool_exchange_rate_updated.exchange_rate_numerator
    }

    public fun sell_pool_exchange_rate_updated_exchange_rate_denominator(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): u64 {
        sell_pool_exchange_rate_updated.exchange_rate_denominator
    }

    public fun sell_pool_exchange_rate_updated_price_delta_x_amount(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): u64 {
        sell_pool_exchange_rate_updated.price_delta_x_amount
    }

    public fun sell_pool_exchange_rate_updated_price_delta_numerator(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): u64 {
        sell_pool_exchange_rate_updated.price_delta_numerator
    }

    public fun sell_pool_exchange_rate_updated_price_delta_denominator(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): u64 {
        sell_pool_exchange_rate_updated.price_delta_denominator
    }

    public fun sell_pool_exchange_rate_updated_provider(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): address {
        sell_pool_exchange_rate_updated.provider
    }

    public fun sell_pool_exchange_rate_updated_x_token_type(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): String {
        sell_pool_exchange_rate_updated.x_token_type
    }

    public fun sell_pool_exchange_rate_updated_y_token_type(sell_pool_exchange_rate_updated: &SellPoolExchangeRateUpdated): String {
        sell_pool_exchange_rate_updated.y_token_type
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_sell_pool_exchange_rate_updated<X: key + store, Y>(
        sell_pool: &SellPool<X, Y>,
        liquidity_token_id: ID,
        exchange_rate_numerator: u64,
        exchange_rate_denominator: u64,
        price_delta_x_amount: u64,
        price_delta_numerator: u64,
        price_delta_denominator: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
    ): SellPoolExchangeRateUpdated {
        SellPoolExchangeRateUpdated {
            id: id(sell_pool),
            version: version(sell_pool),
            liquidity_token_id,
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

    struct SellPoolXTokenAdded has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        x_amount: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_id: ID,
    }

    public fun sell_pool_x_token_added_id(sell_pool_x_token_added: &SellPoolXTokenAdded): object::ID {
        sell_pool_x_token_added.id
    }

    public fun sell_pool_x_token_added_liquidity_token_id(sell_pool_x_token_added: &SellPoolXTokenAdded): ID {
        sell_pool_x_token_added.liquidity_token_id
    }

    public fun sell_pool_x_token_added_x_amount(sell_pool_x_token_added: &SellPoolXTokenAdded): u64 {
        sell_pool_x_token_added.x_amount
    }

    public fun sell_pool_x_token_added_provider(sell_pool_x_token_added: &SellPoolXTokenAdded): address {
        sell_pool_x_token_added.provider
    }

    public fun sell_pool_x_token_added_x_token_type(sell_pool_x_token_added: &SellPoolXTokenAdded): String {
        sell_pool_x_token_added.x_token_type
    }

    public fun sell_pool_x_token_added_y_token_type(sell_pool_x_token_added: &SellPoolXTokenAdded): String {
        sell_pool_x_token_added.y_token_type
    }

    public fun sell_pool_x_token_added_x_id(sell_pool_x_token_added: &SellPoolXTokenAdded): ID {
        sell_pool_x_token_added.x_id
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_sell_pool_x_token_added<X: key + store, Y>(
        sell_pool: &SellPool<X, Y>,
        liquidity_token_id: ID,
        x_amount: u64,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_id: ID,
    ): SellPoolXTokenAdded {
        SellPoolXTokenAdded {
            id: id(sell_pool),
            version: version(sell_pool),
            liquidity_token_id,
            x_amount,
            provider,
            x_token_type,
            y_token_type,
            x_id,
        }
    }

    struct SellPoolXTokenRemoved has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        x_id: ID,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
    }

    public fun sell_pool_x_token_removed_id(sell_pool_x_token_removed: &SellPoolXTokenRemoved): object::ID {
        sell_pool_x_token_removed.id
    }

    public fun sell_pool_x_token_removed_liquidity_token_id(sell_pool_x_token_removed: &SellPoolXTokenRemoved): ID {
        sell_pool_x_token_removed.liquidity_token_id
    }

    public fun sell_pool_x_token_removed_x_id(sell_pool_x_token_removed: &SellPoolXTokenRemoved): ID {
        sell_pool_x_token_removed.x_id
    }

    public fun sell_pool_x_token_removed_provider(sell_pool_x_token_removed: &SellPoolXTokenRemoved): address {
        sell_pool_x_token_removed.provider
    }

    public fun sell_pool_x_token_removed_x_token_type(sell_pool_x_token_removed: &SellPoolXTokenRemoved): String {
        sell_pool_x_token_removed.x_token_type
    }

    public fun sell_pool_x_token_removed_y_token_type(sell_pool_x_token_removed: &SellPoolXTokenRemoved): String {
        sell_pool_x_token_removed.y_token_type
    }

    public fun sell_pool_x_token_removed_x_amount(sell_pool_x_token_removed: &SellPoolXTokenRemoved): u64 {
        sell_pool_x_token_removed.x_amount
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_sell_pool_x_token_removed<X: key + store, Y>(
        sell_pool: &SellPool<X, Y>,
        liquidity_token_id: ID,
        x_id: ID,
        provider: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
    ): SellPoolXTokenRemoved {
        SellPoolXTokenRemoved {
            id: id(sell_pool),
            version: version(sell_pool),
            liquidity_token_id,
            x_id,
            provider,
            x_token_type,
            y_token_type,
            x_amount,
        }
    }

    struct YReserveWithdrawn has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
        y_amount: u64,
        x_token_type: String,
        y_token_type: String,
    }

    public fun y_reserve_withdrawn_id(y_reserve_withdrawn: &YReserveWithdrawn): object::ID {
        y_reserve_withdrawn.id
    }

    public fun y_reserve_withdrawn_liquidity_token_id(y_reserve_withdrawn: &YReserveWithdrawn): ID {
        y_reserve_withdrawn.liquidity_token_id
    }

    public fun y_reserve_withdrawn_y_amount(y_reserve_withdrawn: &YReserveWithdrawn): u64 {
        y_reserve_withdrawn.y_amount
    }

    public fun y_reserve_withdrawn_x_token_type(y_reserve_withdrawn: &YReserveWithdrawn): String {
        y_reserve_withdrawn.x_token_type
    }

    public fun y_reserve_withdrawn_y_token_type(y_reserve_withdrawn: &YReserveWithdrawn): String {
        y_reserve_withdrawn.y_token_type
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_y_reserve_withdrawn<X: key + store, Y>(
        sell_pool: &SellPool<X, Y>,
        liquidity_token_id: ID,
        y_amount: u64,
        x_token_type: String,
        y_token_type: String,
    ): YReserveWithdrawn {
        YReserveWithdrawn {
            id: id(sell_pool),
            version: version(sell_pool),
            liquidity_token_id,
            y_amount,
            x_token_type,
            y_token_type,
        }
    }

    struct SellPoolDestroyed has copy, drop {
        id: object::ID,
        version: u64,
        liquidity_token_id: ID,
    }

    public fun sell_pool_destroyed_id(sell_pool_destroyed: &SellPoolDestroyed): object::ID {
        sell_pool_destroyed.id
    }

    public fun sell_pool_destroyed_liquidity_token_id(sell_pool_destroyed: &SellPoolDestroyed): ID {
        sell_pool_destroyed.liquidity_token_id
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_sell_pool_destroyed<X: key + store, Y>(
        sell_pool: &SellPool<X, Y>,
        liquidity_token_id: ID,
    ): SellPoolDestroyed {
        SellPoolDestroyed {
            id: id(sell_pool),
            version: version(sell_pool),
            liquidity_token_id,
        }
    }

    struct SellPoolYSwappedForX has copy, drop {
        id: object::ID,
        version: u64,
        x_id: ID,
        sender: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        new_exchange_rate_numerator: u64,
    }

    public fun sell_pool_y_swapped_for_x_id(sell_pool_y_swapped_for_x: &SellPoolYSwappedForX): object::ID {
        sell_pool_y_swapped_for_x.id
    }

    public fun sell_pool_y_swapped_for_x_x_id(sell_pool_y_swapped_for_x: &SellPoolYSwappedForX): ID {
        sell_pool_y_swapped_for_x.x_id
    }

    public fun sell_pool_y_swapped_for_x_sender(sell_pool_y_swapped_for_x: &SellPoolYSwappedForX): address {
        sell_pool_y_swapped_for_x.sender
    }

    public fun sell_pool_y_swapped_for_x_x_token_type(sell_pool_y_swapped_for_x: &SellPoolYSwappedForX): String {
        sell_pool_y_swapped_for_x.x_token_type
    }

    public fun sell_pool_y_swapped_for_x_y_token_type(sell_pool_y_swapped_for_x: &SellPoolYSwappedForX): String {
        sell_pool_y_swapped_for_x.y_token_type
    }

    public fun sell_pool_y_swapped_for_x_x_amount(sell_pool_y_swapped_for_x: &SellPoolYSwappedForX): u64 {
        sell_pool_y_swapped_for_x.x_amount
    }

    public fun sell_pool_y_swapped_for_x_y_amount(sell_pool_y_swapped_for_x: &SellPoolYSwappedForX): u64 {
        sell_pool_y_swapped_for_x.y_amount
    }

    public fun sell_pool_y_swapped_for_x_new_exchange_rate_numerator(sell_pool_y_swapped_for_x: &SellPoolYSwappedForX): u64 {
        sell_pool_y_swapped_for_x.new_exchange_rate_numerator
    }

    #[allow(unused_type_parameter)]
    public(friend) fun new_sell_pool_y_swapped_for_x<X: key + store, Y>(
        sell_pool: &SellPool<X, Y>,
        x_id: ID,
        sender: address,
        x_token_type: String,
        y_token_type: String,
        x_amount: u64,
        y_amount: u64,
        new_exchange_rate_numerator: u64,
    ): SellPoolYSwappedForX {
        SellPoolYSwappedForX {
            id: id(sell_pool),
            version: version(sell_pool),
            x_id,
            sender,
            x_token_type,
            y_token_type,
            x_amount,
            y_amount,
            new_exchange_rate_numerator,
        }
    }


    public(friend) fun transfer_object<X: key + store, Y>(sell_pool: SellPool<X, Y>, recipient: address) {
        assert!(sell_pool.version == 0, EInappropriateVersion);
        transfer::transfer(sell_pool, recipient);
    }

    public(friend) fun update_version_and_transfer_object<X: key + store, Y>(sell_pool: SellPool<X, Y>, recipient: address) {
        update_object_version(&mut sell_pool);
        transfer::transfer(sell_pool, recipient);
    }

    #[lint_allow(share_owned)]
    public fun share_object<X: key + store, Y>(sell_pool: SellPool<X, Y>) {
        assert!(sell_pool.version == 0, EInappropriateVersion);
        transfer::share_object(sell_pool);
    }

    #[lint_allow(freeze_wrapped)]
    public(friend) fun freeze_object<X: key + store, Y>(sell_pool: SellPool<X, Y>) {
        assert!(sell_pool.version == 0, EInappropriateVersion);
        transfer::freeze_object(sell_pool);
    }

    #[lint_allow(freeze_wrapped)]
    public(friend) fun update_version_and_freeze_object<X: key + store, Y>(sell_pool: SellPool<X, Y>) {
        update_object_version(&mut sell_pool);
        transfer::freeze_object(sell_pool);
    }

    public(friend) fun update_object_version<X: key + store, Y>(sell_pool: &mut SellPool<X, Y>) {
        sell_pool.version = sell_pool.version + 1;
        //assert!(sell_pool.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_sell_pool<X: key + store, Y>(sell_pool: SellPool<X, Y>) {
        let SellPool {
            id,
            version: _version,
            schema_version: _,
            admin_cap: _,
            x_reserve,
            x_amounts,
            x_total_amount: _x_total_amount,
            y_reserve,
            liquidity_token_id: _liquidity_token_id,
            x_sold_amount: _x_sold_amount,
            exchange_rate_numerator: _exchange_rate_numerator,
            exchange_rate_denominator: _exchange_rate_denominator,
            price_curve_type: _price_curve_type,
            price_delta_x_amount: _price_delta_x_amount,
            price_delta_numerator: _price_delta_numerator,
            price_delta_denominator: _price_delta_denominator,
        } = sell_pool;
        object::delete(id);
        sui::object_table::destroy_empty(x_reserve);
        sui::table::destroy_empty(x_amounts);
        sui::balance::destroy_zero(y_reserve);
    }

    public(friend) fun emit_sell_pool_initialized(sell_pool_initialized: SellPoolInitialized) {
        assert!(std::option::is_some(&sell_pool_initialized.id), EEmptyObjectID);
        event::emit(sell_pool_initialized);
    }

    public(friend) fun emit_sell_pool_exchange_rate_updated(sell_pool_exchange_rate_updated: SellPoolExchangeRateUpdated) {
        event::emit(sell_pool_exchange_rate_updated);
    }

    public(friend) fun emit_sell_pool_x_token_added(sell_pool_x_token_added: SellPoolXTokenAdded) {
        event::emit(sell_pool_x_token_added);
    }

    public(friend) fun emit_sell_pool_x_token_removed(sell_pool_x_token_removed: SellPoolXTokenRemoved) {
        event::emit(sell_pool_x_token_removed);
    }

    public(friend) fun emit_y_reserve_withdrawn(y_reserve_withdrawn: YReserveWithdrawn) {
        event::emit(y_reserve_withdrawn);
    }

    public(friend) fun emit_sell_pool_destroyed(sell_pool_destroyed: SellPoolDestroyed) {
        event::emit(sell_pool_destroyed);
    }

    public(friend) fun emit_sell_pool_y_swapped_for_x(sell_pool_y_swapped_for_x: SellPoolYSwappedForX) {
        event::emit(sell_pool_y_swapped_for_x);
    }

}
