import React from "react";
import { newContextComponents } from "@drizzle/react-components";
import { Card } from "../src/ships/Card/Card.controller";

const { AccountData, ContractData, ContractForm } = newContextComponents;

export default ({ drizzle, drizzleState }) => {
  // destructure drizzle and drizzleState from props
  return (
    <div className="App">

      <div className="section">
        <h2>Ethroulette</h2>
        <p>
          Value of <b>owner</b>:&nbsp;
          <ContractData drizzle={drizzle} drizzleState={drizzleState} contract="EthRoulette" method="owner" />
        </p>
        
        <p>
          Call function <b>addEther</b>
        </p>
        <ContractForm drizzle={drizzle} contract="EthRoulette" method="addEther" sendArgs={{ value: 1000000000000000000 }} />
        <p>
          Call function <b>addEther</b> as {drizzleState.accounts[1]}
        </p>
        <ContractForm
          drizzle={drizzle}
          contract="EthRoulette"
          method="addEther"
          sendArgs={{ from: drizzleState.accounts[1], value: 2000000000000000000 }}
        />
        <p>
          Call function <b>bet</b>
        </p>
        <ContractForm drizzle={drizzle} contract="EthRoulette" method="bet" sendArgs={{ from: drizzleState.accounts[0], value: 10000000000000000, gas: 240000 }}/>
        <p>
          Call function <b>spinWheel</b>
        </p>
        <ContractForm drizzle={drizzle} contract="EthRoulette" method="spin" sendArgs={{ gas: 240000 }}/>
        
        <div>
        <br></br>
        <b>All info</b>:&nbsp;
          <ContractData drizzle={drizzle} drizzleState={drizzleState} contract="EthRoulette" method="getInfo" render={(e) => <div> number of bets : {e[0]} value of active bets {e[1]} next playable timestamp : {e[2]} balance of the contract {e[3]} winnings : {e[4]} </div>}/>
        </div>

        <p>
          Call function <b>withdraw</b>
        </p>
        <ContractForm drizzle={drizzle} contract="EthRoulette" method="withdraw"/>
      </div>
    </div>
  );
};
