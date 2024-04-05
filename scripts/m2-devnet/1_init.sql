-- mvn clean
-- mvn package -DskipTests
-- CREATE SCHEMA `m2_devnet` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- java -jar ./suiswapexample-service-cli/target/suiswapexample-service-cli-0.0.1-SNAPSHOT.jar ddl -d "./scripts" -c "jdbc:mysql://127.0.0.1:3306/m2_devnet?enabledTLSProtocols=TLSv1.2&characterEncoding=utf8&serverTimezone=GMT%2b0&useLegacyDatetimeCode=false" -u root -p 123456


INSERT INTO `nft_collection`
(`collection_type`,
`off_chain_version`,
`name`,
`image_url`,
`di_package_id`,
`di_buy_pool_service_module_name`,
`di_sell_pool_service_module_name`,
`di_trade_pool_service_module_name`,
`basic_unit_amount`,
`amount_field_name`,
`subtype_field_name`,
`version`,
`created_by`,
`updated_by`,
`active`,
`deleted`,
`created_at`,
`updated_at`)
VALUES
('0x52bffc0becd6f3ba12b1b3b0f60de6b5239cfb568bd0688701209a4b7e3e328b::equipment::Equipment',
0,
'Test Equipment 1',
'',
'0x8305989fe8286bdec3ea489712101a8aa7478644d22ff3327a4fe6fe88501333',
'test_equipment_buy_pool_service',
'test_equipment_sell_pool_service',
'test_equipment_trade_pool_service',
1,
'amount',
'type',
0,
null,
null,
true,
false,
null,
null);

UPDATE `nft_collection` SET `image_url` = 'https://arweave.net/WA1r_yylVVWTBIV8e18xeWwlCTZvdQ7XQ5CKVvZ74EA' 
    WHERE (`collection_type` = '0x52bffc0becd6f3ba12b1b3b0f60de6b5239cfb568bd0688701209a4b7e3e328b::equipment::Equipment');

UPDATE `nft_collection` SET 
    `nft_service_impl_package_id` = '0x7313bc541172c4ea46466307b1d9e82a32240417a6720ddf1cbd881cd980dbef', 
    `nft_service_impl_module_name` = 'test_equipment_service_impl' 
	WHERE (`collection_type` = '0x52bffc0becd6f3ba12b1b3b0f60de6b5239cfb568bd0688701209a4b7e3e328b::equipment::Equipment');



INSERT INTO `nft_collection_subtype`
(`nft_collection_collection_type`,
`subtype_value`,
`off_chain_version`,
`name`,
`image_url`,
`created_by`,
`updated_by`,
`active`,
`deleted`,
`created_at`,
`updated_at`)
VALUES
('0x52bffc0becd6f3ba12b1b3b0f60de6b5239cfb568bd0688701209a4b7e3e328b::equipment::Equipment',
'1',
0,
'Brick',
'https://arweave.net/6AXZZCbeJLoOiexVs4TbWYcBvAtHsP8j0b0TZCLovs0',
null,
null,
true,
false,
null,
null);

INSERT INTO `nft_collection_subtype`
(`nft_collection_collection_type`,
`subtype_value`,
`off_chain_version`,
`name`,
`image_url`,
`created_by`,
`updated_by`,
`active`,
`deleted`,
`created_at`,
`updated_at`)
VALUES
('0x52bffc0becd6f3ba12b1b3b0f60de6b5239cfb568bd0688701209a4b7e3e328b::equipment::Equipment',
'2',
0,
'Shield',
'https://arweave.net/8CXgwIU2n7nVj9Bw5SAz5Kj_16OPUaNnOuYDEqCV5eQ',
null,
null,
true,
false,
null,
null);

INSERT INTO `nft_collection_subtype`
(`nft_collection_collection_type`,
`subtype_value`,
`off_chain_version`,
`name`,
`image_url`,
`created_by`,
`updated_by`,
`active`,
`deleted`,
`created_at`,
`updated_at`)
VALUES
('0x52bffc0becd6f3ba12b1b3b0f60de6b5239cfb568bd0688701209a4b7e3e328b::equipment::Equipment',
'3',
0,
'Sword',
'https://arweave.net/ItEzNg2lSS1Ne5ir5Cfbcyvi2HNsx5e6Et4LvzQx2rA',
null,
null,
true,
false,
null,
null);



UPDATE `nft_collection_subtype`
    SET
    `subtype_amount` = 5
WHERE `nft_collection_collection_type` = '0x52bffc0becd6f3ba12b1b3b0f60de6b5239cfb568bd0688701209a4b7e3e328b::equipment::Equipment'
	AND `subtype_value` = '3';
 
UPDATE `nft_collection_subtype`
    SET
    `subtype_amount` = 3
WHERE `nft_collection_collection_type` = '0x52bffc0becd6f3ba12b1b3b0f60de6b5239cfb568bd0688701209a4b7e3e328b::equipment::Equipment'
	AND `subtype_value` = '2';

UPDATE `nft_collection_subtype`
    SET
    `subtype_amount` = 1
WHERE `nft_collection_collection_type` = '0x52bffc0becd6f3ba12b1b3b0f60de6b5239cfb568bd0688701209a4b7e3e328b::equipment::Equipment'
	AND `subtype_value` = '1';



