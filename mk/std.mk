include mk/vars.mk \
        mk/typo.mk \
				mk/mixins.mk \
				mk/version.mk 

.DEFAULT_GOAL := default

##############################
# PUBLIC GLOBAL TASKS
##############################
PHONY:  help 
default: help
	@echo "$(_IRED)$(_WHITE)$(_BOLD)                       $(_END)"
	@echo "$(_IRED)$(_WHITE)$(_BOLD) Please select a rule. $(_END)"
	@echo "$(_IRED)$(_WHITE)$(_BOLD)                       $(_END)\n"

help: .splash						##@Xtra Display this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
	@echo "Options:"
	$(call _PRINT_OPTION,PRINT_HELP,$(_BOLD)n$(_END) | y,Print help for a specific rule.)
	$(call _PRINT_OPTION,DEBUB ,$(_BOLD)false$(_END),Display informations for debugging purpose.)
	@echo ""

##############################
# PRIVATE GLOBAL TASKS
##############################
.init:
	$(call GET_VERSION)

.splash: .init
	$(call _SPLASH)

.as-root:
ifneq ($(_CURRENT_USER), root)
	$(call _MSG_ERROR,This command must be runned as root user or with sudo command.)
endif 

.prompt-yesno:
	@echo "$(_YELLOW)$(MSG)? [y/n]:$(_END)"
	@read -rs -n 1 yn && [[ -z $$yn ]] || [[ $$yn == [yY] ]] && echo Y >&2 || (echo N >&2 && exit 1)
