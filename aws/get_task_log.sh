#!/bin/bash
CLUSTER_NAME=$1
aws ecs list-tasks --cluster "$CLUSTER_NAME" --output text |cut -f2 > ~/task_list_$CLUSTER_NAME
while read task; do aws ecs describe-tasks --cluster "$CLUSTER_NAME" --task $task|grep taskDefinitionArn|cut -f2 -d/|tr -d ','|tr -d '"'; done <~/task_list_$CLUSTER_NAME >~/task_list_definition_$CLUSTER_NAME
while read taskdefinition; do echo $taskdefinition;aws ecs describe-task-definition --task-definition $taskdefinition |grep logDriver;done <~/task_list_definition_$CLUSTER_NAME > ~/task_list_log_version_dev



