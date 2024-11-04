# shellcheck shell=sh disable=SC1091,SC2039,SC2166
# Check for interactive bash and that we haven't already been sourced.
## JD commented out this next line on 11/4/23 because brew bash autocompletion was failing
#if [ "x${BASH_VERSION-}" != x -a "x${PS1-}" != x -a "x${BASH_COMPLETION_VERSINFO-}" = x ]; then

    # Check for recent enough version of bash.
    if [ "${BASH_VERSINFO[0]}" -gt 4 ] ||
        [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -ge 2 ]; then
        [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] &&
            . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
        if shopt -q progcomp && [ -r /home/linuxbrew/.linuxbrew/Cellar/bash-completion@2/2.11/share/bash-completion/bash_completion ]; then
            # Source completion code.
            . /home/linuxbrew/.linuxbrew/Cellar/bash-completion@2/2.11/share/bash-completion/bash_completion
        fi
    fi

## JD commented out this next line on 11/4/23 because brew bash autocompletion was failing
#fi
