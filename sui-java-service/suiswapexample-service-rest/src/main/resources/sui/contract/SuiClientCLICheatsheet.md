# Sui Client CLI Cheatsheet

[ToC]

## TokenPair aggregate

### UpdateExchangeRate method

```shell
sui client call --package _PACKAGE_ID_ --module token_pair_aggregate --function update_exchange_rate \
--type-args 'X' 'Y' \
--args token_pair_Object_ID \"_LIQUIDITY_TOKEN<_X,_Y>_OBJECT_ID_\" \"u64_exchange_rate_numerator\" \"u64_exchange_rate_denominator\" \
--gas-budget 100000
```

## LiquidityToken aggregate

## Exchange singleton object

### Update method

```shell
sui client call --package _PACKAGE_ID_ --module exchange_aggregate --function update \
--args exchange_Object_ID \"_EXCHANGE_ADMIN_CAP_OBJECT_ID_\" '"string_name"' \
--gas-budget 100000
```


---

## Tips

You can escape single quotes in string arguments by using the following method when enclosing them within single quotes in a shell:

1. Close the current single quote.
2. Use a backslash `\` to escape the single quote.
3. Open a new set of single quotes to continue the string.

Here is an example of how to escape a single quote within a string enclosed by single quotes in a shell:

```shell
echo 'It'\''s a beautiful day'
```

