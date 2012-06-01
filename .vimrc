
call pathogen#infect()
call pathogen#helptags()
" Show us the command we're typing
set showcmd

" Highlight matching parens
set showmatch

" indent things
set autoindent
"set smartindent
filetype on
syntax on
filetype plugin on
filetype indent on
set nonu
"set paste
set ts=3
set shiftwidth=3
set background=dark
" 
set clipboard=unnamed

colorscheme delek
set laststatus=2
set grepprg=grep\ -nH\ $*

syn region myFold start="{" end="}" transparent fold
" Enable folds

 if has("folding")
	set foldenable
	set foldmethod=indent
	set foldlevelstart=99
endif

function Folding ()
if (foldclosed (line(".")) > 0)
	exe 'foldo!'
else
	exe 'foldc!'
endif
endfunction


map <F10> :call Folding() <CR>

map <F9> :set nopaste

map <F8> :set expandtab

set sb
map <F11> :split /tmp/ocaml \| %d \|setlocal ft=omlet \| setlocal autowrite \| r!ocaml < # <CR>
map <F12> :dr /tmp/ocaml \| %d \|setlocal ft=omlet \|setlocal autowrite \| r!ocaml < # <CR>

" Un exemple de fichier vimrc.
"
" Mainteneur :  Bram Moolenaar <Bram@vim.org>
" Dernières modifications : 9 Sep 1999
"
" Pour l'utiliser, copiez le dans
"     pour Unix et OS/2 :  ~/.vimrc
"            pour Amiga :  s:.vimrc
" pour MS-DOS and Win32 :  $VIM\_vimrc
set nocompatible        " Utilise les défauts Vim (bien mieux !)
set bs=2                " autorise l'effacement de tout en mode insertion
" set ai                  " toujours utiliser l'autoindentation
set backup              " Conserver un fichier de sauvegarde
set viminfo='20,\"50    " Lit/écrit un fichier .viminfo, ne sauve pas plus
 " de 50 lignes de registres
set history=50          " Conserve 50 lignes d'historique des commandes
set ruler               " Montre toujours la position du curseur
" Pour l'interface Win32: retirez l'option 't' de 'guioptions': pas d'entrée menu tearoff
" let &guioptions = substitute(&guioptions, "t", "", "g")
" N'utilise pas le mode Ex, utilise Q pour le formatage
map Q gq
" p en mode Visuel remplace le texte sélectionné par le registre "".
"vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>
" Active la coloration syntaxique lorsque le terminal dispose de couleurs
" Active aussi la coloration de la dernière chaîne recherchée.
if &t_Co> 2 || has("gui_running")
 syntax on
 set hlsearch
 set incsearch
endif
" Ne lance la partie suivante que si le support des autocommandes a été inclus
" lors de la compilation
if has("autocmd")
 " Dans les fichiers textes, toujours limiter la longueur du texte à 78
 " caractères
 autocmd BufRead *.txt set tw=78
 augroup cprog
 " Supprime toutes les autocommandes cprog
 au!
 " Lors du début d'édition d'un fichier :
 "   Pour les fichiers C et C++ active le formatage des
 "   commentaires et l'indentation C
 "   Pour les autres fichiers, les désactive.
 "   Ne pas changer l'ordre, il est important que la ligne
 "   avec * arrive avant.
 "  autocmd FileType *      set formatoptions=tcql nocindent comments&
 "  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
 augroup END
 augroup gzip
 " Supprime toutes les autocommandes gzip
 au!
 " Active l'édition des fichiers gzippés
 " Active le mode binaire avant de lire le fichier
 autocmd BufReadPre,FileReadPre        *.gz,*.bz2 set bin
 autocmd BufReadPost,FileReadPost      *.gz call GZIP_read("gunzip")
 autocmd BufReadPost,FileReadPost      *.bz2 call GZIP_read("bunzip2")
 autocmd BufWritePost,FileWritePost    *.gz call GZIP_write("gzip")
 autocmd BufWritePost,FileWritePost    *.bz2 call GZIP_write("bzip2")
 autocmd FileAppendPre                 *.gz call GZIP_appre("gunzip")
 autocmd FileAppendPre                 *.bz2 call GZIP_appre("bunzip2")
 autocmd FileAppendPost                *.gz call GZIP_write("gzip")
 autocmd FileAppendPost                *.bz2 call GZIP_write("bzip2")
 " Après la lecture du fichier compressé : décompresse le texte dans le
 " buffer avec "cmd"
 fun! GZIP_read(cmd)
 let ch_save = &ch
 set ch=2
 execute "'[,']!" . a:cmd
 set nobin
 let &ch = ch_save
 execute ":doautocmd BufReadPost " . expand("%:r")
 endfun
 " Après l'écriture du fichier compressé : compresse le fichier écrit avec "cmd"
 fun! GZIP_write(cmd)
 if rename(expand("<afile>"), expand("<afile>:r")) == 0
 execute "!" . a:cmd . " <afile>:r"
 endif
 endfun
 " Avant l'ajout au fichier compressé : décompresser le fichier avec "cmd"
 fun! GZIP_appre(cmd)
 execute "!" . a:cmd . " <afile>"
 call rename(expand("<afile>:r"), expand("<afile>"))
 endfun
 augroup END
 " Ce qui suit est désactivé, car il change la liste de sauts. On ne peut pas utiliser
 " CTRL-O pour revenir en arrière dans les fichiers précédents plus d'une fois.
 if 0
 " Lors de l'édition d'un fichier, saute toujours à la dernière position du curseur.
 " Ceci doit se trouver après les commandes de décompression.
 autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif
endif " has("autocmd")

" vimrc file for following the coding standards specified in PEP 7 & 8.
"
" To use this file, source it in your own personal .vimrc file (``source
" <filename>``) or, if you don't have a .vimrc file, you can just symlink to it
" (``ln -s <this file> ~/.vimrc``).  All options are protected by autocmds
" (read below for an explanation of the command) so blind sourcing of this file
" is safe and will not affect your settings for non-Python or non-C files.
"
"
" All setting are protected by 'au' ('autocmd') statements.  Only files ending
" in .py or .pyw will trigger the Python settings while files ending in *.c or
" *.h will trigger the C settings.  This makes the file "safe" in terms of only
" adjusting settings for Python and C files.
"
" Only basic settings needed to enforce the style guidelines are set.
" Some suggested options are listed but commented out at the end of this file.


" Number of spaces to use for an indent.
" This will affect Ctrl-T and 'autoindent'.
" Python: 4 spaces
" C: 8 spaces (pre-existing files) or 4 spaces (new files)
au BufRead,BufNewFile *.py,*.pyw set shiftwidth=4
"au BufRead *.c,*.h set shiftwidth=8
"au BufNewFile *.c,*.h set shiftwidth=4

" Number of spaces that a pre-existing tab is equal to.
" For the amount of space used for a new tab use shiftwidth.
" Python: 8
" C: 8
au BufRead,BufNewFile *.py,*.pyw set tabstop=4

" Replace tabs with the equivalent number of spaces.
" Also have an autocmd for Makefiles since they require hard tabs.
" Python: yes
" C: no
" Makefile: no
au BufRead,BufNewFile *.py,*.pyw set expandtab
au BufRead,BufNewFile *.c,*.h set noexpandtab
au BufRead,BufNewFile Makefile* set noexpandtab

" Use the below highlight group when displaying bad whitespace is desired
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/

" Wrap text after a certain number of characters
" Python: 79 
" C: 79
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h set textwidth=79

" Turn off settings in 'formatoptions' relating to comment formatting.
" - c : do not automatically insert the comment leader when wrapping based on
"    'textwidth'
" - o : do not insert the comment leader when using 'o' or 'O' from command mode
" - r : do not insert the comment leader when hitting <Enter> in insert mode
" Python: not needed
" C: prevents insertion of '*' at the beginning of every line in a comment
" au BufRead,BufNewFile *.c,*.h set formatoptions-=c formatoptions-=o formatoptions-=r

" Use UNIX (\n) line endings.
" Only used for new files so as to not force existing files to change their
" line endings.
" Python: yes
" C: yes
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix


" ----------------------------------------------------------------------------
" The following section contains suggested settings.  While in no way required
" to meet coding standards, they are helpful.

" Set the default file encoding to UTF-8: ``set encoding=utf-8``

" Puts a marker at the beginning of the file to differentiate between UTF and
" UCS encoding (WARNING: can trick shells into thinking a text file is actually
" a binary file when executing the text file): ``set bomb``

" For full syntax highlighting:
let python_highlight_all=1

" Nice statusbar
set laststatus=2
set statusline=
set statusline+=%2*%-3.3n%0*\                " buffer number
set statusline+=%f\                          " file name
if has("eval")
    let g:scm_cache = {}
    fun! ScmInfo()
        let l:key = getcwd()
        if ! has_key(g:scm_cache, l:key)
            if (isdirectory(getcwd() . "/.git"))
                let g:scm_cache[l:key] = "[" . substitute(readfile(getcwd() . "/.git/HEAD", "", 1)[0],
                            \ "^.*/", "", "") . "] "
            else
                let g:scm_cache[l:key] = ""
            endif
        endif
        return g:scm_cache[l:key]
    endfun
    set statusline+=%{ScmInfo()}             " scm info
endif
set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
if filereadable(expand("$VIM/vimfiles/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()}          " vim buddy
endif
set statusline+=%=                           " right align
set statusline+=%2*0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" Show tabs and trailing whitespace visually
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        if has("gui_running")
            set list listchars=tab:»·,trail:·,extends:…,nbsp:‗
        else
            " xterm + terminus hates these
            set list listchars=tab:»·,trail:·,extends:>,nbsp:_
        endif
    else
        set list listchars=tab:»·,trail:·,extends:…
    endif
else
    if v:version >= 700
        set list listchars=tab:>-,trail:.,extends:>,nbsp:_
    else
        set list listchars=tab:>-,trail:.,extends:>
    endif
endif

set fillchars=fold:-

augroup Tex
	au BufNewFile *.tex 0r ~/vim/template.tex | let IndentStyle = "tex"
augroup END

"vim-latex

let g:tex_flavor='latex'
imap <buffer> <leader>it <Plug>Tex_InsertItemOnThisLine
"Regle les problèmes d'accents
imap <C-b> <Plug>Tex_MathBF
imap <C-c> <Plug>Tex_MathCal
imap <C-l> <Plug>Tex_LeftRight

"Je veux du pdf
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_ViewRule_pdf = 'okular'

"BlueSpec
let b:verilog_indent_modules = 1

au BufRead,BufNewFile *.bsv set expandtab
au BufRead,BufNewFile *.bsv set tabstop=2
au BufRead,BufNewFile *.bsv set shiftwidth=2



" Make trailing whitespace be flagged as bad.
match BadWhitespace /\s\+$/

" Bufexplorer
let g:bufExplorerSplitRight = 1        " Split right.
let g:bufExplorerSortBy     ='mru'        " Sort by most recently used.
nnoremap <silent> <M-F12> :BufExplorer<CR>
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>

" Don't save backups of *.gpg files
set backupskip+=*.gpg
" To avoid that parts of the file is saved to .viminfo when yanking or
" deleting, empty the 'viminfo' option.

augroup encrypted
  au!
  " Disable swap files, and set binary file format before reading the file
  autocmd BufReadPre,FileReadPre *.gpg
    \ setlocal noswapfile bin
  autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
  " Decrypt the contents after reading the file, reset binary file format
  " and run any BufReadPost autocmds matching the file name without the .gpg
  " extension
  autocmd BufReadPost,FileReadPost *.gpg
    \ execute "'[,']!gpg --decrypt --default-recipient-self  2>/dev/null" |
    \ setlocal nobin |
    \ execute "doautocmd BufReadPost " . expand("%:r")
  " Set binary file format and encrypt the contents before writing the file
  autocmd BufWritePre,FileWritePre *.gpg
    \ setlocal bin |
    \ '[,']!gpg --encrypt --default-recipient-self  2>/dev/null
  " After writing the file, do an :undo to revert the encryption in the
  " buffer, and reset binary file format
  autocmd BufWritePost,FileWritePost *.gpg
    \ silent u |
    \ setlocal nobin
augroup END

augroup filetypedetect
  au! BufNewFile,BufRead *.jemdoc setf jemdoc
augroup END

" Last line is for proper wrapping of jemdoc lists, etc.
autocmd Filetype jemdoc setlocal comments=:#,fb:-,fb:.,fb:--,fb:..,fb:\:
