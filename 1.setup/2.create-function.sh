if [ "$#" -ne 4 ]; then
  echo "requires 4 arguments: function-name, role, handler, js-file"
  echo "e.g., busStop, bus-role, busStop.main, busStop.js"
  exit 2
fi

if [ "$AWS_ACCOUNT_ID" == "" ]; then
  echo "please set your aws account id in \$AWS_ACCOUNT_ID"
  exit 3
fi
account_id=$AWS_ACCOUNT_ID
echo "using account id $account_id"

chmod 644 ../src/$4
zip -9 -j $4.zip ../src/$4
aws lambda create-function --function-name $1 --runtime nodejs8.10 --role arn:aws:iam::$account_id:role/$2 --handler $3 --zip-file fileb://$4.zip


