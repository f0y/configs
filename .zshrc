ZSH=$HOME/projects/other/oh-my-zsh
ZSH_THEME="gallois"
CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_AUTO_TITLE="true"
# COMPLETION_WAITING_DOTS="true"
plugins=(cp sublime command-not-found mvn git extract svn zsh-syntax-highlighting svn encode64 rvm)
source $ZSH/oh-my-zsh.sh
unsetopt auto_cd
#unsetopt correct_all
HISTFILE=$HOME/.zhistory
HISTSIZE=1000000
SAVEHIST=1000000
PAGER='vimpager'
EDITOR='vim'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
#[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting


#PATH=$PATH:/opt/sbt/bin
PATH=$PATH:/opt/bin
PATH=$PATH:/opt/heroku/bin

alias lock-screen="qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"
alias l='ls -ACF'
alias la='ls -aAlFh'
alias o='cat_via_pygmentize'
alias sudo='nocorrect sudo'
alias mvn="mvn-color"
alias netstat-listen="netstat -tulpn"

alias -s {avi,mpeg,mpg,mov,m2v}=mplayer
alias -s {odt,doc,sxw,rtf}=openoffice.org
autoload -U pick-web-browser
alias -s {html,htm}=chromium

alias ping='grc --colour=auto ping'
alias traceroute='grc --colour=auto traceroute'
alias make='grc --colour=auto make'
alias diff='grc --colour=auto diff'
alias cvs='grc --colour=auto cvs'
alias netstat='grc --colour=auto netstat'


git_install_hook() {
    rm -f .git/hooks/prepare-commit-msg
    ln -s $HOME/projects/work/fed-utilz/git-hooks/prepare-commit-msg .git/hooks/prepare-commit-msg
}


git_push_to() {
    FEATURE_BRANCH=`current_branch`
    git fetch origin && git rebase origin/${FEATURE_BRANCH} && git checkout "$1" && git rebase origin/${1} && git merge $FEATURE_BRANCH && git log -1 && git push origin "$1" $FEATURE_BRANCH && git co $FEATURE_BRANCH
}


git_merge_with() {
FEATURE_BRANCH=`current_branch`
BRANCHES=$1
for MERGE_BRANCH in $(echo $BRANCHES | tr " " "\n")
do
    git checkout $MERGE_BRANCH && git fetch origin && git pull --rebase && git merge $FEATURE_BRANCH && git push origin $MERGE_BRANCH
done
git co $FEATURE_BRANCH
git push origin $FEATURE_BRANCH
}

git_switch_to() {
DEST=$1
PROJECTS_HOME=/home/kandaurov/projects/work/
PROJECTS="pgu-forms-core-back pgu-forms-core-front pgu-forms-svc"
BRANCHES=$1
for PROJECT in $(echo $PROJECTS | tr " " "\n")
do
    cd "${PROJECTS_HOME}${PROJECT}" && git fetch origin && git stash save && git co $DEST && git reset --hard && git rebase && mvn clean install -Dmaven.test.skip=true
done
cd ${PROJECTS_HOME}
}

git_cp_onto() {
CURRENT_BRANCH=`current_branch`
COMMIT=$1
BRANCHES=$2
for BRANCH in $(echo $BRANCHES | tr " " "\n")
do
    git checkout $BRANCH && git fetch origin && git pull --rebase && git cherry-pick $COMMIT && git push origin
done
git co $CURRENT_BRANCH
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

cat_via_pygmentize() {
    if [ ! -x $(which pygmentize) ]; then
        echo package \'pygmentize\' is not installed!
        exit -1
    fi

    if [ $# -eq 0 ]; then
        echo "\n\n"
        echo "######################"
        echo "##  READING FROM STDIN"
        echo "######################"
        echo "\n\n"
        pygmentize -g $@
    fi
     
    for FNAME in $@
    do
        filename=$(basename "$FNAME")
        lexer=`pygmentize -N \"$filename\"`
        echo "\n\n"
        echo "#####################"
        echo "##  READING FROM FILE $FNAME"
        echo "#####################\n\n"
        if [ "Z$lexer" != "Ztext" ]; then
            pygmentize -l $lexer "$FNAME"
        else
            pygmentize -g "$FNAME"
        fi

    done
}

man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}

determine_line_ending() {
    perl -p -e 's[\r\n][WIN\n]; s[(?<!WIN)\n][UNIX\n]; s[\r][MAC\n];' $1
}

kill_matching() {
    ps aux | grep $1 | egrep -v "grep|tmux"  | awk '{ print $2 }' | xargs kill -9
}
