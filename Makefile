APP_NAME = pipelines-slack-notifier
VERSION_MAJOR = 0
VERSION_MINOR = 0
VERSION_PATCH = 0
VERSION_PRE_ID = alpha
VERSION_PRE_NB = 1

include mk/std.mk
_TITLE := H4sIAGCvpV4AA4WPSwrAIAxE955icNMWSt3mGB6gkOr9D9GMXyhCIyYvYZKoCC0nALJEJ2IeXjLLK2yKU2Ivf9EUyUzixvIKMTc9c/zAAoCq0uGuUUPPW2uaeyfWXiqDBrs78QBzHlf/Gv34dsPxAFNeXGa9JbQ5AQ5/ZqoXLLwMlGEBAAA=

# PUBLIC TASKS
###############
PHONY:  install 
ifeq ($(PRINT_HELP),y)
install: .splash  											##@Dev Installation local du projet et vérification des dépendances.
	@echo "Usage: make install [options]\n"
	@echo "Installation local du projet et vérification des dépendances."
	@echo "\n${_WHITE}Options:${_END}"
	$(call _PRINT_OPTION,PRINT_HELP,$(_BOLD)n$(_END)|y,Print help for a specific rule.)
	@echo "\n${_WHITE}Example:${_END}"
	@echo ""
else
install: .splash									
	$(call _PRINT_CMD,Installation local du projet)
endif

# PRIVATE TASKS
################
