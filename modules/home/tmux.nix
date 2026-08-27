{ pkgs, lib, ... }:
let
  path = lib.makeBinPath [
    pkgs.coreutils
    pkgs.fzf
    pkgs.gawk
    pkgs.gnugrep
    pkgs.gnused
    pkgs.tmux
    pkgs.util-linux
    pkgs.xdg-utils
  ];
  tmux-fuzzy-find = pkgs.writeShellScript "tmux-fuzzy-find" ''
    export PATH=${path}:$PATH
    tab=$(printf '\t')
    hit=$(
        tmux list-panes -a -F "#{pane_id}''${tab}#{session_name}:#{window_index}.#{pane_index}" \
        | while IFS="$tab" read -r pane target; do
              tmux capture-pane -p -S - -t "$pane" \
              | tr '\t' ' ' \
              | awk -v pane="$pane" -v target="$target" -v OFS="$tab" '
                  NF { printf "%s%s%s%s%s%s\033[90m%s\033[0m %s\n",
                              pane, OFS, NR, OFS, target, OFS, target, $0 }'
          done \
        | fzf --ansi --reverse --delimiter="$tab" --with-nth=4.. \
              --preview 'tmux capture-pane -p -S - -t {1} \
                         | awk -v n={2} "NR>=n-10 && NR<=n+10 {printf \"%s%s\n\", (NR==n?\"> \":\"  \"), \$0}"' \
              --preview-window=down:60%
    )
    [ -n "$hit" ] || exit 0
    target=$(printf '%s' "$hit" | cut -f3)
    tmux switch-client -t "''${target%%:*}"
    tmux select-window -t "''${target%.*}"
    tmux select-pane -t "$target"
  '';
  tmux-fuzzy-window = pkgs.writeShellScript "tmux-fuzzy-window" ''
    export PATH=${path}:$PATH
    tab=$(printf '\t')
    fmt="#{session_name}''${tab}#{window_index}''${tab}#{window_name}''${tab}#{pane_current_command}"
    target=$(
        tmux list-windows -a -F "$fmt" \
        | awk -F"$tab" -v OFS="$tab" '
            $1 != prev { printf "%s%s\033[1m%s\033[0m\n", $1, OFS, $1; prev = $1 }
            {
                label = sprintf("%s (%s)", $3, $4)
                printf "%s:%s%s  %-3s %-34s\033[90m%s\033[0m\n", $1, $2, OFS, $2, label, $1
            }
          ' \
        | fzf --ansi --reverse --no-sort --delimiter="$tab" --with-nth=2.. \
              --preview 'tmux capture-pane -ep -t {1}' \
              --preview-window=down:60% \
        | cut -f1
    )
    [ -n "$target" ] || exit 0
    tmux switch-client -t "''${target%%:*}"
    case $target in
        *:*) tmux select-window -t "$target" ;;
    esac
  '';
  tmux-fuzzy-url = pkgs.writeShellScript "tmux-fuzzy-url" ''
    export PATH=${path}:$PATH
    extract() {
        grep -oE "https?://[^[:space:]<>\"')]+" \
        | sed 's/[].,;:!?)]*$//' \
        | tac \
        | awk 'NF && !seen[$0]++'
    }
    if [ "$1" = --self-test ]; then
        got=$(printf 'x https://glvortex.net/a.\nhttps://glvortex.net/a\nhttps://b.example/c)\n' | extract)
        want=$(printf '%s\n' 'https://b.example/c' 'https://glvortex.net/a')
        [ "$got" = "$want" ] || { printf 'got:\n%s\n' "$got"; exit 1; }
        exit 0
    fi
    copy=0
    [ "$1" = --copy ] && { copy=1; shift; }
    pane=$1
    [ -n "$pane" ] || exit 1
    list=$(tmux capture-pane -p -S - -t "$pane" | extract)
    [ -n "$list" ] || { tmux display-message 'no urls'; exit 0; }
    url=$(printf '%s\n' "$list" | fzf --reverse --no-sort) || exit 0
    [ -n "$url" ] || exit 0
    if [ "$copy" -eq 1 ]; then
        tmux set-buffer -w "$url"
        tmux display-message "copied $url"
    else
        setsid xdg-open "$url" >/dev/null 2>&1
    fi
  '';
in
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-Space";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    clock24 = true;
    aggressiveResize = true;
    focusEvents = true;
    reverseSplit = true;
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      copycat
      open
      resurrect
    ];
    extraConfig = builtins.replaceStrings
      [ "@fuzzy-window@" "@fuzzy-find@" "@fuzzy-url@" ]
      [ "${tmux-fuzzy-window}" "${tmux-fuzzy-find}" "${tmux-fuzzy-url}" ]
      (builtins.readFile ./tmux.conf);
  };
}
