ZSH=$HOME/workspace/oh-my-zsh
ZSH_THEME="gallois"
CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_AUTO_TITLE="true"
# COMPLETION_WAITING_DOTS="true"
plugins=(git rvm extract svn)

source $ZSH/oh-my-zsh.sh
HISTFILE=$HOME/.zhistory
PAGER='less'
alias lock-screen="qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"
EDITOR='vim'
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
unsetopt auto_cd
unsetopt correct_all