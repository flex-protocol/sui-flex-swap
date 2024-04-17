# Sui Flex Swap

注意：本文的中文版本比较相对英文版本 [README.md](./README.md) 要简略，更详细信息请参考英文版本。

## 需求

需求简单描述：

* 前端可以显示支持的币对列表。

* 用户可以初始化流动性（创建新的可以 swap 的代币对）。

* 用户可以添加流动性。

* 前端可以显示当前账号所占的流动性份额。

* 前端可以显示代币对中的代币储备。即在 X-Y 币对中有多少代币 X 和代币 Y。

* 提供兑换功能。代币 X 换成代币 Y，或者反过来也可以。每笔兑换收取 0.3% 的手续费。

* 用户可以移除流动性。

* 用户“提供流动性”获得的收益来自于手续费，没有其他。


## 前置条件

[TBD]

## 测试应用

### 部署合约

执行以下命令部署合约：

```shell
sui client publish --gas-budget 1000000000 --skip-fetch-latest-git-deps
```

如果命令执行成功，在终端中会输出这次发布的交易摘要。 记录下这个交易摘要，比如 `AJoNuD8kstRtHjDzrKLJngfd7EanNy1v1GFHjSW4M5Uz`。
在设置链下服务的时候，我们需要用到它。

### 一些可能需要的准备工作

我们可能需要先给自己 mint 一些测试代币。

在本代码库中，包含一个部署测试代币（`EXAMPLE_COIN`）需要的 Move 文件（`example_coin.move`）。你可以单独为它创建一个 Move 项目，然后部署它。

注意，mint 测试币需要传入的第一个参数是一个类型为 `0x0000..0002::coin::TreasuryCap` 的对象的 Id。
你可以在部署合约时，终端的输出信息中发现它。

假设我们部署的测试币合约的包 Id 是 `{EXAMPLE_COIN_PACKAGE_ID}`，
那么，像下面这样给自己 mint 一些测试币：


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

记录下创建的测试币的 Coin 对象的 Id，比如 `0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55`：

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

注意初始化流动性函数所需要的参数，下面的命令假设：

* 模块 `liquidity_token` 的 publisher 对象的 Id 为 `0xeefacdaacffe5d94276a0b827c664a3abea9256a3bc82990c81cb74128f7d116`，
* 假设 `Exchange` 对象的 Id 是 `0xfc600b206b331c61bf1710bb04188d6aff2c9ceaf4e87acd75b6f2beeeb19bf6`，
* Sui 的 Coin 对象 Id 为 `0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294`，
* 测试币（EXAMPLE_COIN）Coin 对象的 Id 为 `0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55`。

所以，需要执行的命令类似下面这样：

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function initialize_liquidity \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'0xeefacdaacffe5d94276a0b827c664a3abea9256a3bc82990c81cb74128f7d116' \
'0xfc600b206b331c61bf1710bb04188d6aff2c9ceaf4e87acd75b6f2beeeb19bf6' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'"1000"' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' \
'"100000000"' \
--gas-budget 30000000
```

注意输出的 `TokenPair` 对象的 Id（在添加流动性的时候，我们需要使用它）：

```text
│  ┌──                                                                                                                                                                                                                               │
│  │ ObjectID: 0x8a7c305c010a481d49a74a2a8ad3148d20e38452eaacab0e720477f0e4d75acd                                                                                                                                                    │
│  │ Sender: 0x...                                                                                                                                                                                                                   │
│  │ Owner: Shared                                                                                                                                                                                                                   │
│  │ ObjectType: {CORE_PACKAGE_ID}::token_pair::TokenPair<0x2::sui::SUI, {EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN>            │
```

### 添加流动性

添加流动性：

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function add_liquidity \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'0x8a7c305c010a481d49a74a2a8ad3148d20e38452eaacab0e720477f0e4d75acd' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'"1000"' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' \
'"100000000"' [] \
--gas-budget 30000000
```

注意输出中的 `LiquidityToken` 对象的 Id：

```text
│ Created Objects:                                                                                                                                                                                                                   │
│  ┌──                                                                                                                                                                                                                               │
│  │ ObjectID: 0x3137df8f5a394a6566539aa2a1b287db52758ad254f7b2b008136cf7ef87bec8                                                                                                                                                    │
│  │ Sender: 0x...                                                                                                                                                                                                                   │
│  │ Owner: Account Address ( 0x... )                                                                                                                                                                                                │
│  │ ObjectType: {CORE_PACKAGE_ID}::liquidity_token::LiquidityToken<0x2::sui::SUI, {EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN>
```

### 移除流动性

移除流动性：

```shell
sui client call --package {CORE_PACKAGE_ID} --module token_pair_service --function remove_liquidity \
--type-args '0x2::sui::SUI' '{EXAMPLE_COIN_PACKAGE_ID}::example_coin::EXAMPLE_COIN' \
--args \
'0x8a7c305c010a481d49a74a2a8ad3148d20e38452eaacab0e720477f0e4d75acd' \
'0x3137df8f5a394a6566539aa2a1b287db52758ad254f7b2b008136cf7ef87bec8' \
'0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294' \
'0xa5fd542a85374df599d1800e8154b1897953f8de981236adcc45ebed15ff3d55' [] [] \
--gas-budget 30000000
```

### 兑换

兑换，以 Token X 换出 Token Y：

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

反方向兑换，以 Token Y 换出 Token X：

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

