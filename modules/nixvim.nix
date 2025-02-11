# !!!Execute ':checkhealth' command in nvim to check health!!!
{ pkgs, lib, config, ... }:

let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    ref = "nixos-24.11";
  });
in

{
  imports = [
    # For home-manager
    #nixvim.homeManagerModules.nixvim

    # For NixOS
    nixvim.nixosModules.nixvim

    # For nix-darwin
    #nixvim.nixDarwinModules.nixvim
  ];

  # Required packages
  # Execute ':checkhealth' command in nvim to check health
  environment.systemPackages = with pkgs; [
    wl-clipboard # For Wayland clipboard support
    #xclip xsel   # For Xorg clipboard support
    ripgrep
    fd
  ];

  # Define Neovim as default editor
  environment.variables = {
    EDITOR="nvim";
    VISUAL="nvim";
  };

  programs.nixvim = {
    enable = true;
    colorschemes.vscode.enable = true;
    plugins.airline.enable = true;
    plugins.bufferline.enable = true;
    plugins.lualine.enable = true;
    plugins.nvim-colorizer.enable = true;
    plugins.nix.enable = true;
    plugins.nix-develop.enable = true;
    plugins.indent-blankline.enable = true;
    plugins.nvim-autopairs.enable = true;
    plugins.sleuth.enable = true;
    plugins.twilight = { # Press F8 to use this plugin
      enable = true;
      # Check extraConfigVim section for keymap
    };
    plugins.toggleterm = {
      enable = true;
      settings.direction = "float";
      settings.open_mapping = "[[<leader>t]]";
    };
    plugins.telescope = {
        enable = true;
        keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
            "<leader>fh" = "help_tags";
        };
        settings.defaults = {
            file_ignore_patterns = [
                "^.git/"
                "^.mypy_cache/"
                "^__pycache__/"
                "^output/"
                "^data/"
                "%.ipynb"
              ];
        };
    };
    plugins.treesitter.enable = true;
    plugins.cmp = {
      enable = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "emoji"; }
      ];
      settings.mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-e>" = "cmp.mapping.close()";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
      };
    };
    plugins.web-devicons.enable = true;
    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-nvim-lsp-document-symbol.enable = true;
    plugins.cmp-nvim-lsp-signature-help.enable = true;
    plugins.lsp = {
      enable = true;
      servers.bashls.enable = true;
      servers.dockerls.enable = true;
      servers.docker_compose_language_service.enable = true;
      servers.java_language_server.enable = true;
      servers.pylsp.enable = true;
    };
    extraConfigVim = ''
      " -- GENERAL ------------------------------------------------------------------

      " Basic
          set autoread                    " detect when a file has been modified externally
          set ignorecase                  " ignoring case in a pattern
          set laststatus=2                " displaying status line always
          set encoding=utf-8              " default character encoding
          set updatetime=400              " time of idleness is milliseconds before saving swapfile
          set undolevels=10000            " how many undo levels to keep in memory
          set nostartofline               " keep cursor in the same column when moving between lines
          set errorbells                  " ring the bell for errors
          set visualbell                  " then use a flash instead of a beep sound
          set smartcase                   " ignore case if the search contains majuscules
          set hlsearch                    " highlight all matches of last search
          set incsearch                   " enable incremental searching (get feedback as you type)
          set backspace=indent,eol,start  " backspace key should delete indentation, line ends, characters
          set textwidth=0                 " hard wrap at this column
          set joinspaces                  " insert two spaces after punctuation marks when joining multiple lines into one
          set mouse=a                     " enable mouse support
          set colorcolumn=80              " setup a ruler
      	  set wrap                        " automatic word wrapping
      	  set number relativenumber       " relative line number
          set history=10000               " number of lines that are remembered
          set clipboard+=unnamedplus       " clipboard integration
          set scrolloff=999               " centering with scroll offset
          set cursorline                  " enable highlight cursorline
          "hi clear cursorline             " highlight only line number
          "set cursorcolumn                " enable highligh cursorcolumn
          "set formatoptions+=t

          let mapleader=","               " map the leader key to comma
      	  syntax on

      " Spaces & Tabs
      	  set tabstop=4       " tab character width
          set shiftwidth=4    " needs to be the same as tabstop
      	  set softtabstop=4   " number of spaces in tab when editing
      	  set shiftwidth=4    " needs to be the same as tabstop
          set list            " displaying tabs as characters
      	  set expandtab       " tabs are space
          set autoindent      " indent automatically (useful for formatoptions)
          set copyindent      " copy indent from the previous line

      " GUI
      "   set guifont=Hack:h14

      " Persistent Undo
          set undofile                    " save undoes after file closes
          set undodir=~/.vim-undo-dir     " where to store the undo files
          set undolevels=10000            " max number of changes that can be undone

      " Cursor
          let &t_SI.="\e[5 q" "SI = INPUT mode
          let &t_SR.="\e[3 q" "SR = REPLACE mode
          let &t_EI.="\e[1 q" "EI = NORMAL mode

      " -- OTHERS -------------------------------------------------------------------

      " Vertical Split & Explore
          map <silent> <F10> :Vexplore<CR>

      " Automatic word wrapping textwidth
          map <F5> :set textwidth=72<CR>
          map <S-F5> : set textwidth=0<CR>

      " Toggle word wrap. Change how text is displayed.
          map  <F6> :set nowrap!<CR>

      " Toggle spell-check (F7 key)
          map  <F7> :setlocal spell! spelllang=en,ru<CR>

      " Toggle Twilight (F8 key)
          map  <F8> :Twilight<CR>

      " Disables automatic commenting on newline:
      	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

      " Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
      "	vnoremap <C-c> "+y
      "	map <C-p> "+P

      " Automatically deletes all trailing whitespace on save.
      	autocmd BufWritePre * %s/\s\+$//e

      " Compile dwm when changed
          autocmd BufWritePost config.h !sudo make clean install
     '';
  };
}

