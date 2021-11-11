#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Sourcing .bash_aliases

if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
fi


PS1='[\u@\h \W]\$ '


export TERM='xterm-256color'


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/usr/local/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/alge/google-cloud-sdk/path.bash.inc' ]; then . '/home/alge/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/alge/google-cloud-sdk/completion.bash.inc' ]; then . '/home/alge/google-cloud-sdk/completion.bash.inc'; fi

# # Start ssh-agent automatically
# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#     ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
# fi
# if [[ ! "$SSH_AUTH_SOCK" ]]; then
#     eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")"
# fi

eval $(keychain --eval --quiet --confhost)
export SSH_ASKPASS=ssh-askpass

# My path directories
[[ -z $(echo $PATH | grep 'path_aliases') ]] && PATH=~/path_aliases:$PATH
[[ -z $(echo $PATH | grep '\.local/bin') ]] && PATH=~/.local/bin:$PATH

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
pyenv global anaconda3-2019.10

# TEMP variables
export dstr="/home/alge/hse2/crsra_HSE_SanDiego/DataStructures"
