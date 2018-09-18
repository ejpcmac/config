" Configuration de vim

let g:is_posix = 1
set nocompatible
set history=50

" Encodage en UTF-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
setglobal fileencoding=utf-8

" Activation de la souris
set mouse=a

" Propagation du presse-papier (décommenter la version adéquate)
""" 1. Avec macOS
" set clipboard=unnamed
"
""" 2. Avec machine locale via SSH
" function! PropagatePasteBufferViaSSH()
"    let @n=@
"    call system('nc -N localhost 2224', @n)
"    echo "Copied and propogated"
" endfunction
" function! PopulatePasteBufferFromSSH()
"    let @" = system('nc localhost 2225')
"    echo "Buffer populated"
" endfunction
" nnoremap yy yy:call PropagatePasteBufferViaSSH()<cr>
" vnoremap y y:call PropagatePasteBufferViaSSH()<cr>
" nnoremap è :call PropagatePasteBufferViaSSH()<cr>
" nnoremap é :call PopulatePasteBufferFromSSH()<cr>

" Thème et coloration
set t_Co=256
" colorscheme wellsokai

set number
set showmode
set ruler

" Activation de la coloration syntaxique et de l’indentation
filetype plugin indent on
syntax on

" Réglage de l’indentation
set smartindent
set expandtab       " Transforme les tabulations en espaces
set tabstop=2
set shiftwidth=2

set backspace=indent,eol,start

" Activation des modelines
set modeline
set modelines=5
