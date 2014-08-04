    git clone --bare -b base git@github.com:dmage/dotfiles.git ~/.cfgit
    git --git-dir="$HOME/.cfgit" --work-tree="$HOME" checkout
    . ~/.bashrc
