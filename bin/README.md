# bin/ 

## Overview
Meant for environment scripts and utilities.

This sort of uses a **dispatch pattern**, where we create our subshell, which adds dispatch.sh to PATH. We then use dispatch.sh to call the rest of our scripts as necessary.

As an example...

1. Create the project subshell:

        ./bin/envsetup

2. Run dispatch.sh with various commands

        dispatch.sh help


Arguments in subscripts are included in dispatch.sh using bash's builtin `shift`.

Down the line, `help` flags will be added for each utility
