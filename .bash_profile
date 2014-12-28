# .bash_profile
[[ -d ~/.bash_profile.d ]] && \
    for f in ~/.bash_profile.d/*; do
        . $f
    done

[[ -f ~/.profile ]] && . ~/.profile

[[ -f ~/.bashrc ]] && . ~/.bashrc

# wayland
export XDG_RUNTIME_DIR=/tmp/.runtime-${USER}
mkdir -p "${XDG_RUNTIME_DIR}"
chmod 0700 "${XDG_RUNTIME_DIR}"
