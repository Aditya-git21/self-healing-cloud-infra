# 🔁 Self-Healing Cloud Infrastructure on AWS (Terraform)

## 📌 Overview

This project implements a **self-healing cloud infrastructure on AWS** using **Terraform (Infrastructure as Code)**.

The system continuously monitors infrastructure health and **automatically restores service availability** when failures occur — **without any manual intervention**.  
The design reflects **real-world cloud architecture practices** where resilience, automation, and fault tolerance are critical.

---

## ❓ Problem Statement

In traditional cloud environments, failures such as **EC2 instance crashes**, **capacity reduction**, or **unhealthy targets** can cause service disruption.

Manual monitoring and recovery:
- Increase operational effort
- Delay service restoration
- Risk SLA violations
- Lead to poor user experience

---

## 💡 Solution Approach

This project implements an **event-driven self-healing mechanism** using native AWS services.

- **CloudWatch** continuously monitors infrastructure health
- **CloudWatch Alarms** detect failure conditions
- **EventBridge** captures alarm state changes
- **AWS Lambda** validates system state and remediates failures
- **Auto Scaling Group (ASG)** restores capacity automatically

Lambda acts as a **secondary remediation layer**, ensuring recovery even if native mechanisms fail.

---

## 🧱 Architecture

    ┌──────────────┐
    │   Users      │
    └──────┬───────┘
           │
           ▼
    ┌────────────────────┐
    │ Application Load   │
    │ Balancer (ALB)     │
    └─────────┬──────────┘
              │
              ▼
    ┌──────────────────────────┐
    │ Auto Scaling Group (ASG) │
    │   EC2 Instances         │
    └─────────┬───────────────┘
              │
              ▼
    ┌──────────────────────────┐
    │ CloudWatch Metrics       │
    │ & Alarms                 │
    └─────────┬───────────────┘
              │ Alarm Trigger
              ▼
    ┌──────────────────────────┐
    │ EventBridge Rule         │
    └─────────┬───────────────┘
              │
              ▼
    ┌──────────────────────────┐
    │ AWS Lambda (heal.py)     │
    │ - Validate ASG capacity  │
    │ - Restore desired state  │
    └──────────────────────────┘

---

## 🔄 Self-Healing Workflow

1. An EC2 instance failure or capacity reduction occurs
2. CloudWatch metrics detect an unhealthy state
3. A CloudWatch alarm transitions to **ALARM**
4. EventBridge captures the alarm event
5. EventBridge triggers the Lambda function
6. Lambda compares desired vs in-service ASG capacity
7. If mismatch exists, ASG capacity is restored automatically

---

## ⭐ Key Features

- Fully automated failure detection and recovery
- Event-driven remediation using Lambda
- Idempotent and safe healing logic
- Zero manual intervention
- Infrastructure fully managed using Terraform
- Observable execution using CloudWatch Logs
- Production-style layered resilience

---

## 📁 Repository Structure

    self-healing-cloud-infra/
    ├── terraform/
    │   ├── provider.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── network.tf
    │   ├── asg.tf
    │   ├── cloudwatch.tf
    │   ├── eventbridge.tf
    │   ├── lambda.tf
    │   ├── lambda_iam.tf
    │   ├── ec2_iam.tf
    │   └── security_group.tf
    ├── lambda/
    │   └── heal.py
    ├── README.md
    └── .gitignore

---

## 🚀 Deployment Instructions

### Prerequisites
- AWS account
- AWS CLI configured with valid credentials
- Terraform version **1.5+**

### Deploy Infrastructure

    cd terraform
    terraform init
    terraform apply

Confirm resource creation when prompted.

---

## 🧪 Testing the Self-Healing Mechanism

To test the self-healing behavior:

1. Manually terminate an EC2 instance in the Auto Scaling Group
2. CloudWatch detects the unhealthy state
3. Lambda executes remediation logic
4. ASG restores the desired capacity automatically

Lambda logs can be viewed in CloudWatch under:

    /aws/lambda/self-healing-handler

---

## 🧠 Design Considerations

- Native ASG recovery provides fast instance replacement
- Lambda-based remediation acts as a **safety net**
- Multiple layers of resilience mirror **real production systems**
- Healing logic is idempotent and safe to re-run

---

## 🧰 Technologies Used

- Amazon EC2
- Auto Scaling Group (ASG)
- Application Load Balancer (ALB)
- Amazon CloudWatch
- Amazon EventBridge
- AWS Lambda (Python)
- AWS IAM
- Terraform (IaC)

---

## 🎯 Use Case

This project demonstrates **real-world cloud resilience engineering** and is suitable for:

- DevOps portfolios
- Cloud engineering interviews
- Learning event-driven automation
- Understanding self-healing systems

---

## 👤 Author

**Aditya Amlapure**
