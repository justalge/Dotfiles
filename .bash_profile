#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc


export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export PANEL_FIFO=/tmp/panel-fifo


if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx
fi

