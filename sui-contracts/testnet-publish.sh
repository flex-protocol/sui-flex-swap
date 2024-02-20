#!/bin/sh

cd utils

sui client publish --gas-budget 300000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json > testnet_utils_publish.json

publish_utils_txn_digest=$(cat testnet_utils_publish.json | jq -r '.digest')
echo "publish utils package txn_digest: $publish_utils_txn_digest"

if [ -z "$publish_utils_txn_digest" ]
then
echo "The publish_utils_txn_digest is empty, exit the script."
exit 1
fi

utils_package_id=$(cat testnet_utils_publish.json | jq -r '.objectChanges[] | select(.type == "published").packageId')
echo "utils package_id: utils_$utils_package_id"

# -------- update Move.toml --------
move_toml_file="Move.toml"
move_toml_temp="Move-temp.toml"
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
# if the line is "[addresses]", then add "published-at = $package_id" below it
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
# -------- end of update Move.toml --------


