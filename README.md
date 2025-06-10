# Automated AWS Minecraft Server Deployment

This project automates the provisioning and configuration of a Minecraft server on an AWS EC2 instance. It uses **Terraform** for infrastructure provisioning and **Ansible** for server configuration.

---

## Background

The goal is to move from a manual installation process to a fully automated one using Infrastructure as Code (IaC) principles.

* **How will we do it?** We will use **Terraform** to create the necessary AWS resources, including an EC2 instance, a security group, and an SSH key pair. Once the infrastructure is up, Terraform will trigger an **Ansible** playbook. Ansible is responsible for connecting to the new instance and running all configuration steps: installing Java, downloading the Minecraft server, and setting up a `systemd` service for proper process management.

---

## Requirements

Before you begin, ensure you have the following tools installed and configured.

### **Tooling**

* **Terraform** (v1.0.0+)
* **Ansible** (v2.10+)
* **AWS CLI** (v2.0.0+)
* **Git**

### **Credentials & Configuration**

1.  **AWS Credentials**: Your AWS CLI must be configured with credentials that have permissions to create EC2 instances, security groups, and key pairs. You can configure this by running `aws configure`.

2.  **SSH Key**: You need an existing SSH key pair in your `~/.ssh` directory. This automation will upload your public key to AWS to create a Key Pair for secure access by Ansible. If you don't have one, create it:
    ```bash
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
    ```

3.  **Environment Variables**: No environment variables are required to run the scripts. All necessary configurations are handled within the Terraform variable files.

---

## How to Deploy

Follow these steps from the root directory of the repository to deploy the Minecraft server.

1.  **Initialize Terraform**:
    This command prepares your workspace and downloads the necessary AWS provider plugins.
    ```bash
    terraform init
    ```

2.  **Install Ansible Roles**:
    This command installs the necessary Ansible roles (in this case, for managing Java).
    ```bash
    ansible-galaxy install -r ansible/requirements.yml
    ```

3.  **Deploy the Infrastructure**:
    This command creates all the AWS resources and runs the Ansible configuration playbook. It will ask for confirmation before proceeding.
    ```bash
    terraform apply -auto-approve
    ```

    The process will take a few minutes. Once complete, Terraform will output the public IP address of the server.

---

## Connecting to the Server

Once the `terraform apply` command finishes successfully, your server is running and ready.

1.  **Verify with `nmap`**:
    You can verify that the Minecraft port is open and the service is running. Replace `<instance_public_ip>` with the IP address from the Terraform output.
    ```bash
    nmap -sV -Pn -p T:25565 <instance_public_ip>
    ```
    You should see the state as `open` and the service as `minecraft`.

2.  **Connect with the Minecraft Client**:
    * Launch your Minecraft game client (Java Edition).
    * Click on **Multiplayer**, then **Add Server**.
    * Enter any server name and use the `<instance_public_ip>` as the **Server Address**.
    * Connect and play!

---

## How to Destroy

To tear down all the AWS resources created by this project and avoid incurring further costs, run the following command:

```bash
terraform destroy -auto-approve
```