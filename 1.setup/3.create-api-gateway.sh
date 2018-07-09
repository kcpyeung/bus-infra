if [ "$#" -ne 1 ]; then
  echo "requires 1 arguments api-name"
  echo "e.g., bus"
  exit 2
fi

aws apigateway create-rest-api --name $1


