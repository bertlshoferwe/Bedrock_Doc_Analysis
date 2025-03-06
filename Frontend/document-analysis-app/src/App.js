import React, { useState } from "react";
import { withAuthenticator } from "@aws-amplify/ui-react";
import { Storage } from "aws-amplify";


function App({ signOut, user }) {
  const [file, setFile] = useState(null);

  const uploadFile = async () => {
    if (!file) return;

    const fileName = `private/${user.attributes.sub}/${file.name}`;
    
    try {
      await Storage.put(fileName, file, {
        contentType: file.type,
      });
      alert("File uploaded successfully!");
    } catch (error) {
      console.error("Upload failed:", error);
    }
  };

  return (
    <div style={{ textAlign: "center", padding: "50px" }}>
      <h1>Welcome, {user.username}!</h1>
      <p>You are signed in.</p>
      <button onClick={signOut}>Sign Out</button>
    </div>
  );
} 

export default withAuthenticator(App);