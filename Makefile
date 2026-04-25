.PHONY: test deps lint run docker_build docker_run docker_push

# Zmienne - ułatwiają zarządzanie nazwami
TAG=latest
DOCKER_USERNAME=donburro

deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt

lint:
	flake8 hello_world test

test:
	export PYTHONPATH=. && pytest

run:
	python main.py

# --- KOMENDY DOCKER

docker_build:
	docker build -t hello-world-printer .

docker_run: docker_build
	docker run \
		--name hello-world-printer-dev \
		-p 5000:5000 \
		-d hello-world-printer

# --- KOMENDY PUSH

docker_push: docker_build
	@# Logowanie do Docker Hub przy użyciu zmiennych środowiskowych z CircleCI
	@echo "$$DOCKER_PASSWORD" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	
	@# Nadanie obrazowi tagu z loginem
	docker tag hello-world-printer $(DOCKER_USERNAME)/hello-world-printer:$(TAG)
	
	@# Wysyłka obrazu do repozytorium donburro/hello-world-printer
	docker push $(DOCKER_USERNAME)/hello-world-printer:$(TAG)