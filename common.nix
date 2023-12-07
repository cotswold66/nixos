{ config, pkgs, lib, ... }:

{
  home-manager.users.john = { pkgs, ... }: {
    home = {
    };
    programs.home-manager.enable = true;
    programs.bash = {
      sessionVariables = {
        RESTIC_PASSWORD_COMMAND = "${pkgs.pass}/bin/pass backup/pluto";
        #      WORKON_HOME = ~/src;
        SSH_AUTH_SOCK = /run/user/1000/keyring/ssh;
        LESS = "-R";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        VDPAU_DRIVER = "va_gl";
      };
    };
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "John Lord";
      userEmail = "john@lordsonline.org";
      extraConfig = {
        core.editor = "${pkgs.emacs}/bin/emacsclient -c";
        pull.rebase = "false";
      };
    };
    # programs.emacs = {
    #   enable = true;
    #   package = pkgs.emacs-nox;
    # };
    programs.vim = {
      enable = true;
      settings = {
        expandtab = true;
        hidden = true;
        history = 200;
        ignorecase = true;
        number = true;
        relativenumber = false;
        shiftwidth = 2;
        smartcase = true;
        tabstop = 2;
      };
      plugins = with pkgs.vimPlugins; [
        commentary
        ctrlp
        ranger-vim
        surround
        vim-airline
        vim-airline-themes
        vim-orgmode
      ];
      extraConfig = ''
      let skip_defaults_vim=1
      set nocompatible

      let &t_SI = "\e[6 q"
      let &t_SR = "\e[4 q"
      let &t_EI = "\e[2 q"

      let mapleader = " "

      set ruler

      set softtabstop=2
      set smartindent
      set smarttab
      set autoindent

      set listchars=tab:→\ ,eol:↲,nbsp:␣,space:·,trail:·,extends:⟩,precedes:⟨

      set textwidth=73 

      set nobackup
      set noswapfile
      set nowritebackup

      set icon

      set laststatus=2
      set statusline=%.40F\ %m\ %y
      set statusline+=%=        " Switch to the right side
      set statusline+=%l        " Current line
      set statusline+=/         " Separator
      set statusline+=%L        " Total lines

      set scrolloff=3

      set hlsearch
      set incsearch
      set linebreak
      map <silent> <leader><cr> :noh<cr>
      
      syntax enable
      
      set ttyfast
      
      set omnifunc=syntaxcomplete#Complete
      
      map <C-j> <C-W>j
      map <C-k> <C-W>k
      map <C-h> <C-W>h
      map <C-l> <C-W>l
      
      filetype plugin indent on
      if has("autocmd")
        autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
      endif
      
      cmap W w !sudo tee % >/dev/null<CR>
      
      let g:airline_powerline_fonts=1
  '';
    };
  };
}
