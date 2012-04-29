#!/bin/bash

########################################
# A wonderful dotfiles installer. meh
set -e
set -u
#set -x

########################################
# startup: set operation mode
doclean="yes"
doinst="yes"
if [[ "x$1" == "x--help" ]]; then
  echo "usage: `basename $0` [--install|--clean|--help]"
  echo -e "  --clean\tClean old files only"
  echo -e "  --install\tInstall and clean"
  echo -e "  --help\tShow help"
  exit
elif [[ "x$1" == "x--clean" ]]; then
  doinst="no"
  echo "Running in 'cleanup only' mode"
elif [[ "x$1" != "x--install" ]]; then
  echo "usage: `basename $0` [--install|--clean|--help]"
  exit
fi

########################################
# initial vars
now=`date +%Y%m%d%H%M`

basedir=`dirname $0`"/../"
basedir=`readlink -f ${basedir}`
backupdir="${basedir}/backup-${now}"

########################################
# functions
function putaway() {
  # move files
  [[ -f $1 ]] && mv -f $1 ${backupdir}/
  # move directories
  [[ -d $1 ]] && mv -f $1 ${backupdir}/

  return 0
}

function linky() {
  if [ "$#" -eq "2" ]; then
    dst=$2
  else
    dst=`basename $1`
  fi
  [[ -f "${basedir}/$1" ]] && ln -s "${basedir}/$1" ~/${dst}
  [[ -d "${basedir}/$1" ]] && ln -s "${basedir}/$1" ~/${dst}
  return 0
}

########################################
# create backupdir if needed
[[ -d ${backupdir} ]] || mkdir -p ${backupdir}

########################################
# make backup copies
if [[ "${doclean}" == "yes" ]]; then
  putaway ~/.bash_profile
  putaway ~/.bashrc
  putaway ~/.gdbinit

  putaway ~/.gitconfig
  putaway ~/.hgrc
  putaway ~/multitail.conf

  putaway ~/.screenrc
  putaway ~/.tmux.conf
  putaway ~/.zshrc.local

  putaway ~/.zshrc # meh
  putaway ~/.vimrc
  putaway ~/.vim
fi

########################################
# create symlinks
if [[ "${doinst}" == "yes" ]]; then
  linky .bash_profile
  linky .bashrc
  linky .gdbinit

  linky .gitconfig
  linky .hgrc
  linky multitail.conf

  linky .screenrc
  linky .tmux.conf
  linky .zshrc.local .zshrc

  linky vim/fa.vim .vimrc
  linky vim .vim
fi
