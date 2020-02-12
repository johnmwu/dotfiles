if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/users/johnmwu/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/users/johnmwu/anaconda3/etc/profile.d/conda.sh" ]; then
	. "/usr/users/johnmwu/anaconda3/etc/profile.d/conda.sh"
    else
	export PATH="/usr/users/johnmwu/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export BIN_DIR="${HOME}/core/prod/bin"

export ENV_STOW_DIR="${BIN_DIR}/env/stow"

export PROC_DIR="${HOME}/core/mind/sys/short/proc"

export TEMP="${HOME}/other/temp"

export SAFE_ARCHIVE="${HOME}/core/state/env/safe.txt.7z"
export WANDER_ARCHIVE="${HOME}/core/mind/sys/other/wander.txt.7z"
export README_HOME="${HOME}/core/mind/sys/other/readme-home.org"

export SLSHOME="/usr/users/johnmwu"

export PATH="${PATH}:${BIN_DIR}/bin"

alias e="emacsclient"
alias v="vim"

alias python="python3"
alias ju="jupyter notebook &> /dev/null & disown"

alias ls="ls --color"

if [[ -f ~/.dircolors ]]; then
    eval "$(env TERM=xterm dircolors ~/.dircolors)"
fi

ENV_C="35;46;01"
LS_COLORS="${LS_COLORS}*profile=$ENV_C:"
LS_COLORS="${LS_COLORS}*dircolors=$ENV_C:"
LS_COLORS="${LS_COLORS}*gitconfig=$ENV_C:"
LS_COLORS="${LS_COLORS}*emacs=$ENV_C:"
LS_COLORS="${LS_COLORS}*emacs_bash=$ENV_C:"
LS_COLORS="${LS_COLORS}*vimrc=$ENV_C:"

shopt -s globstar # Thu Feb  7 20:53:09 EST 2019

function jmw_on_desktop () {
    [[ $(uname -m) = x86* ]]
}

function jmw_on_mobile () {
    ! jmw_on_desktop
}

export HDF5_USE_FILE_LOCKING=FALSE # See https://github.com/MPAS-Dev/MPAS-Analysis/issues/407

if jmw_on_desktop; then
    export TEXT_EDITOR="emacsclient --alternate-editor=emacs" 
    export PATH="${PATH}:/usr/local/texlive/2018/bin/x86_64-linux"
    export PATH="${PATH}:${HOME}/.android/Android/Sdk/platform-tools"
    export PATH="${PATH}:~/.local/bin"
    if [[ $XDG_SESSION_TYPE = "x11" ]]; then 
        alias o="xdg-open 2>/dev/null"
    else
        alias o="gio open 2>/dev/null"
    fi
    if type dconf; then
        dconf write /org/gnome/settings-daemon/plugins/media-keys/area-screenshot-clip "['<Ctrl><Shift>End']"
    fi &>/dev/null
    function vterm_printf(){
        if [ -n "$TMUX" ]; then
    	# tell tmux to pass the escape sequences through
    	# (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
    	printf "\ePtmux;\e\e]%s\007\e\\" "$1"
        elif [ "${TERM%%-*}" = "screen" ]; then
    	# GNU screen (screen, screen-256color, screen-256color-bce)
    	printf "\eP\e]%s\007\e\\" "$1"
        else
    	printf "\e]%s\e\\" "$1"
        fi
    }
    vterm_prompt_end(){
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
    }
    PS1=$PS1'\[$(vterm_prompt_end)\]'
    export GOPATH="${HOME}/go"
    export PATH="${PATH}:${GOPATH}/bin"
fi

if jmw_on_mobile; then
    export TEXT_EDITOR="vim"
    alias o="termux-open"
    alias wander="bash wander"
    alias safe="bash safe"
fi
