if [ "$#" -ne 3 ]; then
  echo "requires 3 arguments: api_id path lambda_function_name"
  echo "e.g., hlgz6pa9b2 schedules bus"
  echo "to get api_id, run aws apigateway get-rest-apis"
  exit 2
fi

account_id=$AWS_ACCOUNT_ID
if [ "$account_id" == "" ]; then
  echo "please set your aws account id in \$AWS_ACCOUNT_ID"
  exit 3
fi
echo "using account id $account_id"

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
  --request-parameters method.request.querystring.busStopCode=false

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
  --type AWS \
  --integration-http-method POST \
  --uri arn:aws:apigateway:ap-southeast-1:lambda:path//2015-03-31/functions/arn:aws:lambda:ap-southeast-1:$account_id:function:$3/invocations \
  --request-templates '{"application/json":"{\"busStopCode\": \"$input.params('"'"busStopCode"'"')\"}"}'

aws apigateway put-integration-response \
  --region ap-southeast-1 \
  --rest-api-id $1 \
  --resource-id $path_resource_id \
  --http-method GET \
  --status-code 200 \
  --selection-pattern ""

aws lambda add-permission \
  --function-name $3 \
  --statement-id apigateway-perm-$1-$2-$3 \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn arn:aws:execute-api:ap-southeast-1:$account_id:$1/*/GET/$2

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

