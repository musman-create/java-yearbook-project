# Cloud & DevOps Automation Capstone Project

## 1. About This Project

This project demonstrates how I use Cloud Computing and DevOps tools to deploy and manage web applications automatically.

In simple terms, I have two applications: a portfolio website and a Java application. Both run on a server hosted on Amazon Web Services (AWS).

Instead of manually logging into the server every time I want to deploy an update, I have created an automated process using GitHub Actions, Docker, and Ansible.

When I push code changes to my GitHub repository, GitHub Actions starts the deployment process, builds the Java application, and uses Ansible to configure the server and deploy the applications.

**The main goal of this project is to make application deployment faster, more consistent, and easier to manage.**

## 2. What Problem Does This Project Solve?

Imagine you have built a website and want to put it online.

Traditionally, you might have to log into a server, install the required software, copy your files, configure the application, and start it manually.

This process can take time, and mistakes can happen along the way.

My project uses automation to handle many of these tasks.

For example:

- I store my project code on GitHub.
- GitHub Actions automatically runs the deployment workflow when I push changes to the main branch.
- Maven builds my Java application.
- Docker packages and runs the applications in containers.
- Ansible automates the configuration and deployment of the applications on my AWS server.
- AWS provides the cloud server where the applications run.

This approach reduces repetitive manual work and makes the deployment process more reliable.

## 3. Project Architecture

The project follows this workflow:

```text
Developer makes code changes
           |
           v
      Git and GitHub
           |
           v
    GitHub Actions
           |
           v
     Build Java App
        (Maven)
           |
           v
    Connect to AWS EC2
           |
           v
   Ansible configures
       the server
           |
           v
   Docker Compose runs
     the applications
           |
           v
    Applications online
```

Terraform is also included in the project for managing cloud infrastructure as code.

In simple terms, Terraform helps define the cloud resources, while Ansible helps configure the server and deploy the applications.

## 4. Technologies Used

| Technology | What it does in this project |
|---|---|
| **Amazon Web Services (AWS)** | Provides the cloud server that hosts the applications. |
| **Amazon EC2** | The virtual computer where the applications run. |
| **Terraform** | Defines and manages cloud infrastructure using code. |
| **Git and GitHub** | Store the project files and track changes. |
| **GitHub Actions** | Automatically runs the build and deployment workflow. |
| **Ansible** | Automates server configuration and application deployment. |
| **Docker** | Packages applications so they can run in isolated environments called containers. |
| **Docker Compose** | Manages and starts multiple application containers together. |
| **Java** | The programming language used by the Java application. |
| **Maven** | Builds the Java application and manages its dependencies. |
| **Linux and Ubuntu** | Provide the operating system for the development environment and cloud server. |

## 5. Applications Deployed

This project runs two main applications.

### Portfolio Website

The portfolio website is accessible through the web server on port 80, which is the standard port for HTTP websites.

### Java Application

The Java application runs in a separate Docker container and is exposed on port 8081.

The two applications run on the same AWS EC2 instance but use different ports.

## 6. How the Automation Works

Here is what happens when I update my project.

**Step 1: I update my code**

I make changes to my project on my local Linux computer.

**Step 2: I push the changes to GitHub**

I use Git to save my changes and push them to the `main` branch of my repository.

**Step 3: GitHub Actions starts automatically**

GitHub detects the new changes and runs my configured workflow.

**Step 4: The Java application is built**

Maven compiles the Java code and packages the application into a build artifact.

**Step 5: Ansible connects to the cloud server**

Ansible uses SSH to connect to my AWS EC2 instance and execute the deployment tasks.

**Step 6: Docker Compose deploys the applications**

Docker Compose builds or updates the required containers and starts the applications.

**Step 7: I verify the deployment**

I check the workflow results in GitHub Actions and confirm that the applications are accessible.

This process allows me to deploy application updates without performing every deployment step manually.

## 7. Project Structure

The repository contains the files used to build, configure, and deploy the project.

```text
java-yearbook-project/
|
|-- .github/
|   |-- workflows/
|       |-- deploy.yml
|       |-- pipeline.yml.disabled
|
|-- ansible/
|   |-- playbook.yml
|   |-- inventory.ini
|
|-- java/
|   |-- pom.xml
|   |-- src/
|
|-- myportfolio/
|
|-- terraform/
|
|-- .gitignore
|-- README.md
```

**Note:** This is a simplified overview of the project structure. Some files, such as the Docker Compose file, may be located in different directories depending on the current repository configuration. The `pipeline.yml.disabled` file is retained as a disabled workflow and is not run by GitHub Actions as a normal `.yml` workflow.

### What the main folders mean

- `.github/workflows/`: Contains the instructions GitHub Actions follows to run automation.
- `ansible/`: Contains the playbook used to configure the server and deploy the applications.
- `java/`: Contains the Java application source code and Maven configuration.
- `myportfolio/`: Contains the portfolio website files.
- `terraform/`: Contains the infrastructure configuration files.
- `.gitignore`: Tells Git which files should not be uploaded to GitHub, including private keys and generated build files.

## 8. How to Run the Project

### Requirements

To work with this project locally, you need:

- Git
- Docker
- Docker Compose
- Java Development Kit (JDK)
- Maven
- Ansible
- Terraform, if you intend to manage the cloud infrastructure
- An AWS account for cloud deployment

### Clone the repository

Open your Linux terminal and run:

```bash
git clone https://github.com/musman-create/java-yearbook-project.git
cd java-yearbook-project
```

### Build the Java application

Run:

```bash
mvn -f java/pom.xml clean package -DskipTests
```

This command builds the Java application. The `-DskipTests` option skips running tests during this build.

### Check the Docker installation

Run:

```bash
docker --version
docker compose version
```

These commands display the installed Docker and Docker Compose versions.

### Deploy to AWS

The automated deployment is configured through GitHub Actions and Ansible.

To deploy successfully, the AWS EC2 instance must be running, SSH access must be configured, and the required GitHub repository secrets must be available.

**Important:** The commands above demonstrate how to build the application locally. The full AWS deployment also depends on the project's Compose configuration, Ansible playbook, server configuration, and GitHub Actions workflow.

## 9. GitHub Actions Configuration

My repository contains a workflow that automates the build and deployment process.

The workflow is triggered when changes are pushed to the `main` branch. It can also be started manually if manual execution is enabled in the workflow.

The deployment workflow uses GitHub repository secrets to connect securely to the cloud server.

The relevant secrets include:

- `EC2_HOST`: The public IP address or hostname of the EC2 instance.
- `AWS_SSH_PRIVATE_KEY`: The private SSH key used to connect to the instance.

Secrets are stored in GitHub repository settings rather than written directly into the workflow file.

For security, private SSH keys must never be committed to GitHub or included in this README.

## 10. Deployment Verification

After deployment, I can check whether my applications are running by connecting to the EC2 instance and executing:

```bash
docker ps
```

This displays the running Docker containers.

To check the restart policies configured for the containers, I can run:

```bash
docker inspect -f '{{.Name}} -> {{.HostConfig.RestartPolicy.Name}}' $(docker ps -aq)
```

My two main application containers currently use the `always` restart policy. This allows Docker to restart them when appropriate after a container stops or the Docker service restarts.

I can also check the GitHub Actions page to confirm whether the deployment workflow completed successfully.

## 11. Live Project Links

**GitHub Repository**

https://github.com/musman-create/java-yearbook-project

**Portfolio Website**

http://184.193.35.117/

**Java Application**

http://184.193.35.117:8081/

The application links use the EC2 instance's current public IP address. They may stop working when the instance is stopped, and the IP address may change when the instance starts again unless a stable address is configured.

## 12. Challenges and Lessons Learned

Building this project helped me understand how the different parts of a cloud deployment work together.

Some of the important lessons I learned include:

- How to connect a local development environment to a remote AWS server using SSH.
- How to use Git and GitHub to manage project changes.
- How to build a Java application using Maven.
- How to run applications in Docker containers.
- How to manage multiple containers with Docker Compose.
- How to use Ansible to automate server configuration and deployment.
- How to configure GitHub Actions to automate repetitive development tasks.
- How to troubleshoot deployment problems by examining workflow logs, server connectivity, and container status.
- How to use Terraform to define cloud infrastructure as code.

I also learned that a successful automated deployment requires more than writing code. Network access, credentials, server configuration, container settings, and workflow configuration must all work together.

## 13. Future Improvements

There are several ways I can improve this project further:

- Add automated unit and integration tests.
- Improve security by restricting SSH and application access where appropriate.
- Configure a stable public IP address or custom domain.
- Add HTTPS using an SSL/TLS certificate.
- Add application health checks and monitoring.
- Improve logging and error reporting.
- Add deployment notifications.
- Review the Terraform configuration and automate infrastructure provisioning through a controlled workflow.
- Add screenshots and a clearer architecture diagram to the repository.

## 14. Conclusion

This capstone project demonstrates my practical understanding of Cloud Computing and DevOps automation.

I have brought together AWS, Linux, Terraform, Ansible, Docker, Docker Compose, GitHub Actions, Java, and Maven to build a repeatable application deployment process.

The biggest lesson from this project is that DevOps is about making software delivery more consistent by automating tasks that would otherwise be performed manually.

This project is part of my continued learning journey in Cloud Engineering and DevOps, and I intend to keep improving it as I develop more practical skills.

---

**Project Status:** Automated deployment workflow successfully executed.

**Areas Demonstrated:** Cloud infrastructure, Linux administration, infrastructure as code, containerization, configuration management, CI/CD, and troubleshooting.

