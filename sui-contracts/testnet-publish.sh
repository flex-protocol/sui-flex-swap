#!/bin/sh

move_toml_file="Move.toml"
move_toml_temp="Move-temp.toml"

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

jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file" | while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
done

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

jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file" | while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
done

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

jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file" | while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
done

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

jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file" | while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
done

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


# --------
