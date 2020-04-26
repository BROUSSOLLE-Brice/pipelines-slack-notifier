##############################
# TYPO
##############################
_END   := $(shell tput -Txterm sgr0)
_BOLD  := $(shell tput -Txterm bold)
_UNDER := $(shell tput -Txterm smul)
_REV   := $(shell tput -Txterm rev)

# Colors
_GREY   := $(shell tput -Txterm setaf 0)
_RED    := $(shell tput -Txterm setaf 1)
_GREEN  := $(shell tput -Txterm setaf 2)
_YELLOW := $(shell tput -Txterm setaf 3)
_BLUE   := $(shell tput -Txterm setaf 4)
_PURPLE := $(shell tput -Txterm setaf 5)
_CYAN   := $(shell tput -Txterm setaf 6)
_WHITE  := $(shell tput -Txterm setaf 7)

# Inverted, i.e. colored backgrounds
_IGREY   := $(shell tput -Txterm setab 0)
_IRED    := $(shell tput -Txterm setab 1)
_IGREEN  := $(shell tput -Txterm setab 2)
_IYELLOW := $(shell tput -Txterm setab 3)
_IBLUE   := $(shell tput -Txterm setab 4)
_IPURPLE := $(shell tput -Txterm setab 5)
_ICYAN   := $(shell tput -Txterm setab 6)
_IWHITE  := $(shell tput -Txterm setab 7)