if [ "$#" -ne 1 ]; then
  echo "requires 1 argument: role-name"
  echo "e.g., bus-lambda-role"
  exit 2
fi

aws iam detach-role-policy --role-name $1 --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess
aws iam delete-role --role-name $1


