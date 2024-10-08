# Sui Flex Swap

README 的中文版本和英文版本 [README.md](./README.md) 有差异。
关于本应用的“低代码开发”方面的介绍，请参考英文版本。


## 需求

一个 AMM Dex MVP，从前端用户体验角度，需求可以简单描述如下：

* 前端可以显示支持的币对列表。

* 用户可以初始化流动性（创建新的可以 swap 的代币对）。

* 用户可以添加流动性。

* 前端可以显示当前账号所占的流动性份额。

* 前端可以显示代币对中的代币储备。即在 X-Y 币对中有多少代币 X 和代币 Y。

* 提供兑换功能。代币 X 换成代币 Y，或者反过来也可以。默认每笔兑换收取 0.3% 的手续费。

* 用户可以移除流动性。

* 用户“提供流动性”获得的收益来自于手续费，没有其他。


## 前置条件

参考英文版本。

## 编码

参考英文版本。

## 测试应用

### 部署合约

执行以下命令部署合约：

```shell
sui client publish --gas-budget 1000000000 --skip-fetch-latest-git-deps
```

如果命令执行成功，在终端中会输出这次发布的交易摘要。 记录下这个交易摘要，在设置链下服务的时候，我们需要用到它。

#### Sui testnet 部署记录

```text
#-------- publish core package --------
publish core package. publish_core_txn_digest: 9k2iqeeV9Gnf95SNv1B6otnj5uVRLJHBLs6YbxsH2JoU
core_package_id: 0x1fbb91bd77221cf17450a4378f2d93100cf65725e0099e4da71f62070ce4b729

objectType: 0x1fbb91bd77221cf17450a4378f2d93100cf65725e0099e4da71f62070ce4b729::exchange::AdminCap
objectId: 0x020c65ea3d61d62c285c73ff7a3c44a60a11b28bf89576eb12c30ee4e66a140e

objectType: 0x2::package::UpgradeCap
objectId: 0x531be2f31853ca83d0e266b78a70fd7f46bde14a59580bdc30aca34abdb53be8

objectType: 0x2::package::Publisher
objectId: 0x609a06380cd877851c73dfbcb899c7ee593f5857bfd7280a0d9b2d0e5e88cc0f

objectType: 0x2::package::Publisher
objectId: 0x9a896d63b1f2c061a0d056951605edf0348201a8005ed0541410d7f4f67f5f0c

objectType: 0x1fbb91bd77221cf17450a4378f2d93100cf65725e0099e4da71f62070ce4b729::exchange::Exchange
objectId: 0xa556bc09e966ab42ddcc98b84bc1d26c00cc6438d8dc61a787cfc696200099e7

objectType: 0x2::coin::TreasuryCap<0x1fbb91bd77221cf17450a4378f2d93100cf65725e0099e4da71f62070ce4b729::example_coin::EXAMPLE_COIN>
objectId: 0xece35b44183b02df36ae544a2071ab5db5c46d957147fac5b3dbcc9d7066259f

objectType: 0x2::coin::CoinMetadata<0x1fbb91bd77221cf17450a4378f2d93100cf65725e0099e4da71f62070ce4b729::example_coin::EXAMPLE_COIN>
objectId: 0xffc28c95ac95373ed4ee603eb2a0c9096db06145f53d6549353ecfbaf2558f8c

example_coin_object_id_1: 0xcaf8f3c81d684f13d7a41df5d10645294fe3ab55533315d0fe66cdb6699c47a8
example_coin_object_id_2: 0x9078a7bb02147bc59b40fd67e61c363a842d0f81768d936ce173ab69b7acbc93
example_coin_object_id_3: 0xf716cb6d5278a1aae6f5be68825ef78aee38a66f0b302081384eefa35adf4c45
token_pair_object_id_1: 0x9c8cb597fdf33be9741308fa9e015e6de9fc78ef2dfc111995be8c4b396cd5cb
liquidity_token_object_id_1: 0x531ec6c8b54c8f2f6dcd511c960958d5d18f800319b8fba22f20125f9d6d7191

EXAMPLE_COIN_PACKAGE_ID: 0x1fbb91bd77221cf17450a4378f2d93100cf65725e0099e4da71f62070ce4b729
EXAMPLE_COIN_TREASURY_CAP_OBJECT_ID: 0xece35b44183b02df36ae544a2071ab5db5c46d957147fac5b3dbcc9d7066259f
```


### 一些可能需要的准备工作

我们可能需要先给自己 mint 一些测试代币。

在本代码库中，包含一个部署测试代币（`EXAMPLE_COIN`）需要的 Move 文件（`example_coin.move`）。你可以单独为它创建一个 Move 项目，然后部署它。

注意，mint 测试币需要传入的第一个参数是一个类型为 `0x0000..0002::coin::TreasuryCap` 的对象的 Id。
你可以在部署合约时，终端的输出信息中发现它。
假设我们部署的测试币合约的包 Id 是 `{EXAMPLE_COIN_PACKAGE_ID}`， 那么，像下面这样给自己 mint 一些测试币：


```shell
sui client call --package {EXAMPLE_COIN_PACKAGE_ID} --module example_coin --function mint \
--args {EXAMPLE_COIN_TREASURY_CAP_OBJECT_ID} 100000000000 --gas-budget 30000000
```

输出包含类似下面这样的内容：

```text
│ Created Objects:                                                                                                                       │
│  ┌──                                                                                                                                   │
│  │ ObjectID: 0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55                                                        │
│  │ Sender: 0x...                                                                                                                       │
│  │ Owner: Account Address ( 0x... )                                                                                                    │
│  │ ObjectType: 0x2::coin::Coin<{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN>         │
```

记录下 mint 得到的测试币的 Coin 对象的 Id，下面的测试可以使用它。

查看当前账户中的 Sui Coin 对象：

```shell
sui client gas
```

如果你的账户只有一个 Sui Coin 对象，可以先给自己的账户转一些 SUI，以达到 split 这个 Sui Coin 对象的目的。
下面的测试中，我们除了需要使用一个 Sui Coin 对象来付 gas 费之外，还需要使用一个 Sui Coin 对象来添加流动性：

```shell
sui client pay-sui --input-coins 0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294 --amounts 1000000000 \
--recipients 0xfc50aa2363f3b3c5d80631cae512ec51a8ba94080500a981f4ae1a2ce4d201c2 --gas-budget 30000000
```

### 初始化流动性

初始化流动性函数的参数：

* 类型参数 `X` 和 `Y` 表示代币对的两种代币类型。
    下面的命令假设我们的 X 代币是 SUI，所以类型参数是 `0x2::sui::SUI`；
    Y 代币是 EXAMPLE_COIN，所以类型参数是 `{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN`。
* x_coin: Coin<X>. 下面 Sui 的 Coin 对象 Id 为 `0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294`。
* x_amount: u64. 初始化存入的 X 代币的数量。
* y_coin: Coin<Y>. 下面假设 Y 代币（EXAMPLE_COIN）的 Coin 对象 Id 为 `0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55`。
* y_amount: u64. 初始化存入的 Y 代币的数量。

使用 Sui CLI 像下面这样执行命令：

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function initialize_liquidity \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'"1000"' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' \
'"100000000"' 3 1000 \
--gas-budget 30000000
```

注意记录下交易执行成功后输出的 `TokenPair` 对象的 Id（在添加流动性的时候，我们需要使用它）：

```text
│  ┌──                                                                                                                                                                                                                               │
│  │ ObjectID: 0x8a7c305c010a481d49a74a2a8ad3148d20e38452eaacab0e720477f0e4d75acd                                                                                                                                                    │
│  │ Sender: 0x...                                                                                                                                                                                                                   │
│  │ Owner: Shared                                                                                                                                                                                                                   │
│  │ ObjectType: {CORE_PACKAGE_ID}::token_pair::TokenPair<0x2::sui::SUI, {EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN>
```

### 添加流动性

添加流动性函数的参数：

* 类型参数 `X` 和 `Y` 表示代币对（池子）的两种代币类型。
* token_pair: &mut TokenPair<X, Y>. 上面初始化流动性的时候记录的 `TokenPair` 对象的 Id。
* x_coin: Coin<X>. 下面假设 Sui 的 Coin 对象 Id 为 `0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294`。
* x_amount: u64. 添加的 X 代币的数量。下面的示例假设为 `1000`。
* y_coin: Coin<Y>. 下面假设 Y 代币（EXAMPLE_COIN）的 Coin 对象 Id 为 `0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55`。
* y_amount: u64. 添加的 Y 代币的数量。下面的示例假设为 `100000000`。
* expected_liquidity_amount: Option<u64>. 期望获得的流动性 Token 的 amount（流动性 Token 可以理解为池子的“股份”）。
    本参数是可选的（以空数组表示“空值”；非空值以只有一个元素的数组来表示）。如果不提供，则表示不管获得多少流动性 token 交易的发送者都可以接受。

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function add_liquidity \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'0x8a7c305c010a481d49a74a2a8ad3148d20e38452eaacab0e720477f0e4d75acd' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'"1000"' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' \
'"100000000"' '[]' \
--gas-budget 30000000
```

注意输出中的 `LiquidityToken` 对象的 Id，移除流动性的时候，需要使用它。

```text
│ Created Objects:                                                                                                                                                                                                                   │
│  ┌──                                                                                                                                                                                                                               │
│  │ ObjectID: 0x3137df8f5a394a6566539aa2a1b287db52758ad254f7b2b008136cf7ef87bec8                                                                                                                                                    │
│  │ Sender: 0x...                                                                                                                                                                                                                   │
│  │ Owner: Account Address ( 0x... )                                                                                                                                                                                                │
│  │ ObjectType: {CORE_PACKAGE_ID}::liquidity_token::LiquidityToken<0x2::sui::SUI, {EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN>
```

### 移除流动性

移除流动性函数的参数：

* 类型参数 `X` 和 `Y` 表示代币对（池子）的两种代币类型。
* token_pair: &mut TokenPair<X, Y>.
* liquidity_token: LiquidityToken<X, Y>. 添加流动性时，获得的 `LiquidityToken` 对象的 Id。
* x_coin: &mut Coin<X>. 下面假设 X 代币（SUI）的 Coin 对象 Id 为 `0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294`。
* y_coin: &mut Coin<Y>. 下面假设 Y 代币（EXAMPLE_COIN）的 Coin 对象 Id 为 `0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55`。
* expected_x_amount: Option<u64>. 期望获得的 X 代币的数量。本参数是可选的。如果不提供，则表示不管获得多少 X 代币交易的发送者都可以接受。
* expected_y_amount: Option<u64>. 期望获得的 Y 代币的数量。本参数是可选的。如果不提供，则表示不管获得多少 Y 代币交易的发送者都可以接受。

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function remove_liquidity \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'0x8a7c305c010a481d49a74a2a8ad3148d20e38452eaacab0e720477f0e4d75acd' \
'0x3137df8f5a394a6566539aa2a1b287db52758ad254f7b2b008136cf7ef87bec8' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' '[]' '[]' \
--gas-budget 30000000
```

### 兑换

兑换，以 Token X 换出 Token Y，参数：

* token_pair: &mut TokenPair<X, Y>.
* x_coin: Coin<X>. 下面假设 X 代币（SUI）的 Coin 对象 Id 为 `0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294`。
* x_amount: u64. 打算兑换（换入）的 X 代币数量。
* y_coin: &mut Coin<Y>. 下面假设用于接受换出的 Y 代币（EXAMPLE_COIN）的 Coin 对象 Id 为 `0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55`。
* expected_y_amount_out: u64. 期望获得的 Y 代币的数量。如果合约计算发现实际可获得的 Y 代币数量小于这个值，则交易失败。关于如何计算这个值，可以参考下面的链下服务接口描述。

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

反方向兑换，以 Token Y 换出 Token X，函数的参数和 `swap_x` 函数类似，不再赘述。示例命令：

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

### 在 Exchange 中注册池子（token pair）

注意，这个操作需要合约的发布者（拥有 publisher 对象）来执行。

```shell
sui client call --package "$core_package_id" --module exchange_aggregate --function add_token_pair \
--type-args '0x2::sui::SUI' "$core_package_id"::example_coin::EXAMPLE_COIN \
--args \
"$exchange_object_id" \
"$publisher_object_id" \
"$token_pair_object_id" \
--gas-budget 30000000
```

### 更新池子的费率

你可以使用 Sui CLI 查看“池子”的信息：

```shell
sui client object {token_pair_object_id}
```

注意输出中的 `AdminCap` 对象的 ID：

```text
│               │ │ fields            │ ╭─────────────────┬───────────────────────────────────────────────────────────────────────────────╮                                                                                              │ │
│               │ │                   │ │ admin_cap       │  0x2308d22d64bfcfc4e3f1308f6fbcb2e052dc7286e57fe220c48daf535fb6aea3           │                                                                                              │ │
│               │ │                   │ │ fee_denominator │  1000                                                                         │                                                                                              │ │
│               │ │                   │ │ fee_numerator   │  3                                                                            │ 
```

这个对象是你创建交易对的时候，合约向你发送（transfer）的一个对象，代表了对这个“池子”管理权限。如果你想要更新这个“池子”的费率，你需要用到。

举例来说，假设池子的对象 ID 是 `0xba7d3a867b315f360f55f4f9ebab0bdd3f0669408512daf9abf9ddca122f0c61`，
它的 `AdminCap` 对象的 ID 是 `0x2308d22d64bfcfc4e3f1308f6fbcb2e052dc7286e57fe220c48daf535fb6aea3`（你需要拥有这个对象），
你想要将费率修改为 1/1000，可以这样执行命令：

```shell
sui client call --package 0xaa999d77147d4fff90d088823c85aac9b396fe97175dc9b7219a1c2ca71e44fa \
--module token_pair_aggregate --function update_fee_rate \
--type-args '0x2::sui::SUI' \
0xaa999d77147d4fff90d088823c85aac9b396fe97175dc9b7219a1c2ca71e44fa::example_coin::EXAMPLE_COIN \
--args 0xba7d3a867b315f360f55f4f9ebab0bdd3f0669408512daf9abf9ddca122f0c61 \
0x2308d22d64bfcfc4e3f1308f6fbcb2e052dc7286e57fe220c48daf535fb6aea3 \
1 1000 \
--gas-budget 30000000
```


### 测试链下服务

关于配置和启动链下服务，请参考英文版本。

#### 计算“初始化移动性”可获得的 Liquidity Amount

示例：

```shell
curl -X GET "http://localhost:1023/api/utils/calculateLiquidity?totalSupplied=0&xReserve=0&yReserve=0&xAmount=1000000&yAmount=1000000" -H "accept: application/json"
```

#### 计算“添加移动性”可获得的 Liquidity Amount

示例：

```shell
curl -X GET "http://localhost:1023/api/utils/calculateLiquidity?totalSupplied=999000&xReserve=1000000&yReserve=1000000&xAmount=500000&yAmount=500000" -H "accept: application/json"
```

查询参数说明：

* totalSupplied: 已经存入的流动性的总量。
* xReserve: 池子中 X 代币的储备量。
* yReserve: 池子中 Y 代币的储备量。
* xAmount: 打算存入的 X 代币数量。
* yAmount: 打算存入的 Y 代币数量。一般来说，存入的 X 代币数量和 Y 代币的比例应该和池子中的 X 代币数量和 Y 代币数量的比例一致，此时流动性提供者获得的收益最大。


#### 计算“移除流动性”可获得的 X 和 Y 代币数量

示例：

```shell
curl -X GET "http://localhost:1023/api/utils/calculateTokenPairAmountsOfLiquidity?totalSupplied=999000&xReserve=1000000&yReserve=1000000&liquidity=300000" -H "accept: application/json"
```

查询参数说明：

* totalSupplied: 已经存入的流动性的总量。
* xReserve: 池子中 X 代币的储备量。
* yReserve: 池子中 Y 代币的储备量。
* liquidity: 打算移除的流动性数量。

#### 计算“兑换 X”可获得的 Y 代币数量

示例：

```shell
curl -X GET "http://localhost:1023/api/utils/calculateSwapAmountOut?xReserve=500000&yReserve=500000&xAmountIn=100000&feeNumerator=3&feeDenominator=1000" -H "accept: application/json"
```

查询参数说明：

* xReserve: 池子中 X 代币的储备量。
* yReserve: 池子中 Y 代币的储备量。
* xAmountIn: 打算换入的 X 代币数量。
* feeNumerator: 手续费的分子。
* feeDenominator: 手续费的分母。在上面的示例中，手续费是 `0.3%`。


### 关于链下服务 API

我们的链下服务将链上的对象状态拉取到链下的 SQL 数据库，以提供查询功能。这样一个链下服务有时候也被称为 indexer。

我们当然可以先使用 Sui 官方提供的 API 服务，见：https://docs.sui.io/references/sui-api
但是，有些应用特定的查询需求，Sui 官方的 API 服务可能并不能满足，所以，很多应有都有必要自己搭建或者使用第三方提供的增强的查询或检索服务。

默认情况下，我们生成的链下服务提供了一些开箱即用的 API。你可以阅读 DDDML 模型文件，然后参考下面的示例来推断有哪些 API 可以使用。

比如，在我们这个项目中，你可以这样获取代币对列表：

```text
http://localhost:1023/api/TokenPairs
```

这里你甚至可以使用查询条件：

```text
http://localhost:1023/api/TokenPairs?totalLiquidity=gt(100)&x_Reserve.tick=MOVE
```

获取某个代币对的信息：

```text
http://localhost:1023/api/TokenPairs/0xe5bb0aa9fcd7ce57973bd3289f5b1ab0f946c47f3273641c3527a5d26775a5ac
```

获取流动性 Token 的列表：

```text
http://localhost:1023/api/LiquidityTokens
```

获取某个流动性 Token 的信息：

```text
http://localhost:1023/api/LiquidityTokens/0x1c934038fbb356446add349062e9fad959820c5998c80f6f363969d07288cb16
```

#### 获取实体列表的查询参数

可以在获取列表的请求 URL 中支持的查询参数，包括：

* sort：用于排序的属性名称。多个属性名称可以英文逗号分隔。属性名称前面有“-”则表示倒序排列。
  查询参数 `sort` 还可以多次出现，像这样：`sort=fisrtName&sort=lastName,desc`。
* fields：需要返回的字段（属性）名称。多个名称可以逗号分隔。
* filter：返回结果的过滤器，后文会进一步解释。
* firstResult：返回结果中第一条记录的序号，从 0 开始计算。
* maxResults：返回结果的最大记录数量。

#### 获取实体列表的 Page 封包

虽然我个人并不喜欢“封包”，但是因为有些开发人员强烈要求，我们还是支持发送 GET 请求到这个 URL 以获取的列表的 Page（分页）封包：

```url
{BASE_URL}/{Entities}/_page?page={page}
```

支持的分页相关的查询参数：

* page：获取第几页（从 0 开始）。
* size：Page size。

比如：

```text
http://localhost:1023/api/TokenPairs/_page?page=0&size=10
```

#### 还需要更多的查询功能？

由于链下服务已经将链上的对象状态拉取到链下的 SQL 数据库，所以，我们可以使用任意 SQL 查询语句来查询链下服务的数据库。
将这些 SQL 查询语句封装成 API，是非常容易的事情。如果你有这样的需求，修改源代码，添加你需要的 API 即可。

