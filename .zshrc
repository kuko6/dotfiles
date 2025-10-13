alias notes=hx -w ~/Notes

export EDITOR=hx

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jakub/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jakub/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/jakub/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jakub/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/jakub/.lmstudio/bin"
