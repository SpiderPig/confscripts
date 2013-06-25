# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

if [ -d $HOME/bin ] ; then
PATH=$PATH:$HOME/bin
fi
export PATH

unset USERNAME

export HISTSIZE=5000
export HISTFILESIZE=5000
