#!/usr/bin/env bash

if ! [ -x "$(command -v brew)" ]; then
  read -p "Would you like to install brew?(y/n) " -n 1;
  echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

brew bundle
rbenv install

gem install bundler
bundle install
