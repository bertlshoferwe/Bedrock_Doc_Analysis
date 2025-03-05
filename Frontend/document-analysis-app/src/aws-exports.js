const awsConfig = {
    Auth: {
      region: "us-east-1", // Replace with your AWS region
      userPoolId: "us-east-1_XXXXXXX", // Replace with your Terraform output value
      userPoolWebClientId: "XXXXXXXXXXXXXX", // Replace with your Terraform output value
      identityPoolId: "us-east-1:XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX", // Replace with your Terraform output value
    },
    Storage: {
        AWSS3: {
          bucket: "document-analysis-app-XXXXXXXX",
          region: "us-east-1",
        },
      },
  };
  
  export default awsConfig;