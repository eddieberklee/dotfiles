# To pick up local paths.
[ -f /etc/profile ] && source /etc/profile

# Include the rescomp scripts in the path by default
export PATH="$PATH:/usr/local/rescomp/bin:/usr/local/rescomp/sbin"

# Default Rescomp .bashrc
if [ -f /rc/etc/dotfiles/system.bashrc ]; then
        source /rc/etc/dotfiles/system.bashrc
fi

# system-wide aliases
# We like ls with colors, but it's different on FreeBSD vs Linux
if [[ FreeBSD == $(uname) ]] ; then
        alias ls='ls -GF'
else    
        alias ls='ls --color'
fi

# Show only the defined mailboxes when you open mutt
alias mutt="mutt -y"
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

propagate() {
    echo "pandora"
    scp $1 elee@pandora.net.berkeley.edu:$1
    echo "hal"
    scp $1 elee@hal.rescomp.berkeley.edu:$1
    echo "nac-dev-1"
    scp $1 elee@nac-dev-1.net.berkeley.edu:$1
    echo "dev-dhcp-1"
    scp $1 elee@dev-dhcp-1.net.berkeley.edu:$1
    echo "dev-dhcp-2"
    scp $1 elee@dev-dhcp-2.net.berkeley.edu:$1
}

nova() {
    ssh $1@nova.cs.berkeley.edu
}
fiesta() {
    ssh $1@fiesta.cs.berkeley.edu
}
cory() {
    ssh $1@cory.eccs.berkeley.edu
}

switchguest1() {
    # run in nac-dev-1
    sudo mv /usr/local/ist/lib/site_perl/shared/Core/ConfigGuest.pm /usr/local/ist/lib/site_perl/shared/Core/ConfigGuest.pm.backup
    sudo mv /usr/local/ist/lib/site_perl/shared/CoreGuest.pm /usr/local/ist/lib/site_perl/shared/CoreGuest.pm.backup
    sudo mv /usr/local/ist/lib/site_perl/shared/guestconfig.conf /usr/local/ist/lib/site_perl/shared/guestconfig.conf.backup
    sudo cp ~/core/lib/site_perl/shared/Core/ConfigGuest.pm /usr/local/ist/lib/site_perl/shared/Core/ConfigGuest.pm
    sudo cp ~/core/lib/site_perl/shared/CoreGuest.pm /usr/local/ist/lib/site_perl/shared/CoreGuest.pm
    sudo cp ~/core/lib/site_perl/shared/guestconfig.conf /usr/local/ist/lib/site_perl/shared/guestconfig.conf
}
switchguest2() {
    sudo mv /usr/local/ist/lib/site_perl/shared/Core/ConfigGuest.pm.backup /usr/local/ist/lib/site_perl/shared/Core/ConfigGuest.pm
    sudo mv /usr/local/ist/lib/site_perl/shared/CoreGuest.pm.backup /usr/local/ist/lib/site_perl/shared/CoreGuest.pm
    sudo mv /usr/local/ist/lib/site_perl/shared/guestconfig.conf.backup /usr/local/ist/lib/site_perl/shared/guestconfig.conf
} 

export HISTSIZE=1000
