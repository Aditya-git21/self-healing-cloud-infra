# Self-Healing Cloud Infrastructure on AWS (Terraform)

## Overview
This project implements a self-healing cloud infrastructure on AWS using Terraform. The system continuously monitors infrastructure health and automatically restores service availability when failures occur, without requiring any manual intervention. The design follows real-world cloud architecture practices where resilience and automation are critical.

## Problem Statement
In traditional cloud environments, failures such as EC2 instance crashes or capacity reduction can lead to service disruption. Manual monitoring and recovery increase operational effort and delay restoration, potentially causing SLA violations and poor user experience.

## Solution Approach
This project solves the problem by implementing an automated, event-driven self-healing mechanism. CloudWatch monitors the infrastructure and detects failures. When a failure condition is met, an EventBridge rule triggers a Lambda function that validates the system state and restores the desired capacity of the Auto Scaling Group if required. Native AWS Auto Scaling handles rapid recovery, while Lambda acts as a secondary remediation layer.

## Architecture Components
The solution is built using the following AWS services:
- Amazon EC2
- Auto Scaling Group (ASG)
- Application Load Balancer (ALB)
- Amazon CloudWatch Metrics and Alarms
- Amazon EventBridge
- AWS Lambda (Python)
- AWS IAM
- Terraform (Infrastructure as Code)

## Self-Healing Workflow
1. An EC2 instance failure or capacity reduction occurs.
2. CloudWatch metrics detect an unhealthy state.
3. A CloudWatch alarm transitions to the ALARM state.
4. EventBridge captures the alarm event.
5. EventBridge triggers a Lambda function.
6. Lambda checks the Auto Scaling Group desired capacity against in-service instances.
7. If a mismatch is detected, the Auto Scaling Group capacity is restored automatically.

## Key Features
- Fully automated failure detection and recovery
- Event-driven remediation using Lambda
- Idempotent and safe healing logic
- Zero manual intervention
- Infrastructure managed entirely using Terraform
- Observable execution using CloudWatch Logs

## Repository Structure
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

## Deployment Instructions
Prerequisites include an AWS account, AWS CLI configured with valid credentials, and Terraform version 1.5 or above installed on the system. To deploy the infrastructure, navigate to the terraform directory, initialize Terraform, and apply the configuration.

terraform init  
terraform apply  

Confirm the resource creation when prompted.

## Testing the Self-Healing Mechanism
To test the self-healing behavior, manually terminate an EC2 instance that belongs to the Auto Scaling Group. The system will automatically evaluate the infrastructure state and restore capacity if required. Lambda execution logs can be viewed in Amazon CloudWatch under the log group /aws/lambda/self-healing-handler.

## Design Considerations
Native Auto Scaling Group recovery handles fast instance replacement. The Lambda-based remediation acts as a backup safety mechanism and executes only when a capacity mismatch persists beyond alarm thresholds. This behavior reflects real production systems where multiple layers of resilience coexist.

## Technologies Used
Amazon Web Services (EC2, ASG, ALB, CloudWatch, EventBridge, Lambda, IAM), Terraform, and Python.

## Use Case
This project demonstrates real-world cloud resilience concepts and is suitable for learning, portfolio demonstration, and DevOps or Cloud Engineering interviews.

## Author
Aditya Amlapure

