// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::exchange {
    use std::string::String;
    use sui::event;
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct EXCHANGE has drop {}

    friend sui_swap_example::exchange_add_token_pair_logic;
    friend sui_swap_example::exchange_add_sell_pool_logic;
    friend sui_swap_example::exchange_update_logic;
    friend sui_swap_example::exchange_aggregate;

    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    const EInappropriateVersion: u64 = 103;

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


    fun init(otw: EXCHANGE, ctx: &mut TxContext) {
        let exchange = new_exchange(
            otw,
            ctx,
        );
        event::emit(new_init_exchange_event(&exchange));
        share_object(exchange);
    }

    public fun assert_schema_version(exchange: &Exchange) {
        assert!(exchange.schema_version == SCHEMA_VERSION, EWrongSchemaVersion);
    }

    struct Exchange has key {
        id: UID,
        version: u64,
        schema_version: u64,
        admin_cap: ID,
        name: String,
        token_pairs: vector<ID>,
        token_pair_x_token_types: vector<String>,
        token_pair_y_token_types: vector<String>,
        sell_pools: vector<ID>,
        sell_pool_x_token_types: vector<String>,
        sell_pool_y_token_types: vector<String>,
    }

    public fun id(exchange: &Exchange): object::ID {
        object::uid_to_inner(&exchange.id)
    }

    public fun version(exchange: &Exchange): u64 {
        exchange.version
    }

    public fun name(exchange: &Exchange): String {
        exchange.name
    }

    public(friend) fun set_name(exchange: &mut Exchange, name: String) {
        assert!(std::string::length(&name) <= 200, EDataTooLong);
        exchange.name = name;
    }

    public fun token_pairs(exchange: &Exchange): vector<ID> {
        exchange.token_pairs
    }

    public(friend) fun set_token_pairs(exchange: &mut Exchange, token_pairs: vector<ID>) {
        exchange.token_pairs = token_pairs;
    }

    public fun token_pair_x_token_types(exchange: &Exchange): vector<String> {
        exchange.token_pair_x_token_types
    }

    public(friend) fun set_token_pair_x_token_types(exchange: &mut Exchange, token_pair_x_token_types: vector<String>) {
        exchange.token_pair_x_token_types = token_pair_x_token_types;
    }

    public fun token_pair_y_token_types(exchange: &Exchange): vector<String> {
        exchange.token_pair_y_token_types
    }

    public(friend) fun set_token_pair_y_token_types(exchange: &mut Exchange, token_pair_y_token_types: vector<String>) {
        exchange.token_pair_y_token_types = token_pair_y_token_types;
    }

    public fun sell_pools(exchange: &Exchange): vector<ID> {
        exchange.sell_pools
    }

    public(friend) fun set_sell_pools(exchange: &mut Exchange, sell_pools: vector<ID>) {
        exchange.sell_pools = sell_pools;
    }

    public fun sell_pool_x_token_types(exchange: &Exchange): vector<String> {
        exchange.sell_pool_x_token_types
    }

    public(friend) fun set_sell_pool_x_token_types(exchange: &mut Exchange, sell_pool_x_token_types: vector<String>) {
        exchange.sell_pool_x_token_types = sell_pool_x_token_types;
    }

    public fun sell_pool_y_token_types(exchange: &Exchange): vector<String> {
        exchange.sell_pool_y_token_types
    }

    public(friend) fun set_sell_pool_y_token_types(exchange: &mut Exchange, sell_pool_y_token_types: vector<String>) {
        exchange.sell_pool_y_token_types = sell_pool_y_token_types;
    }

    public fun admin_cap(exchange: &Exchange): ID {
        exchange.admin_cap
    }

    public(friend) fun new_exchange(
        _witness: EXCHANGE,
        ctx: &mut TxContext,
    ): Exchange {
        let admin_cap = AdminCap {
            id: object::new(ctx),
        };
        let admin_cap_id = object::id(&admin_cap);
        transfer::transfer(admin_cap, sui::tx_context::sender(ctx));
        Exchange {
            id: object::new(ctx),
            version: 0,
            schema_version: SCHEMA_VERSION,
            admin_cap: admin_cap_id,
            name: std::string::utf8(b"sui-dddappp-dex"),
            token_pairs: std::vector::empty(),
            token_pair_x_token_types: std::vector::empty(),
            token_pair_y_token_types: std::vector::empty(),
            sell_pools: std::vector::empty(),
            sell_pool_x_token_types: std::vector::empty(),
            sell_pool_y_token_types: std::vector::empty(),
        }
    }

    entry fun migrate(exchange: &mut Exchange, a: &AdminCap) {
        assert!(exchange.admin_cap == object::id(a), ENotAdmin);
        assert!(exchange.schema_version < SCHEMA_VERSION, ENotUpgrade);
        exchange.schema_version = SCHEMA_VERSION;
    }

    struct InitExchangeEvent has copy, drop {
        id: object::ID,
    }

    public fun init_exchange_event_id(init_exchange_event: &InitExchangeEvent): object::ID {
        init_exchange_event.id
    }

    public(friend) fun new_init_exchange_event(
        exchange: &Exchange,
    ): InitExchangeEvent {
        InitExchangeEvent {
            id: id(exchange),
        }
    }

    struct TokenPairAddedToExchange has copy, drop {
        id: object::ID,
        version: u64,
        token_pair_id: ID,
        x_token_type: String,
        y_token_type: String,
    }

    public fun token_pair_added_to_exchange_id(token_pair_added_to_exchange: &TokenPairAddedToExchange): object::ID {
        token_pair_added_to_exchange.id
    }

    public fun token_pair_added_to_exchange_token_pair_id(token_pair_added_to_exchange: &TokenPairAddedToExchange): ID {
        token_pair_added_to_exchange.token_pair_id
    }

    public fun token_pair_added_to_exchange_x_token_type(token_pair_added_to_exchange: &TokenPairAddedToExchange): String {
        token_pair_added_to_exchange.x_token_type
    }

    public fun token_pair_added_to_exchange_y_token_type(token_pair_added_to_exchange: &TokenPairAddedToExchange): String {
        token_pair_added_to_exchange.y_token_type
    }

    public(friend) fun new_token_pair_added_to_exchange(
        exchange: &Exchange,
        token_pair_id: ID,
        x_token_type: String,
        y_token_type: String,
    ): TokenPairAddedToExchange {
        TokenPairAddedToExchange {
            id: id(exchange),
            version: version(exchange),
            token_pair_id,
            x_token_type,
            y_token_type,
        }
    }

    struct SellPoolAddedToExchange has copy, drop {
        id: object::ID,
        version: u64,
        sell_pool_id: ID,
        x_token_type: String,
        y_token_type: String,
    }

    public fun sell_pool_added_to_exchange_id(sell_pool_added_to_exchange: &SellPoolAddedToExchange): object::ID {
        sell_pool_added_to_exchange.id
    }

    public fun sell_pool_added_to_exchange_sell_pool_id(sell_pool_added_to_exchange: &SellPoolAddedToExchange): ID {
        sell_pool_added_to_exchange.sell_pool_id
    }

    public fun sell_pool_added_to_exchange_x_token_type(sell_pool_added_to_exchange: &SellPoolAddedToExchange): String {
        sell_pool_added_to_exchange.x_token_type
    }

    public fun sell_pool_added_to_exchange_y_token_type(sell_pool_added_to_exchange: &SellPoolAddedToExchange): String {
        sell_pool_added_to_exchange.y_token_type
    }

    public(friend) fun new_sell_pool_added_to_exchange(
        exchange: &Exchange,
        sell_pool_id: ID,
        x_token_type: String,
        y_token_type: String,
    ): SellPoolAddedToExchange {
        SellPoolAddedToExchange {
            id: id(exchange),
            version: version(exchange),
            sell_pool_id,
            x_token_type,
            y_token_type,
        }
    }

    struct ExchangeUpdated has copy, drop {
        id: object::ID,
        version: u64,
        name: String,
    }

    public fun exchange_updated_id(exchange_updated: &ExchangeUpdated): object::ID {
        exchange_updated.id
    }

    public fun exchange_updated_name(exchange_updated: &ExchangeUpdated): String {
        exchange_updated.name
    }

    public(friend) fun new_exchange_updated(
        exchange: &Exchange,
        name: String,
    ): ExchangeUpdated {
        ExchangeUpdated {
            id: id(exchange),
            version: version(exchange),
            name,
        }
    }


    public(friend) fun transfer_object(exchange: Exchange, recipient: address) {
        assert!(exchange.version == 0, EInappropriateVersion);
        transfer::transfer(exchange, recipient);
    }

    public(friend) fun update_version_and_transfer_object(exchange: Exchange, recipient: address) {
        update_object_version(&mut exchange);
        transfer::transfer(exchange, recipient);
    }

    #[lint_allow(share_owned)]
    public(friend) fun share_object(exchange: Exchange) {
        assert!(exchange.version == 0, EInappropriateVersion);
        transfer::share_object(exchange);
    }

    public(friend) fun freeze_object(exchange: Exchange) {
        assert!(exchange.version == 0, EInappropriateVersion);
        transfer::freeze_object(exchange);
    }

    public(friend) fun update_version_and_freeze_object(exchange: Exchange) {
        update_object_version(&mut exchange);
        transfer::freeze_object(exchange);
    }

    public(friend) fun update_object_version(exchange: &mut Exchange) {
        exchange.version = exchange.version + 1;
        //assert!(exchange.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_exchange(exchange: Exchange) {
        let Exchange {
            id,
            version: _version,
            schema_version: _,
            admin_cap: _,
            name: _name,
            token_pairs: _token_pairs,
            token_pair_x_token_types: _token_pair_x_token_types,
            token_pair_y_token_types: _token_pair_y_token_types,
            sell_pools: _sell_pools,
            sell_pool_x_token_types: _sell_pool_x_token_types,
            sell_pool_y_token_types: _sell_pool_y_token_types,
        } = exchange;
        object::delete(id);
    }

    public(friend) fun emit_token_pair_added_to_exchange(token_pair_added_to_exchange: TokenPairAddedToExchange) {
        event::emit(token_pair_added_to_exchange);
    }

    public(friend) fun emit_sell_pool_added_to_exchange(sell_pool_added_to_exchange: SellPoolAddedToExchange) {
        event::emit(sell_pool_added_to_exchange);
    }

    public(friend) fun emit_exchange_updated(exchange_updated: ExchangeUpdated) {
        event::emit(exchange_updated);
    }

}
