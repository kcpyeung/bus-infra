if [ "$#" -ne 2 ]; then
  echo "requires 2 arguments: rest-api-id resource-id"
  echo "e.g., 1we6udvzml j7hfj06q48"
  exit 2
fi

aws apigateway delete-resource --rest-api-id $1 --resource-id $2 

deployment_id=$(aws apigateway create-deployment \
  --region ap-southeast-1 \
  --rest-api-id $1 \
  --description "delete $2 deployment" \
  --stage-name "prod" \
  --stage-description "$2 prod" \
  --no-cache-cluster-enabled \
  --output text \
  --query 'id')

echo deployment_id=$deployment_id

