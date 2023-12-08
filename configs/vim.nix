{ config, pkgs, lib, ... }:

{
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
      base16-vim
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
      
      if exists('$BASE16_THEME')
         \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
           let base16colorspace=256
            colorscheme base16-$BASE16_THEME
            endif
      "let base16colorspace=256
      "colorscheme base16-tomorrow-night

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
}
