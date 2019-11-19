IMG_PREFIX = johanneswuerbach/k8s-meetup-talk-autoscaling

ENDPOINT = $(shell kubectl get service http-api -o json | jq -r .status.loadBalancer.ingress[0].hostname)

build-consumer:
	docker build -t $(IMG_PREFIX)-consumer applications/consumer

push-consumer:
	docker push $(IMG_PREFIX)-consumer

build-http-api:
	docker build -t $(IMG_PREFIX)-http-api applications/http-api

push-http-api:
	docker push $(IMG_PREFIX)-http-api

build: build-consumer build-http-api build-load

push: push-consumer push-http-api

open-endpoint:
	open "http://$(ENDPOINT)"

build-load:
	docker build -t $(IMG_PREFIX)-load load

run-load:
	docker run --rm -it -e TERM_PROGRAM -e TERM -e ENDPOINT=$(ENDPOINT) $(IMG_PREFIX)-load
