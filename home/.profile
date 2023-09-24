# Append "$1" to $PATH when not already in.
# This function API is accessible to scripts in /etc/profile.d
append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

# Personal scripts
append_path "$HOME/.local/bin"
append_path "$HOME/.scripts"

# Ruby path
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
append_path "$GEM_HOME/bin"

# Emacs / Doom Emacs
append_path "$HOME/.emacs.d/bin/"
append_path "$HOME/.config/emacs/bin"

# Force PATH to be environment
export PATH

# Default programs
EDITOR=/usr/bin/nvim;               export EDITOR
VISUAL=/usr/bin/nvim;               export VISUAL
TERMINAL=/usr/bin/kitty;            export TERMINAL
TERMINAL_EMULATOR=$TERMINAL;        export TERMINAL_EMULATOR
BROWSER=/usr/bin/firefox;           export BROWSER

CC=/usr/bin/clang;                  export CC
CXX=/usr/bin/clang++;               export CXX

BUG_PROJECT="$HOME/.bugproject";    export BUG_PROJECT

# SSH-Agent
SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export SSH_AUTH_SOCK

# Other apps
RANGER_LOAD_DEFAULT_RC=FALSE; export RANGER_LOAD_DEFAULT_RC
RANGER_DEVICONS_SEPARATOR=" "; export RANGER_DEVICONS_SEPARATOR

# Used in ~/.scripts/libreoffice-config for changing the LibreOffice theme when using .desktop files
LIBREOFFICE_THEME=Adwaita-light; export LIBREOFFICE_THEME 

# C compiler options
# https://github.com/espressif/esp-idf/issues/4162
export EXTRA_CFLAGS=-fdiagnostics-color=always
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:range1=32:range2=34:locus=01:quote=01:path=01;36:fixit-insert=32:fixit-delete=31:diff-filename=01:diff-hunk=32:diff-delete=31:diff-insert=32:type-diff=01;32"
