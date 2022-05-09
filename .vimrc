""""""""""" general section """"""""""""""""""""""
set belloff=all
set tabstop=4
set shiftwidth=4
set expandtab
set number
set nobackup
set noswapfile
set nowrap
set hlsearch
set ic is vb sm cul cindent nowrap
set scr=3
set cst
set nocompatible
filetype plugin on
syntax on

set guioptions-=e

set listchars=tab:··
set list

set shiftwidth=4 tabstop=4 softtabstop=4 expandtab smarttab
" Don't redraw while executing macros (good performance config)
set lazyredraw

syntax on


function! LoadCscope()
  let fpath = expand('%:p')
"  if (fpath)
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

""""""""""" plugins section """"""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

"my choise of plugins:
Plugin 'flazz/vim-colorschemes'
Plugin 'joshdick/onedark.vim'
Plugin 'vivien/vim-linux-coding-style'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'bogado/file-line'
Plugin 'bling/vim-airline'
Plugin 'jacoborus/tender.vim'
Plugin 'jeaye/color_coded'
Plugin 'vimwiki/vimwiki'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""""""""""""""""" appearance section """""""""""""""""""""""""
"colorscheme wombat "from vim-colorschemes plugin
"colorscheme onedark
set background=dark
"colorscheme desertink

"set background=dark    " Setting dark mode
"colorscheme gruvbox

colorscheme tender

let g:color_coded_enabled = 1
let g:color_coded_filetypes = ['c', 'cpp']

""""""""""""""""" kernel section """""""""""""""""""""""""""""
"80 characters line
set colorcolumn=81 "
"execute "set colorcolumn=" . join(range(81,335), ',') "if you want to make 80+ columns highlighted as well
highlight ColorColumn ctermbg=Black ctermfg=DarkRed

set tabstop=8
set shiftwidth=8
set expandtab

"Trailing spaces are prohibited by kernel coding style, so you may want to highlight them:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"linux coding style plugin
"let g:linuxsty_patterns = [ "/usr/src/", "/linux" ]
"nnoremap <silent> <leader>a :LinuxCodingStyle<cr>
