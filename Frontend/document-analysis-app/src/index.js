import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import { Amplify } from "aws-amplify";
import awsConfig from "./aws-exports";

Amplify.configure(awsConfig);

ReactDOM.render(<App />, document.getElementById("root"));