ZSH=$HOME/projects/other/oh-my-zsh
ZSH_THEME="gallois"
CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_AUTO_TITLE="true"
# COMPLETION_WAITING_DOTS="true"
plugins=(git rvm extract svn)

source $ZSH/oh-my-zsh.sh
HISTFILE=$HOME/.zhistory
HISTSIZE=1000000
SAVEHIST=1000000
PAGER='less'
alias lock-screen="qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"
EDITOR='vim'
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
unsetopt auto_cd
unsetopt correct_all
alias s='setsid sublime'
git_push_to() {
    git checkout "$1" && git pull origin "$1" && git merge "$2"  && git push origin "$1" "$2"
}


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
