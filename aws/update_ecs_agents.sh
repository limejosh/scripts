#!/bin/bash
# usage: ./update_ecs_agent.sh $cluster_name
CLUSTER_NAME=$1
aws ecs list-container-instances --cluster "$CLUSTER_NAME" --output text |cut -d/ -f2 > ecs-list-instances_$CLUSTER_NAME

while read instance;do aws ecs update-container-agent --cluster "$CLUSTER_NAME" --container-instance $instance; done <ecs-list-instances_$CLUSTER_NAME
