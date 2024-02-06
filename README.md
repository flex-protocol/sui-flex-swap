# Sui Swap Example

## Requirements

It's worth noting that in the current version of the `nft` branch, token X refers to NFT.
And the `LiquidityToken` degenerates into a "capability" object.
We use it to control access to "add liquidity" and "remove liquidity".
The account that owns it can be thought of as the owner of the `TokenPair` (two-way trade pool).

This `nft` branch currently implements a NFT/FT `TokenPair` that supports the AMM model;
plus a simple "Sell Pool" (for selling NFTs).

One problem with using the AMM model to support NFT/FT swap is that the indivisibility of NFTs results in the "last NFT" being unsellable.
Because of the fixed-product formula of AMM, the amount of token Y needed to buy up token X is infinite.

When having `SellPool`, it can be said to be a complete MVP (Minimum Viable Product) now. 
The owner of the token pair can take out the last NFT in the `TokenPair` by removing all liquidity and create a `SellPool` to sell it.


### Sell Pool

The `SellPool` entity has some similarity to `TokenPair`.

* It has `ExchangeRateNumerator` and `ExchangeRateDenominator` properties, 
    which represent the "exchange rate" of NFT (X token) to Y token. (Similar to `fixed-exchange-rate` branch version.)
* Implement a linear price curve (exponential curve will be implemented later). 
    To do this, the pool needs a couple of properties: 
    for every `PriceDeltaX_Amount` sold, the price of X token increases by `PriceDeltaNumerator` / `PriceDeltaDenominator`.
* Anyone can create a Sell Pool.
* The owner of the pool can modify the NFT price related settings of the pool; 
    can add X token (NFT); can take out X token; can take out Y token (FT) reserve.
    The owner of the pool can destroy the pool.
* Methods of sell pool for general users include `BuyX`, i.e. "Swap-Y-For-X".


## Prerequisites

Here, let's try to develop it using the [dddappp](https://www.dddappp.org) low-code tool.

Currently, the dddappp low-code tool is published as a Docker image for developers to experience.

So before getting started, you need to:

* Install [Sui](https://docs.sui.io/build/install).

* Install [Docker](https://docs.docker.com/engine/install/).

* (Optional) Install MySQL database server if you want to test the off-chain service. The off-chain service generated by the tool currently use MySQL by default.

* (Optional) Install JDK and Maven if you want to test the off-chain service. The off-chain services generated by the tool currently use Java.

If you have already installed Docker, you can use Docker to run a MySQL database service. For example:

```shell
sudo docker run -p 3306:3306 --name mysql \
-v ~/docker/mysql/conf:/etc/mysql \
-v ~/docker/mysql/logs:/var/log/mysql \
-v ~/docker/mysql/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
-d mysql:5.7
```

## Programming

### Write DDDML model file

In the `dddml` directory in the root of the repository, create a DDDML file like [this](./dddml/swap.yaml).

> **Tip**
>
> About DDDML, here is an introductory article: ["Introducing DDDML: The Key to Low-Code Development for Decentralized Applications"](https://github.com/wubuku/Dapp-LCDP-Demo/blob/main/IntroducingDDDML.md).

There is one thing worth noting: why do we use property names like `X_Amount` in DDDML files - that is,
cases where one of the components of the property name is a "single letter".

The off-chain service code we generated was written in Java;
and Java Bean specification, in a way, 
does not handle correctly when converting various naming styles (e.g. `PascalCase`, `camelCase`, `snake_case`, etc.) 
for property names like `XAmount` is required.
To get around this problem, we decided to use property names like `X_Amount` instead of `XAmount`.

### Run dddappp project creation tool

#### Update dddappp Docker image

Since the dddappp v0.0.1 image is updated frequently, you may be required to manually delete the image and pull it again before `docker run`.

```shell
# If you have already run it, you may need to Clean Up Exited Docker Containers first
docker rm $(docker ps -aq --filter "ancestor=wubuku/dddappp:0.0.1")
# remove the image
docker image rm wubuku/dddappp:0.0.1
# pull the image
git pull wubuku/dddappp:0.0.1
```

---

In repository root directory, run:

```shell
docker run \
-v .:/myapp \
wubuku/dddappp:0.0.1 \
--dddmlDirectoryPath /myapp/dddml \
--boundedContextName Test.SuiSwapExample \
--suiMoveProjectDirectoryPath /myapp/sui-contracts/core \
--boundedContextSuiPackageName sui_swap_example \
--boundedContextJavaPackageName org.test.suiswapexample \
--javaProjectsDirectoryPath /myapp/sui-java-service \
--javaProjectNamePrefix suiswapexample \
--pomGroupId test.suiswapexample
```

The command parameters above are straightforward:

* This line `-v .:/myapp \` indicates mounting the local current directory into the `/myapp` directory inside the container.
* `dddmlDirectoryPath` is the directory where the DDDML model files are located. It should be a directory path that can be read in the container.
* Understand the value of the `boundedContextName` parameter as the name of the application you want to develop. When the name has multiple parts, separate them with dots and use the PascalCase naming convention for each part. Bounded-context is a term in Domain-driven design (DDD) that refers to a specific problem domain scope that contains specific business boundaries, constraints, and language. If you cannot understand this concept for the time being, it is not a big deal.
* `boundedContextJavaPackageName` is the Java package name of the off-chain service. According to Java naming conventions, it should be all lowercase and the parts should be separated by dots.
* `boundedContextSuiPackageName` is the package name of the on-chain Sui contracts. According to the Sui development convention, it should be named in snake_case style with all lowercase letters.
* `javaProjectsDirectoryPath` is the directory path where the off-chain service code is placed. The off-chain service consists of multiple modules (projects). It should be a readable and writable directory path in the container.
* `javaProjectNamePrefix` is the name prefix of each module of the off-chain service. It is recommended to use an all-lowercase name.
* `pomGroupId` is the GroupId of the off-chain service. We use Maven as the project management tool for off-chain service. It should be all lowercase and the parts should be separated by dots.
* `suiMoveProjectDirectoryPath` is the directory path where the on-chain Sui contract code is placed. It should be a readable and writable directory path in the container.

After the above command is successfully executed, two directories `sui-java-service` and `sui-contracts/core` should be added to the local current directory.


### Implementing business logic

The tool has generated some files with the suffix `_logic.move` in the directory `sui-contracts/core/sources`.

Generally, these files contain the scaffolding code of functions that implement business logic,
namely the signature part of the functions.
You just need to fill in the implementation part of the functions.

[TBD]

---

In [the model file](./dddml/swap.yaml), we defined some methods which use `Balance`, a resource type, as type of parameters or return values.
This makes these methods very combinable - as a developer of Move, a "resource-oriented programming" language,
you will already know this.

However, it's not easy to call them directly from clients.
So, we added this file [token_pair_service.move](sui-contracts/core/sources/token_pair_service.move).
In this file, some entry functions are provided to facilitate clients to use the corresponding features directly.

That's the whole programming routine, isn't it simple?

## Test Application

### Some preparations might be needed

#### Prepare some SUI coins

View the SUI coin objects in the current account:

```shell
sui client gas
```

If you have only one SUI coin object in your account, you can transfer some SUI to your account first to split this SUI coin object.
In the following test, we need to use a SUI coin object to add liquidity in addition to a SUI coin object to pay gas fee:

```shell
sui client pay-sui --input-coins 0x79e6fd15db671bdf426166a494f15845353701c742febb66e88fb61a4981a5d1 --amounts 1000000000 \
--recipients 0xfc50aa2363f3b3c5d80631cae512ec51a8ba94080500a981f4ae1a2ce4d201c2 --gas-budget 30000000
```

#### Mint some Movescription tokens

We use Movescription token `MOVE` as test NFT. Movescription is a community-driven inscription protocol on Move.

We have deployed a movescription test contract on testnet with package ID: `0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff`.

Object ID of the `TickRecord` used to mint the `MOVE` inscription: `0x34fccc1a953d02f3a7ddbd546e7982aff89c6989c8181d34e788bd855cb6ff64`.

Note that when testing with the Sui CLI, switch the environment to testnet first:

```shell
sui client switch --env testnet
```

Mint some test inscriptions (please allow one minute between each mint),
Note that the third parameter, `0x44e677e7fbfebef80d484eca63e350a1e8d9d5da4ab5a1e757d7e22a2d0a7b2c` 
in the example below should be changed to the ID of one of your SUI Coin objects.

```shell
sui client call --package 0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff --module movescription --function mint --args 0x34fccc1a953d02f3a7ddbd546e7982aff89c6989c8181d34e788bd855cb6ff64 \"MOVE\" 0x44e677e7fbfebef80d484eca63e350a1e8d9d5da4ab5a1e757d7e22a2d0a7b2c \"0x6\" --gas-budget 19000000
```

Maybe you want to quickly make some more inscription objects for testing, then, you can split an inscription object like this:

```shell
sui client call --package 0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff --module movescription --function split --args  0xfc8debdede996da1901ec9090ac8d6cda8478705f6c8bad64056b540ff6b4f8c '"1000"' --gas-budget 19000000
```

### Deploy contracts

#### Deploy core project

Execute the following command in the directory `sui-contracts/core` to publish the `core` project on chain:

```shell
sui client publish --gas-budget 900000000 --skip-fetch-latest-git-deps  --skip-dependency-verification
```

If the command is executed successfully, the transaction digest of this publication will be output. For example:

```text
Transaction Digest: J9DQm5BWs2tBxLF6DYpHRgQkA8CAgNs3btqsCAGKo6mb
```

Take note of this transaction digest, for example, `J9DQm5BWs2tBxLF6DYpHRgQkA8CAgNs3btqsCAGKo6mb`.
When setting up the off-chain service, we will need it.

For the next tests, we assume the deployed `core` package ID:

```text
│ Published Objects:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            │
│  ┌──                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          │
│  │ PackageID: 0x4fbbc944f3d38aaf0b287933659a424f356298067e610ff5d64ccbdf4d37e1f6
```

Record information about a number of objects created at the time of publishing. 
We use the following object IDs for the next tests:

```text
ObjectID: 0x9097b3003d6bd0503fe86ceb3293c70f88f22c4dba284d6f73494c3073278c29
ObjectType: 0x4fbbc944f3d38aaf0b287933659a424f356298067e610ff5d64ccbdf4d37e1f6::nft_service_config::NftServiceConfig

ObjectID: 0x28715920551bc548cca0f833a054f6d2fbc19265148201bfa1624cdc37783e9c
ObjectType: 0x4fbbc944f3d38aaf0b287933659a424f356298067e610ff5d64ccbdf4d37e1f6::nft_service_config::NftServiceConfigCap

ObjectID: 0x30fb3e33020c1a9f615ff571e86a207fd5d100e3515fa194a7e077ef90e4ef1b
ObjectType: 0x2::package::Publisher

ObjectID: 0x69f3d2f77b8a456d7fd9e972ab96af6abaf61e7d17c7923af70bdd95142a78f2
ObjectType: 0x2::package::Publisher

ObjectID: 0x9bc2c185436981202c28b01eb5804ab031b798886effc80d68b3bf9f9ad0ca67
ObjectType: 0x4fbbc944f3d38aaf0b287933659a424f356298067e610ff5d64ccbdf4d37e1f6::exchange::Exchange
```

Modify `sui-contracts/core/Move.toml`:

```toml
[package]
published-at = "0x4fbbc944f3d38aaf0b287933659a424f356298067e610ff5d64ccbdf4d37e1f6"

[addresses]
sui_swap_example = "0x4fbbc944f3d38aaf0b287933659a424f356298067e610ff5d64ccbdf4d37e1f6"
```

#### Deploy "nft-service-impl" project

Under the directory `sui-contracts/nft-service-impl`, publish the contract:

```shell
sui client publish --gas-budget 900000000 --skip-fetch-latest-git-deps  --skip-dependency-verification
```

Record the following information:

```text
Transaction Digest: C9Qtg299pT4nNRHvyKTaJUXXkSmZCAPfPvwFJPrZaGnb

│ Published Objects:                                                                               │
│  ┌──                                                                                             │
│  │ PackageID: 0x42e0b61dbc8942ba38268e9c9369c7748019f3b710e504466b4c1124cef52eb7                 │
```

Modify the file `/sui-contracts/nft-service-impl/Move.toml`:

```text
[package]
published-at = "0x42e0b61dbc8942ba38268e9c9369c7748019f3b710e504466b4c1124cef52eb7"

[addresses]
nft_service_impl = "0x42e0b61dbc8942ba38268e9c9369c7748019f3b710e504466b4c1124cef52eb7"
```

#### Deploy "di" project

Execute the following command in the directory `sui-contracts/di` to publish the `di` project on chain:

```shell
sui client publish --gas-budget 900000000 --skip-fetch-latest-git-deps  --skip-dependency-verification
```

Record the following information:

```text
Transaction Digest: NYsLLTaXRPAG2sZL9XcYo8z7ffjEfJJbYq8RgTh7RTM

│ Published Objects:                                                                               │
│  ┌──                                                                                             │
│  │ PackageID: 0x87e40eeda3466feca7c6a332b3dbc3512bbfbe460a6741b0788790449114bfdc                 │
```

#### Configure dependency injection allowlist

Execute the following:

```shell
sui client call --function add_allowed_impl --module nft_service_config --package 0x4fbbc944f3d38aaf0b287933659a424f356298067e610ff5d64ccbdf4d37e1f6 \
--type-args '0x42e0b61dbc8942ba38268e9c9369c7748019f3b710e504466b4c1124cef52eb7::movescription_service_impl::MovescriptionServiceImpl' \
--args 0x9097b3003d6bd0503fe86ceb3293c70f88f22c4dba284d6f73494c3073278c29 0x28715920551bc548cca0f833a054f6d2fbc19265148201bfa1624cdc37783e9c \
--gas-budget 300000000
```

### TokenPair tests

#### Initialize liquidity

Note the arguments required by the "initialize liquidity" function, which are assumed by the following commands:

* `_nft_service_config: &NftServiceConfig`: `0x9097b3003d6bd0503fe86ceb3293c70f88f22c4dba284d6f73494c3073278c29`.
* `exchange: &mut Exchange`: Assuming the ID of the `Exchange` object is `0x9bc2c185436981202c28b01eb5804ab031b798886effc80d68b3bf9f9ad0ca67`. 
* `x: Movescription`: The ID of the `Movescription` object is `0xf27bbf01517779ecc56a1487a20b028b713c648bec3ae3c7b0279c37a9921480`.
* `y_coin: Coin<Y>`: SUI coin object ID is `0x2d5aa8072b01f29fe074d4d0be89a33ebc4c4d63b6fc3bd0b611fde655a703e0`.
* `y_amount: u64`: `1000000`.
* `fee_numerator: u64`: `30`. We are going to set the pool fee rate to 0.3%.
* `fee_denominator: u64`: `10000`.

So, the command that needs to be executed is similar to the following:

```shell
sui client call --package 0x87e40eeda3466feca7c6a332b3dbc3512bbfbe460a6741b0788790449114bfdc --module movescription_swap_service --function initialize_liquidity \
--type-args '0x2::sui::SUI' \
--args \
'0x9097b3003d6bd0503fe86ceb3293c70f88f22c4dba284d6f73494c3073278c29' \
'0x9bc2c185436981202c28b01eb5804ab031b798886effc80d68b3bf9f9ad0ca67' \
'0xf27bbf01517779ecc56a1487a20b028b713c648bec3ae3c7b0279c37a9921480' \
'0x2d5aa8072b01f29fe074d4d0be89a33ebc4c4d63b6fc3bd0b611fde655a703e0' \
'"1000000"' \
'"30"' \
'"10000"' \
--gas-budget 100000000
```

Note the ID of the output `TokenPair` object (we need to use it when adding liquidity):

```text
│  │ ObjectID: 0xb7355c68ca3a475549124774603de9626ecec27dad223cd177e7422be2c2933c                                                    │
│  │ Sender: 0x...                                                                                                                  │
│  │ Owner: Shared                                                                                                                  │
│  │ ObjectType: 0x2301a3ea0ccba8d48360f1579c1f4ddfd976910b1c45919d9f2360d9294ae97::token_pair::TokenPair<...>                      │
```

And note the ID of the output `LiquidityToken` object:

```text
│  ┌──                                                                                               │
│  │ ObjectID: 0x22d93db8e5f477492b0c1ebfacaae89e3836dae62937ecd07215e5d52dd07e23                     │
│  │ Sender: 0xfc50aa2363f3b3c5d80631cae512ec51a8ba94080500a981f4ae1a2ce4d201c2                      │
│  │ Owner: Account Address ( 0xfc50aa2363f3b3c5d80631cae512ec51a8ba94080500a981f4ae1a2ce4d201c2 )   │
│  │ ObjectType: 0xf832b...::liquidity_token::LiquidityToken<...                                     │
```


#### Add liquidity

Add liquidity, the function parameters:

* `_nft_service_config: &NftServiceConfig`.
* `token_pair: &mut TokenPair<Movescription, Y>`.
* `liquidity_token: &mut LiquidityToken<Movescription, Y>`.
* `x: Movescription`: We assume another ID of the `Movescription` object is `0xf27bbf01517779ecc56a1487a20b028b713c648bec3ae3c7b0279c37a9921480`.
* `y_coin: Coin<Y>`.
* `y_amount: u64`.

```shell
sui client call --package 0x87e40eeda3466feca7c6a332b3dbc3512bbfbe460a6741b0788790449114bfdc --module movescription_swap_service --function add_liquidity \
--type-args '0x2::sui::SUI' \
--args \
'0x9097b3003d6bd0503fe86ceb3293c70f88f22c4dba284d6f73494c3073278c29' \
'0xb7355c68ca3a475549124774603de9626ecec27dad223cd177e7422be2c2933c ' \
'0x22d93db8e5f477492b0c1ebfacaae89e3836dae62937ecd07215e5d52dd07e23 ' \
'0xf27bbf01517779ecc56a1487a20b028b713c648bec3ae3c7b0279c37a9921480' \
'0x2d5aa8072b01f29fe074d4d0be89a33ebc4c4d63b6fc3bd0b611fde655a703e0' \
'"1000000"' \
--gas-budget 100000000
```

You can add liquidity multiple times.

#### Remove liquidity

Remove liquidity, the function parameters:

* `token_pair: &mut TokenPair<X, Y>`.
* `liquidity_token: &LiquidityToken<X, Y>`.
* `x_id: ID`: Assumes the ID of the NFT object you want to remove is `0xf27bbf01517779ecc56a1487a20b028b713c648bec3ae3c7b0279c37a9921480`.
* `y_coin: &mut Coin<Y>`: The SUI Coin object used to accept the balance.

Execute the following command:

```shell
sui client call --package 0x4fbbc944f3d38aaf0b287933659a424f356298067e610ff5d64ccbdf4d37e1f6 --module token_pair_service --function remove_liquidity \
--type-args '0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff::movescription::Movescription' '0x2::sui::SUI' \
--args \
'0xb7355c68ca3a475549124774603de9626ecec27dad223cd177e7422be2c2933c ' \
'0x22d93db8e5f477492b0c1ebfacaae89e3836dae62937ecd07215e5d52dd07e23 ' \
'0xf27bbf01517779ecc56a1487a20b028b713c648bec3ae3c7b0279c37a9921480' \
'0x2d5aa8072b01f29fe074d4d0be89a33ebc4c4d63b6fc3bd0b611fde655a703e0' \
--gas-budget 100000000
```


#### Swap token X for token Y

Swap, to exchange Movescription token  (i.e. token X)  for token Y.

The function parameters:

* `_nft_service_config: &NftServiceConfig`.
* `token_pair: &mut TokenPair<Movescription, Y>`.
* `x: Movescription`: Assumes that the Movescription object ID is `0xf210d8e4f0701c7e97b415c1258a0b942228f79ca4ff508ce7cae1c5dd27aeb4`.
* `y_coin: &mut Coin<Y>`: The SUI Coin object used to accept the balance.
* `expected_y_amount_out: u64`: The minimum acceptable output balance is expected.

Execute the following command:

```shell
sui client call --package 0x87e40eeda3466feca7c6a332b3dbc3512bbfbe460a6741b0788790449114bfdc --module movescription_swap_service --function swap_x \
--type-args '0x2::sui::SUI' \
--args \
'0x9097b3003d6bd0503fe86ceb3293c70f88f22c4dba284d6f73494c3073278c29' \
'0xb7355c68ca3a475549124774603de9626ecec27dad223cd177e7422be2c2933c ' \
'0xf210d8e4f0701c7e97b415c1258a0b942228f79ca4ff508ce7cae1c5dd27aeb4' \
'0x2d5aa8072b01f29fe074d4d0be89a33ebc4c4d63b6fc3bd0b611fde655a703e0' \
'"100"' \
--gas-budget 100000000
```

#### Swap token Y for token X

In the opposite direction, token Y is exchanged for token X (NFT). The function parameters:

* `token_pair: &mut TokenPair<X, Y>`.
* `y_coin: Coin<Y>`: The SUI Coin object you own.
* `y_amount: u64`: The amount of SUI coin you would like to pay.
* `x_id: ID`: Assumes the ID of the NFT object you want to get is `0xf210d8e4f0701c7e97b415c1258a0b942228f79ca4ff508ce7cae1c5dd27aeb4`.

So, execute the following command:

```shell
sui client call --package 0x4fbbc944f3d38aaf0b287933659a424f356298067e610ff5d64ccbdf4d37e1f6 --module token_pair_service --function swap_y \
--type-args '0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff::movescription::Movescription' '0x2::sui::SUI' \
--args '0xb7355c68ca3a475549124774603de9626ecec27dad223cd177e7422be2c2933c ' \
'0x2d5aa8072b01f29fe074d4d0be89a33ebc4c4d63b6fc3bd0b611fde655a703e0' \
'"1000000"' \
'0xf210d8e4f0701c7e97b415c1258a0b942228f79ca4ff508ce7cae1c5dd27aeb4' \
--gas-budget 100000000
```

### SellPool tests

[TBD]

### Test off-chain service

#### Configuring off-chain service

Open the `application-test.yml` file located in the directory `sui-java-service/suiswapexample-service-rest/src/main/resources` and set the published transaction digest.

After setting, it should look like this:

```yaml
sui:
  contract:
    jsonrpc:
      url: "https://fullnode.devnet.sui.io/"
    package-publish-transaction: "J9DQm5BWs2tBxLF6DYpHRgQkA8CAgNs3btqsCAGKo6mb"
```

This is the only place where off-chain service need to be configured, and it's that simple.


#### Creating a database for off-chain service

Use a MySQL client to connect to the local MySQL server and execute the following script to create an empty database (assuming the name is `test5`):

```sql
CREATE SCHEMA `test5` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
```

Go to the `sui-java-service` directory and package the Java project:

```shell
mvn package
```

Then, run a command-line tool to initialize the database:

```shell
java -jar ./suiswapexample-service-cli/target/suiswapexample-service-cli-0.0.1-SNAPSHOT.jar ddl -d "./scripts" -c "jdbc:mysql://127.0.0.1:3306/test5?enabledTLSProtocols=TLSv1.2&characterEncoding=utf8&serverTimezone=GMT%2b0&useLegacyDatetimeCode=false" -u root -p 123456
```

#### Starting off-chain service

In the `sui-java-service` directory, run the following command to start the off-chain service:

```shell
mvn -pl suiswapexample-service-rest -am spring-boot:run
```

### Off-chain service API

Our off-chain service pulls the state of objects on chain into an off-chain SQL database to provide query functionality.

We can certainly start by using Sui's official API service, see: https://docs.sui.io/references/sui-api

However, there are some application-specific query requirements that Sui's official API service may not be able to fulfill, 
so it should be necessary to build your own or use enhanced query or indexer services provided by third parties.

By default, the off-chain services we generate provide some out-of-the-box APIs. for example:

Get a list of token pairs:

```text
http://localhost:1023/api/TokenPairs
```

You can use query criteria:

```text
http://localhost:1023/api/TokenPairs?totalLiquidity=gt(100)&x_Reserve.tick=MOVE
```

Get the information of a token pair:

```text
http://localhost:1023/api/TokenPairs/0xe5bb0aa9fcd7ce57973bd3289f5b1ab0f946c47f3273641c3527a5d26775a5ac
```

Get a list of liquidity tokens:

```text
http://localhost:1023/api/LiquidityTokens
```

Get the information of a liquidity token:

```text
http://localhost:1023/api/LiquidityTokens/0x1c934038fbb356446add349062e9fad959820c5998c80f6f363969d07288cb16
```

#### Query parameters for getting lists

Query parameters that can be supported in the request URL for getting a list, including:

* `sort`: The name of the property to be used for sorting. Multiple names can be separated by commas. 
    A "-" in front of the name indicates reverse order. 
    The query parameter `sort` can appear multiple times, like this: `sort=fisrtName&sort=lastName,desc`.
* `fields`: The names of the fields (properties) to be returned. 
    Multiple names can be separated by commas.
* `filter`: The filter to return the result, explained further later (TBD).
* `firstResult`: The ordinal number of the first record returned in the result, starting from `0`.
* `maxResults`: The maximum number of records returned in the result.

#### Getting the list's page envelope

I personally don't like page "envelope", 
but because some developers requested it, 
we support sending a GET request to a URL to get a page envelope for the list:

```url
{BASE_URL}/{Entities}/_page?page={page}
```

Supported paging-related query parameters:

* `page`: Page number, starting from 0.
* `size`: Page size.

For example:

```text
http://localhost:1023/api/TokenPairs/_page?page=0&size=10
```

#### Need more query functionality?

Since the off-chain service already pulls the state of the objects on chain to the off-chain SQL database, 
we can query the off-chain service's database using any SQL query statement.
It is very easy to encapsulate these SQL query statements into an API. 
If you have such a need, modify the source code and add the API you need.


##  Further Reading

### Sui Crowdfunding Example

Another Sui Move sample project for teaching purposes. Repository: https://github.com/dddappp/sui-crowdfunding-example

You can refer to its README to refine the business logic of this project, as well as to test the application.

### Sui Blog Example

Repository: https://github.com/dddappp/sui-blog-example

It only requires 30 or so lines of code (all of which is a description of the domain model) to be written by the developer, and then generates a blog example that emulates [RoR Getting Started](https://guides.rubyonrails.org/getting_started.html) in one click, without requiring the developer to write a single line of other code.


### A More Complex Sui Demo

If you are interested, you can find a more complex Sui Demo here: ["A Sui Demo"](https://github.com/dddappp/A-Sui-Demo).


### Rooch Blog Example

Here is a Rooch version like above Sui blog example: https://github.com/rooch-network/rooch/blob/main/examples/blog/README.md

