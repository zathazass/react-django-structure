.DEFAULT_GOAL := help
.ONESHELL:

# Variables
# ---------

ROOT_PATH := rename_it
ENV_DIR := env
ENV := . $(ROOT_PATH)/$(ENV_DIR)/bin/activate
PROJ_NAME := blank
CONFIG_DIR := config# set as project folder

.PHONY = root
root:
	mkdir $(ROOT_PATH)


# FOR ENVIRONMENTAL SETUP
# ------------------------
.PHONY = env
env: root env-setup pip-install pip-freeze

.PHONY = env-setup
env-setup:
	test -d $(ROOT_PATH)/$(ENV_DIR) || virtualenv $(ROOT_PATH)/$(ENV_DIR)

.PHONY = pip-install
pip-install:
	$(ENV); pip install django==3.2 djangorestframework
	$(ENV); pip install djangorestframework-simplejwt django-environ
	$(ENV); pip install psycopg2

.PHONY = pip-freeze
pip-freeze: ## freeze current pip dependencies
	$(ENV); pip freeze > $(ROOT_PATH)/requirements.txt


# FOR BLANK DJANGO PROJECT SETUP
# ------------------------------
.PHONY = django-env
django-env: env
	$(ENV); django-admin startproject $(PROJ_NAME) $(ROOT_PATH)/

.PHONY = django
django: django-env config ## #1 create new blank django project with customization

.PHONY = run
run:
	$(ENV); python3 $(ROOT_PATH)/manage.py runserver

# Customization
# -------------
.PHONY = config
config: config-django config-edit

.PHONY = config-django
config-django:
	mv $(ROOT_PATH)/$(PROJ_NAME) $(ROOT_PATH)/$(CONFIG_DIR)
	mkdir $(ROOT_PATH)/$(CONFIG_DIR)/django
	touch $(ROOT_PATH)/$(CONFIG_DIR)/django/__init__.py
	mv $(ROOT_PATH)/$(CONFIG_DIR)/settings.py $(ROOT_PATH)/$(CONFIG_DIR)/django/

.PHONY = config-edit
config-edit:
	sed -i 's/$(PROJ_NAME).settings/$(CONFIG_DIR).django.settings/' $(ROOT_PATH)/manage.py
	sed -i 's/$(PROJ_NAME).settings/$(CONFIG_DIR).django.settings/' $(ROOT_PATH)/$(CONFIG_DIR)/asgi.py
	sed -i 's/$(PROJ_NAME).settings/$(CONFIG_DIR).django.settings/' $(ROOT_PATH)/$(CONFIG_DIR)/wsgi.py
	sed -i 's/.parent/.parent.parent/' $(ROOT_PATH)/$(CONFIG_DIR)/django/settings.py
	sed -i 's/$(PROJ_NAME).urls/$(CONFIG_DIR).urls/' $(ROOT_PATH)/$(CONFIG_DIR)/django/settings.py
	sed -i 's/$(PROJ_NAME).wsgi/$(CONFIG_DIR).wsgi/' $(ROOT_PATH)/$(CONFIG_DIR)/django/settings.py


# RECOMMENTED SOFTWARES FOR DEVELOPMENT
# -------------------------------------
.PHONY = recommended-freeze
recommended-freeze: ## collects recommended software packages for development
	python3 --version > $(ROOT_PATH)/runtime.txt
	psql -V > $(ROOT_PATH)/recommended.txt


# Clean up all
# ------------
.PHONY = clean
clean: ## #0 clean-up everything
	rm -rf $(ROOT_PATH)


# Make Help Utility
# -----------------
SPACE_COUNT = 20
.PHONY: help
help: ## show target's description
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-$(SPACE_COUNT)s\033[0m %s\n", $$1, $$2}'
