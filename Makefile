IMAGE_NAME = "xtracer"
dep:
	go mod download

build: dep
	GOOS=linux \
	GOARCH=amd64 \
	go build -o xtracer_service .

ci-docker-build:
	docker build -t $(IMAGE_NAME):latest .