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

    git checkout "$2" && git pull origin "$2" && git merge "$1"  && git push origin "$2" "$1"
}

git_move_to() {
git add web/src/main/webapp/WEB-INF/ftl/pages/service/$2 web/src/main/java/com/nvision/pgu/web/services/$2
git commit -m "$1" web/src/main/webapp/WEB-INF/ftl/pages/service/$2 web/src/main/java/com/nvision/pgu/web/services/$2
git stash save
LAST_COMMIT=`git rev-parse HEAD`
FEATURE_BRANCH=`current_branch`
git co $2.common
git cherry-pick $LAST_COMMIT
git co $FEATURE_BRANCH
git reset --hard HEAD~1
git merge $2.common 
git stash apply
    
}

extract_audio() {
TEMP_WAV=`mktemp`'.wav'
echo 'writing wav to ' $TEMP_WAV
TARGET_FILE=`basename $1`'.mp3'
ffmpeg -i $1 $TEMP_WAV
lame -h -b 128 $TEMP_WAV $TARGET_FILE

}


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
