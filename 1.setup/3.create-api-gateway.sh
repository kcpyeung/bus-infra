if [ "$#" -ne 1 ]; then
  echo "requires 1 arguments api-name"
  echo "e.g., bus"
  exit 2
fi

api_id=$(aws apigateway create-rest-api --name $1 --region ap-southeast-1 --query id)
api_id=`echo $api_id | cut -d\" -f2`
echo api_id=$api_id

