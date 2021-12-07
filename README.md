# Social Something Terraform Build 🤗
 Creates a fully scalable web application of [Sam's Social Something App](https://github.com/sam-meech-ward-bcit/social_something_full). 
 
 Uses the following resources from AWS:
 - Application Load Balancer
 - Auto Scaling Group
   - EC2 Instances
 - Cloud Watch
 - RDS
 - Route 53
   - Certificates
 - S3 Bucket
 - VPC 

 
 The following image shows the infrastructure configuration:
 <div>
  <a href="https://github.com/github_username/repo_name">
    <img src="/configuration.png" alt="Configuration" height="70%" width="70%">
  </a>
 </div>
 

 
 ## Requirements
   ⚠️ **IMPORTANT:** Setup [Social Something Packer](https://github.com/hu9okwan/social-something-final-packer) before continuing. ⚠️
 - [Terraform](https://www.terraform.io/downloads.html)
 - [AWS CLI](https://aws.amazon.com/cli/)


## Setup
1. Clone this repo
2. Initialize a working directory: ```terraform init```
3. Change variables in ```social-something-final-terraform/variables.tf``` to desired whatever
4. Create an execution plan: ```terraform plan``` -> ```yes``` (Optional)


## Usage
Execute the actions proposed in the Terraform plan ```terraform apply``` -> ```yes```

Wait for ???????????? Terraform to build the fully scalable web application.
