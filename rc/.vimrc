" Syntax / Coloring
syntax on
filetype plugin on
filetype indent on

set bg=dark
set mouse=a

" Set line wrapping off for now (can easily turn on with :set wrap)
set wrap!

" Type jj while in insert mode to immediately switch to command line.
inoremap jj <Esc>

" Autoread - when file is changed from outside
set autoread

" Indenting stuff.
filetype indent on
set smartindent

" I like 2 spaces for tabs - 4 just seems like too much sometimes.
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab

" Add lines above/below by just pressing Enter or Shift-Enter.
map <Enter> o<Esc>
map <S-Enter> O<Esc>

" Quick switch between buffers
map <C-j> :bn<CR>
map <C-k> :bp<CR>

map <C-h> :tabp<CR>
map <C-l> :tabn<CR>

" Accidental shift (:W instead of :w)
command W w
command Q q

" Add lines above/below by just pressing Enter + Shift-Enter.
map <Enter> o<Esc>
map <S-Enter> O<Esc>

" Turn off the highlighting for current search.
map <C-n> :noh<CR>

" Number lines.
set number

" Pathogen
call pathogen#infect()
colorscheme solarized

