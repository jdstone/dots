# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## SOURCING ##
##############

## Source local bash completion files
if [ -d ".bash_completion/" ]; then
  for file in ".bash_completion"/*; do
    source "$file"
  done
fi

## Source Linuxbrew
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

## Kubectl Bash auto-completion
if [ "$(which kubectl)" ]; then
  source <(kubectl completion bash)
  alias k='kubectl'
  complete -o default -F __start_kubectl k
fi

## kube-ps1 prompt
## https://github.com/jonmosco/kube-ps1
if [ -f "/home/linuxbrew/.linuxbrew/opt/kube-ps1/share/kube-ps1.sh" ]; then
  source "/home/linuxbrew/.linuxbrew/opt/kube-ps1/share/kube-ps1.sh"
fi

## asdf
if [ -d "$HOME/.asdf" ]; then
  . "$HOME/.asdf/asdf.sh"
  . "$HOME/.asdf/completions/asdf.bash"
fi

## Homebrew bash-completion@2 tab-completion
[[ -r "/home/linuxbrew/.linuxbrew/etc/profile.d/bash_completion.sh" ]] && . "/home/linuxbrew/.linuxbrew/etc/profile.d/bash_completion.sh"

## Git bash completion
if [ -f "/home/linuxbrew/.linuxbrew/etc/bash_completion.d/git-completion.bash" ]; then
  . "/home/linuxbrew/.linuxbrew/etc/bash_completion.d/git-completion.bash"
elif [ -f "/usr/share/bash-completion/completions/git" ]; then
  . "/usr/share/bash-completion/completions/git"
fi

## Add git completion to aliases
if [ "$(which git)" ]; then
  __git_complete g __git_main
  __git_complete gb _git_branch
  __git_complete gco _git_checkout
  __git_complete gm _git_merge
  __git_complete gp _git_pull
  __git_complete gst _git_stash
fi

## bash-git-prompt
## https://github.com/magicmonty/bash-git-prompt
if [ -f "/home/linuxbrew/.linuxbrew/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="/home/linuxbrew/.linuxbrew/opt/bash-git-prompt/share"
  source "/home/linuxbrew/.linuxbrew/opt/bash-git-prompt/share/gitprompt.sh"
fi

## LiquidPrompt
## https://github.com/nojhan/liquidprompt
if [ -f "/home/linuxbrew/.linuxbrew/share/liquidprompt" ]; then
  . "/home/linuxbrew/.linuxbrew/share/liquidprompt"
fi


## PROMPT ##
############

## kube-ps1 prompt
## https://github.com/jonmosco/kube-ps1
if [ -f "/home/linuxbrew/.linuxbrew/opt/kube-ps1/share/kube-ps1.sh" ]; then
  PS1='$(kube_ps1)'$PS1
fi

#KUBE_PS1_SYMBOL_ENABLE=true
#KUBE_PS1_NS_COLOR="cyan"
#export KUBE_PS1_SYMBOL_ENABLE
#export KUBE_PS1_NS_COLOR

#kube_ns() {
#  kube_ps1=$(kube_ps1)
#  namespace=$(echo ${kube_ps1} | cut -d ':' -f 2)
#  echo -e "(${namespace}"
#}

## DEFAULT PROMPT
#PS1='\h:\W \u\$ '
## NEW PROMPT
#PS1='\[\e[1;32m\]\u@\H\[\e[0m\]:\[\e[35m\]\w\[\e[0m\]$(__git_ps1 "(\[\e[31m\]%s\[\e[0m\])")\$ '
## OLD PROMPTS
#PS1='$(kube_ns) \w$(__git_ps1 " (%s)")\$ '
#PS1='\[\e[1;32m\]\u@\H\[\e[0m\]:\e[35m\]\w\[\e[0m\]$(kube_ns)$(__git_ps1 "(\[\e[31m\]%s\[\e[0m\])")\$ '
#PS1='\[\e[1;32m\]\u@\H\[\e[0m\]:\e[35m\]\w\[\e[0m\](\e[36m\]${GCLOUD_ACTIVE_PROJ}\[\e[0m\])$(kube_ns)$(__git_ps1 "(\[\e[31m\]%s\[\e[0m\])")\$ '
#PS1='\[\e[1;32m\]\u@\H\[\e[0m\]:\e[35m\]\w\[\e[0m\](\e[36m\]\[${GCLOUD_ACTIVE_PROJ}\]\[\e[0m\])$(kube_ns)$(__git_ps1 "(\[\e[31m\]%s\[\e[0m\])")\$ '


## EDITOR ##
############

export EDITOR=/usr/bin/vim


## MISCELLANEOUS ##
###################

## Add GitHub SSH key to keychain
## Run 'chmod 600 ~/.ssh/github_server_ed25519' if problem adding to keychain
if [ -f "$HOME/.ssh/github_server_ed25519" ]; then
  eval `keychain --eval --agents ssh github_server_ed25519`
fi

## Git GPG signed commits
## Fixes the following error when signing Git commits:
## error: gpg failed to sign the data
## fatal: failed to write commit object
if [ "$(which gpg)" ]; then
  export GPG_TTY=$(tty)
fi

