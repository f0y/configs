ZSH=$HOME/projects/lib/oh-my-zsh
ZSH_THEME="gallois"
CASE_SENSITIVE="true"
DISABLE_CORRECTION="false"
plugins=(colorize gitignore colored-man cp emoji-clock sublime command-not-found mvn git extract svn zsh-syntax-highlighting svn encode64 rvm)
source $ZSH/oh-my-zsh.sh
HISTFILE=$HOME/.zhistory
HISTSIZE=1000000
SAVEHIST=1000000
PAGER='vimpager'
EDITOR='vim'

PATH=$PATH:/opt/sbt/bin
[[ -s ${HOME}/.rvm/scripts/rvm ]] && source ${HOME}/.rvm/scripts/rvm
PATH=$PATH:$HOME/.rvm/bin

alias jdk6='export JAVA_HOME=/usr/lib/jvm/java-6-sun'
alias jdk7='export JAVA_HOME=/usr/lib/jvm/java-7-sun'
alias jdk8='export JAVA_HOME=/usr/lib/jvm/java-8-sun'
alias java='${JAVA_HOME}/bin/java'
alias mvn="mvn-color"
alias netstat-listen="netstat -tulpn"
alias s="st -a ."
alias chromium-private='/usr/bin/chromium-browser --proxy-server="http://192.168.1.50:8118" --incognito &'

alias -s {avi,mpeg,mpg,mov,m2v}=mplayer
alias -s {odt,doc,sxw,rtf}=openoffice.org
autoload -U pick-web-browser
alias -s {html,htm}=google-chrome

alias ping='grc --colour=auto ping'
alias traceroute='grc --colour=auto traceroute'
alias make='grc --colour=auto make'
alias diff='grc --colour=auto diff'
alias netstat='grc --colour=auto netstat'

svndiff() {
	svn diff "${@}" | colordiff 
}

stream_desktop() {
    cvlc screen:// :screen-fps=24.000000 :input-slave=alsa://pulse :screen-follow-mouse :screen-mouse-image="~/Pictures/mousepointerimage.png" :sout="#transcode{vcodec=mp2v,vb=10000,fps=24,width=1280,acodec=mp3,ab=192,channels=2,samplerate=44100} :http{dst=:18081/desk.ts}" :no-sout-rtp-sap :no-sout-standard-sap :ttl=1 :sout-keep
}

extract_audio() {
    TEMP_WAV=`mktemp`'.wav'
    echo 'writing wav to ' $TEMP_WAV
    TARGET_FILE=`basename $1`'.mp3'
    ffmpeg -i $1 $TEMP_WAV
    lame -h -b 128 $TEMP_WAV $TARGET_FILE
}

make_post() {
    BLOG_PATH=~/projects/other/f0y.github.com/_posts
    TITLE=$1
    echo "Post title: $TITLE"
    TITLE_OUT=`echo "$1" | sed -e "s/\\s/-/g"`
    echo "Post title for output $TITLE_OUT"
    FILENAME=$BLOG_PATH/`date +%Y-%m-%d`-$TITLE_OUT.md
    echo "Creating file $FILENAME"
    touch $FILENAME
    echo -n "---
layout: post
title: \"$TITLE\"
category : Programming
---" > $FILENAME
}

m4a2mp3() {
    for i in *.m4a; do
    faad "$i"
    x=`echo "$i"|sed -e 's/.m4a/.wav/'`
    y=`echo "$i"|sed -e 's/.m4a/.mp3/'`
    lame -h -b 192 "$x" "$y"
    rm "$x"
    done
}

determine_line_ending() {
    perl -p -e 's[\r\n][WIN\n]; s[(?<!WIN)\n][UNIX\n]; s[\r][MAC\n];' $1
}

killit() {
    ps aux | grep $1 | egrep -v "grep|tmux"  | awk '{ print $2 }' | xargs kill -9
}
