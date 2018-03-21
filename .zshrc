ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gallois"
CASE_SENSITIVE="true"
DISABLE_CORRECTION="false"
plugins=(colorize gitignore colored-man cp emoji-clock sublime command-not-found mvn git extract svn zsh-syntax-highlighting svn encode64 rvm)
source $ZSH/oh-my-zsh.sh
HISTFILE=$HOME/.zhistory
HISTSIZE=1000000
SAVEHIST=1000000
PAGER='less'
EDITOR='vim'

alias netstat-listen="netstat -tulpn"
alias s="st -a ."

alias -s {avi,mpeg,mpg,mov,m2v}=mplayer
alias -s {odt,doc,sxw,rtf}=openoffice.org
autoload -U pick-web-browser
alias -s {html,htm}=google-chrome

alias ping='grc --colour=auto ping'
alias traceroute='grc --colour=auto traceroute'
alias make='grc --colour=auto make'
alias diff='grc --colour=auto diff'
alias netstat='grc --colour=auto netstat'

determine_line_ending() {
    perl -p -e 's[\r\n][WIN\n]; s[(?<!WIN)\n][UNIX\n]; s[\r][MAC\n];' $1
}

killit() {
    ps aux | grep $1 | egrep -v "grep|tmux"  | awk '{ print $2 }' | xargs kill -9
}
