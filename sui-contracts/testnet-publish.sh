#!/bin/bash

## External Package IDs
# ...

# The following are the object IDs of the SUI objects that are used in the following script.
# Make sure the amounts of the following SUI objects are greater than 200000000
sui_coin_object_id_1="0x42ce68efec70dc482cafb4eb6f6e759074ab8397202cb8002f9fb33130951758"
sui_coin_object_id_2="0x719daa0c3c4a06f72e9efa1fcf0a96a178065895c23be0e10eaece30fd8c24c9"

# -------- Constants --------
move_toml_file="Move.toml"
move_toml_temp="Move-temp.toml"

log_file="testnet-publish.log"
echo "#-------- publish core package --------" | tee -a "$log_file"
publish_json_file="testnet_core_publish.json"

sui client publish --gas-budget 800000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json > "$publish_json_file"

publish_core_txn_digest=$(jq -r '.digest' "$publish_json_file")
echo "publish core package. publish_core_txn_digest: $publish_core_txn_digest" | tee -a "$log_file"

if [ -z "$publish_core_txn_digest" ]
then
echo "The publish_core_txn_digest is empty, exit the script." | tee -a "$log_file"
exit 1
fi

core_package_id=$(jq -r '.objectChanges[] | select(.type == "published").packageId' "$publish_json_file")
echo "core_package_id: $core_package_id" | tee -a "$log_file"
echo "" | tee -a "$log_file"

example_coin_treasury_cap_object_id=""
exchange_object_id=""
exchange_admin_cap_object_id=""

while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
  if [[ $objectType == "0x2::coin::TreasuryCap<$core_package_id::example_coin::EXAMPLE_COIN>" ]]
  then
    example_coin_treasury_cap_object_id=$objectId
  elif [[ $objectType == *::package::Publisher ]]
  then
    publisher_object_id=$objectId
  elif [[ $objectType == *::exchange::Exchange ]]
  then
    exchange_object_id=$objectId
  elif [[ $objectType == *::exchange::AdminCap ]]
  then
    exchange_admin_cap_object_id=$objectId
  fi
done < <(jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file")
echo "example_coin_treasury_cap_object_id: $example_coin_treasury_cap_object_id"
echo "publisher_object_id: $publisher_object_id"
echo "exchange_object_id: $exchange_object_id"
echo "exchange_admin_cap_object_id: $exchange_admin_cap_object_id"


# -------- update core Move.toml --------
while read -r line
do
if [[ $line == "published-at ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[package]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "published-at = \"$core_package_id\"" >> $move_toml_temp
elif [[ $line == "sui_swap_example ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[addresses]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "sui_swap_example = \"$core_package_id\"" >> $move_toml_temp
else
  echo "$line" >> $move_toml_temp
fi
done < $move_toml_file

mv $move_toml_temp $move_toml_file


# Mint some example coins

sui client call --package "$core_package_id" --module example_coin --function mint \
--args "$example_coin_treasury_cap_object_id" 1000000000 --gas-budget 30000000 --json > testnet_mint_example_coin.json
example_coin_object_id_1=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("0x2::coin::Coin<")).objectId' testnet_mint_example_coin.json)
echo "example_coin_object_id_1: $example_coin_object_id_1" | tee -a "$log_file"

sui client call --package "$core_package_id" --module example_coin --function mint \
--args "$example_coin_treasury_cap_object_id" 1000000000 --gas-budget 30000000 --json > testnet_mint_example_coin.json
example_coin_object_id_2=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("0x2::coin::Coin<")).objectId' testnet_mint_example_coin.json)
echo "example_coin_object_id_2: $example_coin_object_id_2" | tee -a "$log_file"

sui client call --package "$core_package_id" --module example_coin --function mint \
--args "$example_coin_treasury_cap_object_id" 1000000000 --gas-budget 30000000 --json > testnet_mint_example_coin.json
example_coin_object_id_3=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("0x2::coin::Coin<")).objectId' testnet_mint_example_coin.json)
echo "example_coin_object_id_3: $example_coin_object_id_3" | tee -a "$log_file"

# Initialize liquidity
sui client call --package "$core_package_id" --module token_pair_service --function initialize_liquidity \
--type-args '0x2::sui::SUI' "$core_package_id"::example_coin::EXAMPLE_COIN \
--args \
"$publisher_object_id" \
"$exchange_object_id" \
"$sui_coin_object_id_1" \
'"100000000"' \
"$example_coin_object_id_1" \
'"100000000"' \
--gas-budget 30000000 --json > testnet_initialize_liquidity.json

token_pair_object_id_1=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("token_pair::TokenPair<")).objectId' testnet_initialize_liquidity.json)
echo "token_pair_object_id_1: $token_pair_object_id_1" | tee -a "$log_file"
liquidity_token_object_id_1=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("liquidity_token::LiquidityToken<")).objectId' testnet_initialize_liquidity.json)
echo "liquidity_token_object_id_1: $liquidity_token_object_id_1" | tee -a "$log_file"

# Add liquidity
sui client call --package "$core_package_id" --module token_pair_service --function add_liquidity \
--type-args '0x2::sui::SUI' "$core_package_id"::example_coin::EXAMPLE_COIN \
--args \
"$token_pair_object_id_1" \
"$sui_coin_object_id_1" \
'"90000000"' \
"$example_coin_object_id_1" \
'"90000000"' [] \
--gas-budget 30000000 --json > testnet_add_liquidity.json

# Remove liquidity
sui client call --package "$core_package_id" --module token_pair_service --function remove_liquidity \
--type-args '0x2::sui::SUI' "$core_package_id"::example_coin::EXAMPLE_COIN \
--args \
"$token_pair_object_id_1" \
"$liquidity_token_object_id_1" \
"$sui_coin_object_id_1" \
"$example_coin_object_id_1" [] [] \
--gas-budget 30000000

# Swap X for Y
sui client call --package "$core_package_id" --module token_pair_service --function swap_x \
--type-args '0x2::sui::SUI' "$core_package_id"::example_coin::EXAMPLE_COIN \
--args \
"$token_pair_object_id_1" \
"$sui_coin_object_id_1" \
'"10000"' \
"$example_coin_object_id_1" \
'"9900"' \
--gas-budget 30000000

# Swap Y for X
sui client call --package "$core_package_id" --module token_pair_service --function swap_y \
--type-args '0x2::sui::SUI' "$core_package_id"::example_coin::EXAMPLE_COIN \
--args \
"$token_pair_object_id_1" \
"$example_coin_object_id_1" \
'"10000"' \
"$sui_coin_object_id_1" \
'"9900"' \
--gas-budget 30000000

