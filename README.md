
# AWS Bedrock Document Analysis Application

This repository provides a complete setup for an AWS-based document analysis application using **AWS Bedrock**, **Terraform**, **Lambda**, **Cognito**, and **S3**. The goal is to leverage AWS services to analyze documents securely and efficiently.

## Architecture Overview

The application consists of the following AWS resources:

1. **Amazon Bedrock**: Used to analyze documents and extract valuable insights using AI models.
2. **AWS Lambda**: Handles processing of documents and invokes Amazon Bedrock.
3. **Amazon S3**: Stores documents and results from the analysis.
4. **AWS Cognito**: Handles user authentication and authorization.
5. **API Gateway**: Exposes an API for users to interact with the application.
6. **IAM Roles & Policies**: Secure access to AWS services by using IAM roles and policies.

## Project Setup

### Prerequisites

Before deploying the infrastructure, make sure you have the following:

- **AWS CLI** installed and configured
- **Terraform** installed
- **AWS account** with necessary permissions
- **IAM User** with permissions for managing AWS resources

### Steps to Deploy

Follow the steps below to deploy the application.

1. **Clone the repository**

   ```bash
   git clone https://github.com/bertlshoferwe/Bedrock_Doc_Analysis.git
   cd Backend
   ```

2. **Configure AWS credentials**

   If you haven't configured AWS CLI credentials yet, do so using the following:

   ```bash
   aws configure
   ```

3. **Initialize Terraform**

   Initialize the Terraform working directory:

   ```bash
   terraform init
   ```

4. **Review Terraform Plan**

   Run the following command to review the plan:

   ```bash
   terraform plan
   ```

5. **Apply Terraform Configuration**

   If everything looks good, run:

   ```bash
   terraform apply
   ```

   Confirm the apply by typing `yes` when prompted.

6. **Access the Application**

   Once the Terraform apply is successful, you can access your document analysis API via the API Gateway URL (provided in the output).

---

## Application Flow

1. **User Authentication**: 
   - Users authenticate using AWS Cognito (signup/sign-in).
   - After authentication, they receive a JWT token that can be used to access protected resources (e.g., upload documents).

2. **Document Upload**:
   - Once authenticated, users can upload documents to an S3 bucket via the API Gateway.
   
3. **Document Analysis**:
   - The Lambda function is triggered by the S3 bucket event when a document is uploaded.
   - Lambda invokes Amazon Bedrock to analyze the document content.
   
4. **Result Storage**:
   - After analysis, the results are stored back into an S3 bucket.
   - The results can be retrieved via the API Gateway by querying the appropriate endpoint.

---

## Secure Access Control

- **IAM Roles and Policies**:
  - The application uses IAM roles with tightly scoped policies to ensure that only authorized services and users can access sensitive data.
  
- **Cognito Authentication**:
  - The app leverages AWS Cognito for user authentication, ensuring that only authenticated users can upload documents or access analysis results.
  
- **API Gateway Authorization**:
  - The API Gateway requires a valid Cognito token for access to the endpoints.

---

## How to Test

### Test User Authentication
You can test the authentication process using AWS Cognito's built-in user management console or through the API Gateway endpoints that handle user registration and login.

### Test Document Upload and Analysis
After logging in, test the document upload and analysis flow by:

1. Uploading a sample document via the API Gateway.
2. Checking S3 for the resulting file with analysis insights.
3. Verify that the Lambda function has processed the document and triggered the analysis correctly.

### Test API Gateway Endpoints
Use Postman or curl to make requests to the API Gateway endpoints:

- **POST /upload**: Upload a document for analysis.
- **GET /results/{documentId}**: Retrieve the analysis results.

---

## Outputs

When the Terraform script is applied successfully, the following outputs will be displayed:

- **api_gateway_url**: The URL of the API Gateway that exposes the document upload and results endpoints.
- **s3_bucket_name**: The name of the S3 bucket used for document storage.
- **cognito_user_pool_id**: The Cognito user pool ID used for authentication.

---

## Cleaning Up

To delete the infrastructure, simply run:

```bash
terraform destroy
```

This will tear down all the resources created by Terraform.