# Sui Swap Example

## Requirements

This is a Sui Move sample project for teaching purposes. The client is a Web3 developer education institution, and the requirements are brief:

> Build a Simple Token Swap dApp using Sui Move
>
> **Overview**: We are creating a basic dApp to allow users to trade one cryptocurrency for another on the Sui blockchain. We need two main components: a smart contract and a simple frontend.
>
> * The token swap dApp contract should be straightforward, focusing only on the swapping feature. We don't need the other DEX features.
> * The smart contract code must include comments to explain how it works.
> * A basic frontend should be provided for users to interact with the dApp.

Let's further clarify the requirements so that we can better determine the workload in the next step.

From the front-end, the dApp would look roughly like this:

* First we would display a list of supported token pairs, TokenX-TokenY, TokenY-TokenZ and so on. Of course, at first, this list is empty.

* Users can "initialize liquidity". i.e. add a new swappable token pair TokenX-TokenY, by providing some amount of TokenX and TokenY.

* Of course, after the token pair is initialized, users can continue to "add liquidity" to the token pair.

* The front-end displays the current account's share of liquidity in the current token pair where appropriate. Of course, at this point the user should already have connected a wallet.

* The front-end has a place to show the "token reserves" in a token pair. That is, the amount of TokenX and TokenY are in the pair TokenX-TokenY.

* For already supported token pair, e.g. TokenX-TokenY, user can "swap" TokenX for TokenY, or vice versa. Each swap transaction is charged 0.3% of the target token as a fee.

* Users can "remove liquidity ". This means that by destroying their share of TokenX-TokenY liquidity, they can get a certain amount of TokenX and TokenY back.

* The revenue that the user receives for providing liquidity comes from the fee and nothing else.

From a front-end UX perspective, the main features are those above.

The internal implementation of the smart contract will be kept as simple as possible, as long as it is sufficient to illustrate the basic principles of the DEX using the AMM model.

Here, let's try to develop it using the dddappp low-code tool.

## Prerequisites

Currently, the dddappp low-code tool is published as a Docker image for developers to experience.

So before getting started, you need to:

* Install [Sui](https://docs.sui.io/build/install).

* Install [Docker](https://docs.docker.com/engine/install/).


## Programming

### Write DDDML Model File

In the `dddml` directory in the root of the repository, create a DDDML file like [this](./dddml/swap.yaml).


> **Tip**
>
> About DDDML, here is an introductory article: ["Introducing DDDML: The Key to Low-Code Development for Decentralized Applications"](https://github.com/wubuku/Dapp-LCDP-Demo/blob/main/IntroducingDDDML.md).


### Run dddappp Project Creation Tool

#### Update dddappp Docker Image

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


### Implementing Business Logic

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

[TBD]




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

