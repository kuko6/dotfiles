{
  config, 
  pkgs,
  ...
}: {
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ls = "ls --color";
    # update = "sudo nixos-rebuild switch";
  };
 
  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };

  initContent = ''
    alias rgdm="sudo systemctl restart gdm"

    # Terminal theme #
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad

    eval "$(starship init zsh)"
    
    # parse_git_branch() {
    #     git branch 2> /dev/null | sed -n -e "s/^\* \(.*\)/(\1) /p"
    # }

    # get_pyenv() {
    #     basename $VIRTUAL_ENV 2> /dev/null | sed -n -e "s/\(.*\)/(\1) /p"
    # }

    # #PYTHONVENV=$(basename $VIRTUAL_ENV)
    # NEWLINE=$"\n"

    # COLOR_DEF="%f"
    # COLOR_GIT="%F{6}"
    # COLOR_HOST="%F{15}"
    # COLOR_DIR="%F{1}"
    # COLOR_VENV="%F{10}"

    # setopt PROMPT_SUBST
    # export PROMPT="%F{15}%n@%m %F{1}%. %F{6}$(parse_git_branch)%f> "
  '';
}
