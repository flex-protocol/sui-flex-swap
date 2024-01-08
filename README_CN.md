# 一个 Sui Swap（DEX）示例应用

注意：本文的中文版本比较相对英文版本 [README.md](./README.md) 要简略，更详细信息请参考英文版本。

## 需求

这是一个 Sui Move 的示例项目，用于教学目的。客户是一个 Web3 开发者教育机构。 需求用中文简单说就是：

* 前端可以显示支持的币对列表。

* 用户可以初始化流动性（创建新的可以 swap 的代币对）。

* 用户可以添加流动性。

* 前端可以显示当前账号所占的流动性份额。

* 前端可以显示代币对中的代币储备。即在 X-Y 币对中有多少代币 X 和代币 Y。

* 提供兑换功能。代币 X 换成代币 Y，或者反过来也可以。每笔兑换收取 0.3% 的手续费。

* 用户可以移除流动性。

* 用户“提供流动性”获得的收益来自于手续费，没有其他。

以“教程”为目的，实现可以尽可能简单。

## 前置条件

[TBD]

## 测试应用

### 一些可能需要的准备工作

#### 准备 SUI coin 对象

查看当前账户中的 SUI Coin 对象：

```shell
sui client gas
```

如果你的账户只有一个 Sui Coin 对象，可以先给自己的账户转一些 SUI，以达到 split 这个 Sui Coin 对象的目的。
下面的测试中，我们除了需要使用一个 Sui Coin 对象来付 gas 费之外，还需要使用一个 Sui Coin 对象来添加流动性：

```shell
sui client pay-sui --input-coins 0x4715b65812e202a97f47f7dddf288776fabae989d1288c2e17c616c566abc294 --amounts 1000000000 \
--recipients 0xfc50aa2363f3b3c5d80631cae512ec51a8ba94080500a981f4ae1a2ce4d201c2 --gas-budget 30000000
```

#### Mint 一些 Movescription 代币

我们已经在 testnet 上部署了一个 movescription 测试合约，它的 package ID：`0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff`。

测试铭文 `MOVE` 的 `TickRecord` 的对象 ID：`0x34fccc1a953d02f3a7ddbd546e7982aff89c6989c8181d34e788bd855cb6ff64`。

注意使用 Sui CLI 测试时，先切换环境到 testnet：

```shell
sui client switch --env testnet
```

Mint 一些 `MOVE` 测试铭文（每次 mint 请间隔一分钟），注意，第三个参数，也就是下面示例的 `0x44e677e7fbfebef80d484eca63e350a1e8d9d5da4ab5a1e757d7e22a2d0a7b2c` 
应该改为你的一个 SUI Coin 对象的 Id。

```shell
sui client call --package 0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff --module movescription --function mint --args 0x34fccc1a953d02f3a7ddbd546e7982aff89c6989c8181d34e788bd855cb6ff64 \"MOVE\" 0x44e677e7fbfebef80d484eca63e350a1e8d9d5da4ab5a1e757d7e22a2d0a7b2c \"0x6\" --gas-budget 19000000
```

Split 一个铭文：

```shell
sui client call --package 0xf4090a30c92074412c3004906c3c3e14a9d353ad84008ac2c23ae402ee80a6ff --module movescription --function split --args  0xfc8debdede996da1901ec9090ac8d6cda8478705f6c8bad64056b540ff6b4f8c '"1000"' --gas-budget 19000000
```


### 部署合约

执行以下命令部署合约：

```shell
sui client publish --gas-budget 1000000000 --skip-fetch-latest-git-deps
```

如果命令执行成功，在终端中会输出这次发布的交易摘要。比如：

```*shell
*----- Transaction Digest ----
267z86Ge4Phdow8AH424uw9WPqBhrGSUbjMsuA6cpEzp
----- Transaction Data ----
#...
```

记录下这个交易摘要，比如 `267z86Ge4Phdow8AH424uw9WPqBhrGSUbjMsuA6cpEzp`。
在设置链下服务的时候，我们需要用到它。


### 初始化流动性

[TBD]

### 添加流动性

[TBD]

### 移除流动性

[TBD]

### 兑换

[TBD]

