BUMP_TYPE ?= patch
BUMP_ALLOWED_TYPES := major minor patch pre-major pre-minor pre-patch pre release
BT := $(filter $(BUMP_TYPE),$(BUMP_ALLOWED_TYPES))
PRE_ID ?= $(if $(VERSION_PRE_ID), $(VERSION_PRE_ID), alpha)
PRE_ID_ALLOWED := alpha beta rc
PI := $(filter $(PRE_ID),$(PRE_ID_ALLOWED))

define CLEAN_PRE
	$(eval VERSION_PRE_ID=)
	$(eval VERSION_PRE_NB=0)
endef

define UPDATE_PRE
	$(eval VERSION_PRE_ID=$(PI))
	$(eval VERSION_PRE_NB=$(shell echo $$(($(VERSION_PRE_NB)+1))))
endef

define GET_VERSION
	$(eval VERSION = "$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH)")
	$(if $(filter-out ,$(VERSION_PRE_ID)),$(eval VERSION := $(VERSION)-$(VERSION_PRE_ID).$(VERSION_PRE_NB)))
endef

PHONY:  version bump 
version: .splash 				##@Xtra Display application version.

ifeq ($(PRINT_HELP),y)
bump: .splash						##@Publishing Bump application version.
	@echo "Usage: make bump BUMP_TYPE=... [PRE_ID=...]\n"
	@echo "The $(_BOLD)bump$(_END) rule update the version number following the semver specification.\
\nIt checking if git modification are not committed, generating git tag and push\
\nthe final vesion to your repository."
	@echo "\n${_WHITE}Options:${_END}"
	$(call _PRINT_OPTION,BUMP_TYPE,patch,Bump the version of your application.\
\nAvailable values are \n$(_BOLD)$(foreach val,$(BUMP_ALLOWED_TYPES),$(val)$(comma))$(_END) )
	@echo
	$(call _PRINT_OPTION,PRE_ID,rc,Set the pre-release id between version and\
\nthe pre-release version number.)
	@echo "\n${_WHITE}Example:${_END}"
	@echo "  make bump BUMP_TYPE=prepatch PRE_ID=rc"
	@echo "  make bump BUMP_TYPE=minor"
	@echo 
else
bump: .splash
	$(call _PRINT_CMD,Bump app version)
	$(call _PRINT_TASK,Check parameters)
	@if [ -z "$(BT)" ]; then make \
		_msg_error MSG="BUMP_TYPE '$(BUMP_TYPE)' is not valid.\
		\nAllowed values are:\n$(BUMP_ALLOWED_TYPES)"; fi
	@if [ -z "$(PI)" ]; then make \
		_msg_error MSG="PRE_ID '$(PRE_ID)' is not valid.\
		\nAllowed values are:\n$(PRE_ID_ALLOWED)"; fi
	$(call _PRINT_TASK,Check for git modifications)
	@if ! git diff-index --quiet HEAD  --; then make \
		_msg_error MSG="Some modifications are not committed yet.\
		\nPlease commit changes first."; fi
	
	$(call _PRINT_TASK,Calculate new app version)
ifeq ($(BUMP_TYPE), patch)
	$(call _PRINT_SUBTASK,Patch version increment)
	$(eval VERSION_PATCH=$(shell echo $$(($(VERSION_PATCH)+1))))
	$(call CLEAN_PRE)
endif

ifeq ($(BUMP_TYPE), pre-patch)
	$(call _PRINT_SUBTASK,PRE Patch version increment)
	$(eval VERSION_PATCH=$(shell echo $$(($(VERSION_PATCH)+1))))
	$(eval VERSION_PRE_NB=0)
	$(call UPDATE_PRE)
endif

ifeq ($(BUMP_TYPE), minor)
	$(call _PRINT_SUBTASK,Minor version increment)
	$(eval VERSION_MINOR=$(shell echo $$(($(VERSION_MINOR)+1))))
	$(eval VERSION_PATCH=0)
	$(call CLEAN_PRE)
endif

ifeq ($(BUMP_TYPE), pre-minor)
	$(call _PRINT_SUBTASK,Minor version increment)
	$(eval VERSION_MINOR=$(shell echo $$(($(VERSION_MINOR)+1))))
	$(eval VERSION_PATCH=0)
	$(eval VERSION_PRE_NB=0)
	$(call UPDATE_PRE)
endif

ifeq ($(BUMP_TYPE), major)
	$(call _PRINT_SUBTASK,Minor version increment)
	$(eval VERSION_MAJOR=$(shell echo $$(($(VERSION_MAJOR)+1))))
	$(eval VERSION_PATCH=0)
	$(eval VERSION_MINOR=0)
	$(call CLEAN_PRE)
endif

ifeq ($(BUMP_TYPE), pre-major)
	$(call _PRINT_SUBTASK,Minor version increment)
	$(eval VERSION_MAJOR=$(shell echo $$(($(VERSION_MAJOR)+1))))
	$(eval VERSION_PATCH=0)
	$(eval VERSION_MINOR=0)
	$(eval VERSION_PRE_NB=0)
	$(call UPDATE_PRE)
endif

ifeq ($(BUMP_TYPE), pre)
	$(call _PRINT_SUBTASK,Pre version increment)
	$(if $(filter-out $(PI),$(VERSION_PRE_ID)),$(eval VERSION_PRE_NB := 0))
	$(call UPDATE_PRE)
endif

ifeq ($(BUMP_TYPE), release)
	$(call _PRINT_SUBTASK,Finalize the release)
	$(call CLEAN_PRE)
endif

	$(call GET_VERSION)
	$(call _PRINT_SUBTASK,new version is $(_BOLD)$(_GREEN)$(VERSION) $(_END))
	
	$(call _PRINT_TASK,Apply new version into files)
	@sed -i.bak -E 's@^VERSION_PATCH =.+@VERSION_PATCH = $(VERSION_PATCH)@g' ./Makefile
	@sed -i.bak -E 's@^VERSION_MINOR =.+@VERSION_MINOR = $(VERSION_MINOR)@g' ./Makefile
	@sed -i.bak -E 's@^VERSION_MAJOR =.+@VERSION_MAJOR = $(VERSION_MAJOR)@g' ./Makefile
	@sed -i.bak -E 's@^VERSION_PRE_ID =.+@VERSION_PRE_ID = $(VERSION_PRE_ID)@g' ./Makefile
	@sed -i.bak -E 's@^VERSION_PRE_NB =.+@VERSION_PRE_NB = $(VERSION_PRE_NB)@g' ./Makefile

	$(call _PRINT_TASK,Apply new version into git)
	@git add Makefile $(SHELL_DEBUG)
	@git commit -m "$(VERSION)" $(SHELL_DEBUG)
	@git tag $(VERSION) $(SHELL_DEBUG)
	
	@if make .prompt-yesno MSG="Do you want push branch and tag" 2> /dev/null; then \
		make _print_task MSG="Send git modification to repository"; \
		make _print_subtask MSG="Send commits"; \
		git push $(SHELL_DEBUG); \
		make _print_subtask MSG="Send tags"; \
		git push --tags $(SHELL_DEBUG); \
	fi
endif
