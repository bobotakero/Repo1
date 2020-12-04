" language en_US.utf8
set langmenu=en_US.UTF-8    
" sets the language of the menu (gvim)
" lan en_US
inoremap <C-f> <C-x><C-f>
" quit vim with :Q
" command Q q
" remap ö zu doppelpunkt
nnoremap ö :
" ## enable mouse !! (based vim update)
set mouse=a
" allow backspace to delete behind insert
set backspace=indent,eol,start
" #### split option #####
" intuitive splits
set splitbelow splitright
" # resizing splits

" disable Q (enters Ex-Mode) (important!)
nnoremap Q <nop>

" autocompelte with TAB
set wildmenu
set tabpagemax=50

" ###### NERDTree plugin
" autostart (turned OFF)
" autocmd vimenter * NERDTree

" ################ Python   ################
" file
" run !python3 by pressing <F9> (<esc> leaves insert mode, optional)
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!clear;python' shellescape(@%, 1)<CR>
" set tabstops 
set tabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set autoindent          " copy indent from current line when starting a new line
set smartindent
set softtabstop=4

" testttttt
set clipboard=unnamed 

" also mapped in normal mode
autocmd FileType python nmap <buffer> <F9> <esc>:w<CR>:exec '!clear;python3' shellescape(@%, 1)<CR>

" map :r in NORMAL mode to run python programm (fuck F keys)

autocmd FileType python imap <buffer> <C-r>  <esc>:w<CR>:exec '!clear;python' shellescape(@%, 1)<CR>

" ################ mappings ################
" mapping CMD+. to <esc> (<esc> still works)
inoremap <C-.> <esc>
inoremap <C-l> <esc>`^
inoremap <C-k> <esc>`^
cnoremap <C-l> <esc>

" the `^ thing in the end does some cursor position thingy i think

" map TAB in command mode to insert
nnoremap <tab> i<tab>

" ############ switch between panes with CTRL+HJKL
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
" ############## comment/uncomment #########

" questionable in some cases (can't move back in * search)
" this remaps # to --> insert at beginning of line, then #
" maps Ç to remove first character in line
" nnoremap # I#<space><esc>0
" nnoremap Ç 0xx

" ############## highlight #################
" 
" indicate mode in green:
hi ModeMsg ctermfg=black ctermbg=lightgreen

" selected window taskbar
hi StatusLineNC ctermfg=black ctermbg=white
hi StatusLine ctermfg=white ctermbg=black

hi StatusLineTermNC ctermfg=lightred ctermbg=black
hi StatusLineTerm ctermfg=lightred ctermbg=white
" numbers line indicator (r=relative, nu=number)
" set rnu!
" set rnu 
set nu
set laststatus=2
" show cursorline only in active buffer
" autocmd WinEnter * setlocal cursorline
" autocmd WinLeave * setlocal nocursorline
" hi LineNr ctermfg=lightgrey
" hi CursorLineNr ctermfg=white
" let's try something:
au InsertLeave * hi CursorLineNr ctermfg=blue
au InsertEnter * hi CursorLineNr ctermfg=green
"au InsertEnter * hi StatusLine term=reverse ctermbg=Yellow  ctermfg=DarkBlue
"au InsertLeave * hi StatusLine term=reverse ctermbg=DarkRed ctermfg=LightGray

" visual color a little darker (does that do anyhting?)
hi Visual ctermbg=grey

" ########## Searching ############

" experimental: remaps ESC key, so that it clears search with 
" nnoremap <esc> :noh<return><esc>
" Map TAB to escape key ---> https://vim.fandom.com/wiki/Avoid_the_escape_key

" cursor line settings
" set cursorline
" hi CursorLine cterm=bold

" vim colored cursor line
au InsertLeave * hi CursorLine ctermbg=darkblue 
au InsertEnter * hi CursorLine ctermbg=green

" syntax
syntax enable

set showmode 
set showcmd " show CTR+L, ESC in bottom right corner
set timeoutlen=100 ttimeoutlen=0


" highlight change search term:
set hlsearch
hi Search ctermbg=white ctermfg=black term=underline cterm=underline

"ignore case when searching
set ignorecase
" update search results while typing
set incsearch
" smart search, includes Upper when Upper in searchterm
set smartcase

" remap :Q to :q in Normal Mode
nmap :W :w
nmap :Q :q

" ########## 3. Highlights ###########

" highlight tab characters as |
" show whitespaces as chars: ON
:set list
" last character is space!
:set lcs=tab:\|\ 

" HIGHLIY Experimental

nnoremap <silent> <F8> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F8> :<C-u>call SaveAndExecutePython()<CR>

" https://stackoverflow.com/questions/18948491/running-python-code-in-vim
function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    " setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
    if (line('$') == 1 && getline(1) == '')
      q!
    endif
    silent execute 'wincmd p'
endfunction
