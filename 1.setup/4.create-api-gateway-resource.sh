if [ "$#" -ne 2 ]; then
  echo "requires 2 arguments: api_id path"
  echo "e.g., hlgz6pa9b2 schedules"
  echo "to get api_id, run aws apigateway get-rest-apis"
  exit 2
fi

root_resource_id=$(aws apigateway get-resources \
  --region ap-southeast-1 \
  --rest-api-id $1 \
  --query 'items[0].id' \
  | cut -d\" -f2)
echo root_resource_id=$root_resource_id

path_resource_id=$(aws apigateway create-resource --rest-api-id $1 --parent-id $root_resource_id --path-part $2 --query id | cut -d\" -f2)
echo path_resource_id=$path_resource_id

aws apigateway put-method \
  --region ap-southeast-1 \
  --rest-api-id $1 \
  --resource-id $path_resource_id \
  --http-method GET \
  --authorization-type NONE \
  --no-api-key-required \
  --request-parameters '{}'

aws apigateway put-method-response \
  --region ap-southeast-1 \
  --rest-api-id $1 \
  --resource-id $path_resource_id \
  --http-method GET \
  --status-code 200

aws apigateway put-integration \
  --region ap-southeast-1 \
  --rest-api-id $1 \
  --resource-id $path_resource_id \
  --http-method GET \
  --type MOCK \
  --request-templates '{"application/json":"{\"statusCode\": 200}"}'

aws apigateway put-integration-response \
  --region ap-southeast-1 \
  --rest-api-id $1 \
  --resource-id $path_resource_id \
  --http-method GET \
  --status-code 200 \
  --response-templates '{"application/json":"ok"}'

deployment_id=$(aws apigateway create-deployment \
  --region ap-southeast-1 \
  --rest-api-id $1 \
  --description "$2 deployment" \
  --stage-name "prod" \
  --stage-description "$2 prod" \
  --no-cache-cluster-enabled \
  --output text \
  --query 'id')

echo deployment_id=$deployment_id

