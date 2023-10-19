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

[TBD]