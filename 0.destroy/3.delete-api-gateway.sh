if [ "$#" -ne 1 ]; then
  echo "requires 1 argument: rest-api-id"
  echo "e.g., pfwj1hac4e"
  echo "to get all ids, run 'aws apigateway get-rest-apis'"
  exit 2
fi

aws apigateway delete-rest-api --rest-api-id $1


