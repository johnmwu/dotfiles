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

export BIN_ENV_DIR="$BIN_DIR/env"

export ENV_STOW_DIR="${BIN_DIR}/env/stow"

export PROC_DIR="${HOME}/core/mind/sys/short/proc"

export TEMP="${HOME}/other/temp"

export SAFE_ARCHIVE="${HOME}/core/state/env/safe.org.7z"
export WANDER_ARCHIVE="${HOME}/core/mind/sys/other/wander.txt.7z"
export README_HOME="${HOME}/core/mind/sys/other/readme-home.org"

if [[ $HOSTNAME = aloysius ]]; then
		export SLS_ROOT=""
elif [[ $HOSTNAME = contessa ]]; then
		export SLS_ROOT="$HOME/other/sls-root"
fi

# this is recommended, but a symlink. Breaks when mounting using sshfs. 
# export SLS_HOME="$SLS_ROOT/usr/users/johnmwu"
export SLS_HOME_REL="data/sls/u/urop/johnmwu"
export SLS_DATA_HOME_REL="data/sls/temp/johnmwu"
export SLS_HOME="$SLS_ROOT/$SLS_HOME_REL"
export SLS_DATA_HOME="$SLS_ROOT/$SLS_DATA_HOME_REL"

export JMW_EMACS_CONFIG="$ENV_STOW_DIR/emacs/.emacs.d/config.org"
export JMW_LATEX_CONFIG="$ENV_STOW_DIR/texmf/texmf/tex/latex/jmw/jmw.sty.org"
export JMW_SH_CONFIG="$ENV_STOW_DIR/bash/.profile.org"

export PATH="${PATH}:${BIN_DIR}/bin"

export PYTHONPATH="$PYTHONPATH:$BIN_ENV_DIR/py"

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

alias e="emacsclient"
alias v="vim"

alias python="python3"
alias ju="jupyter notebook &> /dev/null & disown"

shopt -s globstar

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

PS1="\[${BWhite}\][\
\[${BCyan}\]\u@\h\
\[${BGreen}\] \W\
\[${BWhite}\]]\$ \
\[${Color_Off}\]"

function jmw_on_desktop () {
	[[ $(uname -m) = x86* ]]
}

function jmw_on_mobile () {
		! jmw_on_desktop
}

export HDF5_USE_FILE_LOCKING=FALSE # See https://github.com/MPAS-Dev/MPAS-Analysis/issues/407

if jmw_on_desktop; then
		export EDITOR="emacsclient --alternate-editor=emacs" 
		export PATH="${PATH}:/usr/local/texlive/2018/bin/x86_64-linux"
		export PATH="${PATH}:${HOME}/.android/Android/Sdk/platform-tools"
		export PATH="${PATH}:${HOME}/.local/bin"
		if [[ $XDG_SESSION_TYPE = "x11" ]]; then 
				alias o="xdg-open 2>/dev/null"
		else
				alias o="gio open 2>/dev/null"
		fi
		if type dconf; then
				dconf write /org/gnome/settings-daemon/plugins/media-keys/area-screenshot-clip "['<Ctrl><Shift>End']"
		fi &>/dev/null
		/usr/bin/setxkbmap -option "ctrl:swapcaps"
		export BROWSER="firefox"
		export PDF_VIEWER="okular"
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
		vterm_cmd() {
		    local vterm_elisp
		    vterm_elisp=""
		    while [ $# -gt 0 ]; do
		        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
		        shift
		    done
		    vterm_printf "51;E$vterm_elisp"
		}
		find_file() {
		    vterm_cmd find-file "$(realpath "${@:-.}")"
		}
		
		say() {
		    vterm_cmd message "%s" "$*"
		}
		vterm_set_directory() {
		    vterm_cmd update-pwd "$PWD/"
		}
		PROMPT_COMMAND="$PROMPT_COMMAND;vterm_set_directory"
		export GOPATH="${HOME}/go"
		export PATH="${PATH}:${GOPATH}/bin"
		if [[ $DESKTOP_SESSION = "emacs" ]]; then
				export GTK_IM_MODULE=ibus
				export QT_IM_MODULE=ibus
				export QT4_IM_MODULE=ibus
				export XMODIFIERS=@im=ibus
				ibus-daemon -dx
		fi
fi

if jmw_on_mobile; then
		export TEXT_EDITOR="vim"
		alias o="termux-open"
		alias wander="bash wander"
		alias safe="bash safe"
		alias agenda="bash agenda"
fi
