# .profile
export DEBUG_INIT_SCRIPTS="${DEBUG_INIT_SCRIPTS:-} .profile"

export PATH="$HOME/bin:$PATH"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"

case `uname -s` in
Darwin)
    ;;
*)
    eval "$(ssh-agent)"
    ;;
esac
