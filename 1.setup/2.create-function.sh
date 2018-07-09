if [ "$#" -ne 4 ]; then
  echo "requires 4 arguments: function-name, role, handler, zip-file"
  echo "e.g., bus, arn:aws:iam::123456792123:role/LambdaServiceRole bus.main, bus.zip"
  exit 2
fi

zip -9 -j $4 ../src/*.js
aws lambda create-function --function-name $1 --runtime nodejs8.10 --role $2 --handler $3 --zip-file fileb://$4


