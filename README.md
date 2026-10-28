# Modern End-to-End DevOps Pipeline

**A hands-on DevOps capstone project demonstrating infrastructure as code, configuration management, containerization, and automated deployment on AWS.**

## Project Overview

This project automates the build and deployment of two applications on a single AWS EC2 instance using modern DevOps tools.

The pipeline uses GitHub Actions to coordinate the process, Terraform to manage AWS infrastructure, Ansible to configure the EC2 server and deploy the applications, and Docker Compose to run both applications as containers.

The objective is to demonstrate how different DevOps tools work together to create a repeatable, maintainable deployment workflow.

## Project Objectives

- Automate application deployment using GitHub Actions.
- Manage AWS infrastructure with Terraform.
- Configure and manage the EC2 server using Ansible.
- Package applications using Docker.
- Run multiple applications on one EC2 instance with Docker Compose.
- Verify deployment results through automated checks.
- Apply infrastructure as code and version-control best practices.

## Architecture

```text
Developer
    |
    | Git push to main
    v
GitHub Repository
    |
    v
GitHub Actions CI/CD
    |
    +--> Configure AWS credentials
    |
    +--> Terraform init, validate and plan
    |
    +--> Build Java application with Maven
    |
    +--> Prepare Ansible inventory and SSH access
    |
    +--> Run Ansible playbook
              |
              v
        AWS EC2 Instance
              |
              v
        Docker Compose
              |
              +--> Portfolio Container
              |       Port 80
              |
              +--> Java Application Container
                      Port 8081
```

**Important:** The current workflow runs Terraform planning and validation. It does not automatically apply infrastructure changes. Ansible performs the application deployment to the existing EC2 instance.

## Technology Stack

| Technology | Purpose |
|---|---|
| AWS EC2 | Hosts the applications |
| Amazon VPC | Provides network isolation and connectivity |
| Terraform | Defines and manages AWS infrastructure |
| Amazon S3 | Stores Terraform remote state and application artifacts |
| GitHub Actions | Automates the CI/CD workflow |
| Ansible | Configures the server and deploys applications |
| Docker | Packages applications into containers |
| Docker Compose | Runs both application services |
| Java 17 | Java application runtime and build environment |
| Apache Maven | Builds the Java application |
| Linux / Ubuntu | Development and server administration environment |
| Git and GitHub | Version control and collaboration |

## Applications

### 1. Personal Portfolio

The portfolio is packaged as a Docker container and exposed on port 80.

- Service name: `portfolio`
- Container name: `app-portfolio-1`
- Container port: `80`

### 2. Java Yearbook Application

The Java application is built with Maven and packaged into a Docker container running on port 8081.

- Service name: `java-app`
- Container name: `app-java-app-1`
- Application port: `8081`

Both applications run on the same EC2 instance but are managed as separate Docker Compose services.

## Repository Structure

```text
java-yearbook-project/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── ansible/
│   └── playbook.yml
├── java/
│   ├── pom.xml
│   ├── Dockerfile
│   └── src/
├── myportfolio/
│   ├── index.html
│   └── Dockerfile
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   └── backend.tf
├── docker-compose.yml
├── .gitignore
└── README.md
```

The structure above shows the main project components. Additional files may exist in the repository.

## CI/CD Workflow

The GitHub Actions workflow is configured to run when changes are pushed to the `main` branch. It can also be started manually.

The pipeline performs the following steps:

1. Checks out the repository.
2. Configures AWS credentials from GitHub repository secrets.
3. Initializes Terraform using the S3 remote-state backend.
4. Validates the Terraform configuration.
5. Generates a Terraform plan to check for infrastructure differences.
6. Sets up Java 17 and Maven caching.
7. Builds the Java application.
8. Installs Ansible.
9. Prepares the SSH private key and inventory on the GitHub Actions runner.
10. Checks the Ansible playbook syntax.
11. Executes the playbook to deploy the applications to EC2.
12. Verifies the running Docker containers.

A successful workflow run confirms that the configured pipeline steps completed successfully. Application availability should also be checked separately.

## Infrastructure Management with Terraform

Terraform manages the AWS resources required by the project, including the network, subnet, internet gateway, routing, security group, EC2 instance, and S3 resources defined in the configuration.

The Terraform state is stored remotely in Amazon S3 to support consistent infrastructure management.

### Validate the configuration

Run from the project directory:

```bash
cd terraform
terraform init
terraform validate
terraform plan
```

Review the plan before applying any infrastructure changes.

The expected result, when the actual infrastructure matches the configuration, is:

```text
No changes. Your infrastructure matches the configuration.
```

Do not run `terraform destroy` as part of routine deployment verification.

## Deployment with Ansible

Ansible connects to the EC2 instance over SSH and runs the deployment playbook.

The playbook is responsible for configuring Docker and deploying the project using Docker Compose.

To check connectivity:

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible webserver \
  -i ansible/inventory.ini \
  -m ping
```

To run the deployment playbook manually:

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
  -i ansible/inventory.ini \
  ansible/playbook.yml
```

The inventory and SSH private key must be configured correctly. The private key must never be committed to Git.

## Docker Compose

Docker Compose manages the portfolio and Java application as separate services.

To check the running containers on the EC2 instance through Ansible:

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible webserver \
  -i ansible/inventory.ini \
  -b \
  -m command \
  -a "docker ps"
```

Expected services include:

- `app-portfolio-1`, exposing port 80.
- `app-java-app-1`, exposing port 8081.

To inspect application logs, run:

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible webserver \
  -i ansible/inventory.ini \
  -b \
  -m command \
  -a "docker logs --tail 100 app-java-app-1"
```

## Application Access

Replace the example IP below with the current public IP of your EC2 instance if it changes.

- **Portfolio:** http://100.54.103.111
- **Java application:** http://100.54.103.111:8081/

The portfolio should return a successful HTTP response. The Java application response depends on the routes implemented by the application.

## Deployment Verification

The following checks were performed during project validation:

- Terraform reported that the infrastructure matched its configuration.
- Ansible successfully connected to the EC2 instance.
- Docker reported both application containers as running.
- The portfolio container exposed port 80.
- The Java application container exposed port 8081.
- The GitHub Actions deployment workflow completed successfully.

Repeat these checks after future deployments and update the evidence when the results change.

## Security and Best Practices

- Store AWS credentials and SSH private keys in GitHub Actions secrets.
- Never commit `.pem` files, Terraform state files, or secret values.
- Keep Terraform state in the configured remote backend.
- Restrict SSH access to trusted IP addresses instead of opening port 22 to the entire internet.
- Expose only the application ports that are required.
- Review Terraform plans before applying infrastructure changes.
- Use Git commits to track changes to infrastructure and application code.
- Preserve backups before making changes to Terraform state or critical infrastructure.

## Challenges and Lessons Learned

This project provided practical experience with several common DevOps challenges:

- Troubleshooting SSH connectivity when an EC2 public IP changes.
- Configuring Ansible inventory and SSH authentication.
- Managing Terraform state remotely in Amazon S3.
- Investigating AWS networking and infrastructure configuration.
- Running multiple Docker containers on one server.
- Connecting GitHub Actions, Terraform, Ansible, and Docker into a deployment workflow.
- Verifying infrastructure and application status independently.

## Future Improvements

Possible next improvements include:

- Add automated application tests to the pipeline.
- Add health checks and more comprehensive deployment verification.
- Restrict inbound SSH access and review public exposure of application ports.
- Add monitoring, centralized logging, and alerting.
- Introduce an automated rollback strategy.
- Add a deployment architecture diagram and screenshots.
- Evaluate a managed container platform as a future extension.

## Conclusion

This capstone demonstrates a practical approach to automating infrastructure checks, building applications, configuring a server, and deploying containerized services on AWS.

It combines infrastructure as code, configuration management, containerization, and CI/CD into a project that can be demonstrated and extended as part of a junior cloud or DevOps engineering portfolio.

**Author:** Sanni Musa Oluwadamilare

**GitHub Repository:** https://github.com/musman-create/java-yearbook-project
