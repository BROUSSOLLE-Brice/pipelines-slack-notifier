##############################
# STD VARS
##############################
_TITLE := H4sIACXLpV4AAwvJV0hKVUhJTcvMS03h4gIA7syxMQ8AAAA=
_OS_ARG := $(if $(filter-out darwin, $(UNAME_S)), "-D", "-d")
_CURRENT_USER := $(shell whoami)
PRINT_HELP ?= n
comma := ,

DEBUG:=false
SHELL_DEBUG?=

ifeq ($(DEBUG), false)
	SHELL_DEBUG := > /dev/null 2>&1
endif