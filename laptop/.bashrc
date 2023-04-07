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
HISTSIZE=1000
HISTFILESIZE=2000

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
    PS1='${arch_chroot:+($arch_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${arch_chroot:+($arch_chroot)}\u@\h:\w\$ '
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

#custom aliases
alias mars="java -jar ~/Downloads/Mars4_5.jar"
alias sshbbb="ssh debian@192.168.7.2"
alias sshbbb1="ssh debian@192.168.8.2"
alias sshbbb2="ssh debian@192.168.9.2"
alias uniwork="cd ~/work/computing-work"
alias ics="cd ~/work/computing-work/year2/ics"
alias iads="cd ~/work/computing-work/year2/iads"
alias hyped22="cd ~/work/hyped-2022; code .; cd build; make -j"
alias hyped23="cd ~/work/hyped-2023; code .; cd build; make -j"
alias code="code ."
alias editbashrc="nano ~/.bashrc; . ~/.bashrc"
alias git="git "
alias restore="restore --staged $1"
alias bat="cat /sys/class/power_supply/BAT0/capacity"
alias gui="gnome-shell --wayland"
alias shutdown="sudo shutdown now"
alias make="make -j"
alias aoc="cd ~/work/advent-of-code/rust"
alias tc="ping -c 2 archlinux.org"
alias bt=bluetoothctl
alias rebuild="cd ~/work/hyped-2023; rm -rf build; mkdir build; cd build; cmake ..; make -j"
alias htb="sudo echo; cd ~/work/random-stuff/htb; gnome-terminal --tab -- bash -c 'cd ~/work/random-stuff/htb; exec bash'; sudo openvpn starting_point_Infernox91645.ovpn"
gfa() {
	local path="$(git rev-parse --show-toplevel)"
	echo "$path"
	git add "$path/$1"
	git clang-format
	git add "$path/$t1"
}

gbp() {
	local path="$(pwd)"
	cd /home/infernox/work/hyped-2023/build
	if make -j; then
		git push
	else
		read -p $'\e[41mBuild failed. Push anyway? [y/n]\e[0m ' local input
		if [[ $input = "y" ]] || [[ $input = "Y" ]]; then
			git push
		fi
	fi
	cd $path
}

gcp() {
	git checkout $1
	git pull
}

ros2_on(){
     export ROS_DOMAIN_ID=42
     export ROS_VERSION=2
     export ROS_PYTHON_VERSION=3
     export ROS_DISTRO=foxy
     source /opt/ros2/foxy/setup.bash
}

if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi # Ubuntu Budgie END

. "$HOME/.cargo/env"

exec fish
