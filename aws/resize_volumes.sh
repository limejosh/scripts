sexyfunc()  { aws ec2 describe-instances --filter Name=tag:Name,Values="$1" --output json  |   jq -r '.Reservations[].Instances[] | [.InstanceId, .PrivateIpAddress, (.Tags|from_entries|.Name), .BlockDeviceMappings[].Ebs.VolumeId] | @csv'; }
#if several volumes are present it's better to use grep -E "volume1|volume2|..."
describe_volumes() { aws ec2 describe-volumes --output json |jq -r '.Volumes[]| [.VolumeId, .VolumeType, .Size] |@csv' |grep -E $1; }

#VOLUMES=$(sexyfunc $1 |cut -d, -f4-)
#describe_volumes $VOLUMES

#too precise, down 
#resize_volume(){ original_size=$(describe_volumes $1|cut -d, -f3);echo $original_size;new_size=$( printf %.10f\\n "$((1000000000 *   $original_size*0.2  ))e-9");echo $new_size ;}
#approximated, but better for the cli. 
#usage: resize_volume $volume_id $percentage_increase. example: resize_volume vol-068d131fa8a32c1 25 
resize_volume(){ original_size=$(describe_volumes $1|cut -d, -f3);echo $original_size;extra_space=$(($original_size*$2/100));new_size=$(($original_size+$extra_space)); echo $new_size; aws ec2 modify-volume --size $new_size --volume-id $1 --dry-run ;}

batch_volume_thing() { VOLUMELIST=$(sexyfunc "$1" |cut -d, -f4-); for item in $(echo -e  $VOLUMELIST|tr ',' '\n'); do resize_volume $item $2; done ;}

batch_volume_thing $1 $2



