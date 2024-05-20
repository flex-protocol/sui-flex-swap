// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module sui_swap_example::exchange_aggregate {
    use std::string::String;
    use sui::tx_context;
    use sui_swap_example::exchange;
    use sui_swap_example::exchange_add_token_pair_logic;
    use sui_swap_example::exchange_update_logic;
    use sui_swap_example::token_pair::TokenPair;

    friend sui_swap_example::token_pair_service;

    const EInvalidPublisher: u64 = 50;
    const EInvalidAdminCap: u64 = 51;

    #[allow(unused_mut_parameter)]
    public entry fun add_token_pair<X, Y>(
        exchange: &mut exchange::Exchange,
        publisher: &sui::package::Publisher,
        token_pair: &TokenPair<X, Y>,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<exchange::Exchange>(publisher), EInvalidPublisher);
        exchange::assert_schema_version(exchange);
        let token_pair_added_to_exchange = exchange_add_token_pair_logic::verify<X, Y>(
            token_pair,
            exchange,
            ctx,
        );
        exchange_add_token_pair_logic::mutate<X, Y>(
            &token_pair_added_to_exchange,
            exchange,
            ctx,
        );
        exchange::update_object_version(exchange);
        exchange::emit_token_pair_added_to_exchange(token_pair_added_to_exchange);
    }

    public entry fun update(
        exchange: &mut exchange::Exchange,
        admin_cap: &exchange::AdminCap,
        name: String,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(exchange::admin_cap(exchange) == sui::object::id(admin_cap), EInvalidAdminCap);
        exchange::assert_schema_version(exchange);
        let exchange_updated = exchange_update_logic::verify(
            name,
            exchange,
            ctx,
        );
        exchange_update_logic::mutate(
            &exchange_updated,
            exchange,
            ctx,
        );
        exchange::update_object_version(exchange);
        exchange::emit_exchange_updated(exchange_updated);
    }

}
