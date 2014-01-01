# Show only the defined mailboxes when you open mutt

# Django Bindings
alias pmr="python manage.py runserver"
alias pms="python manage.py shell_plus"
alias pm="python manage.py"

# Follows aliases to their true paths
alias cd="cd -P"

alias mutt="mutt -y"
alias ls="ls -GF"
alias ll="ls -l"
alias la="ls -a"
alias l="ls -CF"
alias sl="ls"
alias L="ls -al"
alias wifiaux0="ssh wifi-aux-0.rescomp.berkeley.edu"
cl() {
	cd $1
	ls
}
vil() {
	vi $1
	ls
}
alias hal="ssh elee@hal.rescomp.berkeley.edu"
alias pandora="ssh elee@pandora.rescomp.berkeley.edu"
alias n1="ssh elee@nac-dev-1.rescomp.berkeley.edu"
alias n2="ssh elee@nac-dev-2.rescomp.berkeley.edu"
alias n3="ssh elee@nac-dev-3.rescomp.berkeley.edu"
alias n4="ssh elee@nac-dev-4.rescomp.berkeley.edu"
alias devdhcp1="ssh elee@dev-dhcp-1.rescomp.berkeley.edu"
alias devdhcp2="ssh elee@dev-dhcp-2.rescomp.berkeley.edu"

alias sv="sudo vim"
alias vi="vim"
alias e="exit"

alias cgis="cd ~/core/www/sec-cgi-bin/login"
alias modules="cd ~/core/lib/site_perl/shared"
alias cgi="cd /usr/local/ist/www/sec-cgi-bin/login"
alias module="cd /usr/local/ist/lib/site_perl/shared"
alias error="tail -f /var/log/httpd-error.log"

alias dev2mine="cp -r /usr/local/ist/lib/site_perl/shared/ ~/core/lib/site_perl/shared/"
alias mine2dev="sudo cp -r ~/core/www/sec-cgi-bin/logout/*.cgi /usr/local/ist/www/sec-cgi-bin/logout/; sudo cp -r ~/core/lib/site_perl/shared/*.pm ~/core/lib/site_perl/shared/*.conf /usr/local/ist/lib/site_perl/shared/; sudo cp -r ~/core/www/sec-cgi-bin/login/*.cgi /usr/local/ist/www/sec-cgi-bin/login/; sudo cp ~/core/lib/site_perl/filesystem/Session.pm /usr/local/ist/lib/site_perl/filesystem/Session.pm;"


create() {
	sudo touch $1
	sudo chmod 777 $1
}

d() {
	diff $1 /usr/local/ist/lib/site_perl/shared/$1
}

s() {
	ssh $1@$2.berkeley.edu
}

alias rails_reset="rm -rf ~/cs169-group29/db/*.sqlite3; rake db:migrate; rake db:seed"

export HISTSIZE=1000

edit() {
	vi ~/dotfiles/rc/.$1
}

music-to-desktop() {
  echo $1 >> ~/Desktop/music-to-desktop/quicky.txt
}
music-to-download() {
  echo $1 >> ~/Desktop/music-to-download/quicky.txt
}

source ~/.git-prompt.sh
PS1="\[\033[01;37m\][\[\033[01;32m\]\W\[\033[01;37m\]] \$ "

# Class Account Login
alias cs170-cc="ssh cs170-cc@cory.eecs.berkeley.edu"
alias cs186-nw="ssh cs186-nw@cory.eecs.berkeley.edu"
alias ee122-fn="ssh ee122-fn@cory.eecs.berkeley.edu"

