if [ "$#" -ne 1 ]; then
  echo "requires 1 argument: role-name"
  echo "e.g., bus-lambda-role"
  exit 2
fi

aws iam create-role --role-name $1 --assume-role-policy-document file://role-policy.json


