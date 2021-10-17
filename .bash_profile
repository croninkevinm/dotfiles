if [ "$(uname)" == "Darwin" ]; then # Do something under Mac OS X platform
  sys_type=mac
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  if [[ $(grep microsoft /proc/version) ]]; then # Do something under WSL/Linux platform
    sys_type=wsl
    PATH=$PATH:/mnt/c/Windows
  else # Do something under GNU/Linux platform
    sys_type=gnu
  fi
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then # Do something under 32 bits Windows NT platform
  
  sys_type=win
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then # Do something under 64 bits Windows NT platform
  sys_type=win
fi


shopt -s autocd
shopt -s histappend
shopt -s checkwinsize

export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# -------
# Prompt
# -------

force_color_prompt=yes

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$force_color_prompt" = yes ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
   color_prompt=yes
  else
   color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  if [ "$sys_type" = win ]; then
    PS1="${debian_chroot:+($debian_chroot)}\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[36m\]$(parse_git_branch)\[\033[00m\]\n\$ "
  else
    PS1="${debian_chroot:+($debian_chroot)}\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[36m\]\$(parse_git_branch)\[\033[00m\]\n\$ "
  fi
else
  if [ "$sys_type" = win ]; then
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\n\$ "
  else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w\$(parse_git_branch)\n\$ "
  fi
fi

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    # test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# -------
# NVM
# -------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# -------
# Functions
# -------
function mkcd()
{
  mkdir $1 && cd $1
}

function updatedotfiles()
{
  git -C ~/dotfiles pull -q
  ~/dotfiles/config.sh
}

# -------
# Aliases
# -------
alias ll='ls -alF'
alias la='ls -A'
alias lls='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias cd..='cd ..'
alias cls='clear'

# vs code
alias a='code .'
alias c='code .'
alias code.='code .'

# node
alias ns='npm start'
alias start='npm start'
alias nr='npm run'
alias run='npm run'

if [ "$sys_type" = wsl ]; then
  alias open="explorer.exe"
  alias winpath='wslpath -aw $PWD'
fi

# ----------------------
# Git Aliases
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gi='git init'
alias gl='git log'
alias gp='git pull'
alias gpsh='git push'
alias gss='git status -s'
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status'

# ----------------------
# Cleanup
# ----------------------
unset sys_type color_prompt force_color_prompt