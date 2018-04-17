# Alias definitions.
#
alias pu="pushd"
alias po="popd"
alias ll='ls -l'
alias la='ls -A'
alias lal='ls -Al'
alias pygrep='grep --include=*.py'
alias l='ls -CF'
alias lt='ls -Altr'
alias today='date +%Y-%m-%d'
alias ..='cd ..'
alias sdr="screen -A -d -r"
alias sxr="screen -A -x -r"
alias ss="ps -aux"
alias dot='ls .[a-zA-Z0-9_]*'
alias dusg='du -s *|sort -g'
alias colors='for ((x=0; x<=255; x++));do echo -e "${x}:\033[48;5;${x}mcolor\033[000m";done'

# The LESS env var isn't working.
#alias less="less -iMRS"

if [ ! -x /bin/more ]
then
	alias more="less"
fi

if [ -d ~/rcfiles ]
then
	alias makerc="tar -C ~/rcfiles --exclude '.vimperator*' --exclude '.git' -cLzf ~/rcfiles.tgz .;ls -l ~/rcfiles.tgz;scp ~/rcfiles.tgz iaio:~/ia.io/rcfiles/rcfiles.tgz"
fi

if which curl >/dev/null
then
	alias updaterc="curl http://ia.io/rcfiles/rcfiles.tgz|tar -C ~/ -zxv"
fi

if which wget >/dev/null
then
	alias updaterc="wget -O - http://ia.io/rcfiles/rcfiles.tgz|tar -C ~/ -zxv"
fi

if which dig >/dev/null
then
	alias remoteip="dig +short myip.opendns.com @resolver1.opendns.com"
fi

if which perl >/dev/null && which ifconfig >/dev/null
then
	alias allips="ifconfig -a|perl -nle '/(\d+\.\d+\.\d+\.\d+)/ && print \$1'"
fi

#Add OS detection code here
case "$OSTYPE" in
	cygwin)
		alias open="rundll32 url.dll,FileProtocolHandler"
		alias kill="kill -f -9"
		alias psa="ps -aW"
		#cygwin and their termcap sucks...
		if which clear >/dev/null 2>&1
		then
			alias clear="TERM=xterm `which clear`"
		fi
		alias man="TERM=xterm `which man`"
		;;
	linux*)
		alias open="gnome-open"
		alias psa="ps aux"
		;;
	darwin*)
		alias psa="ps aux"
		#Install from macports...
		alias seq="gseq"
		alias locate="mdfind -name"
		cdf ()
		{
			currFolderPath=`/usr/bin/osascript -e 'tell application "Finder"' -e 'try' -e 'set currFolder to (folder of the front window as alias)' -e 'on error' -e 'set currFolder to (path to desktop folder as alias)' -e 'end try' -e 'POSIX path of currFolder' -e 'end tell'`
			echo "$currFolderPath"
			cd "$currFolderPath"
		}
		alias localip="ipconfig getifaddr en1 || ipconfig getifaddr en0"
		;;
esac
