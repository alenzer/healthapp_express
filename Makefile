.ONESHELL:
.EXPORT_ALL_VARIABLES:
include $(env).sh
echo $(BE_TAG)

	
code_build:
	docker build -t $(BE_TAG) --label version=$(VERSION) .

tag:
	docker tag $(BE_TAG) $(ECR_REPO_BE_URL)/$(ECR_REPO_BE_NAME):$(VERSION)


login:
	aws ecr get-login-password --region eu-south-1 | docker login --username AWS --password-stdin 150379301580.dkr.ecr.$(AWS_REGION).amazonaws.com

push:
	docker push $(ECR_REPO_BE_URL)/$(ECR_REPO_BE_NAME):$(VERSION) 

all: code_build tag login push

stack_deploy_be:
	aws cloudformation deploy \
		--template-file stack.yaml \
		--stack-name ${BE_STACK_NAME} \
		--capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM \
		--parameter-overrides \
			ServiceName=${ECR_REPO_BE_NAME} \
			HealthCheckPath=${HEALTH_CHECK_PATH} \
			ContainerID=${CONTAINER_ID_BE} \
			Image=${ECR_REPO_BE_URL}/${ECR_REPO_BE_NAME}:${VERSION} \
		--profile ${AWS_PROFILE} --region ${AWS_REGION}

	