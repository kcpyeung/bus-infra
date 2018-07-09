if [ "$#" -ne 1 ]; then
  echo "requires 1 argument: function-name"
  echo "e.g., bus"
  exit 2
fi

aws lambda delete-function --function-name $1


