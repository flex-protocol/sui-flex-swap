DROP TABLE `nft_collection_subtype`, `nft_collection_subtype_event`;

create table nft_collection_subtype (
	nft_collection_collection_type varchar(500) not null, 
    subtype_value varchar(200) not null, 
    off_chain_version bigint not null, 
    name varchar(200), image_url varchar(500), 
    created_by varchar(255), updated_by varchar(255), active bit, deleted bit, created_at datetime, updated_at datetime, 
    primary key (nft_collection_collection_type, subtype_value)
);

create table nft_collection_subtype_event (
	nft_collection_collection_type varchar(500) not null, 
    subtype_value varchar(200) not null, 
    version DECIMAL(20,0) not null, 
    event_type varchar(255) not null, created_by varchar(255), created_at datetime, command_id varchar(255), 
    primary key (nft_collection_collection_type, subtype_value, version)
);

-- alter table nft_collection_subtype add constraint FK8wnhuutusrpfhd2sllyi0ivnt foreign key (nft_collection_collection_type) references nft_collection (collection_type);

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
('0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment',
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
('0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment',
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
('0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment',
'3',
0,
'Sword',
'image_url": "https://arweave.net/ItEzNg2lSS1Ne5ir5Cfbcyvi2HNsx5e6Et4LvzQx2rA',
null,
null,
true,
false,
null,
null);

UPDATE `nft_collection_subtype`
    SET
    `image_url` = 'https://arweave.net/ItEzNg2lSS1Ne5ir5Cfbcyvi2HNsx5e6Et4LvzQx2rA'
WHERE `nft_collection_collection_type` = '0x507d2aacb7425085612e0d56131a57362729779bf3510c286b98568479314920::equipment::Equipment'
	AND `subtype_value` = '3';




