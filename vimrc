"" vim configuration

let g:is_posix = 1
set nocompatible
set history=50

" Use UTF-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
setglobal fileencoding=utf-8

" Enable the mouse
set mouse=a

" Propagate the clipboard (uncomment one of the versions)
""" 1. To macOS
" set clipboard=unnamed
"
""" 2. To a local machine via SSH
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

" Theme and coloration
set t_Co=256
colorscheme wellsokai

set number
set showmode
set ruler

" Activate syntax coloring and indentation
filetype plugin indent on
syntax on

" Indentation settings
set smartindent
set expandtab       " Use spaces for tabs
set tabstop=4
set shiftwidth=4

set backspace=indent,eol,start

" Enable modelines
set modeline
set modelines=5

" Use <C-l> to center the cursor
noremap <C-l> z.

" Remapping du clavier adapté au BÉPO
" https://bepo.fr/wiki/Vim

" Adaptations locales :
" - T/S pour défiler vers le bas/haut
" - J n’est pas remappé (toujours join)

" {W} -> [É]
" ——————————
" On remappe W sur É :
noremap é w
noremap É W
" Corollaire: on remplace les text objects aw, aW, iw et iW
" pour effacer/remplacer un mot quand on n’est pas au début (daé / laé).
onoremap aé aw
onoremap aÉ aW
onoremap ié iw
onoremap iÉ iW
" Pour faciliter les manipulations de fenêtres, on utilise {W} comme un Ctrl+W :
noremap w <C-w>
noremap W <C-w><C-w>

" [HJKL] -> {CTSR}
" ————————————————
" {cr} = « gauche / droite »
noremap c h
noremap r l
" {ts} = « haut / bas »
noremap t j
noremap s k
" {CR} = « haut / bas de l'écran »
noremap C H
noremap R L
" {TS} = « défilement vers le bas / haut » (Non strictement inversé)
noremap T <C-d>
noremap S <C-u>
" Corollaire : repli suivant / précédent
noremap zs zj
noremap zt zk

" {HJKL} <- [CTSR]
" ————————————————
" {J} = « Jusqu'à »            (j = suivant, J n’est pas remappé)
noremap j t
" {L} = « Change »             (l = attend un mvt, L = jusqu'à la fin de ligne)
noremap l c
noremap L C
" {H} = « Remplace »           (h = un caractère slt, H = reste en « Remplace »)
noremap h r
noremap H R
" {K} = « Substitue »          (k = caractère, K = ligne)
noremap k s
noremap K S
" Corollaire : correction orthographique
noremap ]k ]s
noremap [k [s

" Désambiguation de {g}
" —————————————————————
" ligne écran précédente / suivante (à l'intérieur d'une phrase)
noremap gs gk
noremap gt gj
" onglet précédant / suivant
noremap gb gT
noremap gé gt
" optionnel : {gB} / {gÉ} pour aller au premier / dernier onglet
noremap gB :exe "silent! tabfirst"<CR>
noremap gÉ :exe "silent! tablast"<CR>
" optionnel : {g"} pour aller au début de la ligne écran
noremap g" g0

" <> en direct
" ————————————
noremap « <
noremap » >

" Remaper la gestion des fenêtres
" ———————————————————————————————
noremap wt <C-w>j
noremap ws <C-w>k
noremap wc <C-w>h
noremap wr <C-w>l
noremap wd <C-w>c
noremap wo <C-w>s
noremap wp <C-w>o
noremap w<SPACE> :split<CR>
noremap w<CR> :vsplit<CR>
