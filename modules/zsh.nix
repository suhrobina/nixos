{ config, pkgs, lib, ... }:

{
  # Required packages
  environment.systemPackages = with pkgs; [
    # zsh-powerlevel10k
    sourceHighlight
    lesspipe
    fzf
    eza
    bat
  ];

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "agnoster";
    };
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    histSize = 10000000;
    setOptions = [ # check zshoptions(1). $ man zshoptions
      "AUTO_CD"                # Allows you to cd into directory merely by typing the directory name
      "AUTO_MENU"              # Automatically  use  menu completion after the second consecutive request for completion
      "POSIX_CD"               # Compatible with the POSIX standard
      "APPEND_HISTORY"         # Allow multiple terminal sessions to all append to one zsh command history
      "BANG_HIST"              # Treat the '!' character specially during expansion.
      "EXTENDED_HISTORY"       # Write the history file in the ":start:elapsed;command" format.
      "INC_APPEND_HISTORY"     # Write to the history file immediately, not when the shell exits.
      "SHARE_HISTORY"          # Share history between all sessions.
      "HIST_EXPIRE_DUPS_FIRST" # Expire duplicate entries first when trimming history.
      "HIST_IGNORE_DUPS"       # Don't record an entry that was just recorded again.
      "HIST_IGNORE_ALL_DUPS"   # Delete old recorded entry if new entry is a duplicate.
      "HIST_FIND_NO_DUPS"      # Do not display a line previously found.
      "HIST_IGNORE_SPACE"      # Don't record an entry starting with a space.
      "HIST_SAVE_NO_DUPS"      # Don't write duplicate entries in the history file.
      "HIST_REDUCE_BLANKS"     # Remove superfluous blanks before recording entry.
      "HIST_VERIFY"            # Don't execute immediately upon history expansion.
      "HIST_BEEP"              # Beep when accessing nonexistent history.
    ];
    shellAliases = {
      # Aliaes for Neovim
      v   = "nvim";
      vi  = "nvim";
      vim = "nvim";

      # Alias to run commands as sudo quickly
      _ = "sudo ";

      # Elevate to root while preserving the user environment;
      __ = "sudo -E su";

      # List directory contents
      ls  = "eza --color=auto --classify=auto --group-directories-first";
      lsa = "eza --all --long --header --git --color=auto --group-directories-first --classify=auto --icons --tree --level=1";
      lsl = "eza --all --long --header --git --color=auto --group-directories-first --classify=auto --icons --tree --level=1";

      # grep & diff
      grep  = "grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}";
      fgrep = "grep -F --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}";
      egrep = "grep -E --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}";
      diff  = "diff --color=auto";

      # safer default for cp, mv, rm.  these will print a verbose output of
      # the operations.  if an existing file is affected, they will ask for
      # confirmation.  this can make things a bit more cumbersome, but is a
      # generally safer option.
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -Iv";

    };
    promptInit = ''
      # == FUNCTIONS ========================================================

      # Shorter version of a common command that it used herein.
      function _checkexec() {
          command -v "$1" > /dev/null
      }

      # Enter directory and list contents.
      cd() {
        builtin cd "$@" && eza --git --color=auto --group-directories-first --classify=auto
      }

      # Change cursor shape for different vi modes.
      function zle-keymap-select () {
          case $KEYMAP in
              vicmd) echo -ne '\e[1 q';;      # block
              viins|main) echo -ne '\e[5 q';; # beam
          esac
      }
      zle -N zle-keymap-select
      zle-line-init() {
          zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
          echo -ne "\e[5 q"
      }
      zle -N zle-line-init
      echo -ne '\e[5 q' # Use beam shape cursor on startup.
      preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

      # == GENERAL ==========================================================

      # Enable colors and change prompt
      autoload -U colors && colors

      # PS1 is your normal "waiting for a command" prompt
      #PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

      # PS2 is the continuation prompt that you saw after typing an incomplete command
      #PS2="> "

      # Set file mode creation mask. Default value is 0022
      umask 0022

      # Use vi keybindings
      bindkey -v
      #export KEYTIMEOUT=1

      # Use vim keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char

      # In Zsh with the zsh-autosuggestions plugin, the default key binding
      # to accept a suggestion is typically the Right Arrow key.
      # Change it to CTRL + Space
      bindkey '^ ' autosuggest-accept

      # == PLUGINS ==========================================================

      # A command-line fuzzy finder. The fzf package is required
      source "$(fzf-share)/key-bindings.zsh"
      source "$(fzf-share)/completion.zsh"

      # PowerLevel10k Theme
      #source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
  };
}
