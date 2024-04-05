" GENERAL SETTINGS (see http://www.jukie.net/~bart/conf/vimrc)
" ================

set nocompatible    " get rid of vi compatibility mode 
set visualbell      " Turn off beep
set history=1000    " set the command history
set mouse=a         " always allow mouse usage
set packpath+=~/.vim/pack/
filetype on

" EDITING SETTINGS
" ================

set nohlsearch      " do not highlight search results
set showmatch       " show matching parens
"set t_kb=        " fix backspace and delete
"fixdel             " fix backspace and delete
set nonumber        " don't show line numbers by default
set laststatus=2    " always show the custom statusline
set path+=**        " allow look up recursively through subdirs
set wildmenu        " show possible completion matches

" Lightline statusline plugin config
let g:lightline = {'colorscheme': 'wombat'}

" INDENT SETTINGS
" ================

set softtabstop=4   " treat 4 spaces to behave like one tab (for deleting aso.)
set shiftwidth=4    " set number of spaces when indenting
set tabstop=4       " set number of spaces when tab is pressed
set expandtab       " use spaces each time tab is pressed
set autoindent
filetype on
filetype plugin indent on

" executing this function changes between tab and space tabtype
function! TabToggle()
    echomsg "TabToggle()"
    if &expandtab
        set shiftwidth=4 softtabstop=0 noexpandtab
        echo "tab indentation mode"
    else
        set shiftwidth=4 softtabstop=4 expandtab
        echo "space indentation mode"
    endif
endfunction

" tries to guess the intendation used for the current buffer by counting lines
" starting with tabs and spaces
function! GetIndentation()
    let l:tablines = len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^\\t"'))
    let l:spacelines = len(filter(getbufline(winbufnr(0), 1, "$"), 'v:val =~ "^ "'))
    "echo l:tablines . " tabs | " . l:spacelines . " spaces | " . &expandtab . " <-- expandtab"
    if (l:tablines > l:spacelines) && &expandtab
        " more lines starting with tabs
        call TabToggle()
    endif
    if (l:tablines < l:spacelines) && &expandtab == 0
        " more lines starting with spaces 
        call TabToggle()
    endif
endfunction

" map TabToggle() to F6
nmap <F6> mz:execute TabToggle()<CR>'z

" try guess indent type on open buffer
augroup GetIndentation
    autocmd!
    autocmd VimEnter,WinEnter,BufEnter * call GetIndentation()
augroup END

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
autocmd FileType make set noexpandtab shiftwidth=4 softtabstop=4

" don't put python at the start of the line. MFSFAFA:...
autocmd BufRead *.py set smartindent
autocmd BufRead *.py inoremap # X<c-h># 

" COLOR & VIDEO SETTINGS
" ======================

syntax on
colorscheme desert

" default gvim color scheme
if has("gui_running")
    " good looking colors for gvim
    color desert
    " adjust fonts to your own taste
    if has("gui_gtk2")
        set guifont=Terminus\ 12
    elseif has("x11")
        set guifont=-adobe-courier-medium-r-normal-*-12-*-*-*-*-*-*-*
    else
        set guifont=-monospace-:h14
    endif 
endif

" 3RD PARTY 
" =========

" fzf
set rtp+=/opt/homebrew/opt/fzf


" Backup
" ======================

" always make backup files when saving
"set backup 
"set backupdir=$HOME/.vim/backup 

" more comfortable way to rewrap the current paragraph
"map q gq}
