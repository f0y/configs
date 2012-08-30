ZSH=$HOME/projects/other/oh-my-zsh
ZSH_THEME="gallois"
CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_AUTO_TITLE="true"
# COMPLETION_WAITING_DOTS="true"
plugins=(git rvm extract svn)
source $ZSH/oh-my-zsh.sh
unsetopt auto_cd
# unsetopt correct_all
HISTFILE=$HOME/.zhistory
HISTSIZE=1000000
SAVEHIST=1000000
PAGER='vimpager'
EDITOR='vim'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

alias lock-screen="qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"
alias s='setsid sublime -a'

git_push_to() {
    FEATURE_BRANCH=`current_branch`
    git checkout "$1" && git pull origin "$1" && git merge $FEATURE_BRANCH  && git push origin "$1" $FEATURE_BRANCH && git co $FEATURE_BRANCH
}

git_move_to() {
git add web/src/main/webapp/WEB-INF/ftl/pages/service/$2 web/src/main/java/com/nvision/pgu/web/services/$2 
git commit -m "$1"
git stash save
LAST_COMMIT=`git rev-parse HEAD`
FEATURE_BRANCH=`current_branch`
git co $2.common
git cherry-pick $LAST_COMMIT
git co $FEATURE_BRANCH
git reset --hard HEAD~1
git merge $2.common
git stash pop
}

git_merge_with() {
FEATURE_BRANCH=`current_branch`
BRANCHES=$1
for MERGE_BRANCH in $(echo $BRANCHES | tr " " "\n")
do
    git checkout $MERGE_BRANCH && git pull origin $MERGE_BRANCH && git merge $FEATURE_BRANCH && git push origin $MERGE_BRANCH
done
git co $FEATURE_BRANCH
git push origin $FEATURE_BRANCH   
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

pcat() {
    if [ ! -x $(which pygmentize) ]; then
        echo package \'pygmentize\' is not installed!
        exit -1
    fi
     
    if [ $# -eq 0 ]; then
        echo usage: `basename $0` "file [file ...]"
        exit -2
    fi
     
    for FNAME in $@
    do
        filename=$(basename "$FNAME")
        extension=${filename##*.}
        pygmentize -l $extension $FNAME
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
