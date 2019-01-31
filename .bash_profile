# .bash_profile
export DEBUG_INIT_SCRIPTS="${DEBUG_INIT_SCRIPTS:-} .bash_profile"

[[ -f ~/.profile ]] && . ~/.profile

[[ -f ~/.bashrc ]] && . ~/.bashrc
