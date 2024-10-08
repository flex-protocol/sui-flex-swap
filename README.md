# Flex Swap - Move

Flex DEX Move, designed for FT <> FT and NFT <> FT trading with indexer support. We will transition our DEX to Solidity to integrate with EVM infrastructure. This document provides an overview of our Move implemetaion.

- main branch has FT <> FT
- nft branch has NFT <> FT 

---

## Migration to Solidity

As we move Flex DEX from Move to Solidity, the goal is to retain core functionalities while adapting them to the EVM architecture. Below are the key concepts and methods for implementing Flex DEX in Solidity.

### Core Concepts

#### Token Standards
- **ERC-20 (Fungible Tokens)**: Equivalent to FT in Move. These represent assets like USDC, ETH, and other tokens swappable on Flex DEX.
- **ERC-721 (Non-Fungible Tokens)**: Used for unique assets.
- **ERC-1155 (Multi-Token Standard)**: Supports both fungible and non-fungible behavior.

#### Liquidity Pools
- **FT <> FT Pools**: Enable direct swaps between fungible tokens, similar to Uniswap’s model.
- **NFT <> FT Pools**: Facilitate NFT <> FT swaps using ERC-721 and ERC-1155 contracts paired with ERC-20 tokens. Ensure robust pricing mechanisms for NFTs, involving bonding curves.

#### Swap Mechanisms
- **FT <> FT Swaps**: Implemented via standard AMM logic, handling liquidity provision, trading, and fee distribution.
- **NFT <> FT Swaps**: Custom logic for NFT <> FT swaps to account for NFT uniqueness and manage liquidity effectively.

#### Migration of Move-Specific Features
- **Resource-Oriented Design**: Translate Move’s resource-oriented design to Solidity, leveraging ownership and access control features.
- **Function Mapping**: Map Move functions to Solidity equivalents.

---

## In-Game AMM with Unified Resource Management

As we transition Flex DEX from Move to Solidity, our focus is also on creating a custom in-game AMM (already build in Move) that allows seamless trading of resources (ERC-20) and products (ERC-1155) within the game’s ecosystem. This AMM will be unique to each island, fostering localized economies where players can trade, craft, and decompose items.

#### Unified Resource Management

- **Root Resource Structure**: We'll manage both ERC-20 resources (e.g., wood, iron) and ERC-1155 products (e.g., sword, axe) under a unified structure. This allows for consistent handling of all assets within the AMM, making it easy to decompose and recombine items as needed.

- **ERC-20 & ERC-1155 Compliance**: While the AMM operates within the game, all tokens will adhere to their respective standards, ensuring they function seamlessly in this custom environment.

#### In-Game AMM Functionality

- **Decomposition**: Composite products (ERC-1155) can be broken down into their base resources (ERC-20) directly within the AMM. The system uses predefined recipes stored on-chain to manage this process.

- **Combination**: Combine resources into products. The AMM will automatically craft the product based on the resources deposited after the decomposed resources are traded.

- **Single Interface for Trading**: Players interact with one interface to trade items with same root resources. The AMM handles all the logic behind the scenes, ensuring a smooth user experience.

- **Island-Owned AMMs**: Each island in the game will have its own AMM, controlled by the island owner. This setup allows for custom rules, fees, and economic strategies tailored to each island’s needs.

#### Resource Liquidity Management

- **Minimum Pool Requirements**: To maintain stability, the AMM enforces minimum resource levels. This ensures that key resources are always available, preventing issues during decompositions, combination and trades.

- **Customizable Rules**: Island owners can configure their AMM to suit their strategy.

#### Some Benefits

- **Self-Contained Economy**: By keeping all trades within the game, we maintain a controlled, immersive in-game economy.
- **Simplified UX**: The AMM abstracts the complexity, letting players focus on gameplay rather than underlying mechanics.
- **Strategic Depth**: Islands can specialize and control their local economies, adding layers of strategy to the game.

---

## Integration with Story Protocol

To integrate with Story Protocol's infrastructure, we will adapt Flex DEX functionalities to accommodate the specific token usecases on Story. Here are the mappings and features, along with the relevant functions:

Types of Pools focused toward Story Assets
- **IPA <> USDC/ETH (NFT <> FT)**: This will allow trading of IP Assets (IPA) with fungible tokens like USDC or ETH.
- **LT <> RT (NFT <> FT)**: This feature enables the exchange of License Tokens (LT) for Royalty Tokens (RT).
- **LT <> FT (NFT <> FT)**: License Tokens can be traded directly with fungible tokens.


For NFT <> FT Pool creation and swap -  Buy, Sell, Trade check [nft branch readme](https://github.com/flex-protocol/sui-flex-swap/tree/nft?tab=readme-ov-file#sell-pool--buy-pool--trade-pool)

- **RT <> FT (FT <> FT)**: Royalty Tokens can be bought and sold using fungible tokens.
- **FT <> FT**: Flex DEX already supports this, enabling direct swaps between different fungible tokens.


For FT <> FT Pool creation and swap - check below.

---


## Requirements

From the front-end, the Dapp would look roughly like this:

* First we would display a list of supported token pairs, TokenX-TokenY, TokenY-TokenZ and so on. Of course, at first, this list is empty.

* Users can "initialize liquidity". i.e. add a new swappable token pair TokenX-TokenY, by providing some amount of TokenX and TokenY.

* Of course, after the token pair is initialized, users can continue to "add liquidity" to the token pair.

* The front-end displays the current account's share of liquidity in the current token pair where appropriate. Of course, at this point the user should already have connected a wallet.

* The front-end has a place to show the "token reserves" in a token pair. That is, the amount of TokenX and TokenY are in the pair TokenX-TokenY.

* For already supported token pair, e.g. TokenX-TokenY, user can "swap" TokenX for TokenY, or vice versa. A fee of 0.3% will be charged for each transaction.

* Users can "remove liquidity". This means that by destroying their share of TokenX-TokenY liquidity, they can get a certain amount of TokenX and TokenY back.

* The revenue that the user receives for providing liquidity comes from the fee and nothing else.

From a front-end UX perspective, the main features are those above.

Here, let's try to develop it using the [dddappp](https://www.dddappp.org) low-code tool.

## Prerequisites

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
--suiMoveProjectDirectoryPath /myapp/sui-contracts \
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

After the above command is successfully executed, two directories `sui-java-service` and `sui-contracts` should be added to the local current directory.


### Implementing business logic

The tool has generated some files with the suffix `_logic.move` in the directory `sui-contracts/sources`.

Generally, these files contain the scaffolding code of functions that implement business logic,
namely the signature part of the functions.
You just need to fill in the implementation part of the functions.

[TBD]

---

In [the model file](./dddml/swap.yaml), we defined some methods which use `Balance`, a resource type, as type of parameters or return values.
This makes these methods very combinable - as a developer of Move, a "resource-oriented programming" language,
you will already know this.

However, it's not easy to call them directly from clients.
So, we added this file [token_pair_service.move](./sui-contracts/sources/token_pair_service.move).
In this file, some entry functions are provided to facilitate clients to use the corresponding features directly.

That's the whole programming routine, isn't it simple?

## Test Application

### Deploy contract

Execute the following command in the directory `sui-contracts` to publish the contracts on chain:

```shell
sui client publish --gas-budget 1000000000 --skip-fetch-latest-git-deps
```

If the command is executed successfully, the transaction digest of this publication will be output. 

Take note of this transaction digest, for example, `AJoNuD8kstRtHjDzrKLJngfd7EanNy1v1GFHjSW4M5Uz`.
When setting up the off-chain service, we will need it.


### Some preparations might be needed

We may need to mint ourselves some test coins first.

Included in this repository is a Move file (`example_coin.move`) that is needed to deploy a test coin (`EXAMPLE_COIN`).
You can create a separate Move project for it and deploy it.

Note that the first argument that needs to be passed to mint test coin is the ID of an object of type `0x0000..0002::coin::TreasuryCap`.
You can find it in the output message of the terminal when you deploy the contract.

Let's say the package ID of the test coin contract we deployed is `{EXAMPLE_COIN_PACKAGE_ID}`.
Then, mint yourself some test coins like the following:

```shell
sui client call --package {EXAMPLE_COIN_PACKAGE_ID} --module example_coin --function mint \
--args {EXAMPLE_COIN_TREASURY_CAP_OBJECT_ID} 100000000000 --gas-budget 30000000
```

The output contains something like the following:

```text
│ Created Objects:                                                                                                                       │
│  ┌──                                                                                                                                   │
│  │ ObjectID: 0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55                                                        │
│  │ Sender: 0x...                                                                                                                       │
│  │ Owner: Account Address ( 0x... )                                                                                                    │
│  │ ObjectType: 0x2::coin::Coin<{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN>
```

Record the ID of the test coin object created, for example `0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55`:

View the Sui coin objects in the current account:

```shell
sui client gas
```

If you have only one SUI coin object in your account, you can transfer some SUI to your account first to split this SUI coin object.
In the following test, we need to use a SUI coin object to add liquidity in addition to a SUI coin object to pay gas fee:

```shell
sui client pay-sui --input-coins 0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294 --amounts 1000000000 \
--recipients 0xfc50aa2363f3b3c5d80631cae512ec51a8ba94080500a981f4ae1a2ce4d201c2 --gas-budget 30000000
```

### Initialize liquidity


Note the arguments required by "initialize liquidity" function, which are assumed by the following commands:

* The ID of the publisher object for module `liquidity_token` is `0xeefacdaacffe5d94276a0b827c664a3abea9256a3bc82990c81cb74128f7d116`.
* The object ID of `Exchange` is `0xfc600b206b331c61bf1710bb04188d6aff2c9ceaf4e87acd75b6f2beeeb19bf6`.
* SUI coin object ID is `0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294`.
* The ID of the test (`EXAMPLE_COIN`) coin object is `0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55`.

So, the command that needs to be executed is similar to the following:

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function initialize_liquidity \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'0xeefacdaacffe5d94276a0b827c664a3abea9256a3bc82990c81cb74128f7d116' \
'0xfc600b206b331c61bf1710bb04188d6aff2c9ceaf4e87acd75b6f2beeeb19bf6' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'"1000"' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' \
'"100000000"' 3 1000 \
--gas-budget 30000000
```

Note the ID of the output `TokenPair` object (we need to use it when adding liquidity):

```text
│  ┌──
│  │ ObjectID: 0x8a7c305c010a481d49a74a2a8ad3148d20e38452eaacab0e720477f0e4d75acd
│  │ Sender: 0x...
│  │ Owner: Shared
│  │ ObjectType: {CORE_PACKAGE_ID}::token_pair::TokenPair<0x2::sui::SUI, {EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN>
```

### Add liquidity

Add liquidity:

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function add_liquidity \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'{TOKEN_PAIR_OBJECT_ID}' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'"1000"' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' \
'"100000000"' [] \
--gas-budget 30000000
```

Note the ID of the `LiquidityToken` object in the output:

```text
│ Created Objects:                                                                                                                                                                                                                   │
│  ┌──                                                                                                                                                                                                                               │
│  │ ObjectID: 0x3137df8f5a394a6566539aa2a1b287db52758ad254f7b2b008136cf7ef87bec8                                                                                                                                                    │
│  │ Sender: 0x...                                                                                                                                                                                                                   │
│  │ Owner: Account Address ( 0x... )                                                                                                                                                                                                │
│  │ ObjectType: {CORE_PACKAGE_ID}::liquidity_token::LiquidityToken<0x2::sui::SUI, {EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN>  │
```

### Remove liquidity

Remove liquidity:

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function remove_liquidity \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'{TOKEN_PAIR_OBJECT_ID}' \
'{LIQUIDITY_TOKEN_OBJECT_ID}' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' [] [] \
--gas-budget 30000000
```

### Swap tokens

Swap, to exchange Token X for Token Y:

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function swap_x \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'0x8a7c305c010a481d49a74a2a8ad3148d20e38452eaacab0e720477f0e4d75acd' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'"100"' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' \
'"9060000"' \
--gas-budget 30000000
```

In the opposite direction, Token Y is exchanged for Token X:

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function swap_y \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'0x8a7c305c010a481d49a74a2a8ad3148d20e38452eaacab0e720477f0e4d75acd' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' \
'"9060000"' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'"90"' \
--gas-budget 30000000
```

### Test off-chain service

#### Configuring off-chain Service

Open the `application-test.yml` file located in the directory `sui-java-service/suiswapexample-service-rest/src/main/resources` and set the publishing transaction digest.

After setting, it should look like this:

```yaml
sui:
  contract:
    jsonrpc:
      url: "https://fullnode.devnet.sui.io/"
    package-publish-transaction: "267z86Ge4Phdow8AH424uw9WPqBhrGSUbjMsuA6cpEzp"
```

This is the only place where off-chain service need to be configured, and it's that simple.


#### Creating a database for off-chain service

Use a MySQL client to connect to the local MySQL server and execute the following script to create an empty database (assuming the name is `flex_testnet_ft`):

```sql
CREATE SCHEMA `flex_testnet_ft` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
```

Go to the `sui-java-service` directory and package the Java project:

```shell
mvn package
```

Then, run a command-line tool to initialize the database:

```shell
java -jar ./suiswapexample-service-cli/target/suiswapexample-service-cli-0.0.1-SNAPSHOT.jar ddl -d "./scripts" -c "jdbc:mysql://127.0.0.1:3306/flex_testnet_ft?enabledTLSProtocols=TLSv1.2&characterEncoding=utf8&serverTimezone=GMT%2b0&useLegacyDatetimeCode=false" -u root -p 123456
```

#### Starting off-chain Service

In the `sui-java-service` directory, run the following command to start the off-chain service:

```shell
mvn -pl suiswapexample-service-rest -am spring-boot:run
```


### About Off-Chain Service APIs

The off-chain service pulls the state of objects on chain into an off-chain SQL database to provide query functionality.
Such an off-chain service is sometimes called an indexer.

We can certainly start by using Sui's official API service, see: https://docs.sui.io/references/sui-api

However, there are some application-specific query requirements that Sui's official API service may not be able to fulfill,
so it should be necessary to build your own or use enhanced query or indexer services provided by third parties.

By default, the off-chain service provide some out-of-the-box APIs - developers don't even need to write a single line of code for this.
You can read the DDDML model files and then refer to the examples below to infer what APIs are available.

For example, in our project, you can HTTP GET the list of token pairs from the URL like this:

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

#### Query parameters for getting entity lists

Query parameters that can be supported in the request URL for getting a list, including:

* `sort`: The name of the property to be used for sorting. Multiple names can be separated by commas.
  A "-" in front of the name indicates reverse order.
  The query parameter `sort` can appear multiple times, like this: `sort=fisrtName&sort=lastName,desc`.
* `fields`: The names of the fields (properties) to be returned.
  Multiple names can be separated by commas.
* `filter`: The filter to return the result, explained further later (TBD).
* `firstResult`: The ordinal number of the first record returned in the result, starting from `0`.
* `maxResults`: The maximum number of records returned in the result.

#### Getting the entity list's page envelope

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
It is very easy to encapsulate these SQL query statements into APIs.
If you have such a need, modify the source code and add the APIs you need.


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

