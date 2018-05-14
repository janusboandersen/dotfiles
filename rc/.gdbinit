# On Mac OS it is necessary to codesign gdb to allow it to take control of processes
# in addition, gdb must start without a shell, so the below option is set
# it can also be invoked inside the gdb cli. For more info, see
# https://sourceware.org/gdb/wiki/BuildingOnDarwin

# __________________gdb functions_________________
set startup-with-shell off
#set verbose off

# CHANGME: If you want to modify the "theme" change the colors here
#          or just create a ~/.gdbinit.local and set these variables there
# __________________color functions_________________
#
# color codes
set $BLACK = 0
set $RED = 1
set $GREEN = 2
set $YELLOW = 3
set $BLUE = 4
set $MAGENTA = 5
set $CYAN = 6
set $WHITE = 7
set $COLOR_REGNAME = $GREEN
set $COLOR_REGVAL = $BLACK
set $COLOR_REGVAL_MODIFIED  = $RED
set $COLOR_SEPARATOR = $BLUE
set $COLOR_CPUFLAGS = $RED
