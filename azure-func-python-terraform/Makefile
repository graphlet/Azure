.PHONY: venv install start test fmt lint export-reqs

VENV?=.venv
PY?=$(VENV)/bin/python
PIP?=$(VENV)/bin/pip

venv:
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip

install: venv
	$(PIP) install -r requirements.txt

start:
	func start --python

test:
	$(PY) -m pytest -q

fmt:
	$(PY) -m pip install ruff black
	ruff check --fix src tests
	black src tests

lint:
	$(PY) -m pip install ruff
	ruff check src tests

export-reqs:
	# Compile requirements.txt from requirements.in (dev uses pip-tools)
	$(PIP) install pip-tools
	pip-compile --allow-unsafe -o requirements.txt requirements.in
