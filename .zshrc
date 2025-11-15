alias notes="hx -w ~/Notes"
alias dotfiles="cd ~/Developer/dotfiles"
alias obsidian="open ~/Applications/Obsidian.app"

export EDITOR=nvim

# Terminal theme #
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

parse_git_branch() {
  git branch 2> /dev/null | sed -n -e "s/^\* \(.*\)/(\1) /p"
}

COLOR_DEF="%f"
COLOR_GIT="%F{6}"
COLOR_HOST="%F{15}"
COLOR_DIR="%F{1}"
COLOR_VENV="%F{10}"

setopt PROMPT_SUBST
export PROMPT='${COLOR_HOST}%n@%m ${COLOR_DIR}%. ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}> '

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
