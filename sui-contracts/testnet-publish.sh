#!/bin/bash

## External Package IDs
#movescription_package_id="0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff"
#
## The following are the object IDs of the Movescription objects that are used in the following script.
#movescription_object_id_1="0xf7f07fe483d4e23db541e835505ac5cabdb4e405db40c13eaf12ce25b3fd87ca"
#movescription_object_id_2="0x457824b0c2c95c7ea1018d2e5aa46626d917a81bacdab9abc938fad01915836a"
#movescription_object_id_3="0x03e5e2206413a762c0eb17d883b66f4017c2fa444e3f6c3589c163456f9b704f"
#movescription_object_id_4="0xefcea26c23f5bfc9f99930450cce4378519bc3b2212760c0b51fd56b36e52440"
#movescription_object_id_5="0xa62f7319d67f1611aba7bd9bfeb3b41023661223df4ba79968dd2adea0922731"

# The following are the object IDs of the SUI objects that are used in the following script.
# Make sure the amounts of the following SUI objects are greater than 200000000
sui_coin_object_id_1="0xfdf3344392babaf053e0293218cb901236dd43c3abf52a1cf3b5af17ee1b9e20"
sui_coin_object_id_2="0xdd4aea51975a506e1e5451e38f340c3444ae03c4b2533afd04253f7a53a8b4d0"

# -------- Constants --------
move_toml_file="Move.toml"
move_toml_temp="Move-temp.toml"

# ----------------------------------------------------------------------------------------
# Publish utils package
cd utils
log_file="../testnet-publish.log"
echo "#-------- publish utils package --------" | tee -a "$log_file"
publish_json_file="testnet_utils_publish.json"

sui client publish --gas-budget 300000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json > "$publish_json_file"

publish_utils_txn_digest=$(jq -r '.digest' "$publish_json_file")
echo "publish utils package txn_digest: $publish_utils_txn_digest" | tee -a "$log_file"

if [ -z "$publish_utils_txn_digest" ]
then
echo "The publish_utils_txn_digest is empty, exit the script." | tee -a "$log_file"
exit 1
fi

utils_package_id=$(jq -r '.objectChanges[] | select(.type == "published").packageId' "$publish_json_file")
echo "utils package_id: $utils_package_id" | tee -a "$log_file"
echo "" | tee -a "$log_file"

while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
done < <(jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file")

# -------- update utils Move.toml --------
# read every line of Move.toml
while read -r line
do
# if the line starts with "published-at =", then add "#" in front of it
if [[ $line == "published-at ="* ]]
  then
    echo "#$line" >> $move_toml_temp
# if the line is "[package]", then add "published-at = $package_id" below it
elif [[ $line == "[package]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "published-at = \"$utils_package_id\"" >> $move_toml_temp
elif [[ $line == "sui_swap_utils ="* ]]
  then
    echo "#$line" >> $move_toml_temp
# if the line is "[addresses]", then add a line below it
elif [[ $line == "[addresses]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "sui_swap_utils = \"$utils_package_id\"" >> $move_toml_temp
# else, keep the line unchanged
else
  echo "$line" >> $move_toml_temp
fi
done < $move_toml_file

# replace the original file with the temp file
mv $move_toml_temp $move_toml_file

#exit 1

# ----------------------------------------------------------------------------------------
# Publish core package

cd ../core
log_file="../testnet-publish.log"
echo "#-------- publish core package --------" | tee -a "$log_file"
publish_json_file="testnet_core_publish.json"

sui client publish --gas-budget 800000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json > "$publish_json_file"

publish_core_txn_digest=$(jq -r '.digest' "$publish_json_file")
echo "publish core package txn_digest: $publish_core_txn_digest" | tee -a "$log_file"

if [ -z "$publish_core_txn_digest" ]
then
echo "The publish_core_txn_digest is empty, exit the script." | tee -a "$log_file"
exit 1
fi

core_package_id=$(jq -r '.objectChanges[] | select(.type == "published").packageId' "$publish_json_file")
echo "core package_id: $core_package_id" | tee -a "$log_file"
echo "" | tee -a "$log_file"

nft_service_config_object_id=""
nft_service_config_cap_object_id=""
exchange_object_id=""

while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
  if [[ $objectType == *::nft_service_config::NftServiceConfig ]]
  then
    nft_service_config_object_id=$objectId
  elif [[ $objectType == *::nft_service_config::NftServiceConfigCap ]]
  then
    nft_service_config_cap_object_id=$objectId
  elif [[ $objectType == *::exchange::Exchange ]]
  then
    exchange_object_id=$objectId
  fi
done < <(jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file")
echo "nft_service_config_object_id: $nft_service_config_object_id"
echo "nft_service_config_cap_object_id: $nft_service_config_cap_object_id"
echo "exchange_object_id: $exchange_object_id"

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
elif [[ $line == "sui_swap_core ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[addresses]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "sui_swap_core = \"$core_package_id\"" >> $move_toml_temp
else
  echo "$line" >> $move_toml_temp
fi
done < $move_toml_file

mv $move_toml_temp $move_toml_file

# ----------------------------------------------------------------------------------------
# Publish nft_service_impl package

cd ../nft-service-impl
log_file="../testnet-publish.log"
echo "#-------- publish nft_service_impl package --------" | tee -a "$log_file"
publish_json_file="testnet_nft_service_impl_publish.json"

sui client publish --gas-budget 200000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json > "$publish_json_file"

publish_nft_service_impl_txn_digest=$(jq -r '.digest' "$publish_json_file")
echo "publish nft_service_impl package txn_digest: $publish_nft_service_impl_txn_digest" | tee -a "$log_file"

if [ -z "$publish_nft_service_impl_txn_digest" ]
then
echo "The publish_nft_service_impl_txn_digest is empty, exit the script." | tee -a "$log_file"
exit 1
fi

nft_service_impl_package_id=$(jq -r '.objectChanges[] | select(.type == "published").packageId' "$publish_json_file")
echo "nft_service_impl package_id: $nft_service_impl_package_id" | tee -a "$log_file"
echo "" | tee -a "$log_file"

while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
done < <(jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file")

# -------- update nft_service_impl Move.toml --------
while read -r line
do
if [[ $line == "published-at ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[package]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "published-at = \"$nft_service_impl_package_id\"" >> $move_toml_temp
elif [[ $line == "nft_service_impl ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[addresses]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "nft_service_impl = \"$nft_service_impl_package_id\"" >> $move_toml_temp
else
  echo "$line" >> $move_toml_temp
fi
done < $move_toml_file

mv $move_toml_temp $move_toml_file


# ----------------------------------------------------------------------------------------
# Publish di package

cd ../di
log_file="../testnet-publish.log"
echo "#-------- publish di package --------" | tee -a "$log_file"
publish_json_file="testnet_di_publish.json"

sui client publish --gas-budget 200000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json > "$publish_json_file"

publish_di_txn_digest=$(jq -r '.digest' "$publish_json_file")
echo "publish di package txn_digest: $publish_di_txn_digest" | tee -a "$log_file"

if [ -z "$publish_di_txn_digest" ]
then
echo "The publish_di_txn_digest is empty, exit the script." | tee -a "$log_file"
exit 1
fi

di_package_id=$(jq -r '.objectChanges[] | select(.type == "published").packageId' "$publish_json_file")
echo "di package_id: $di_package_id" | tee -a "$log_file"

while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
done < <(jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file")

# -------- update di Move.toml --------
while read -r line
do
if [[ $line == "published-at ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[package]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "published-at = \"$di_package_id\"" >> $move_toml_temp
elif [[ $line == "sui_swap_di ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[addresses]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "sui_swap_di = \"$di_package_id\"" >> $move_toml_temp
else
  echo "$line" >> $move_toml_temp
fi
done < $move_toml_file

mv $move_toml_temp $move_toml_file


# ----------------------------------------------------------------------------------------
# Initialize sell pool, buy pool, and trade pool
cd ..
log_file="./testnet-publish.log"
echo "" | tee -a "$log_file"
echo "# -------- Initialize sell pool, buy pool, and trade pool --------" | tee -a "$log_file"

# Configure dependency injection allowlist

# -------- Movescription as NFT --------
#sui client call --function add_allowed_impl --module nft_service_config --package "$core_package_id" \
#--type-args "$nft_service_impl_package_id::movescription_service_impl::MovescriptionServiceImpl" \
#--args "$nft_service_config_object_id" "$nft_service_config_cap_object_id" \
#--gas-budget 300000000

# Initialize sell pool

# -------- Movescription as NFT --------
#sui client call --package "$di_package_id" --module movescription_sell_pool_service --function initialize_sell_pool \
#--type-args '0x2::sui::SUI' \
#--args \
#"$nft_service_config_object_id" \
#"$exchange_object_id" \
#"$movescription_object_id_1" \
#'"11110"' \
#'"100"' \
#'0' \
#'"10"' \
#'"10"' \
#'"100"' \
#--gas-budget 100000000 --json > testnet_initialize_sell_pool.json
#sell_pool_id_1=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("trade_pool::TradePool<")).objectId' testnet_initialize_sell_pool.json)
#echo "sell_pool_id_1: $sell_pool_id_1" | tee -a "$log_file"
#sell_pool_liquidity_token_id_1=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("liquidity_token::LiquidityToken<")).objectId' testnet_initialize_sell_pool.json)
#echo "sell_pool_liquidity_token_id_1: $sell_pool_liquidity_token_id_1" | tee -a "$log_file"

# Initialize buy pool

# -------- Movescription as NFT --------
#sui client call --package "$core_package_id" --module buy_pool_service --function initialize_buy_pool \
#--type-args "$movescription_package_id::movescription::Movescription" '0x2::sui::SUI' \
#--args \
#"$exchange_object_id" \
#"$sui_coin_object_id_1" \
#'"200000000"' \
#'"11110"' \
#'"100"' \
#'0' \
#'"500"' \
#'"10"' \
#'"100"' \
#--gas-budget 100000000 --json > testnet_initialize_buy_pool.json
#buy_pool_id_1=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("trade_pool::TradePool<")).objectId' testnet_initialize_buy_pool.json)
#echo "buy_pool_id_1: $buy_pool_id_1" | tee -a "$log_file"
#buy_pool_liquidity_token_id_1=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("liquidity_token::LiquidityToken<")).objectId' testnet_initialize_buy_pool.json)
#echo "buy_pool_liquidity_token_id_1: $buy_pool_liquidity_token_id_1" | tee -a "$log_file"

# Initialize trade pool

# -------- Movescription as NFT --------
#sui client call --package "$di_package_id" --module movescription_trade_pool_service --function initialize_trade_pool \
#--type-args '0x2::sui::SUI' \
#--args \
#"$nft_service_config_object_id" \
#"$exchange_object_id" \
#"$movescription_object_id_2" \
#"$sui_coin_object_id_2" \
#'"200000000"' \
#'"11110"' \
#'"100"' \
#'1' \
#'"500"' \
#'"10"' \
#'"100"' \
#--gas-budget 100000000 --json > testnet_initialize_trade_pool.json
#trade_pool_id_1=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("trade_pool::TradePool<")).objectId' testnet_initialize_trade_pool.json)
#echo "trade_pool_id_1: $trade_pool_id_1" | tee -a "$log_file"
#trade_pool_liquidity_token_id_1=$(jq -r '.objectChanges[] | select(.type == "created") | select(.objectType | test("liquidity_token::LiquidityToken<")).objectId' testnet_initialize_trade_pool.json)
#echo "trade_pool_liquidity_token_id_1: $trade_pool_liquidity_token_id_1" | tee -a "$log_file"

## -------- Get pool IDs from exchange object --------
#exchange_object_id="0x01e4361f1bcf6529e5f68517d2dcd68b25b57bee016cc34a9b7639c2bd8b72fb"
#sui client object "$exchange_object_id" --json > testnet_exchange_object.json
#sell_pool_id_1=$(jq -r '.content.fields.sell_pools[]' testnet_exchange_object.json)
#echo "sell_pool_id_1: $sell_pool_id_1" | tee -a "$log_file"
#
#buy_pool_id_1=$(jq -r '.content.fields.buy_pools[]' testnet_exchange_object.json)
#echo "buy_pool_id_1: $buy_pool_id_1" | tee -a "$log_file"
#
#trade_pool_id_1=$(jq -r '.content.fields.trade_pools[]' testnet_exchange_object.json)
#echo "trade_pool_id_1: $trade_pool_id_1" | tee -a "$log_file"

## -------- Get liquidity token IDs from pool objects --------
#sell_pool_liquidity_token_id_1=$(sui client object "$sell_pool_id_1" --json | jq -r '.content.fields.liquidity_token_id')
#echo "sell_pool_liquidity_token_id_1: $sell_pool_liquidity_token_id_1" | tee -a "$log_file"
#
#buy_pool_liquidity_token_id_1=$(sui client object "$buy_pool_id_1" --json | jq -r '.content.fields.liquidity_token_id')
#echo "buy_pool_liquidity_token_id_1: $buy_pool_liquidity_token_id_1" | tee -a "$log_file"
#
#trade_pool_liquidity_token_id_1=$(sui client object "$trade_pool_id_1" --json | jq -r '.content.fields.liquidity_token_id')
#echo "trade_pool_liquidity_token_id_1: $trade_pool_liquidity_token_id_1" | tee -a "$log_file"

# ----------------------------------------------------------------------------------------
# Do some operations on the initialized trade pool
# Sell X token to trade pool / buy pool

# -------- Movescription as NFT --------
#sui client call --package "$di_package_id" --module movescription_buy_pool_service --function sell_x \
#--type-args '0x2::sui::SUI' \
#--args \
#"$nft_service_config_object_id" \
#"$trade_pool_id_1" \
#"$movescription_object_id_3" \
#"$sui_coin_object_id_1" \
#'"100"' \
#--gas-budget 100000000

# Buy X token from trade pool / sell pool

# -------- Movescription as NFT --------
#sui client call --package "$core_package_id" --module sell_pool_service --function buy_x \
#--type-args "$movescription_package_id::movescription::Movescription" '0x2::sui::SUI' \
#--args "$trade_pool_id_1" \
#"$sui_coin_object_id_1" \
#'"120000"' \
#"$movescription_object_id_3" \
#--gas-budget 100000000

# Deposit Y reserve to trade pool / buy pool

# -------- Movescription as NFT --------
#sui client call --package "$core_package_id" --module trade_pool_service --function deposit_y_reserve \
#--type-args "$movescription_package_id::movescription::Movescription" '0x2::sui::SUI' \
#--args "$trade_pool_id_1" \
#"$trade_pool_liquidity_token_id_1" \
#"$sui_coin_object_id_1" \
#'"1000"' \
#--gas-budget 100000000

# Owner add X token to trade pool / sell pool

# -------- Movescription as NFT --------
#sui client call --package "$di_package_id" --module movescription_sell_pool_service --function add_x_token \
#--type-args '0x2::sui::SUI' \
#--args \
#"$nft_service_config_object_id" \
#"$trade_pool_id_1" \
#"$trade_pool_liquidity_token_id_1" \
#"$movescription_object_id_4" \
#--gas-budget 100000000

# Owner remove X token from trade pool / sell pool / buy pool

# -------- Movescription as NFT --------
#sui client call --package "$core_package_id" --module trade_pool_service --function remove_x_token \
#--type-args "$movescription_package_id::movescription::Movescription" '0x2::sui::SUI' \
#--args "$trade_pool_id_1" \
#"$trade_pool_liquidity_token_id_1" \
#"$movescription_object_id_4" \
#--gas-budget 100000000

# Owner withdraw Y reserve from trade pool / sell pool / buy pool

# -------- Movescription as NFT --------
#sui client call --package "$core_package_id" --module trade_pool_service --function withdraw_y_reserve \
#--type-args "$movescription_package_id::movescription::Movescription" '0x2::sui::SUI' \
#--args "$trade_pool_id_1" \
#"$trade_pool_liquidity_token_id_1" \
#'"1000"' \
#"$sui_coin_object_id_1" \
#--gas-budget 100000000

# -------- buy pool tests --------
# Sell X token to buy pool

# -------- Movescription as NFT --------
#sui client call --package "$di_package_id" --module movescription_buy_pool_service --function sell_x \
#--type-args '0x2::sui::SUI' \
#--args \
#"$nft_service_config_object_id" \
#"$buy_pool_id_1" \
#"$movescription_object_id_5" \
#"$sui_coin_object_id_1" \
#'"100"' \
#--gas-budget 100000000

# ----------------------------------------------------------------------------------------
