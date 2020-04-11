export VISUAL=vim
export EDITOR="$VISUAL"

# set the terminal prompt to:
# user:current_dir(git branch)$
function parse_git_branch {
     git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
     
}

export PS1="\u:\W\$(parse_git_branch)\\$ "
