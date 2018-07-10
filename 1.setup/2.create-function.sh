if [ "$#" -ne 4 ]; then
  echo "requires 4 arguments: function-name, role, handler, zip-file"
  echo "e.g., bus, bus-role, bus.main, bus.zip"
  exit 2
fi

if [ "$AWS_ACCOUNT_ID" == "" ]; then
  echo "please set your aws account id in \$AWS_ACCOUNT_ID"
  exit 3
fi
account_id=$AWS_ACCOUNT_ID
echo "using account id $account_id"

zip -9 -j $4 ../src/*.js
aws lambda create-function --function-name $1 --runtime nodejs8.10 --role arn:aws:iam::$account_id:role/$2 --handler $3 --zip-file fileb://$4


