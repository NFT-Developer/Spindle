import WalletConnectProvider from "@walletconnect/web3-provider";
import WalletLink from "walletlink";
import { Alert, Button, Col, Menu, Row } from "antd";
import "antd/dist/antd.css";
import React, { useCallback, useEffect, useState } from "react";
import { BrowserRouter, Link, Route, Switch } from "react-router-dom";
import Web3Modal from "web3modal";
import "./App.css";
import { Account, Contract, Faucet, GasGauge, Header, Ramp, ThemeSwitch } from "./components";
import { INFURA_ID, NETWORK, NETWORKS } from "./constants";
import { Transactor } from "./helpers";
import {
  useBalance,
  useContractLoader,
  useContractReader,
  useEventListener,
  useExchangePrice,
  useGasPrice,
  useOnBlock,
  useUserSigner,
} from "./hooks";
// import Hints from "./Hints";
import { ExampleUI, Hints, Subgraph } from "./views";

import NFTStorage from './components/nftstorage';

const { ethers } = require("ethers");
const val = 'bafybeifwseojvjrqpkcux6nx7xxmgofwrbl7eofplut4p7dxintf2kefju';

function App(props) {
  

  return (
    <div>
      <NFTStorage cid={val}/>
      Hello World
    </div>
  )
}

export default App;
