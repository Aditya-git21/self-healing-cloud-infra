import boto3
import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

autoscaling = boto3.client("autoscaling")

ASG_NAME = os.environ.get("ASG_NAME")

def lambda_handler(event, context):
    logger.info("CloudWatch alarm triggered")
    logger.info(json.dumps(event))

    if not ASG_NAME:
        logger.error("ASG_NAME environment variable not set")
        return

    response = autoscaling.describe_auto_scaling_groups(
        AutoScalingGroupNames=[ASG_NAME]
    )

    asg = response["AutoScalingGroups"][0]

    desired_capacity = asg["DesiredCapacity"]
    in_service = [
        i for i in asg["Instances"]
        if i["LifecycleState"] == "InService"
    ]

    current_capacity = len(in_service)

    logger.info(
        f"ASG: {ASG_NAME}, Desired: {desired_capacity}, InService: {current_capacity}"
    )

    if current_capacity < desired_capacity:
        logger.warning("ASG capacity mismatch detected. Triggering self-healing.")

        autoscaling.set_desired_capacity(
            AutoScalingGroupName=ASG_NAME,
            DesiredCapacity=desired_capacity,
            HonorCooldown=False
        )

        logger.info("ASG self-healing action executed")

        return {
            "status": "healed",
            "desired": desired_capacity,
            "current": current_capacity
        }

    logger.info("ASG is healthy. No action required.")

    return {
        "status": "healthy",
        "desired": desired_capacity,
        "current": current_capacity
    }

