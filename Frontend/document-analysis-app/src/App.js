import React from "react";
import { withAuthenticator } from "@aws-amplify/ui-react";

function App({ signOut, user }) {
  return (
    <div style={{ textAlign: "center", padding: "50px" }}>
      <h1>Welcome, {user.username}!</h1>
      <p>You are signed in.</p>
      <button onClick={signOut}>Sign Out</button>
    </div>
  );
}

export default withAuthenticator(App);