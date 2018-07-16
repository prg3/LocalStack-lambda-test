#!/bin/bash

# Creating Zip file
if [ -f lambda.zip ] ; then
	rm lambda.zip
fi
cd payload
zip ../lambda.zip *
cd ..

# Deploying function to Localstack
aws --region=us-east-1 --endpoint-url=http://localhost:4574 lambda update-function-code --function-name=f1 --zip-file fileb://lambda.zip

if [ $? == 255 ] ; then
	# Create function if the deploy failed because the function wasn't there
	aws --region=us-east-1 --endpoint-url=http://localhost:4574 lambda create-function --function-name=f1 --runtime=python2.7 --role=r1 --handler=lambda.handler --zip-file fileb://lambda.zip
fi

echo "Running test"
aws lambda --endpoint-url=http://localhost:4574 invoke --region=local --function-name f1 result.log
cat result.log
