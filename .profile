# .profile
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"

[[ -d ~/.profile.d ]] && \
    for f in ~/.profile.d/*; do
        . $f
    done
