
"The Nvim config file is named "init.vim", located at:              
"            Unix            ~/.config/nvim/init.vim
"            Windows         ~/AppData/Local/nvim/init.vim            
"    Or if $XDG_CONFIG_HOME is defined:                                   
"                            $XDG_CONFIG_HOME/nvim/init.vim

"#0 Usefull commands
"#1 Controls
"#2 Base Settings #3 File Settings #4 Aditional / Modified functions
"#5 Visual Stiling

""#0"""""""""""""""""" Usefull commands """"""""""""""""""""
" 
" 
" -------- Test file model: testfile.nvimdec ---------
" here is first
" here is second
" h3re is third
" Here is fourth
" here_is_fifth
" ----------------------------------------------------

""#1"""""""""""""""""" Controls """"""""""""""""""""
" vim -x <file_name> - to encript file with vimcript (not working in neovim)
" :Config - open configuration file (in read-only in separate tab)
" (SW :SS Done)Ctrl-k - to save vim session
"
" <F1> to open help in NETRW
" gn - use this directoy as main directory                - - to go up one directory
" d - make a directory                                    D/r_click - delete with confirmation 
" % - make a new file                                     R - to rename a file

" zf#j - creates a fold from the cursor down # lines      za - to toggle the fold
" zE - to erase all folds
" zM - to close all folds                                 zR - to open all folds
" #gt - to jump to the #th tab
" gf - go to file path in another tab
" >#[down/up] - add indent to # number of lines down/up (< to remove indent)
" * - search up word under cursor                       # - search down word under cursor
" ~ - switch letter case
" A - insert at end of line

" u - to undo change                                      Ctrl-R - to redo change
" (SW Ctrl-h,j,k,l Done)Ctrl-up,down,left,right - to move text around
" (ADD H,J,K,L - fast(10x) move Done)
" Ctrl-p - to paste text under current line

" Ctrl-w+v - vertical window split                        Ctrl-w+s - Horizontal window split
" Ctrl-w+w - Switch to next window

" (SW Ctrl-e Done)Ctrl-s - to open the terminal                           Ctrl-x - to close the terminal

" (SW Ctrl-i ? Done)Alt-r - To open replace command (with confirmation by default)
" (SW s Done)Alt-c - To select current word (selects selection in Visual mode)

" (SW Ctrl-s Done)Alt-s - to set the string to grep (selects selection in Visual mode)
" (SW Ctrl-f Done)Alt-f - to set the files to grep
" (SW Ctrl-g Done)Alt-_ - to search with vimgrep and display the results in split window
" (RM Done)Alt-d - to display git diff in window
" Ctrl-d - to toggle diffmode (you need to have two windows open)
" 
" (ADD Ctrl-[enter ?] - in netrw to open file in split window after closing all others)
" 
" Ctrl-z, bg and fg are for suspending applications in the terminal

" :mks - to make a session (add ! to overwrite last one)  vim -S sessionfile - to open the saved session
" :e - to reload a file buffer if edited outside of vim   :Lexplore - to do the same in NETRW  (! to force them of course)
" :bufdo e - to reload all buffers (not really recomended though)
" 
" Ctrl-v & Ctrl-q - Open Visual Block
" 
" q[letter] - to start recording macro                            q - to stop recording macro
" @[letter] - to run recorded macro
" 
" m[letter] - to make a bookmark on the [letter] key
" '[letter] - to jump to the [letter] bookmark
" 
" :Encript & :Decript - they do what they say
" :Reveal - open current file path in system file manager
" :Vex - to open netrw on file location in split window
" 
" Ctrl-y is free from what it seems
" Ctrl-f is free now too

""#2"""""""""""""""""" Base Settings """""""""""""""
:set sessionoptions+=buffers
:set autoread
:set number "relativenumber
:set incsearch
:set hlsearch
:set scrolloff=1
:let g:netrw_liststyle = 4
:let g:netrw_banner = 1
:set cursorline
:set foldenable
:set mouse=a
:set noequalalways
:se fdc=1
:syntax enable
:set sessionoptions+=localoptions
" Enable auto completion menu after pressing TAB.
set wildmenu
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

augroup remember_folds
  autocmd!
  "autocmd BufWinLeave *.* mkview
  autocmd BufLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview
augroup END
" Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

autocmd TermOpen * setlocal nonumber norelativenumber
""#3"""""""""""""" File Settings """"""""""""""""""""
if has("autocmd")
	autocmd BufNewFile,BufRead *.md set filetype=markdown
	autocmd FileType markdown setlocal spell spelllang=en_gb
endif
" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" GPG Encryption
" https://stackoverflow.com/a/31552829
" :terminal echo "<string_buffer_contents>" | gpg --output test.nvimenc --symmetric --cipher-algo AES256 --armor --no-symkey-cache
" :terminal gpg --decrypt test.nvimenc
let $enc_info = ''
"map <A-t> :let $ENCINF = enc_info<CR>:sp<CR>:terminal<CR>i<CR>echo $ENCINF<CR>
let g:comm = "terminal echo "
" Setting the info_string value
let g:comm .= "\"hey again there 2\"" 
let g:comm .= " | gpg --output " . expand("%:r") . ".nvimenc --symmetric --cipher-algo AES256 --armor --no-symkey-cache"
"map <A-t> :exe "sp"<CR>:exe comm<CR>

"gpg-agent --daemon     < for windows to work
"start gpg-agent --daemon     < for windows to work in background maybe and run the encryption after
"gpg --output .\data.nvimenc --symmetric --cipher-algo AES256 --armor --no-symkey-cache .\data.json
:command Encript :call EncFile()
"map <C-)> :call EncFile()<CR>
function! EncFile()
	let g:comm = "echo no_valid_input"
	if &filetype == 'netrw'
		let g:pathUnderCursor=netrw#Call('NetrwFile', netrw#Call('NetrwGetWord'))
		" Make the script take into account THE SPACEEEESSS in path
        	let g:comm = "terminal gpg --output " . fnameescape(g:pathUnderCursor) . ".nvimenc --symmetric --cipher-algo AES256 --armor --no-symkey-cache " . fnameescape(g:pathUnderCursor)
	else
		"still working on this" 
		"let g:comm = "terminal cat " . expand("%:p") ." | gpg --output " . expand("%:p") . ".nvimenc --symmetric --cipher-algo AES256 --armor --no-symkey-cache"
        	let g:comm = "terminal gpg --output " . fnameescape(expand("%:p")) . ".nvimenc --symmetric --cipher-algo AES256 --armor --no-symkey-cache " . fnameescape(expand("%:p"))
	endif 
	:exe "sp"
	:exe g:comm
endfunction

" gpg --output .\data.nvimdec --decrypt .\data.nvimenc
" (SW Ctrl-E)
:command Decript :call DecFile()
"map <C-(> :call DecFile()<CR>
function! DecFile()
	let g:comm = "echo no_valid_input"
	if &filetype == 'netrw'
		let g:pathUnderCursor=netrw#Call('NetrwFile', netrw#Call('NetrwGetWord'))
		let g:comm = "terminal gpg --output " . fnameescape(g:pathUnderCursor) . ".nvimdec --decrypt " . fnameescape(g:pathUnderCursor)
	else
		let g:comm = "echo can_only_decript_from_netrw"
	endif
	:exe "sp"
	:exe g:comm
endfunction

""#4""""""""""""" Aditional / Modified functions """

" To highlight text at specific positons:
" :call matchadd('LineHighlight', '\%'.line('.').'l'.'\%[number]v')
" https://neovim.io/doc/user/pattern.html

" define line highlight color
highlight LineHighlight ctermbg=darkgray guibg=darkgray
" highlight the current line
nnoremap <silent> <Leader>l :call matchadd('LineHighlight', '\%'.line('.').'l')<CR>
" clear all the highlighted lines
nnoremap <silent> <Leader>c :call clearmatches()<CR>

map <C-d> :call ToggleDiff()<CR>
function! ToggleDiff ()
    if (&diff)
        "set nodiff noscrollbind
	diffoff!
    else
        " enable diff options in both windows; balance the sizes, too
        wincmd =
        diffthis 
        wincmd w
        diffthis
        wincmd w
    endif
endfunction

" Replace selection (with confirmation)
map <C-i> :%s/<C-R>=@/<CR>/<C-R>=@/<CR>_/gc
" Select in normal mode (try to use expand("<cword>"))
:nmap s :<C-u>call <SID>VSetWordSearch()<Esc>/<C-R>=@/<CR><CR>:norm N<CR>
function! s:VSetWordSearch()
    let temp = @s
    "norm! gv"sy
    let @/ = expand("<cword>")
    let @s = temp
endfunction
" Select visual selection
:xnoremap s :<C-u>call <SID>VSetSearch()<Esc>/<C-R>=@/<CR><CR>:norm N<CR>
function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '' . substitute(escape(@s, '/\'), '\n', '\\n','g')
    let @s = temp
endfunction
":map <A-d> :sp<CR>:term git diff %<CR>i<CR>
:let g:srch_string = 'nothing'
:let g:srch_file = '**'
:xnoremap <C-s> :<C-u>call <SID>VSetString()<Esc>:let g:srch_string =@/<CR><CR>
nmap <C-s> :call SetString()<CR>
"nmap <C-f> :call SetFile()<CR>
nmap <C-g> :call VSSearch()<CR>
function! SetString()
    :let g:srch_string = input('srch_string: ')
endfunc
function! s:VSetString()
    let temp = @s
    norm! gv"sy
    let @/ = substitute(escape(@s, '/\'), '\n', '\\n','g')
    let @s = temp
endfunction
"function! SetFile()
"    :let g:srch_file = input('srch_file: ')
"endfunc
function! VSSearch()
    ":silent :exe 
    :execute 'vimgrep /'.g:srch_string.'/g '. "`find . \\( -path '**/.git' -o -path '**/vnv' -o -path '**/__pycache__' -o -path '**/env' -o -path '**/venv' -o -path '**/*.png' -o -path '**/*.jpg' -o -path '**/*.mp4' -o -path '**/*.mp3' -o -path '**/*.mkv' -o -path '**/*.webp' -o -path '**/*.webm' -o -path '**/*.jpeg' -o -path '**/*.JPG' -o -path '**/*.PNG' -o -path '**/*.torrent' -o -path '**/*.zip' -o -path '**/*.exe' -o -path '**/*.pdf' -o -path '**/*.rar' -o -path '**/*.db' -o -path '**/*.rpm' -o -path '**/*.deb' -o -path '**/*.download' -o -path '**/*.swp' -o -path '**/*.o' -o -path '**/*.obj' -o -path '**/*.so' \\) -prune -o -print` | copen"
endfunction

" Open current path in system filemanager

if has("win32") || has("win32unix")
	function! PathReveal()
		:echo "to test on win"
	endfunction
elseif has("macunix")
	function! PathReveal()
		:let $VIM_DIR= expand('%:p:h')
		":echo $VIM_DIR
		:silent :exe ":! open " . fnameescape($VIM_DIR)
	endfunction
else
	function! PathReveal()
		":exe ":let $VIM_DIR=expand('%:p:h'):sp:terminal i cd $VIM_DIR xdg-open ."
		:let $VIM_DIR= expand('%:p:h')
		":echo $VIM_DIR
		:silent :exe ":! xdg-open " . fnameescape($VIM_DIR)
		":let com = "terminal xdg-open " . fnameescape(expand('%:p:h'))
		":exe com
		":norm <CR>
	endfunction
endif
:command Reveal :call PathReveal()
"Close the terminal
:tnoremap <C-x> <C-\><C-n>:q!<CR>
"Exit terminal insert mode
:tnoremap <Esc> <C-\><C-n>
"Open a terminal
:set splitbelow
if has("win32") || has("win32unix")
	:set shell=C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
	:map <C-e> :let $VIM_DIR=expand('%:p:h')<CR>:sp<CR>:terminal<CR>i<CR>cmd.exe /k "C:/Program Files/Git/bin/bash.exe" --login<CR><C-\><C-n>:sleep 1<CR>i<CR>cd $VIM_DIR<CR>clear<CR>
else
	:map <C-e> :let $VIM_DIR=expand('%:p:h')<CR>:sp<CR>:terminal<CR>i<CR>cd $VIM_DIR<CR>clear<CR>
endif


let g:tmp = $MYVIMRC."temp"
:command Select :call SelectFile()
function! SelectFile()
  tabnew
  execute 'terminal fzf >'.g:tmp
  "let g:fname = readfile(tmp)[0]  " < move this in the autocmd & use same terminal config + others on the fzf one 
  "silent execute 'terminal rm '.tmp
  "execute 'vsplit '.fname
  autocmd TermClose * ++once call OpenFile()

endfunction

function! OpenFile()
	execute 'e '.readfile(g:tmp)[0]
	let aux = split(readfile(g:tmp)[0], "[.]")
	execute 'set filetype='.get(aux, len(aux)-1, 'txt')
endfunction


"Copy to system clipboard
:vmap <C-c> "+y
"Move Selection Left/Right
:vmap <C-h> xhPgvhoho
:vmap <C-l> xpgvlolo
"Move Line Up/Down
vnoremap <C-k>   :m '<-2<CR>gv=gv
vnoremap <C-j> :m '>+1<CR>gv=gv
" Fast move
map H 10h
map L 10l
map J 10j
map K 10k

"Paste below current line 
map <C-p> :call PutText()<CR> 
function! PutText()
	:set formatoptions-=c formatoptions-=r formatoptions-=o
	:exe ":norm o" . substitute(escape(@", '/\'), '\n\s\+', '\n','g')
	:set formatoptions+=c formatoptions+=r formatoptions+=o
endfunction

map <C-o> :call PutClipText()<CR>
function! PutClipText()
	:set formatoptions-=c formatoptions-=r formatoptions-=o
	:exe ":norm o" . substitute(escape(@*, '/\'), '\n\s\+', '\n','g')
	:set formatoptions+=c formatoptions+=r formatoptions+=o
endfunction
inoremap <CR> <CR>x<BS>
nnoremap o ox<BS>
nnoremap O Ox<BS>
function! OpenConfig()
  :tab sview $MYVIMRC
endfunction
:command Config :call OpenConfig() 
function! SourceIfExists()
  if argc() == 0 && filereadable('./Session.vim')
    :exe 'source ./Session.vim'
  elseif argc() == 0
    :e .
  endif
endfunction
autocmd! VimEnter * call SourceIfExists()
function SaveSession()
    norm 1gt
    "echo &filetype
    if &filetype == 'netrw'
        :e .
	:set bl
    endif
    :mks!
endfunction
:command SS :call SaveSession()
":map <C-m> :call SaveSession()<CR>
function! Create()
  :norm %
  :w
  Rex
  redraw!
endf
 
au FileType netrw au BufEnter <buffer> :0
autocmd filetype netrw call Netrw_mappings()
function! Netrw_mappings()
  noremap <buffer>_ :call Create()<cr>
  nmap <buffer> <RightMouse> t
endfunction

""#5""""""""""""""" Visual stiling """""""""""""""""
hi VertSplit	guifg=white gui=none ctermfg=white term=none cterm=none
hi FoldColumn	guifg=white guibg=NONE ctermbg=NONE ctermfg=white cterm=bold term=bold
hi Folded	guifg=white guibg=NONE ctermbg=NONE ctermfg=white cterm=none term=none
hi LineNr       ctermfg=LightBlue ctermbg=None
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END
hi iconcolor ctermfg=Black ctermbg=LightBlue 
hi nscolor ctermfg=Black ctermbg=White 
if exists("+showtabline")
     function MyTabLine()
         let s = '%#iconcolor# nVim '
         let t = tabpagenr()
         let i = 1
         while i <= tabpagenr('$')
             let buflist = tabpagebuflist(i)
             let winnr = tabpagewinnr(i)
             let s .= '%' . i . 'T'
             let s .= (i == t ? '%1*' : '%2*')
             let s .= (i == t ? ' %#TabLineSel#' : '%#nscolor# ')
             let s .= i . ' '
	     let s .= '%*'  
             let s .= (i == t ? '%#TabLineSel#' : '%#nscolor#')
             let file = bufname(buflist[winnr - 1])
             let file = fnamemodify(file, ':p:t')
             if file == ''
		 if has("win32") || has("win32unix")
		     let file_aux = bufname(buflist[winnr - 1])
             	     let file_aux = fnamemodify(file_aux, ':r')
		     let file_aux = split(file_aux, "[\\|/]")
		     let file = get(file_aux, len(file_aux)-1, '[netrw]') . "/"
		 else
		     let file_aux = bufname(buflist[winnr - 1])
             	     let file_aux = fnamemodify(file_aux, ':p')
		     for x in split(file_aux, "[\\|/]")[:-2]
			 let file .= x[0] . "/"
		     endfor
		     let file_aux = bufname(buflist[winnr - 1])
             	     let file_aux = fnamemodify(file_aux, ':t:r')
		     let file .= file_aux . "/"
             	 endif
	     endif
	     if ((strlen(s . file)-25*i-14) <= &columns) || (i < (t+2))
		     let s .= file . ' '
	     endif
             "let s .= file
             let s .= (i == t || i+1 == t ? '' : '│')
             let i = i + 1
         endwhile
	 let s .= '%T%#nscolor#%='
         "let s .= '%T%#TabLineFill#%='
         "let s .= (tabpagenr('$') > 1 ? "[" . tabpagenr('$') . " tabs]  " : "[1 tab]  ")
         return s
     endfunction
     set stal=2
     set tabline=%!MyTabLine()
endif
" Highlight current word
" Credit to Antoine Madec <aja.madec@gmail.com>
let g:cursorhold_updatetime = 1000
let g:fix_cursorhold_nvim_timer = -1
set eventignore+=CursorHold,CursorHoldI
augroup fix_cursorhold_nvim
  autocmd!
  autocmd CursorMoved * call CursorHoldTimer()
  autocmd CursorMovedI * call CursorHoldITimer()
augroup end
function CursorHold_Cb(timer_id) abort
  if v:exiting isnot v:null
    return
  endif
  set eventignore-=CursorHold
  doautocmd <nomodeline> CursorHold
  set eventignore+=CursorHold
endfunction
function CursorHoldI_Cb(timer_id) abort
  if v:exiting isnot v:null
    return
  endif
  set eventignore-=CursorHoldI
  doautocmd <nomodeline> CursorHoldI
  set eventignore+=CursorHoldI
endfunction
function CursorHoldTimer() abort
  call timer_stop(g:fix_cursorhold_nvim_timer)
  if mode() == 'n'
    let g:fix_cursorhold_nvim_timer = timer_start(g:cursorhold_updatetime, 'CursorHold_Cb')
  endif
endfunction
function CursorHoldITimer() abort
  call timer_stop(g:fix_cursorhold_nvim_timer)
  let g:fix_cursorhold_nvim_timer = timer_start(g:cursorhold_updatetime, 'CursorHoldI_Cb')
endfunction
function! HighlightWordUnderCursor()
    if getline(".")[col(".")-1] !~# '[[:punct:][:blank:]]' && -1 == stridx(@/, expand("<cword>")) && -1 == stridx(expand("<cword>"), @/)
	hi MatchWord cterm=underline gui=underline
        exec 'match' 'MatchWord' '/\V\<'.expand("<cword>").'\>/' 
    else 
        match none 
    endif
endfunction
autocmd! CursorHold,CursorHoldI * call HighlightWordUnderCursor()
" End Highlight current word
" first, enable status line always
set laststatus=2
" now set it up to change the status line based on mode
hi StatColor ctermfg=Black ctermbg=LightBlue
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black
highlight CursorLineNr ctermfg=Black ctermbg=LightBlue
function! MyStatusLine(mode)
    let statusline=""
    if a:mode == 'Enter'
        let statusline.="%#StatColor#"
    endif
    let file = expand("%:p")
    let statusline.="\(0x%B\)\ " . (file == '' || winnr('$') > 1 ? "%f" : file) . "\ "
    
    if a:mode == 'Enter'
        let statusline.="%*"
    endif
    let statusline.="%#Modified#%m"
    if a:mode == 'Leave'
        let statusline.="%*%r"
    elseif a:mode == 'Enter'
        let statusline.="%r%*"
    endif
    let statusline .= "%#nscolor#"
    let statusline .= "\ (%l/%L,\ %c)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ "
    return statusline
endfunction
au CursorMoved * setlocal statusline=%!MyStatusLine('Enter')
au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
au WinLeave * setlocal statusline=%!MyStatusLine('Leave')
set statusline=%!MyStatusLine('Enter')
function! SetCursorLineNrColorInsert()
    hi StatColor ctermfg=Black ctermbg=Red
    hi iconcolor ctermfg=Black ctermbg=Red
    highlight CursorLineNr ctermfg=Black ctermbg=Red 
    hi LineNr       ctermfg=Red ctermbg=None
endfunction
function! SetCursorLineNrColorVisual()
    let g:cursorhold_updatetime=10
    hi iconcolor ctermfg=Black ctermbg=Green
    hi StatColor ctermfg=Black ctermbg=Green
    hi LineNr       ctermfg=Green ctermbg=None
    highlight CursorLineNr ctermfg=Black ctermbg=Green 
endfunction
function! ResetCursorLineNrColor()
	if mode() == 'n'
    		let g:cursorhold_updatetime=1000
		hi iconcolor ctermfg=Black ctermbg=LightBlue
		highlight CursorLineNr ctermfg=Black ctermbg=LightBlue
		hi LineNr       ctermfg=LightBlue ctermbg=None
    		hi StatColor ctermfg=Black ctermbg=LightBlue
	endif
endfunction
nnoremap <silent> v :call SetCursorLineNrColorVisual()<CR>v
nnoremap <silent> V :call SetCursorLineNrColorVisual()<CR>V
nnoremap <silent> <C-v> :call SetCursorLineNrColorVisual()<CR><C-v>
xnoremap <silent> <Esc> :call ResetCursorLineNrColor()<CR><Esc>
augroup CursorLineNrColorSwap
    autocmd!
    autocmd InsertEnter * call SetCursorLineNrColorInsert()
    autocmd InsertLeave * call ResetCursorLineNrColor()
    autocmd CursorHold * call ResetCursorLineNrColor()
augroup END
