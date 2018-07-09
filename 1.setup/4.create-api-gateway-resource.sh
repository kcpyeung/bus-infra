if [ "$#" -ne 2 ]; then
  echo "requires 2 arguments: api_id path"
  echo "e.g., hlgz6pa9b2 schedules"
  echo "to get api_id, run aws apigateway get-rest-apis"
  exit 2
fi

root_resource_id=$(aws apigateway get-resources \
  --region ap-southeast-1 \
  --rest-api-id $1 \
  | grep id \
  | cut -d\" -f4)
echo root_resource_id=$root_resource_id

aws apigateway create-resource --rest-api-id $1 --parent-id $root_resource_id --path-part $2


