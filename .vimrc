" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set nu

set nobackup
set laststatus=2
set statusline+=%F

" set the tab to 4 space
set smartindent
"set tabstop=4
"set shiftwidth=4


function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

" clipboard integration
" http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing#Comments
if has('win64')|| has('win32') || has('mac')
    " mac/windows
    set clipboard=unnamed
else
    " linux
    set clipboard=unnamedplus
endif


" Configuration for ctrlp
let g:ctrlp_working_path_mode = ''
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|pyc|so|dll|cmd|o|out)$',
    \ }
let g:ctrlp_user_command = ['ctrlp.files', 'cat %s/ctrlp.files']

" vim yank to clipboard, clipboard integration
" 1. vim --version | grep clip
"   Make sure clipboard is include, if not
"   sudo apt-get install vim-gtk 
"   to reinstall vim
" 2. http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing#Comments
if has('win64')|| has('win32') || has('mac')
    " mac/windows
    set clipboard=unnamed
else
    " linux
    set clipboard=unnamedplus
endif


" disable continuation of comment to allow ctrl-v in insert mode
" http://stackoverflow.com/questions/6076592/vim-set-formatoptions-being-lost
" http://superuser.com/questions/271023/vim-can-i-disable-continuation-of-comments-to-the-next-line
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro


color desert
set cursorline
"set cursorcolumn
hi CursorLine   cterm=NONE ctermbg=green ctermfg=black
"hi CursorColumn   cterm=NONE ctermbg=green ctermfg=black

" reload when change
set autoread
