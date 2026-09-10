# Aesthetically Pleasing Bash Configuration
# Reset previous settings to avoid conflicts
unset PROMPT_COMMAND
PS1=""

# Colors with proper escaping for PS1
RESET="\[\033[0m\]"
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
MAGENTA="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
WHITE="\[\033[0;37m\]"
BOLD_BLACK="\[\033[1;30m\]"
BOLD_RED="\[\033[1;31m\]"
BOLD_GREEN="\[\033[1;32m\]"
BOLD_YELLOW="\[\033[1;33m\]"
BOLD_BLUE="\[\033[1;34m\]"
BOLD_MAGENTA="\[\033[1;35m\]"
BOLD_CYAN="\[\033[1;36m\]"
BOLD_WHITE="\[\033[1;37m\]"

# Fix for echo color output in functions
ECHO_RESET="\033[0m"
ECHO_BLACK="\033[0;30m"
ECHO_RED="\033[0;31m"
ECHO_GREEN="\033[0;32m"
ECHO_YELLOW="\033[0;33m"
ECHO_BLUE="\033[0;34m"
ECHO_MAGENTA="\033[0;35m"
ECHO_CYAN="\033[0;36m"
ECHO_WHITE="\033[0;37m"
ECHO_BOLD_BLACK="\033[1;30m"
ECHO_BOLD_RED="\033[1;31m"
ECHO_BOLD_GREEN="\033[1;32m"
ECHO_BOLD_YELLOW="\033[1;33m"
ECHO_BOLD_BLUE="\033[1;34m"
ECHO_BOLD_MAGENTA="\033[1;35m"
ECHO_BOLD_CYAN="\033[1;36m"
ECHO_BOLD_WHITE="\033[1;37m"

# Enhanced git status function with untracked changes indicator
parse_git_status() {
  local git_status=$(git status -s 2>/dev/null)
  local branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

  if [ -n "$branch" ]; then
    local status_indicators=""

    # Check for untracked files
    if echo "$git_status" | grep -q '?? '; then
      status_indicators+="?"
    fi

    # Check for modified files
    if echo "$git_status" | grep -q ' M\| A\| D\| R\| C'; then
      status_indicators+="*"
    fi

    # Check for staged files
    if echo "$git_status" | grep -q '^M\|^A\|^D\|^R\|^C'; then
      status_indicators+="+"
    fi

    # Display branch with status indicators
    echo -n "[$branch"
    if [ -n "$status_indicators" ]; then
      echo -n "|$status_indicators"
    fi
    echo -n "]"
  fi
}

# Function to get exit status color
exit_status_color() {
  if [ $? -eq 0 ]; then
    echo -e "${ECHO_BOLD_GREEN}✓${ECHO_RESET}" # Green checkmark for success
  else
    echo -e "${ECHO_BOLD_RED}✗${ECHO_RESET}" # Red X for error
  fi
}

# Function to get current time (HH:MM)
current_time() {
  date +"%H:%M"
}

# Enhanced system info for welcome message
function clean_sysinfo() {
  fastfetch
}

# Directory size function
dirsize() {
  du -sh "${1:-.}" | sort -hr
}

# Function to extract various archive types
extract() {
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar e "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick directory navigation
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Enhanced aliases
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias la='ls -lah --color=auto'
alias lt='ls -lahtr --color=auto'  # List by time, reversed
alias l.='ls -lhd .* --color=auto' # List hidden files
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias mkdir='mkdir -pv'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias today='date +"%d-%m-%Y"'
alias wget='wget -c'
alias update='sudo apt update && sudo apt upgrade -y'
alias ports='netstat -tulanp'

# Git aliases
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gpull='git pull'

# File search
alias ff='find . -type f -name'
alias fd='find . -type d -name'

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s cmdhist

# Ignore duplicates in history and some common commands
export HISTIGNORE="&:ls:ll:la:cd:exit:clear:history"

# Check window size after each command
shopt -s checkwinsize

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Clean and elegant multi-line prompt with time, exit status and git information
prompt_command() {
  local EXIT="$?"
  local EXIT_STATUS=""

  # Set exit status indicator
  if [ $EXIT -eq 0 ]; then
    EXIT_STATUS="${BOLD_GREEN}✓${RESET}"
  else
    EXIT_STATUS="${BOLD_RED}✗ $EXIT${RESET}"
  fi

  # Set terminal title
  echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/$HOME/~}\007"
}

PROMPT_COMMAND=prompt_command

# Custom multi-line prompt with added features
PS1="\n${BOLD_BLUE}┌─[${RESET}${BOLD_CYAN}\u${RESET}${BOLD_BLUE}@${RESET}${BOLD_GREEN}\h${RESET}${BOLD_BLUE}]─[${RESET}${YELLOW}\w${RESET}${BOLD_BLUE}]─[${RESET}${WHITE}\$(current_time)${RESET}${BOLD_BLUE}]${RESET}${MAGENTA}\$(parse_git_status)${RESET} \$(if [ \$? -eq 0 ]; then echo \"${BOLD_GREEN}✓${RESET}\"; else echo \"${BOLD_RED}✗${RESET}\"; fi)\n${BOLD_BLUE}└─▶${RESET} "

# Show clean system info at login, only once
if [ "$SHLVL" = 1 ]; then
  clean_sysinfo
fi

# Set a large command history
export HISTSIZE=10000

# Set colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Weather function - requires curl and an internet connection
weather() {
  local city="${1:-}"
  if [ -z "$city" ]; then
    curl -s "wttr.in/?q&format=3"
  else
    curl -s "wttr.in/$city?q&format=3"
  fi
}

# Quick note taking
note() {
  local notes_dir="$HOME/notes"
  mkdir -p "$notes_dir"

  if [ -z "$1" ]; then
    # List all notes
    echo -e "${ECHO_BOLD_CYAN}Notes:${ECHO_RESET}"
    ls -la "$notes_dir"
  else
    # Open or create a note
    $EDITOR "$notes_dir/$1.md"
  fi
}

# Function to display cheatsheet for common commands
cheatsheet() {
  local command="$1"
  if [ -z "$command" ]; then
    echo -e "${ECHO_BOLD_YELLOW}Available cheatsheets:${ECHO_RESET} git, bash, vim, tmux"
    return
  fi

  case "$command" in
  git)
    echo -e "${ECHO_BOLD_GREEN}Git Cheatsheet:${ECHO_RESET}"
    echo -e "${ECHO_YELLOW}git init${ECHO_RESET} - Initialize a repository"
    echo -e "${ECHO_YELLOW}git clone [url]${ECHO_RESET} - Clone a repository"
    echo -e "${ECHO_YELLOW}git add [file]${ECHO_RESET} - Add file to staging"
    echo -e "${ECHO_YELLOW}git commit -m [msg]${ECHO_RESET} - Commit changes"
    echo -e "${ECHO_YELLOW}git status${ECHO_RESET} - Check status"
    echo -e "${ECHO_YELLOW}git pull${ECHO_RESET} - Pull changes"
    echo -e "${ECHO_YELLOW}git push${ECHO_RESET} - Push changes"
    echo -e "${ECHO_YELLOW}git branch${ECHO_RESET} - List branches"
    echo -e "${ECHO_YELLOW}git checkout [branch]${ECHO_RESET} - Switch branches"
    ;;
  bash)
    echo -e "${ECHO_BOLD_GREEN}Bash Cheatsheet:${ECHO_RESET}"
    echo -e "${ECHO_YELLOW}ctrl+a${ECHO_RESET} - Move to beginning of line"
    echo -e "${ECHO_YELLOW}ctrl+e${ECHO_RESET} - Move to end of line"
    echo -e "${ECHO_YELLOW}ctrl+r${ECHO_RESET} - Search history"
    echo -e "${ECHO_YELLOW}ctrl+l${ECHO_RESET} - Clear screen"
    echo -e "${ECHO_YELLOW}ctrl+u${ECHO_RESET} - Cut line before cursor"
    echo -e "${ECHO_YELLOW}ctrl+k${ECHO_RESET} - Cut line after cursor"
    echo -e "${ECHO_YELLOW}ctrl+y${ECHO_RESET} - Paste cut text"
    ;;
  *)
    echo -e "${ECHO_RED}No cheatsheet available for $command${ECHO_RESET}"
    ;;
  esac
}

# Improved cd command that lists directory after changing
cd() {
  builtin cd "$@" && ls -la
}

# End of configuration
# echo -e "${ECHO_GREEN}Bash configuration loaded successfully!${ECHO_RESET}"
