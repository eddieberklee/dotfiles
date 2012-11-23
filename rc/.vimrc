" Syntax / Coloring
syntax on
filetype plugin on
filetype indent on

set mouse=a

" Set line wrapping off for now (can easily turn on with :set wrap)
set wrap!

" Type jj while in insert mode to immediately switch to command line.
inoremap jj <Esc>

" I like 2 spaces for tabs - 4 just seems like too much sometimes.
set shiftwidth=2
set tabstop=2

" Quick switch between buffers
map <C-j> :bn<CR>
map <C-k> :bp<CR>

" Accidental shift (:W instead of :w)
command W w
command Q q

" Add lines above/below by just pressing Enter + Shift-Enter.
map <Enter> o<Esc>
map <S-Enter> O<Esc>

" Turn off the highlighting for current search.
map <C-n> :noh<CR>

" Indenting stuff.
filetype indent on
set smartindent

" Number lines.
set number

