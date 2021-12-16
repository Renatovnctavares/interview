## DevOps

- This is a quick assessment about DevOps world which will cover basically Docker and Infrastructure as code(IaC) technologies.

# Task 1

- The given Dockerfile was created a few months ago by a Senior DevOps engineer and he asked you to review it.
Please describe what would you do to improve the code.

Disclaimer: You dont need to build the docker image. just put together your findings with details.

Expected output: text file with a list of findings

# Task 2

- The given a scenario is a React FrontEnd with a Node/Express BackEnd application that needs to be deployed against a AWS ECS cluster.
As a DevOps engineer, you will need to help the team to build and run it on docker locally. Please dockerize the frontend and backend  application.

Tip: [Docker compose](https://docs.docker.com/compose/) can be used to orchestrate your containers.

Expected output: Both applications running on docker container. please provide the dockerfile or docker-compose.yml. 

# Task 3

- AWS has a services called elastic Container Registry (ECR) to store your docker images.
 1. You as a DevOps engineer must create the resources on AWS via code.
 2. You can create this script using any tool (e.g. Ansible, Cloudformation, Terraform, etc)
 3. The account number `982389731301` must have access to your ECR. please create a policy to allow it.
 To start building on AWS using the [free tier](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all)
consideration:

Expected output: a portable script file that can be used to create a ECR on AWS.