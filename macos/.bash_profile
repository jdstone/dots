NOTE: Homebrew on Apple silicon macs installs to: /opt/homebrew and /opt/homebrew/bin


## PATH ##

export PATH="~/bin:$PATH"

## Krew (kubectl plugin)
if [ -d "${KREW_ROOT:-$HOME/.krew}" ]; then
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi


## SOURCING ##

source /etc/profile
source ~/.bash_aliases
if [ -d "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" ]; then
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi

## iTerm Bash integration
if [ -e "${HOME}/.iterm2_shell_integration.bash" ]; then
    source "${HOME}/.iterm2_shell_integration.bash"
fi

## Source Homebrew
if [ -f "$HOMEBREW_PREFIX" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

## Kubectl Bash auto-completion
if [ "$(which kubectl)" ]; then
    source <(kubectl completion bash)
    alias k='kubectl'
    complete -o default -F __start_kubectl k
fi

## kube-ps1 prompt
## https://github.com/jonmosco/kube-ps1
if [ -f "$HOMEBREW_PREFIX/opt/kube-ps1/share/kube-ps1.sh" ]; then
    source "$HOMEBREW_PREFIX/opt/kube-ps1/share/kube-ps1.sh"
fi

## asdf
if [ -d "$HOMEBREW_PREFIX/opt/asdf" ]; then
    . "$HOMEBREW_PREFIX/opt/asdf/asdf.sh"
    . "$HOMEBREW_PREFIX/opt/asdf/etc/bash_completion.d/asdf.bash"
fi

## Homebrew bash-completion@2 tab-completion
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

## Git bash completion
if [ -f "$HOMEBREW_PREFIX/etc/bash_completion.d/git-completion.bash" ]; then
    . "$HOMEBREW_PREFIX/etc/bash_completion.d/git-completion.bash"
fi

## Add git completion to aliases
if [ "$(which git)" ]; then
    __git_complete g __git_main
    __git_complete gb _git_branch
    __git_complete gco _git_checkout
    __git_complete gm _git_merge
    __git_complete gp _git_pull
fi

## bash-git-prompt
## https://github.com/magicmonty/bash-git-prompt
if [ -f "$HOMEBREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR="$HOMEBREW_PREFIX/opt/bash-git-prompt/share"
    source "$HOMEBREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh"
fi

## LiquidPrompt
## https://github.com/nojhan/liquidprompt
if [ -f "$HOMEBREW_PREFIX/share/liquidprompt" ]; then
    . "$HOMEBREW_PREFIX/share/liquidprompt"
fi


## PROMPT ##

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
#    kube_ps1=$(kube_ps1)
#    namespace=$(echo ${kube_ps1} | cut -d ':' -f 2)
#    echo -e "(${namespace}"
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

export EDITOR=/usr/bin/vim


## MISCELLANEOUS ##

## Add GitHub SSH key to keychain
## Run 'chmod 600 ~/.ssh/github_macos_ed25519' if problem adding to keychain
if [ -f "$HOME/.ssh/github_macos_ed25519" ]; then
    eval `keychain --eval github_macos_ed25519`
fi

## Git GPG signed commits
## Fixes the following error when signing Git commits:
## error: gpg failed to sign the data
## fatal: failed to write commit object
if [ "$(which gpg)" ]; then
    export GPG_TTY=$(tty)
fi

## Turn on Bash terminal coloring ##
## https://www.marinamele.com/customize-colors-of-your-terminal-in-mac-os-x/
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

