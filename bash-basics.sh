# Bash Basics
# https://guide.bash.academy/commands/

# Simple commmands
# Specify the name of a command to run, any arguments, environment variables and file descriptor redirections.

# Pipelines |
# Tell bash to pipe the standard output as the standard input to the next command.
echo "This is an example of a pipeline"
echo Hello | rev

# Lists / control operators
# Between each command is a control operator, which tells bash what to do when the prior command has finished. The newline character is equivalent to a ;.
# The | character is another type of control operator.
# The || operator tells bash to execute the next command *only* if the previous command fails, e.g.:
# A bash script is essentially a list of commands connected by newline characters.
rm filename.txt || echo "Could not remove filename.txt" >&2

# Compound commands
# Commands with special syntax which means they behave as a single command (even if they contain multiple 'sub' commands).

if ! rm hello.txt; then echo "Couldn't delete hello.txt." >&2; exit 1; fi
rm hello.txt || { echo "Couldn't delete hello.txt." >&2; exit 1; }

# The first example above is a compound command - everything from 'then' onwards is executed as a single command.
# The second example is a compound command in a list of commands. Because we have surrounded it in {}, everything between those {} is considered a single command and is executed if the || recognises a failure. If the {} were left out, only the echo command would be executed on failure - 'exit' would be run no matter what.

# Coprocesses
# These are asynchronous commands which can be accessed by other commands by means of file descriptor inputs and outputs which you set up.

# Command names and running programs
# Bash searches for a matching command in the following order
# Function: all declared functions are put in a list, bash searches the list to see if any of them match a given command.
# Builtin: Tiny procedures built into bash.
# Program / external command: e.g. google-chrome. Bash finds programs by looking in your system's configured PATH.

# PATH
# The path variable contains a set of directories where bash should look for matching programs to a given command.
# Builtin programs run immediately without bash needing to check the PATH.
# If a program location has been defined in the PATH, you may need to declare the location explicitly, e.g. (superfluous)

/bin/ping -c 1 127.0.0.1

# Create a script in your home directory, add it to your PATH and then run the script as an ordinary command.
# $ ex
# : i

#!/usr/bin/env bash
echo "Hello world."
.
: w myscript
"myscript" [New] 2L, 40C written
: q
$ chmod +x myscript
$ PATH=$PATH:~
$ myscript
Hello world.

# Arguments
# Come after the command's name - they are words / tokens separated by a blank space

# Redirection
ls -l >lsfile.txt # redirects the standard output of ls to a file called lsfile.txt
ls -l >lsfile.txt 2>lserrors.txt # as above, but also redirects standard error to lserrors.txt

# If you wanted to output both FD1 and FD2 to a file called ls.txt, you should not approach it like this:
ls -l 1>lsfile.txt 2>lsfile.txt
# Because of the way output streams work, results will be unpredictable. Instead, you should duplicate output #1 as follows:

ls -l >lsfile.txt 2>&1 # Which tells bash to duplicate the file stream from SO1 to SO2.

# the >> operator appends output to a file rather than emptying the contents completely

# Here documents
# Make FD0 read the entire text block between delimiters, ending only when the delimiter appears alone on a line
cat <<.
Hello
world
How
are
You?
.

# Here Strings
# Make FD0 read from the string
cat <<<"Hello mate
What is a going on?
Are you OK?"


# Closing file descriptors
exec 3>&1 >mylog; echo moo; exec 1>&3 3>&- # Closes fd3


# Fix this command so that the message is properly saved into the log file and such that FD 3 is properly closed afterwards:  
exec 3>&2 2>log; echo 'Hello!'; exec 2>&3
exec 3>&1 >log; echo 'Hello!'; exec 1>&3 3>&-

# Variables and expansion

# Using expansion, bash will match against the patterns we provide, a la regex. 

# Extended globs
# Provide more advanced patterns. We can install them as follows:
shopt -s extglob


# Extended Glob	Meaning
# +(pattern[ | pattern ... ])	Matches when any of the patterns in the list appears, once or many times over. Reads: at least one of ....
# *(pattern[ | pattern ... ])	Matches when any of the patterns in the list appears, once, not at all, or many times over. Reads: however many of ....
# ?(pattern[ | pattern ... ])	Matches when any of the patterns in the list appears, once or not at all. Reads: maybe one of ....
# @(pattern[ | pattern ... ])	Matches when any of the patterns in the list appears just once. Reads: one of ....
# !(pattern[ | pattern ... ])	Matches only when none of the patterns in the list appear. Reads: none of ....

# Tilde expansion
# Resolves to the home directory - you can access the home directory of any user by putting their username after the tilde, as follows:
echo 'My boss lives in ' ~root

# Command Substitution
# Is the process of expanding data into command arguments.
echo "The contents of the example.txt file are $(cat example.txt)"
# Value expansion means we can start a subshell - which bash starts on the code between brackets. Bash will wait for this subshell to execute and then feed the results into the echo command.

# Bash parameters
# Allow us to access stored information. 

# Shell variables
shellvar=hello # Never spaces around the =
echo $shellvar
# You can optionally add {} to specify where the parameter name begins and ends
echo ${shellvar}

# Parameter expansion operators
# Additional modifiers which allow us to modify the output of the expansion.
# https://guide.bash.academy/expansions/?=Parameter_Expansion#p2.2.2_5

# Arrays
myarray=( one two 'and a third' )
echo ${myarray[@]}

