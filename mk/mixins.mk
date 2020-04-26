##############################
# STD FUNCTIONS
##############################
define _SPLASH
	$(eval APP_NAME_LENGTH:=$(shell echo "$(APP_NAME)" | awk '{print length}'))
	$(eval APP_VERSION_LENGTH:=$(shell echo $(VERSION) | awk '{print length}'))
	@echo "${_TITLE}" | base64 $(_OS_ARG) | zcat
	@echo ""
	@echo "┌──────$(shell printf '─%.0s' {1..$(APP_NAME_LENGTH)})──┬─────────$(shell printf '─%.0s' {1..$(APP_VERSION_LENGTH)})─┐"
	@echo "│ App ${_IGREY} ${_BOLD}${_RED}${APP_NAME} ${_END} │ Version ${_BOLD}${_GREEN}${VERSION}${_END} │"
	@echo "└──────$(shell printf '─%.0s' {1..$(APP_NAME_LENGTH)})──┴─────────$(shell printf '─%.0s' {1..$(APP_VERSION_LENGTH)})─┘"
endef

define _MSG_ERROR
	@echo "${_BOLD}${_IRED} [ERROR] ${_END}\n${_RED}$(_BOLD)$(1)$(_END)"
	@exit 2
endef

define _MSG_SUCCESS
	@echo "${_BOLD}${_IGREEN} [SUCCESS] ${_END} \n$(1)"
endef

define _MSG_WARNING
	@echo "${_BOLD}${_YELLOW} [WARNING] ${_END} \n${_YELLOW}$(1)${_END}"
endef

define _PRINT_CMD
	$(eval .LOC_TXT_LENGTH:=$(shell echo "$(1)" | awk '{print length}'))
	@echo "${_GREEN}│ $(1)"
	@echo "└─$(shell printf '─%.0s' {1..$(.LOC_TXT_LENGTH)})─${_END}"
endef

define _PRINT_TASK
	@echo "$(_BOLD)∙ $(1)$(_END)"
endef

define _PRINT_SUBTASK
	@echo "   » $(1)."
endef

define _PRINT_OPTION
	$(eval _summary:=$(subst \n,\n\t\t\t\t  ,$(3)))
	@echo "  $(_CYAN)$(1)$(_END)\t\t$(2)\t  $(_GREEN)$(_summary)$(_END)"
endef

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(call _MSG_ERROR,"$1" is missing$(if $2, ($2)).))

HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "Usage: make [rule] [options]\n\n"; \
    for (sort keys %help) { \
    print "${_WHITE}$$_:${_END}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${_YELLOW}$$_->[0]${_END}$$sep${_GREEN}$$_->[1]${_END}\n"; \
    }; \
    print "\n"; }

_msg_error:
	$(call _MSG_ERROR,$(MSG),$(CODE))