# the dollar signs are variables thus allows you to pass the stack name, filepath and parameters to commandline 
# use this script to save time writing all the commands
aws cloudformation create-stack \
--stack-name $1 \
--template-body file://$2 \
--parameters file://$3 \
--region=us-west-2