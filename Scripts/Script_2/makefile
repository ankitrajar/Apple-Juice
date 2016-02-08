
include $(SOFTWARE_ROOT)/make/rules.tn100 

ADDED_CFLAGS = #-Werror #-pedantic -pedantic-errors 
ADDED_C++FLAGS = #-Werror #-pedantic -pedantic-errors 
ADDED_C++_INCLUDES = -I$(SOFTWARE_ROOT)/app/common

ifeq ($(SMART_TIDL),YES)
    ADDED_C++FLAGS += -DSMART_TIDL
endif

ifeq ($(DEBUG_SMART),YES)
    ADDED_C++FLAGS += -DDEBUG_SMART
endif

all: 

clean: 



