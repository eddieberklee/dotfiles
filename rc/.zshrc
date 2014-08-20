# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="muse"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/elee/dev/DevTools/bin:/Users/elee/dev/adt-bundle-mac/sdk/tools:/Users/elee/dev/adt-bundle-mac/sdk/platform-tools:/Users/elee/dev/android-test-tools/scripts"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# MY PERSONAL ALIASES
#
# Accidental ls/sl
alias sl="ls"

# These allows for pulling of the Evernote database off the device connected via USB - works when 1 device is connected and a user is logged in:
alias endb='DIR=`adb shell ls -a /sdcard/Android/data/com.evernote/files/ | grep user | tr -cd "[:print:]"`; FILE=`adb shell ls -a /sdcard/Android/data/com.evernote/files/$DIR | grep \\.db | head -1 | tr -cd "[:print:]"`; adb pull /sdcard/Android/data/com.evernote/files/$DIR/$FILE en.db'
alias endbpush='DIR=`adb shell ls -a /sdcard/Android/data/com.evernote/files/ | grep user | tr -cd "[:print:]"`; FILE=`adb shell ls -a /sdcard/Android/data/com.evernote/files/$DIR | grep \\.db | head -1 | tr -cd "[:print:]"`; adb push /sdcard/Android/data/com.evernote/files/$DIR/$FILE en.db'

# PATH points to Android SDK tools and platform-tools folders
export PATH=/usr/local/sbin:/Users/elee/dev/DevTools/bin:/Users/elee/dev/adt-bundle-mac/sdk/tools:/Users/elee/dev/adt-bundle-mac/sdk/platform-tools:/Users/elee/dev/android-test-tools/scripts:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin

export ANDROID_HOME="$HOME/dev/adt-bundle-mac/sdk"
export JAVA_HOME=`/usr/libexec/java_home -v 1.6`

# Apply My Machine-Specific Gradle File Versions
alias apply="/Users/elee/dev/gradle-exceptions/apply.sh"
alias revert="/Users/elee/dev/gradle-exceptions/revert.sh"

# Evernote Mac Client Staging/Production Switch
alias evernote_stage="defaults write com.evernote.Evernote stage YES"
alias evernote_production="defaults write com.evernote.Evernote stage NO"

# Android SDK
alias android_sdk="subl ~/dev/adt-bundle-mac/sdk/sources/android-17/android"


# Useful Only When Working on Evernote_Android
# cd /Users/elee/dev/android; git st
#


# Android APK Building
# TODO: replace extraneous output with readable output
alias android-emulator="build_evernote e android evernote-android com.evernote"
alias android-device="build_evernote d android evernote-android com.evernote"
alias android-widget-emulator="build_evernote e android-widget evernote-android-widget com.evernote.widget"
alias android-widget-device="build_evernote d android-widget evernote-android-widget com.evernote.widget"
alias android-old-emulator="build_evernote e android-old evernote-android com.evernote"
alias android-old-device="build_evernote d android-old evernote-android com.evernote"

build_evernote() {
  uninstall $1 $4
  cd /Users/elee/dev/$2
  mvn -U clean install
  install $1 ./app/target/$3.apk
} 

alias evernote-database="cd /Users/elee/evernote-data-dump; endb; mv en.db en.sqlite"

alias install-referrer-broadcast="adb shell am broadcast -a com.android.vending.INSTALL_REFERRER -n com.evernote/com.evernote.util.ReferralTrackingReceiver --es 'referrer' 'utm_medium=test&utm_source=eddySourceMedium&utm_term=eddyTerm&utm_content=eddyContent&utm_campaign=testCampaign'"

uninstall() {
  adb -$1 shell pm uninstall $2
}
install() {
  adb -$1 install $2
}

alias gradle="cp ~/dev/gradle-exceptions/app/build.gradle ./app/build.gradle"
alias ungradle="cp ~/dev/gradle-exceptions/app/build.gradle.old ./app/build.gradle"


# Git Stuff
alias git-b="perl /Users/elee/dotfiles/git/git-branch-with-description.pl"
