# .profile
export XDG_CONFIG_HOME="$HOME/.config"

[[ -d ~/.profile.d ]] && \
    for f in ~/.profile.d/*; do
        . $f
    done
