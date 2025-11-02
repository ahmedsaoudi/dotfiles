export VISUAL=nvim
export EDITOR="$VISUAL"

# set the terminal prompt to:
# user:current_dir(git branch)$
# function parse_git_branch {
#      git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
#      
# }
# 
# export PS1="\u:\W\$(parse_git_branch)\\$ "
#

#############################
# ~/.bashrc or similar file #
#############################

# 1. Optional: Some color variables for a nicer prompt
GREEN='\[\033[0;32m\]'
BLUE='\[\033[0;34m\]'
YELLOW='\[\033[0;33m\]'
RESET='\[\033[0m\]'

# 2. Source the official Git prompt script (if it exists on your system)
# On Ubuntu, it's usually at /usr/share/git/git-prompt.sh
# To get the path for the script, use `dpkg -L git | grep prompt` and 
# select the path without the "sh" in it.
if [ -f /etc/bash_completion.d/git-prompt ]; then
    . /etc/bash_completion.d/git-prompt
    
    # These env vars enable extra Git status information:
    export GIT_PS1_SHOWDIRTYSTATE=1      # Shows * (modified) and + (staged)
    export GIT_PS1_SHOWUNTRACKEDFILES=1  # Shows % if there are untracked files
    export GIT_PS1_SHOWSTASHSTATE=1      # Shows $ if something is stashed
    export GIT_PS1_SHOWCOLORHINTS=1      # Adds auto-color to the Git info
fi

# 3. Define your prompt, using __git_ps1
# \u is username, \W is basename of current dir.
# __git_ps1 " (%s)" inserts " (branch)" if you’re in a repo. 
# The color codes are wrapped in \[ \] so Bash calculates prompt length correctly.
export PS1="${GREEN}\u${RESET}:${BLUE}\W${RESET}\$(__git_ps1 ' ${YELLOW}(%s)${RESET}')\$ "

export PATH="$HOME/.local/bin:$PATH"

# Set vi mode
set -o vi

# Change cursor shape for vi mode
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string \1\e[6 q\2'
bind 'set vi-cmd-mode-string \1\e[2 q\2'
