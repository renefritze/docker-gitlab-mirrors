.PHONY: build push

build:
	docker build -t renemilk/gitlab-mirrors .

push: build
	docker push renemilk/gitlab-mirrors
