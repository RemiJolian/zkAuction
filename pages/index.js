import Head from "next/head";
import Image from "next/image";
import styles from "../styles/Home.module.css";
import Web3Modal from "web3modal";
import { useState, useEffect } from "react";
import { ethers } from "ethers";
import WalletConnectProvider from "@walletconnect/web3-provider";
import { abi } from "../constants/abi";
import {
  INFURA_ID,
  AUCTION_CONTRACT_ADDRESS,
  NETWORK,
  NETWORKS,
} from "../constants/networks";

let web3Modal;

const targetNetwork = NETWORKS.rinkeby;

const providerOptions = {
  walletconnect: {
    package: WalletConnectProvider, // required
    options: {
      rpc: { 42: process.env.NEXT_PUBLIC_RPC_URL },
      // This is when it is deployed on Rinkeby testnet
      // infuraId: INFURA_ID,
      // network: "rinkeby",
    },
  },
};

if (typeof window !== "undefined") {
  web3Modal = new Web3Modal({
    network: "rinkeby",
    cacheProvider: false,
    providerOptions,
  });
}

export default function Home() {
  const [isConnected, setIsConnected] = useState(false);
  const [hasMetamask, setHasMetamask] = useState(false);
  const [signer, setSigner] = useState(undefined);

  useEffect(() => {
    if (typeof window.ethereum !== "undefined") {
      setHasMetamask(true);
    }
  });

  async function connect() {
    if (typeof window.ethereum !== "undefined") {
      try {
        const web3ModalProvider = await web3Modal.connect();
        setIsConnected(true);
        const provider = new ethers.providers.Web3Provider(web3ModalProvider);
        setSigner(provider.getSigner());
      } catch (e) {
        console.log(e);
      }
    } else {
      setIsConnected(false);
    }
  }

  async function sendBid(to, val) {
    if (typeof window.ethereum !== "undefined") {
      const contract = new ethers.Contract(
        AUCTION_CONTRACT_ADDRESS,
        abi,
        signer
      );
      try {
        await contract.sendBid(to, ethers.utils.parseEther(val));
      } catch (error) {
        console.log(error);
      }
    } else {
      console.log("Please install MetaMask");
    }
  }

  async function createAuction(val) {
    if (typeof window.ethereum !== "undefined") {
      const contract = new ethers.Contract(
        AUCTION_CONTRACT_ADDRESS,
        abi,
        signer
      );
      try {
        await contract.createAuction({ value: ethers.utils.parseEther(val) });
        console.log("Auction created! ");
      } catch (error) {
        console.log(error);
      }
    } else {
      console.log("Please install MetaMask");
    }
  }

  async function getBalance() {
    if (typeof window.ethereum !== "undefined") {
      const contract = new ethers.Contract(
        AUCTION_CONTRACT_ADDRESS,
        abi,
        signer
      );

      try {
        const balance = await contract.getAuction();
      } catch (error) {
        console.log(error);
      }
    } else {
      console.log("Please install MetaMask");
    }
  }

  return (
    <div>
      {hasMetamask ? (
        isConnected ? (
          "Connected! "
        ) : (
          <button onClick={() => connect()}>Connect</button>
        )
      ) : (
        "Please install metamask"
      )}

      {isConnected ? (
        <>
          <button
            onClick={() => {
              //reciever is the second hardhat account address, values are in Eth.
              createAuction("test auction", "09122022", 1);
            }}
          >
            sendReward
          </button>
          {/* <button onClick={() => deposit("0.5")}>sendBid</button> */}

          <button onClick={() => getAuction()}>Get Auction</button>
        </>
      ) : (
        ""
      )}
    </div>
  );
}
