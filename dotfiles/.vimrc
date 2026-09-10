"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set auto read to buffer changes
set autoread

" Set auto indentation
set autoindent

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Colorscheme
"colorscheme molokai
"colorscheme green

" Enable type file detection. Vim will be able to try to detect the type of file is use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax enable

" Add numbers to the file.
set number
" set relativenumber 

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
" set cursorcolumn

" Set shift width to 2 spaces.
set shiftwidth=2

" Set tab width to 2 columns.
set tabstop=2

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Rust {{{
let g:rustfmt_autosave = 1
"}}}

" Python {{{
let g:ale_linters = {
      \ 'python': ['ruff'],
      \}
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python': ['ruff', 'ruff_format'],
      \}
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_delay = 300
" }}}

" ShellFmt {{{
"let g:shfmt_fmt_on_save = 1
" }}}"

" Prettier {{{

" Autoformatting files on save without @format or @prettier tags
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" Forced async
let g:prettier#exec_cmd_async = 1

"}}}"

" Floaterm {{{ 

let g:floaterm_autoclose = 0
let g:floaterm_autoinsert = 'smart'

" "}}}

" NerdTree ---------------------------------------------------------------- {{{

let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1

" }}}

" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')

Plug 'rust-lang/rust.vim'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

call plug#end()

" }}}

if isdirectory(expand('~/.tmux/plugins/vim-tmux-navigator'))
  set runtimepath+=~/.tmux/plugins/vim-tmux-navigator
  silent! runtime plugin/tmux_navigator.vim
endif

" MAPPINGS --------------------------------------------------------------- {{{

" Set the backslash as the leader key.
let mapleader = '\'

function! s:ShowMenu(lines) abort
  if has('popupwin')
    let l:width = max(map(copy(a:lines), 'strdisplaywidth(v:val)')) + 2
    let l:popup = popup_create(a:lines, {
          \ 'line': 'cursor+1',
          \ 'col': 'cursor',
          \ 'minwidth': l:width,
          \ 'padding': [0, 1, 0, 1],
          \ 'border': [],
          \ 'time': 3000,
          \ })
    redraw
    return l:popup
  endif

  echo join(a:lines, "\n")
  return -1
endfunction

function! s:CloseMenu(popup_id) abort
  if a:popup_id > 0
    call popup_close(a:popup_id)
  endif
endfunction

function! s:GetLeaderKey() abort
  let l:key = getcharstr()
  if l:key ==# "\<Esc>"
    return ''
  endif
  return l:key
endfunction

function! s:LeaderMenu() abort
  let l:popup = s:ShowMenu([
        \ '\        last cursor position',
        \ 'f        files/search',
        \ 'r        python/run',
        \ 't        toggle terminal',
        \ 'T        new terminal',
        \ 'p        print file',
        \ ])
  let l:key = s:GetLeaderKey()
  call s:CloseMenu(l:popup)

  if l:key ==# '\'
    normal! ``
  elseif l:key ==# 'f'
    call s:LeaderFileMenu()
  elseif l:key ==# 'r'
    call s:LeaderRunMenu()
  elseif l:key ==# 't'
    FloatermToggle
  elseif l:key ==# 'T'
    FloatermNew
  elseif l:key ==# 'p'
    %w !lp
  endif
endfunction

function! s:LeaderFileMenu() abort
  let l:popup = s:ShowMenu([
        \ 'f        find files',
        \ 'b        buffers',
        \ 's        search text',
        \ ])
  let l:key = s:GetLeaderKey()
  call s:CloseMenu(l:popup)

  if l:key ==# 'f'
    Files .
  elseif l:key ==# 'b'
    Buff
  elseif l:key ==# 's'
    Rg
  endif
endfunction

function! s:LeaderRunMenu() abort
  let l:popup = s:ShowMenu([
        \ 'r        run Python file',
        \ 'i        Python REPL',
        \ 'f        fix current file',
        \ ])
  let l:key = s:GetLeaderKey()
  call s:CloseMenu(l:popup)

  if l:key ==# 'r'
    call s:RunPythonFile()
  elseif l:key ==# 'i'
    FloatermNew --autoclose=0 --cwd=<buffer> python3
  elseif l:key ==# 'f'
    ALEFix
  endif
endfunction

nnoremap <silent> <leader> :<C-u>call <SID>LeaderMenu()<CR>

" Type jj to exit insert mode quickly.
inoremap jj <Esc>


" Auto close tags
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Press the space bar to type the : character in command mode.
nnoremap <space> :

" Save with CTRL S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>

" Pressing the letter o will open a new line below the current one.
" Exit insert mode after creating a new line above or below the current line.
nnoremap o o<esc>
nnoremap O O<esc>

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz

" Yank from cursor to the end of line.
nnoremap Y y$

" Use CTRL+q for Visual Block mode so CTRL+v can paste from the clipboard.
nnoremap <C-q> <C-v>
vnoremap <C-q> <C-v>

" Clipboard copy/paste.
function! s:ClipboardCopyText(text) abort
  if has('clipboard')
    let @+ = a:text
  elseif executable('xclip')
    call system('xclip -selection clipboard', a:text)
  endif
endfunction

function! s:ClipboardPasteText() abort
  if has('clipboard')
    return @+
  elseif executable('xclip')
    return system('xclip -selection clipboard -out')
  endif

  return ''
endfunction

function! s:ClipboardCopyLine() abort
  let l:save_z = @z
  normal! "zyy
  call s:ClipboardCopyText(@z)
  let @z = l:save_z
endfunction

function! s:ClipboardCopySelection() abort
  let l:save_z = @z
  normal! gv"zy
  call s:ClipboardCopyText(@z)
  let @z = l:save_z
endfunction

function! s:ClipboardPasteNormal() abort
  let l:save_z = @z
  let @z = s:ClipboardPasteText()
  normal! "zp
  let @z = l:save_z
endfunction

function! s:ClipboardPasteSelection() abort
  let l:save_z = @z
  let @z = s:ClipboardPasteText()
  normal! gv"zp
  let @z = l:save_z
endfunction

function! s:ClipboardPasteInsert() abort
  return s:ClipboardPasteText()
endfunction

nnoremap <silent> <C-c> :<C-u>call <SID>ClipboardCopyLine()<CR>
vnoremap <silent> <C-c> :<C-u>call <SID>ClipboardCopySelection()<CR>
nnoremap <silent> <C-v> :<C-u>call <SID>ClipboardPasteNormal()<CR>
vnoremap <silent> <C-v> :<C-u>call <SID>ClipboardPasteSelection()<CR>
inoremap <C-v> <C-r>=<SID>ClipboardPasteInsert()<CR>

function! s:RunPythonFile() abort
  update
  execute 'FloatermNew --autoclose=0 --cwd=<buffer> python3 ' . shellescape(expand('%:p'))
endfunction

" Run the current Python file in a reusable terminal.
nnoremap <silent> <f5> :<C-u>call <SID>RunPythonFile()<CR>

" You can split the window in Vim by typing :split or :vsplit.
" Navigate Vim and tmux panes with CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

" NERDTree specific mappings.
" Map the F3 key to toggle NERDTree open and close.
nnoremap <silent> <F3> :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{

"-- FOLDING --
set foldmethod=syntax "syntax highlighting items specify folds
set foldcolumn=0
let javaScript_fold=1 "activate folding by JS syntax
set foldlevelstart=99 "start file with all folds opened

" Enable the marker method of folding.
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" If the current file type is HTML, set indentation to 2 spaces.
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

" Python uses standard 4-space indentation and Ruff's default line length.
autocmd Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab textwidth=88 colorcolumn=89

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
  set undodir=~/.vim/backup
  set undofile
  set undoreload=10000
endif

" You can split a window into sections by typing `:split` or `:vsplit`.
" Display cursorline only in the active editing window.
augroup cursor_off
  autocmd!
  autocmd WinLeave * setlocal nocursorline nocursorcolumn colorcolumn= foldcolumn=0
  autocmd WinEnter * setlocal cursorline nocursorcolumn
  autocmd FileType nerdtree,NERD_tree setlocal nocursorline nocursorcolumn colorcolumn= foldcolumn=0 nonumber norelativenumber signcolumn=no
  autocmd BufWinEnter,WinEnter * if &filetype ==# 'nerdtree' || &filetype ==# 'NERD_tree' || expand('%:t') =~# '^NERD_tree' | setlocal nocursorline nocursorcolumn colorcolumn= foldcolumn=0 nonumber norelativenumber signcolumn=no | endif
augroup END

" If GUI version of Vim is running set these options.
if has('gui_running')

  " Set the background tone.
  set background=dark

  " Set the color scheme.
  colorscheme molokai

  " Set a custom font you have installed on your computer.
  " Syntax: <font_name>\ <weight>\ <size>
  set guifont=Monospace\ Regular\ 12

  " Display more of the file by default.
  " Hide the toolbar.
  set guioptions-=T

  " Hide the the left-side scroll bar.
  set guioptions-=L

  " Hide the the left-side scroll bar.
  set guioptions-=r

  " Hide the the menu bar.
  set guioptions-=m

  " Hide the the bottom scroll bar.
  set guioptions-=b

  " Map the F4 key to toggle the menu, toolbar, and scroll bar.
  " <Bar> is the pipe character.
  " <CR> is the enter key.
  nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
        \set guioptions-=mTr<Bar>
        \else<Bar>
        \set guioptions+=mTr<Bar>
        \endif<CR>

endif

" }}}

" STATUS LINE ------------------------------------------------------------ {{{

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
"set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}
