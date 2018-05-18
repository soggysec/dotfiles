# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f ~/.bash_colors ]; then
    . ~/.bash_colors
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=90000

# append to the history file
shopt -s histappend

# re-edit failed history substitutions
shopt -s histreedit

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# ignore case while expanding filenames
shopt -u nocaseglob

#make multiline commands all be one when searching history
shopt -s cmdhist

# multiline has embedded newline instead of ;
shopt -u lithist

# correct spelling errors when using cd
shopt -s cdspell

# include filenames starting with . with filename expansion
shopt -u dotglob

# echo expands backslash-escape sequences
shopt -u xpg_echo

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

[ $TERM == 'linux' ] && STR_MAX_LENGTH=2 || STR_MAX_LENGTH=3

NEW_PWD='$(
p="${PWD#$HOME}";
[ "$p" != "$PWD" ] && echo -n "~";
i=0;

until [ "$p" == "$d2" ]; do
    echo -n "${d2:0:'"$STR_MAX_LENGTH"'}/";
    p=${p#*/};
    d2=${p%%/*};
done;
[ "$d2" ] && echo -n "${d2}";
)'

#build better detection for 256 versus regular here.
# also, add window title dressing?
case "$TERM" in
*256color*)
	DIR_COLOR='\[\e[38;5;117m\]'
	DIR_SEP_COLOR='\[\e[38;5;179m\]'
	ABBR_DIR_COLOR='\[\e[38;5;39m\]'
	HOSTNAME_COLOR='\[\e[38;5;179m\]'
	AT_COLOR='\[\e[38;5;243m\]'
	[ $UID == '0' ] && USER_COLOR='\[\e[38;5;160m\]' || USER_COLOR='\[\e[38;5;121m\]'
	[ $UID == '0' ] && FINAL_SEP='#' || FINAL_SEP='$'

	PS1_ERROR='$(
	ret=$?;
	if [ $ret -gt 0 ]; then
	    (( i = 3 - ${#ret} ));
	    echo -n "\[\e[38;5;160m\][";
	    [ $i -gt 0 ] && echo -n " ";
	    echo -n "$ret";
	    [ $i -eq 2 ] && echo -n " ";
	    echo -n "] \[\e[0m\]";
	fi
	)'
	PS1="$PS1_ERROR$USER_COLOR\u$AT_COLOR@$HOSTNAME_COLOR\h:$DIR_COLOR$NEW_PWD $USER_COLOR$FINAL_SEP \[\e[0m\]"

	;;
rxvt|xterm|screen|*color)
	function cd()
	{
        builtin cd "$@" && xtitle ${USER}@${HOSTNAME}: ${PWD/$HOME/~}
	}
#	export PS1='\[\033[00;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# 	Come back later and fix up these colors to look nicer on lame 16 color systems.
	DIR_COLOR='\[\e[38;5;117m\]'
	DIR_SEP_COLOR='\[\e[38;5;179m\]'
	ABBR_DIR_COLOR='\[\e[38;5;39m\]'
	HOSTNAME_COLOR='\[\e[38;5;179m\]'
	AT_COLOR='\[\e[38;5;243m\]'
	[ $UID == '0' ] && USER_COLOR='\[\e[38;5;160m\]' || USER_COLOR='\[\e[38;5;121m\]'
	PS1="$PS1_ERROR$USER_COLOR\u$AT_COLOR@$HOSTNAME_COLOR\h:$DIR_COLOR$NEW_PWD $USER_COLOR$FINAL_SEP \[\e[0m\]"

    ;;
*)
    PS1='\u@\h:\w\$ '
    ;;
esac

unset STR_MAX_LENGTH DIR_COLOR DIR_SEP_COLOR ABBR_DIR_COLOR HOSTNAME_COLOR AT_COLOR USER_COLOR NEW_PWD PS1_ERROR FINAL_SEP

function xtitle()
{
    echo -ne "\033]0;$*\007"
}


# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
	if [ -f ~/.dir_colors ] && which dircolors >/dev/null
	then
		eval `dircolors -b $HOME/.dir_colors`
    else
        export CLICOLOR=YES
        #This sets directory colors to less offensive blue
        export LSCOLORS="gx"
	fi

	if [[ "${OSTYPE}" == freebsd* || "${OSTYPE}" == darwin* ]]; then
		if [ -d /opt/local/bin ]
		then
			PATH=/opt/local/bin:$PATH
		fi
		if [ -d /opt/local/sbin ]
		then
			PATH=/opt/local/sbin:$PATH
		fi
		if [ -d /usr/local/bin ]
		then
			PATH=/usr/local/bin:$PATH
		fi
		if [ -d /usr/local/sbin ]
		then
			PATH=/usr/local/sbin:$PATH
		fi
	    alias ls="ls -G"
	else
	    alias ls="ls --color=always"
	fi
fi

if [ "$COLORTERM" == "gnome-terminal" ]
then
    TERM=xterm-256color
	elif [ "$COLORTERM" == "rxvt-xpm" ]
	then
		TERM=rxvt-256color
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]
then
    . /etc/bash_completion
elif [ -f /opt/local/etc/bash_completion ]
then
	. /opt/local/etc/bash_completion
elif [ -f /usr/local/etc/bash_completion ]
then
	. /usr/local/etc/bash_completion
fi

# use vim for editing
EDITOR="vim"
VISUAL="vim"

# use less for paging through text
PAGER="less"

# options to less
#   -i  ignore case while searching
#   -M  always show line numbers and percentage
#   -R  pass-through ANSI color escapes
#   -S  do not wrap lines
LESS="-iMRS"

# colorize grep
GREP_OPTIONS="--color=auto"

# python rc file (adds tab completion)
if [ -f ~/.pythonrc.py ]; then
	export PYTHONSTARTUP=~/.pythonrc.py
fi

#handy functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [ -f ~/.bash_localrc ]; then
	. ~/.bash_localrc
fi

export PS1 EDITOR VISUAL PAGER LESS TERM PATH
alias gitlog='git log --oneline --graph --pretty=format:"[%C(yellow)%h%C(reset) | %C(green)%cd %C(reset)| %C(blue)%cr%C(reset)] %C(cyan)%cn%C(reset), %C(cyan)%s" --date=short -20'

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
    export WORKON_HOME=~/Envs
    mkdir -p $WORKON_HOME
fi

if [ -f $HOME/git/dram/dram/dram.sh ]; then
    export DRAM_ROOT=/dram
    source $HOME/git/dram/dram/dram.sh
fi


export PYTHONDONTWRITEBYTECODE=1
export PM_DEBUG="true"
