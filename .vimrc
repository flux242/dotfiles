"source $VIMRUNTIME/mswin.vim
"behave mswin

" Compiler
"set mp=./bm_main.bat\ .\ VC71\ GPDB\ NO\ DEBUG\ YES\ DLL

" load package manager
execute pathogen#infect()

set t_Co=256

" Use vim settings
set nocompatible

" Settings for the gvim
if has("gui_running")
  "source $VIMRUNTIME/mswin.vim
  "behave mswin
  "set co=120
  set co=95
  set lines=30
  "set lines=65
  "set guifont=Courier:h10:cRUSSIAN
  set guifont=Monospace,\ 10
  " no tool bar by default
  set guioptions-=T
  "set guioptions-=m
  " toggle menu bar mapping for the gvim
  map <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
                          \set guioptions-=T <Bar>
                       \else <Bar>
                          \set guioptions+=T <Bar>
                       \endif<CR>
  noremap   <C-s>     :w!<CR>
  inoremap  <C-s>     <Esc>:w!<CR>i
" set shell=c:\cygwin\cygwin.bat
endif "gui_running


" Vim common options
filetype plugin on
" allow backspacing over everything in insert mode
set backspace=indent,eol,start whichwrap+=<,>,[,]
set history=50   " keep 50 lines of command line history
set ruler        " show the cursor position all the time
set showcmd      " display incomplete commands
set incsearch    " do incremental searching
set wildmenu     " Set wildmenu
set nowrap       " Set nowrapping for text
set updatetime=250
set timeoutlen=50
" Tabstop and shiftwidth
set expandtab
set tabstop=2
set sw=2
set ignorecase
" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a
set mousemodel=extend
" Add a cursor line
if exists("+cursorline")
  set cursorline
endif
" Set current window height
set winheight=100
" Indent
set cin
" Show numbers
set number
" Set visual bell
set visualbell
set t_vb=
set list lcs=tab:→\ 
" Use stronger encryption ( use :X or vim -x file)
if has("crypt-blowfish2")
  set cm=blowfish2
 else
  set cm=blowfish
endif
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Set status line
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%03v][%p%%]\ [LEN=%L]
" set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [CHAR=\%03.3b/\#%02.2B]\ [POS=%04l/%L,%03v][%p%%]
set laststatus=2


" Global mapping
" faster movement with Ctrl
nmap     <C-l>    w
nmap     <C-h>    b
nmap     <C-k>    <C-u>
nmap     <C-j>    <C-d>
noremap  <C-a>    ggvG$
noremap  <C-Tab>  :tabn<CR>
noremap  <C-w>t   :tabnew<CR>
" findes and load file under cursor (path shall be set accordingly)
map      ,g       :find <cfile>:t<CR>
map      ,G       :sf <cfile>:t<CR>
" next/previous buffer
noremap  <C-b>p   :bprevious<CR>
noremap  <C-b>n   :bnext<CR>
" changes size of the current window
noremap  +       <C-W>+
noremap  -       <C-W>-
noremap  <C-<>   <C-W><
noremap  <C->>   <C-W>>
" toggles search highlighting
map       H        :let &hlsearch = !&hlsearch<CR>
" restores selection after shift
vnoremap  <       <gv
vnoremap  >       >gv
" copy selection to the system clipboard
vnoremap <C-C> :w !xclip -i -sel c<CR><CR>
" insert mode mappings
inoremap  <C-l>  <ESC>o
"inoremap  {      {<CR>x<CR>}<ESC>k$xi<SPACE>
"inoremap  [      []<ESC>i
"inoremap  (      ()<ESC>i
" Yank to the end of the line
map       Y      y$
" quick exit
map Q :qa<CR>

" ctags
set tags=./tags,tags,$PROJDIR/tags
map      ,t       :!~/tagsall %:h<CR>

" setting path to include current project dir
set path=.,/usr/iuclude/,,,$PROJDIR/**

" Explorer plugin and netrw
" explorer setting is kept for compatibility with older versions
let g:explSplitBelow=1
"let g:netrw_winsize=15
"let g:netrw_alto=1
"let g:netrw_browse_split=1
if has("win32unix")
  let g:netrw_cygwin=1
endif

" taglist plugin
let g:Tlist_Inc_Winwidth=0

" folding
let g:vimsyn_folding='af'
set foldmethod=syntax
set foldlevelstart=20
let g:xml_syntax_folding=1

" grep
set wildignore=*.o,*.obj,*~,*.pyc,.git/**,tags,cscope*,.cproject,CMake*
let &grepprg='grep -HEnri --exclude={' . &wildignore . '} --exclude-dir={' . &wildignore . '} $*'
"let &grepprg='grep -HEnri --exclude=' . shellescape(&wildignore) . ' $*'

" fill chars
"set fillchars+=vert:\│
"set fillchars=vert:\┃
set fillchars=vert:▕
set fillchars+=fold:-

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin,*.exe,*.vob,*.mp3 let &bin=1
  au BufReadPost *.bin,*.exe,*.vob,*.mp3 if &bin | %!xxd
  au BufReadPost *.bin,*.exe,*.vob,*.mp3 set ft=xxd | endif
  au BufWritePre *.bin,*.exe,*.vob,*.mp3 if &bin | %!xxd -r
  au BufWritePre *.bin,*.exe,*.vob,*.mp3 endif
  au BufWritePost *.bin,*.exe,*.vob,*.mp3 if &bin | %!xxd
  au BufWritePost *.bin,*.exe,*.vob,*.mp3 set nomod | endif
augroup END

" keep quickfix window 11 lines always
au WinEnter  *  call s:SetQFixHeight()
function! s:SetQFixHeight()
  if winheight(0) < 2
    resize +6
  endif
endfunction

" spell checking is on
if exists("spell")
  "set spell
  "set spelllang=en,de,ru
  set spelllang=en
endif


" colorscheme
" colorscheme shine
"colorscheme summerfruit256
colorscheme eclipse

"hi clear Normal
hi clear Special
hi clear StatusLine
hi clear Comment
hi clear Statement
hi clear Number
hi clear CursorLine
hi clear StorageClass

"hi Normal        cterm=NONE ctermfg=16 ctermbg=254 guifg=Black guibg=LightGray
"hi StatusLine    cterm=bold ctermbg=darkblue ctermfg=yellow guibg=blue guifg=Yellow gui=bold
hi StatusLine    term=bold,reverse cterm=bold ctermfg=12 ctermbg=15 guifg=#ffffff guibg=#4570aa
hi StatusLineNC  ctermfg=16 ctermbg=242
hi VertSplit     ctermfg=81 ctermbg=NONE
"hi StatusLineNC  ctermbg=242 ctermfg=12
"hi Cursor        cterm=reverse guibg=Brown
hi LineNr        ctermfg=DarkGray cterm=reverse guifg=Blue guibg=Gray
hi CursorLine    term=underline ctermbg=black guibg=gray
hi Comment       ctermfg=DarkGreen cterm=none guifg=DarkGreen gui=none
hi Type          term=underline ctermfg=Blue guifg=Blue gui=none
hi Question      term=standout ctermfg=Blue gui=bold guifg=Blue
hi Special       ctermfg=DarkRed cterm=bold guifg=OrangeRed
hi Statement     ctermfg=Brown cterm=bold
"hi Number        ctermfg=DarkRed guifg=DarkRed
"hi Constant      ctermfg=64
"hi Constant      term=underline ctermfg=9 guifg=#ffa0a0
hi Constant      term=underline ctermfg=15 guifg=#ffa0a0
hi! link          Number Constant
hi StorageClass  ctermfg=Red guifg=Red gui=bold
hi Search        term=reverse ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi MoreThen80    ctermbg=236 guibg=lightcyan
hi Directory     ctermfg=DarkBlue cterm=bold
hi Visual        ctermfg=0 ctermbg=7
hi! link         SignColumn LineNr

" change statusline color depending on the mode
autocmd InsertEnter * hi StatusLine ctermbg=52
autocmd InsertLeave * hi StatusLine ctermbg=blue

" airline settings
let g:airline_theme='kalisi'
let g:airline_section_z='%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#%#__restore__#%#__accent_bold#%#__accent_bold#%{g:airline_symbols.maxlinenr}%#__restore__#%#__restore__# :%3v'
let g:airline#extensions#whitespace#enabled=0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
      endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
"let g:airline_left_sep = ''
"let g:airline_right_sep = ''
"let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = ''
"let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.crypt= ''

" Nerdtree settings
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" the amount of space to use after the glyph character
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, term, guifg, guibg)
 exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' cterm='. a:term .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('apk', '215', 'none', 'none', '#ffaf5f', '#151515')
call NERDTreeHighlightFile('asc', '192', 'none', 'italic', '#d7ff87', '#151515')
call NERDTreeHighlightFile('asm', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('avi', '114', 'none', 'none', '#87d787', '#151515')
call NERDTreeHighlightFile('awk', '172', 'none', 'none', '#d78700', '#151515')
call NERDTreeHighlightFile('bak', '241', 'none', 'none', '#626262', '#151515')
call NERDTreeHighlightFile('bat', '172', 'none', 'none', '#d78700', '#151515')
call NERDTreeHighlightFile('bin', '124', 'none', 'none', '#af0000', '#151515')
call NERDTreeHighlightFile('bmp', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('bz2', '40', 'none', 'none', '#00d700', '#151515')
call NERDTreeHighlightFile('c', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('cc', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('chm', '141', 'none', 'none', '#af87ff', '#151515')
call NERDTreeHighlightFile('coffee', '74', 'none', 'bold', '#5fafd7', '#151515')
call NERDTreeHighlightFile('cpp', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('cs', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('css', '125', 'none', 'bold', '#af005f', '#151515')
call NERDTreeHighlightFile('csv', '78', 'none', 'none', '#5fd787', '#151515')
call NERDTreeHighlightFile('cxx', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('dat', '137', 'none', 'bold', '#af875f', '#151515')
call NERDTreeHighlightFile('db', '60', 'none', 'none', '#5f5f87', '#151515')
call NERDTreeHighlightFile('deb', '215', 'none', 'none', '#ffaf5f', '#151515')
call NERDTreeHighlightFile('def', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('diff', '232', '197', 'none', '#080808', '#ff005f')
call NERDTreeHighlightFile('dll', '241', 'none', 'none', '#626262', '#151515')
call NERDTreeHighlightFile('dmp', '29', 'none', 'none', '#00875f', '#151515')
call NERDTreeHighlightFile('doc', '111', 'none', 'none', '#87afff', '#151515')
call NERDTreeHighlightFile('docx', '111', 'none', 'none', '#87afff', '#151515')
call NERDTreeHighlightFile('dtd', '178', 'none', 'none', '#d7af00', '#151515')
call NERDTreeHighlightFile('dts', '137', 'none', 'bold', '#af875f', '#151515')
call NERDTreeHighlightFile('dylib', '241', 'none', 'none', '#626262', '#151515')
call NERDTreeHighlightFile('eps', '99', 'none', 'none', '#875fff', '#151515')
call NERDTreeHighlightFile('epub', '141', 'none', 'none', '#af87ff', '#151515')
call NERDTreeHighlightFile('gif', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('git', '197', 'none', 'none', '#ff005f', '#151515')
call NERDTreeHighlightFile('go', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('gpg', '192', 'none', 'italic', '#d7ff87', '#151515')
call NERDTreeHighlightFile('gz', '40', 'none', 'none', '#00d700', '#151515')
call NERDTreeHighlightFile('h', '110', 'none', 'none', '#87afd7', '#151515')
call NERDTreeHighlightFile('hpp', '110', 'none', 'none', '#87afd7', '#151515')
call NERDTreeHighlightFile('htm', '125', 'none', 'bold', '#af005f', '#151515')
call NERDTreeHighlightFile('html', '125', 'none', 'bold', '#af005f', '#151515')
call NERDTreeHighlightFile('icns', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('ico', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('iml', '166', 'none', 'none', '#d75f00', '#151515')
call NERDTreeHighlightFile('in', '242', 'none', 'none', '#6c6c6c', '#151515')
call NERDTreeHighlightFile('info', '184', 'none', 'none', '#d7d700', '#151515')
call NERDTreeHighlightFile('ipynb', '41', 'none', 'none', '#00d75f', '#151515')
call NERDTreeHighlightFile('jar', '215', 'none', 'none', '#ffaf5f', '#151515')
call NERDTreeHighlightFile('java', '74', 'none', 'bold', '#5fafd7', '#151515')
call NERDTreeHighlightFile('jpeg', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('jpg', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('JPG', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('js', '74', 'none', 'bold', '#5fafd7', '#151515')
call NERDTreeHighlightFile('jsm', '74', 'none', 'bold', '#5fafd7', '#151515')
call NERDTreeHighlightFile('json', '178', 'none', 'none', '#d7af00', '#151515')
call NERDTreeHighlightFile('jsp', '74', 'none', 'bold', '#5fafd7', '#151515')
call NERDTreeHighlightFile('key', '166', 'none', 'none', '#d75f00', '#151515')
call NERDTreeHighlightFile('less', '125', 'none', 'bold', '#af005f', '#151515')
call NERDTreeHighlightFile('log', '190', 'none', 'none', '#d7ff00', '#151515')
call NERDTreeHighlightFile('lua', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('m', '110', 'none', 'none', '#87afd7', '#151515')
call NERDTreeHighlightFile('m3u', '116', 'none', 'none', '#87d7d7', '#151515')
call NERDTreeHighlightFile('m4', '242', 'none', 'none', '#6c6c6c', '#151515')
call NERDTreeHighlightFile('map', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('markdown', '184', 'none', 'none', '#d7d700', '#151515')
call NERDTreeHighlightFile('md', '184', 'none', 'none', '#d7d700', '#151515')
call NERDTreeHighlightFile('md5', '116', 'none', 'none', '#87d7d7', '#151515')
call NERDTreeHighlightFile('mf', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('mkd', '184', 'none', 'none', '#d7d700', '#151515')
call NERDTreeHighlightFile('mm', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('mp3', '137', 'none', 'bold', '#af875f', '#151515')
call NERDTreeHighlightFile('mp4', '114', 'none', 'none', '#87d787', '#151515')
call NERDTreeHighlightFile('msg', '178', 'none', 'none', '#d7af00', '#151515')
call NERDTreeHighlightFile('o', '241', 'none', 'none', '#626262', '#151515')
call NERDTreeHighlightFile('odb', '111', 'none', 'none', '#87afff', '#151515')
call NERDTreeHighlightFile('ods', '112', 'none', 'none', '#87d700', '#151515')
call NERDTreeHighlightFile('odt', '111', 'none', 'none', '#87afff', '#151515')
call NERDTreeHighlightFile('ogg', '137', 'none', 'bold', '#af875f', '#151515')
call NERDTreeHighlightFile('old', '242', 'none', 'none', '#6c6c6c', '#151515')
call NERDTreeHighlightFile('orig', '241', 'none', 'none', '#626262', '#151515')
call NERDTreeHighlightFile('otf', '66', 'none', 'none', '#5f8787', '#151515')
call NERDTreeHighlightFile('out', '242', 'none', 'none', '#6c6c6c', '#151515')
call NERDTreeHighlightFile('pak', '215', 'none', 'none', '#ffaf5f', '#151515')
call NERDTreeHighlightFile('patch', '232', '197', 'bold', '#080808', '#ff005f')
call NERDTreeHighlightFile('pc', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('pdf', '141', 'none', 'none', '#af87ff', '#151515')
call NERDTreeHighlightFile('PDF', '141', 'none', 'none', '#af87ff', '#151515')
call NERDTreeHighlightFile('pem', '192', 'none', 'italic', '#d7ff87', '#151515')
call NERDTreeHighlightFile('pgp', '192', 'none', 'italic', '#d7ff87', '#151515')
call NERDTreeHighlightFile('php', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('pk3', '215', 'none', 'none', '#ffaf5f', '#151515')
call NERDTreeHighlightFile('pl', '208', 'none', 'none', '#ff8700', '#151515')
call NERDTreeHighlightFile('png', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('pptx', '166', 'none', 'none', '#d75f00', '#151515')
call NERDTreeHighlightFile('properties', '116', 'none', 'none', '#87d7d7', '#151515')
call NERDTreeHighlightFile('py', '41', 'none', 'none', '#00d75f', '#151515')
call NERDTreeHighlightFile('pyc', '240', 'none', 'none', '#585858', '#151515')
call NERDTreeHighlightFile('rar', '40', 'none', 'none', '#00d700', '#151515')
call NERDTreeHighlightFile('rb', '41', 'none', 'none', '#00d75f', '#151515')
call NERDTreeHighlightFile('rdf', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('rom', '213', 'none', 'none', '#ff87ff', '#151515')
call NERDTreeHighlightFile('rst', '184', 'none', 'none', '#d7d700', '#151515')
call NERDTreeHighlightFile('rtf', '111', 'none', 'none', '#87afff', '#151515')
call NERDTreeHighlightFile('s', '110', 'none', 'none', '#87afd7', '#151515')
call NERDTreeHighlightFile('S', '110', 'none', 'none', '#87afd7', '#151515')
call NERDTreeHighlightFile('sample', '114', 'none', 'none', '#87d787', '#151515')
call NERDTreeHighlightFile('sav', '213', 'none', 'none', '#ff87ff', '#151515')
call NERDTreeHighlightFile('scala', '41', 'none', 'none', '#00d75f', '#151515')
call NERDTreeHighlightFile('sch', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('scm', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('scss', '125', 'none', 'bold', '#af005f', '#151515')
call NERDTreeHighlightFile('sed', '172', 'none', 'none', '#d78700', '#151515')
call NERDTreeHighlightFile('service', '45', 'none', 'none', '#00d7ff', '#151515')
call NERDTreeHighlightFile('sgml', '178', 'none', 'none', '#d7af00', '#151515')
call NERDTreeHighlightFile('sh', '172', 'none', 'none', '#d78700', '#151515')
call NERDTreeHighlightFile('sig', '192', 'none', 'italic', '#d7ff87', '#151515')
call NERDTreeHighlightFile('sqlite', '60', 'none', 'none', '#5f5f87', '#151515')
call NERDTreeHighlightFile('sty', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('sub', '117', 'none', 'none', '#87d7ff', '#151515')
call NERDTreeHighlightFile('svg', '99', 'none', 'none', '#875fff', '#151515')
call NERDTreeHighlightFile('swp', '244', 'none', 'none', '#808080', '#151515')
call NERDTreeHighlightFile('tar', '40', 'none', 'none', '#00d700', '#151515')
call NERDTreeHighlightFile('tcl', '64', 'none', 'bold', '#5f8700', '#151515')
call NERDTreeHighlightFile('tex', '184', 'none', 'none', '#d7d700', '#151515')
call NERDTreeHighlightFile('tgz', '40', 'none', 'none', '#00d700', '#151515')
call NERDTreeHighlightFile('theme', '116', 'none', 'none', '#87d7d7', '#151515')
call NERDTreeHighlightFile('tmp', '244', 'none', 'none', '#808080', '#151515')
call NERDTreeHighlightFile('toml', '178', 'none', 'none', '#d7af00', '#151515')
call NERDTreeHighlightFile('ts', '115', 'none', 'none', '#87d7af', '#151515')
call NERDTreeHighlightFile('tsv', '78', 'none', 'none', '#5fd787', '#151515')
call NERDTreeHighlightFile('ttf', '66', 'none', 'none', '#5f8787', '#151515')
call NERDTreeHighlightFile('twig', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('txt', '253', 'none', 'none', '#dadada', '#151515')
call NERDTreeHighlightFile('vbs', '81', 'none', 'none', '#5fd7ff', '#151515')
call NERDTreeHighlightFile('vim', '172', 'none', 'none', '#d78700', '#151515')
call NERDTreeHighlightFile('vtt', '117', 'none', 'none', '#87d7ff', '#151515')
call NERDTreeHighlightFile('wav', '136', 'none', 'bold', '#af8700', '#151515')
call NERDTreeHighlightFile('webp', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('woff', '66', 'none', 'none', '#5f8787', '#151515')
call NERDTreeHighlightFile('woff2', '66', 'none', 'none', '#5f8787', '#151515')
call NERDTreeHighlightFile('xcf', '7', 'none', 'none', '#c0c0c0', '#151515')
call NERDTreeHighlightFile('xls', '112', 'none', 'none', '#87d700', '#151515')
call NERDTreeHighlightFile('xlsx', '112', 'none', 'none', '#87d700', '#151515')
call NERDTreeHighlightFile('xltx', '73', 'none', 'none', '#5fafaf', '#151515')
call NERDTreeHighlightFile('xml', '178', 'none', 'none', '#d7af00', '#151515')
call NERDTreeHighlightFile('xpm', '97', 'none', 'none', '#875faf', '#151515')
call NERDTreeHighlightFile('xsd', '178', 'none', 'none', '#d7af00', '#151515')
call NERDTreeHighlightFile('xz', '40', 'none', 'none', '#00d700', '#151515')
call NERDTreeHighlightFile('yaml', '178', 'none', 'none', '#d7af00', '#151515')
call NERDTreeHighlightFile('yml', '178', 'none', 'none', '#d7af00', '#151515')
call NERDTreeHighlightFile('Z', '40', 'none', 'none', '#00d700', '#151515')
call NERDTreeHighlightFile('zip', '40', 'none', 'none', '#00d700', '#151515')

" AsyncRun aliases
"command! -bang -nargs=* -complete=file Make call asyncrun#run('<bang>', '', 'make <f-args>') | cwindow 10
command! -bang -nargs=* -complete=file Make call asyncrun#run('<bang>', '', 'make <f-args>')
command! -bang -nargs=* -complete=file Grep call asyncrun#run('<bang>', '', 'grep -HEnri --exclude={*.o,*.obj,*~,*.pyc,.git/**,tags,cscope*,.cproject,CMake*} --exclude-dir={CMakeFiles} <f-args>')

" Functions
"
" shows diff of the current edited file with the original
function! s:DiffWithSaved()
  diffthis
  vert new | r # | normal 1Gdd
  diffthis
  setlocal bt=nofile bh=wipe nobl noswf ro
endfunction
com! Diff call s:DiffWithSaved()

" Create a global dir for all swap files
function! s:CreateSwapDir()
  let s:useSwapDir = 1
  if $TEMP=="" || !isdirectory($TEMP)
    echo "TEMP is not set or " . "$TEMP" . " does not exist. Swap files will be created in place."
    let s:useSwapDir = 0
  else
    let s:vimTmpDir = $TEMP . "/vim"
    if !isdirectory(s:vimTmpDir)
      if exists("*mkdir") && mkdir(s:vimTmpDir)==1
        let s:err = ""
      else
        let s:err = system("mkdir " . s:vimTmpDir)
      endif
      if s:err!=""
        echo "Error creating dir " . s:vimTmpDir . " - " . s:err
        let s:useSwapDir = 0
      endif
      unlet! s:err
    endif
    unlet! s:vimTmpDir
  endif
  return s:useSwapDir
endfunction
" defines where swap and backup files goes to
if s:CreateSwapDir() == 1
  set   backupdir=$TEMP/vim
  set   directory=$TEMP/vim
endif

" Toggle fold state between closed and opened.
"
" If there is no fold at current line, just moves forward.
" If it is present, reverse it's state.
fun! ToggleFold()
  if foldlevel('.') == 0
    normal! l
  else
    if foldclosed('.') < 0
      . foldclose
    else
      . foldopen
    endif
  endif
  " Clear status line
  echo
endfun
" Map this function to Space key.
noremap <space> :call ToggleFold()<CR>

" Insert <Tab> or complete identifier
" if the cursor is after a keyword character
function! MyTabOrComplete()
    let col = col('.')-1
    if !col || getline('.')[col-1] !~ '\k'
        return "\<tab>"
    else
        return "\<C-N>"
    endif
endfunction
inoremap <Tab> <C-R>=MyTabOrComplete()<CR>

" Rematching if a new window is opened
" because match does only work in the currnet window
fun! ReMatch()
  "echo &buftype
  if &buftype == 'help'
    return
  endif
  match MoreThen80 /\%>79v.\+/
  2match ErrorMsg /\t/
endfun
autocmd BufEnter * call ReMatch()

