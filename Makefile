# Global vars.
VENV=.venv
PYTHON_VERSION=3.10.0
PYTHON=${VENV}/bin/python

# Define standard colours.
GREEN=\033[0;32m
RED=\033[0;31m
BLUE=\033[0;34m

.PHONY: clean
clean:
### Remove any existing virtual environments & temp files.
	@echo "${RED}Removing existing virtual environments."
	rm -rf .python-version
	rm -rf $(VENV)

	@echo "${GREEN}Removing temp files${NORMAL}"
	-rm -rf .cache
	-rm -rf .pytest_cache
	-rm -rf coverage
	-rm -rf .coverage
	-rm -rf build
	-rm -rf */*/build
	-rm -rf dist
	-rm -rf */*/dist
	-rm -rf *.egg-info
	-rm -rf */*/*.egg-info
	-rm -rf *.whl

build-virtualenv:
### Install python version using pyenv & set it to local version used in this directory.
	@echo "${GREEN}Installing default python version using pyenv."
	pyenv install -s $(PYTHON_VERSION)
	pyenv local $(PYTHON_VERSION)
	@echo "${GREEN}Creating virtual environment."
	test -d $(VENV) || $(HOME)/.pyenv/versions/$(PYTHON_VERSION)/bin/python -m venv $(VENV)

	@echo "${GREEN}Building root environment for local testing & databricks connect"
	. $(VENV)/bin/activate && \
	pip install -r requirements-dev.txt

.PHONY: setup
setup: clean build-virtualenv

.PHONY: test
test:
	@echo "${GREEN}Running tests"
	$(PYTHON) -m pytest -s tests/ -v

ci-test: setup test
