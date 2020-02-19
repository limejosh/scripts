aws ec2 describe-instances --filter Name=tag:Name,Values="$1" --output json  |   jq -r '.Reservations[].Instances[] | [.InstanceId, .PrivateIpAddress, .Tags[].Value, .BlockDeviceMappings[].Ebs.VolumeId] | @csv'

sexyfunc()  { aws ec2 describe-instances --filter Name=tag:Name,Values="$1" --output json  |   jq -r '.Reservations[].Instances[] | [.InstanceId, .PrivateIpAddress, .Tags[].Value, .BlockDeviceMappings[].Ebs.VolumeId] | @csv'; }

