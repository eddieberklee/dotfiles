syntax on
set mouse=a

" Type jj while in insert mode to immediately switch to command line.
inoremap jj <Esc>

" I like 2 spaces for tabs - 4 just seems like too much sometimes.
set shiftwidth=2
set tabstop=2

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
