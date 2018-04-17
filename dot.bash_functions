function mkcd() { mkdir "$1" && cd "$1"; }

function inttohex()
{
	if [ $1 -lt 16 ]
	then
		echo -n 0$(echo "obase=16; $1" |bc)
	else
		echo -n $(echo "obase=16; $1" |bc)
	fi
}

function rot13()
{
        if [ $# = 0 ] ; then
                tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
        else
                tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" < $1
        fi
}

function b64()
{
	if [ -f $1 ]
	then
		base64 -d --ignore-garbage -q `cat $1|tr -d '\n '`
	else
		base64 -d --ignore-garbage -q `echo $*|tr -d '\n '`
	fi
}

function watch()
{
	if [ -f `which watch` ]
	then
		`which watch` $@
	else
		while true;
		do
			clear
			$@
			sleep 5
		done
	fi
}

function psgrep()
{
	if [ ! -z $1 ]
	then
		if [ "$OSTYPE" == "cygwin" ]
		then
			ps -aW|grep $@|grep -iv grep
		else
			ps aux|awk '$11 != "grep"'|grep -i $@
		fi
	else
		echo "Must provide something to search for."
	fi
}

# positive integer test (including zero)
function positive_int() { return $(test "$@" -eq "$@" > /dev/null 2>&1 && test "$@" -ge 0 > /dev/null 2>&1); }

# resize the Terminal window
function sizetw()
{ 
	if [[ $# -eq 2 ]] && $(positive_int "$1") && $(positive_int "$2"); then 
		printf "\e[8;${1};${2};t"
		return 0
	fi
	return 1
}

function :wq()
{
	kill -9 $$
}
