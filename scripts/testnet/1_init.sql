INSERT INTO `nft_collection`
  (`collection_type`,`off_chain_version`,`name`,`image_url`,`di_package_id`,`di_buy_pool_service_module_name`,`di_sell_pool_service_module_name`,`di_trade_pool_service_module_name`,`basic_unit_amount`,`amount_field_name`,`subtype_field_name`,`version`,`created_by`,`updated_by`,`active`,`deleted`,`created_at`,`updated_at`,`nft_service_impl_package_id`,`nft_service_impl_module_name`)
    VALUES ('0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment',0,'Test NFT 2','https://arweave.net/WA1r_yylVVWTBIV8e18xeWwlCTZvdQ7XQ5CKVvZ74EA','0x5780d0992aa082a83f52acaf82d44ec52c21373f7709d556f73774447f6524a0','test_equipment_buy_pool_service','test_equipment_sell_pool_service','test_equipment_trade_pool_service',1,'amount','type',0,NULL,NULL,1,0,NULL,NULL,'0x2ec32d6b9280d0c26280310e1367a5db3f5aa9bd8f3d7112170518522fead632','test_equipment_service_impl');
INSERT INTO `nft_collection`
  (`collection_type`,`off_chain_version`,`name`,`image_url`,`di_package_id`,`di_buy_pool_service_module_name`,`di_sell_pool_service_module_name`,`di_trade_pool_service_module_name`,`basic_unit_amount`,`amount_field_name`,`subtype_field_name`,`version`,`created_by`,`updated_by`,`active`,`deleted`,`created_at`,`updated_at`,`nft_service_impl_package_id`,`nft_service_impl_module_name`)
    VALUES ('0x8b697f60efef437887f3c1c80879091a7e60f9880e4a41d745b96f0fb520691c::equipment::Equipment',0,'Test NFT 1','','0xe8ab46a6a9e24ee824a819f6e2aa68cc4bb4f6981057495c9919755ed74f7099','test_equipment_buy_pool_service','test_equipment_sell_pool_service','test_equipment_trade_pool_service',1,'amount','type',0,NULL,NULL,1,0,NULL,NULL,'0x6485d131e5a2a30c7b606fcb71c1b3c828f00ae5e5e4298269cc9e7287fe0223','test_equipment_service_impl');
INSERT INTO `nft_collection`
  (`collection_type`,`off_chain_version`,`name`,`image_url`,`di_package_id`,`di_buy_pool_service_module_name`,`di_sell_pool_service_module_name`,`di_trade_pool_service_module_name`,`basic_unit_amount`,`amount_field_name`,`subtype_field_name`,`version`,`created_by`,`updated_by`,`active`,`deleted`,`created_at`,`updated_at`,`nft_service_impl_package_id`,`nft_service_impl_module_name`)
    VALUES ('0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff::movescription::Movescription',0,'Movescription','','0xe8ab46a6a9e24ee824a819f6e2aa68cc4bb4f6981057495c9919755ed74f7099','movescription_buy_pool_service','movescription_sell_pool_service','movescription_trade_pool_service',1,'amount','tick',0,NULL,NULL,1,0,NULL,NULL,'0x6485d131e5a2a30c7b606fcb71c1b3c828f00ae5e5e4298269cc9e7287fe0223','movescription_service_impl');

INSERT INTO `nft_collection_subtype`
  (`nft_collection_collection_type`,`subtype_value`,`off_chain_version`,`name`,`image_url`,`created_by`,`updated_by`,`active`,`deleted`,`created_at`,`updated_at`,`subtype_amount`)
    VALUES ('0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment','1',0,'Brick','https://arweave.net/6AXZZCbeJLoOiexVs4TbWYcBvAtHsP8j0b0TZCLovs0',NULL,NULL,1,0,NULL,NULL,1);
INSERT INTO `nft_collection_subtype`
  (`nft_collection_collection_type`,`subtype_value`,`off_chain_version`,`name`,`image_url`,`created_by`,`updated_by`,`active`,`deleted`,`created_at`,`updated_at`,`subtype_amount`)
    VALUES ('0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment','2',0,'Shield','https://arweave.net/8CXgwIU2n7nVj9Bw5SAz5Kj_16OPUaNnOuYDEqCV5eQ',NULL,NULL,1,0,NULL,NULL,3);
INSERT INTO `nft_collection_subtype`
  (`nft_collection_collection_type`,`subtype_value`,`off_chain_version`,`name`,`image_url`,`created_by`,`updated_by`,`active`,`deleted`,`created_at`,`updated_at`,`subtype_amount`)
    VALUES ('0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment','3',0,'Sword','image_url\": \"https://arweave.net/ItEzNg2lSS1Ne5ir5Cfbcyvi2HNsx5e6Et4LvzQx2rA',NULL,NULL,1,0,NULL,NULL,5);
