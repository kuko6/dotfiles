alias notes="cd ~/Notes && nvim"
alias dotfiles="cd ~/Developer/dotfiles"
alias obsidian="open ~/Applications/Obsidian.app"

export EDITOR=nvim

export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
source <(fzf --zsh)

# Terminal theme #
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

parse_git_branch() {
  git branch 2> /dev/null | sed -n -e "s/^\* \(.*\)/(\1) /p"
}

COLOR_DEF="%f"
COLOR_GIT="%F{6}"
COLOR_HOST="%F{15}"
COLOR_VENV="%F{10}"

case "$HOST" in
  Jakub-MBP | Mac*)
    COLOR_DIR="%F{5}"
    ;;
  Menton*)
    COLOR_DIR="%F{3}"
    ;;
  *)
    COLOR_DIR="%F{1}"
    ;;
esac

setopt PROMPT_SUBST
export PROMPT='${COLOR_HOST}%n@%m ${COLOR_DIR}%. ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}> '

if [[ "$(uname)" == "Darwin" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi
