#! /bin/bash

DOTFILES=(.bash_profile .bashrc .gitconfig .gitignore)

#Remove old dotfiles and replace them
for dotfile in $(echo ${DOTFILES[*]});
do
  if [ -f ~/$(echo $dotfile) ]; then
    rm ~/$(echo $dotfile)
  fi
  ln -s ~/dotfiles/$(echo $dotfile) ~/$(echo $dotfile)
done
source ~/.bash_profile