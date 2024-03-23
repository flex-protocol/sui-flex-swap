module example_tokens::equipment {

    use std::string::{String, utf8};

    use sui::display;
    use sui::object::{Self, UID};
    use sui::package;
    use sui::transfer::{Self, public_transfer};
    use sui::tx_context::{Self, sender, TxContext};

    const EWrongEquipmentType: u64 = 1;

    struct Equipment has key, store {
        id: UID,
        type: u8,
        amount: u64,
        name: String,
        image_url: String,
    }

    /// One-Time-Witness for the module.
    struct EQUIPMENT has drop {}


    fun init(otw: EQUIPMENT, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            //utf8(b"link"),
            utf8(b"image_url"),
            //utf8(b"description"),
            //utf8(b"project_url"),
            //utf8(b"creator"),
        ];

        let values = vector[
            // For `name` one can use the `Hero.name` property
            utf8(b"{name}"),
            // For `link` one can build a URL using an `id` property
            //utf8(b"https://sui-heroes.io/hero/{id}"),
            // For `image_url` use an IPFS template + `image_url` property.
            utf8(b"https://arweave.net/{image_url}"),
            // Description is static for all `Hero` objects.
            //utf8(b"A true Hero of the Sui ecosystem!"),
            // Project URL is usually static
            //utf8(b"https://sui-heroes.io"),
            // Creator field can be any
            //utf8(b"Unknown Sui Fan")
        ];

        // Claim the `Publisher` for the package!
        let publisher = package::claim(otw, ctx);

        // Get a new `Display` object for the `Hero` type.
        let display = display::new_with_fields<Equipment>(
            &publisher, keys, values, ctx
        );

        // Commit first version of `Display` to apply changes.
        display::update_version(&mut display);

        transfer::public_transfer(publisher, sender(ctx));
        transfer::public_transfer(display, sender(ctx));
    }

    public fun brick(): u8 {
        1
    }

    public fun shield(): u8 {
        2
    }

    public fun sword(): u8 {
        3
    }

    public fun brick_name(): String {
        utf8(b"Brick")
    }

    public fun shield_name(): String {
        utf8(b"Shield")
    }

    public fun sword_name(): String {
        utf8(b"Sword")
    }

    public fun amount(equipment: &Equipment): u64 {
        equipment.amount
    }

    public fun brick_image_url(): String {
        utf8(b"6AXZZCbeJLoOiexVs4TbWYcBvAtHsP8j0b0TZCLovs0")
    }

    public fun shield_image_url(): String {
        utf8(b"8CXgwIU2n7nVj9Bw5SAz5Kj_16OPUaNnOuYDEqCV5eQ")
    }

    public fun sword_image_url(): String {
        utf8(b"ItEzNg2lSS1Ne5ir5Cfbcyvi2HNsx5e6Et4LvzQx2rA")
    }

    public entry fun mint(type: u8, ctx: &mut TxContext) {
        assert!(type == 1 || type == 2 || type == 3, EWrongEquipmentType);
        let amount = if (type == 1) { 1 } else {
            if (type == 2) { 3 } else { 5 }
        };
        let name = if (type == 1) { brick_name() } else {
            if (type == 2) { shield_name() } else { sword_name() }
        };
        let image_url = if (type == 1) { brick_image_url() } else {
            if (type == 2) { shield_image_url() } else { sword_image_url() }
        };
        let e = Equipment {
            id: object::new(ctx),
            type,
            amount,
            name,
            image_url,
        };
        public_transfer(e, tx_context::sender(ctx));
    }
}
