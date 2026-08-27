{ lib, ... }:
{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=3";
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
      ];
    };
    history = {
      size = 200000;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
      extended = true;
    };
    historySubstringSearch = {
      enable = true;
      searchUpKey = [
        "^[[A"
        "^P"
      ];
      searchDownKey = [
        "^[[B"
        "^N"
      ];
    };
    setOptions = [
      "NO_BEEP"
      "PROMPT_SUBST"
    ];
    shellAliases = {
      l = "eza";
      sl = "ls";
      f = "z";
      ff = "zi";
      diff = "diff --color=auto";
    };
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        if [[ "$TERM" == "dumb" && -z "$INSIDE_EMACS" ]]; then
          unsetopt zle prompt_cr prompt_subst
          unfunction precmd 2>/dev/null
          unfunction preexec 2>/dev/null
          PS1='$ '
          return
        fi
      '')
      ''
        WORDCHARS=''${WORDCHARS//[\/]}
        zstyle ':completion:*' rehash true
        [[ -t 0 ]] && stty -ixon 2>/dev/null

        unalias run-help 2>/dev/null
        autoload -Uz run-help run-help-git run-help-ip run-help-sudo
        alias help=run-help

        autoload -Uz edit-command-line
        zle -N edit-command-line

        ta() {
          if [ -n "$1" ]; then
            tmux attach -d -t "$1" || tmux new -s "$1"
          else
            print "Please specify a session name"
          fi
        }

        git_prompt_info() {
          if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
            if [ -n "$branch" ]; then
              local git_status=""
              if ! git diff --quiet 2>/dev/null; then
                git_status=" ✎"
              elif ! git diff --cached --quiet 2>/dev/null; then
                git_status=" ●"
              fi
              echo " ⎇ %F{yellow}$branch%f%F{red}$git_status%f"
            fi
          fi
        }

        remote_host_info() {
          if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
            echo "%F{yellow}%n@%m%f "
          fi
        }

        PROMPT='$(remote_host_info)%F{cyan}%~%f$(git_prompt_info) %F{green}λ%f '
      ''
      (lib.mkAfter ''
        bindkey -M vicmd 'K' run-help
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
        bindkey -M viins jj vi-cmd-mode
        bindkey -M viins jk vi-cmd-mode
        bindkey -M viins '^?' backward-delete-char
        bindkey -M viins '^H' backward-delete-char
        bindkey -M viins '^A' beginning-of-line
        bindkey -M viins '^E' end-of-line
        bindkey -M viins '^W' backward-kill-word
        bindkey -M viins '^U' backward-kill-line
        bindkey -M viins '^K' kill-line
        bindkey -M viins '^Y' yank
        bindkey -M viins '^[[H' beginning-of-line
        bindkey -M viins '^[[F' end-of-line
        bindkey -M viins '^X^E' edit-command-line
        if (( ''${+widgets[autosuggest-accept]} )); then
          bindkey -M viins '^O' autosuggest-accept
        fi
      '')
    ];
  };

  programs.eza.enable = true;
  programs.fzf = {
    enable = true;
    defaultCommand = ''rg --files --hidden --follow --glob "!{.git,node_modules}/*" 2>/dev/null'';
    defaultOptions = [ "--color=base16,fg+:green:reverse,bg+:-1,hl+:green" ];
    historyWidget.command = ""; # atuin owns Ctrl-R
  };
  programs.zoxide.enable = true;
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };

  home.sessionVariables.EDITOR = "nvim";
}
