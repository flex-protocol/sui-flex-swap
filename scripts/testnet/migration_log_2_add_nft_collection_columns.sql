alter table nft_collection add column nft_service_impl_package_id VARCHAR(66);
alter table nft_collection add column nft_service_impl_module_name varchar(200);

UPDATE `nft_collection` SET `nft_service_impl_package_id` = '0x6485d131e5a2a30c7b606fcb71c1b3c828f00ae5e5e4298269cc9e7287fe0223', `nft_service_impl_module_name` = 'test_equipment_service_impl' 
	WHERE (`collection_type` = '0x8b697f60efef437887f3c1c80879091a7e60f9880e4a41d745b96f0fb520691c::equipment::Equipment');
UPDATE `nft_collection` SET `nft_service_impl_package_id` = '0x6485d131e5a2a30c7b606fcb71c1b3c828f00ae5e5e4298269cc9e7287fe0223', `nft_service_impl_module_name` = 'movescription_service_impl' 
	WHERE (`collection_type` = '0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff::movescription::Movescription');
UPDATE `nft_collection` SET `nft_service_impl_package_id` = '0x091e6daa7d6e000290fbdae96cd12b44619e98b956af9838921a7942e17ab5e2', `nft_service_impl_module_name` = 'test_equipment_service_impl' 
	WHERE (`collection_type` = '0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment');

-- SELECT * FROM nft_collection;
-- ------------------

UPDATE `nft_collection` 
    SET 
        `di_package_id` = '0x5780d0992aa082a83f52acaf82d44ec52c21373f7709d556f73774447f6524a0', 
        `nft_service_impl_package_id` = '0x2ec32d6b9280d0c26280310e1367a5db3f5aa9bd8f3d7112170518522fead632' 
	WHERE 
        (`collection_type` = '0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment');


