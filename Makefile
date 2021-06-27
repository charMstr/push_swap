# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: charmstr <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/11/18 18:51:52 by charmstr          #+#    #+#              #
#    Updated: 2021/06/27 19:08:02 by charmstr         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

############################ SETTINGS #########################################
###############################################################################
NAME = push_swap
CFLAGS = -Wall -Wextra -Werror
CC = gcc
I_FLAGS = -I $(INCLUDE_PATH)
LDFLAGS = #-lft -lm etc... 
###############################################################################
###############################################################################


################## FOR COMPILATION WITH DEBUG #################################
###############################################################################
# NOTE: redefining EXTRA_FLAGS and EXTRA_DEFINES

ifeq ($(TRACE_TARGET), )
	EXTRA_DEFINES+=
else
	EXTRA_DEFINES+= -D TRACE_TARGET=$(TRACE_TARGET)
endif

ifeq ($(DEBUG), )
	EXTRA_DEFINES+=
else
	EXTRA_DEFINES+= -D DEBUG=$(DEBUG)
endif

ifeq ($(flags), )
	EXTRA_FLAGS =
	VALGRIND 	=
else ifeq ($(flags), f)
	EXTRA_FLAGS +=  -fsanitize=address,undefined -g3 -ferror-limit=1
	VALGRIND 	=
else ifeq ($(flags), v)
	EXTRA_FLAGS += -g3
	SHOW_LEAK 	= --show-leak-kinds=definite
	VALGRIND 	= valgrind --track-origins=yes --leak-check=full $(SHOW_LEAK)
endif
###############################################################################
###############################################################################


############################ PATHS ############################################
###############################################################################
OBJ_PATH = ./objects/
SRC_PATH = ./sources/
INCLUDE_PATH = ./includes/
LIBRARIES = ./libraries/
###############################################################################
###############################################################################


########################### SRC/OBJ & BONUS FILES #############################
###############################################################################
SRC_FILES =	\

# HERE SRC_FILES

FILE_NUMBER=1
FILE_COUNTER=0
SRC := $(patsubst %, $(SRC_PATH)%.c, $(SRC_FILES))
OBJ := $(patsubst %, $(OBJ_PATH)%.o, $(basename $(notdir $(SRC))))

OBJ_MAIN += $(OBJ_PATH)main.o

#BONUS_SRC_FILES = 

#SRC_BONUS = $(patsubst %, $(SRC_PATH)%.c, $(BONUS_SRC_FILES))
#OBJ_BONUS = $(patsubst %, $(OBJ_PATH)%.o, $(basename $(notdir $(SRC_BONUS))))
###############################################################################
###############################################################################


########################### HEADER FILES ######################################
###############################################################################
H_FILES = 

# HERE H_FILES

INCLUDES += $(patsubst %, $(INCLUDE_PATH)%.h, $(H_FILES))

#BONUS_H_FILES = ./get_next_line_bonus.h GNL_TESTS.h

#INCLUDES_BONUS += $(patsubst %, $(INCLUDE_PATH)%, $(BONUS_H_FILES))
###############################################################################
###############################################################################


########################### DEPENDENCIES ######################################
###############################################################################
# Dependencies:
DEPS = $(INCLUDES)

#ADD EXTRANEOUS DEPENCENCIES LIKE LIBRARY INCLUDES.
LIBFT = $(LIBRARIES)libft/libft.a
DEPS += $(LIBFT)
###############################################################################
###############################################################################


############################ COLORS ###########################################
###############################################################################
REMOVE_FG = \033[38;5;196m 
CREAT_FG = \033[38;5;46m
BLACK_FG = \033[38;5;0m
BLACK_BG = \033[48;5;0m
CLEAR_COLOR = \033[m

NAME_BG = \033[48;5;39m 
OBJECTS_BG = \033[48;5;121m
COUNTER_FG = \033[38;5;121m
BONUS_BG = \033[48;5;213m
###############################################################################
###############################################################################


all: $(NAME)

.PHONY: all clean fclean re bonus break_implicit_r

$(OBJ_PATH):
	@mkdir -p $(OBJ_PATH)
	@echo "\t\t$(CREAT_FG)created the $(OBJECTS_BG)$(BLACK_FG) $@ $(BLACK_BG)$(CREAT_FG) repository for $(NAME_BG)$(BLACK_FG) $(NAME) $(BLACK_BG)$(CREAT_FG)$(CLEAR_COLOR)\n"

$(NAME): $(DEPS) $(OBJ_MAIN) $(OBJ)
	@$(CC) $(CFLAGS) $(IFLAGS) $(OBJ_MAIN) $(OBJ) $(LIBFT) -o $@ $(LDFLAGS)
	@echo "\n\t\t$(CREAT_FG)Binary $(NAME_BG)$(BLACK_FG) $(NAME) $(BLACK_BG)$(CREAT_FG) has been created$(CLEAR_COLOR)"
	@echo "\t\t$(CREAT_FG)We used the flags: $(CXXFLAGS)$(CLEAR_COLOR)\n"

$(OBJ_MAIN): $(OBJ_PATH)%.o: $(SRC_PATH)%.c $(INCLUDES) | $(OBJ_PATH)
	@$(CC) $(CFLAGS) $(IFLAGS) -c $< -o $@
	$(eval FILE_COUNTER=$(shell echo $$(($(FILE_COUNTER)+1))))
	@echo " $(COUNTER_FG)[$(FILE_COUNTER)/$(FILE_NUMBER)] $(CREAT_FG)>>......... $@$(CLEAR_COLOR)"

$(OBJ): $(OBJ_PATH)%.o: $(SRC_PATH)%.c $(INCLUDES) | $(OBJ_PATH)
	@$(CC) $(CFLAGS) $(IFLAGS) -c $< -o $@
	$(eval FILE_COUNTER=$(shell echo $$(($(FILE_COUNTER)+1))))
	@echo " $(COUNTER_FG)[$(FILE_COUNTER)/$(FILE_NUMBER)] $(CREAT_FG)>>......... $@$(CLEAR_COLOR)"

$(OBJ_BONUS): $(OBJ_PATH)%.o : $(SRC_PATH)%.c $(INCLUDES) | $(OBJ_PATH)
	@$(CC) $(CFLAGS) $(IFLAGS) -c $< -o $@
	@TODO CHANGE BG COLOR: printf "[\e[32mOK\e[0m] %s\n" $@

$(LIBFT): break_implicit_r
	@make -C $(LIBRARIES)/libft

break_implicit_r: 

bonus: $(LIB) $(OBJ_BONUS) $(OBJ)
	@echo TODO: need to change the bonus rule
	@echo "\t\t$(CREAT_FG)building Library $(NAME_BG)$(BLACK_FG)$(NAME) $(BLACK_BG)$(CREAT_FG) with $(BONUS_BG)$(BLACK_FG) BONUSES $(BLACK_BG)$(CREAT_FG)...$(CLEAR_COLOR)"
	ar -src $(NAME) $^

clean:
	@echo "\t\t$(REMOVE_FG)deleting $(OBJECTS_BG)$(BLACK_FG) $(OBJ_PATH) $(BLACK_BG)$(REMOVE_FG) containing all the .o files for $(NAME_BG)$(BLACK_FG) $(NAME) $(CLEAR_COLOR)"
	@rm -rf $(OBJ_PATH)
	@rm -rf $(LIBRARIES)/libft/objects

fclean: clean
	@echo "\t\t$(REMOVE_FG)deleting $(NAME_BG)$(BLACK_FG)$(NAME) $(BLACK_BG)$(REMOVE_FG)...$(CLEAR_COLOR)"
	@make fclean -C $(LIBRARIES)/libft
	@rm -rf $(NAME)
	@echo "\t\t$(REMOVE_FG)deleting $(NAME_BG)$(BLACK_FG) compile_commands.json $(BLACK_BG)$(REMOVE_FG)...$(CLEAR_COLOR)"
	@rm -f compile_commands.json

re: fclean all

