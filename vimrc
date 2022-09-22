" Commands:

" <F1> to open help in NETRW
" gn - use this directoy as main directory                - - to go up one directory
" d - make a directory                                    D/r_click - delete with confirmation 
" % - make a new file                                     R - to rename a file

" zf#j - creates a fold from the cursor down # lines      za - to toggle the fold
" #gt - to jump to the #th tab
" >#[down/up] - add indent to # number of lines down/up (< to remove indent)
" * - search down word under cursor                       # - search up word under cursor
" ~ - switch letter case
" A - insert at end of line

" u - to undo change                                      Ctrl-r - to redo change

" Ctrl-s - to open the terminal                           Ctrl-x - to close the terminal
" Ctrl-z, bg and fg are for suspending applications the terminal

" :mks - to make a session (add ! to ovwrwrite last one)  vim -S sessionfile - to open the saved session
" :e - to reload a file buffer if edited outside of vim   :Lexplore - to do the same in NETRW  (! to force them of course)
" :bufdo e - to reload all buffers (not really recomended though)

function! SourceIfExists()
  if argc() == 0 && filereadable('./Session.vim')
    exe 'source ./Session.vim'
  endif
endfunction

autocmd! VimEnter * call SourceIfExists()
:set sessionoptions+=buffers
:set autoread
:set number relativenumber
:set smartindent
:set incsearch
:set tabstop=4
:set hlsearch
:set scrolloff=5
:set splitright
:set splitbelow
:let g:netrw_liststyle = 3
:let g:netrw_banner = 0
:set cursorline
:set foldenable
:set mouse=a
:set noequalalways
"Terminal commands
:let g:terms = 0
function SaveSession()
    norm 1gt
    "echo &filetype
    if &filetype == 'netrw'
        :e .
	:set bl
    endif
    :mks!
endfunction
:map <C-k> :call SaveSession()<CR>
:tnoremap <C-x> <C-\><C-n>:q!<CR>:let g:terms = g:terms - 1<CR>
:map <C-s> :let $VIM_DIR=expand('%:p:h')<CR>:let g:terms = g:terms + 1<CR>:botright terminal<CR><C-w>10_<CR>cd $VIM_DIR<CR>clear<CR>
"Copy to system clipboard
" Linux
:vmap <C-c> :<Esc>`>a<CR><Esc>mx`<i<CR><Esc>my'xk$v'y!xclip -selection c<CR>u

:se fdc=1

""""""""""""""Tab Bar""""""""""""""""""""""""""""""""""""""""""
hi iconcolor ctermfg=Black ctermbg=LightGreen 
hi tabcolor ctermfg=DarkBlue ctermbg=LightGreen
hi nscolor ctermfg=Black ctermbg=DarkGray 
hi nsmun ctermfg=Black ctermbg=White
if exists("+showtabline")
     function MyTabLine()
         let s = '%#iconcolor# Vim '
         let t = tabpagenr()
         let i = 1
         while i <= tabpagenr('$')
             let buflist = tabpagebuflist(i)
             let winnr = tabpagewinnr(i)
             let s .= '%' . i . 'T'
             let s .= (i == t ? '%1*' : '%2*')
             let s .= (i == t ? ' %#TabLineSel#' : '%#nscolor#│')
             let s .= i . ' '
             let s .= '%*'
             let s .= (i == t ? '%#TabLineSel#' : '%#nscolor#')
             let file = bufname(buflist[winnr - 1])
             let file = fnamemodify(file, ':p:t')
             if file == ''
                 let file = '[???]'
             endif
             let s .= file
             let s .= ' '
             let i = i + 1
         endwhile
         let s .= '%T%#TabLineFill#%='
         let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
         return s
     endfunction
     set stal=2
     set tabline=%!MyTabLine()
endif

""""""""""""""Status line""""""""""""""""""""""""""""""""""""""""
" first, enable status line always
set laststatus=2

" now set it up to change the status line based on mode
hi StatColor ctermfg=DarkBlue ctermbg=LightBlue
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black

function! MyStatusLine(mode)
    let statusline=""
    if a:mode == 'Enter'
        let statusline.="%#StatColor#"
    endif
    let statusline.="\(0x%B\)\ %f\ "
    if a:mode == 'Enter'
        let statusline.="%*"
    endif
    let statusline.="%#Modified#%m"
    if a:mode == 'Leave'
        let statusline.="%*%r"
    elseif a:mode == 'Enter'
        let statusline.="%r%*"
    endif
    let statusline .= "\ (%l/%L,\ %c)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ "
    return statusline
endfunction

au CursorMoved * setlocal statusline=%!MyStatusLine('Enter')
au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
au WinLeave * setlocal statusline=%!MyStatusLine('Leave')
set statusline=%!MyStatusLine('Enter')

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi StatColor ctermfg=DarkRed ctermbg=LightRed
  elseif a:mode == 'r'
    hi StatColor ctermfg=DarkMagenta ctermbg=LightMagenta
  elseif a:mode == 'v'
    hi StatColor ctermfg=DarkYellow ctermbg=LightYellow
  else
    hi StatColor ctermfg=DarkBlue ctermbg=LightBlue
  endif
endfunction 

" with ModeChanged
au ModeChanged * call InsertStatuslineColor(mode())
" keep in case ModeChanged doesn't work fro some reason (vim version I think)
"au CursorMoved * call InsertStatuslineColor(mode())
"au InsertEnter * call InsertStatuslineColor(v:insertmode)

""""""""""""Specific File settings"""""""""""""""""""""""""""""""
augroup remember_folds
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview
augroup END

if has("autocmd")
	autocmd BufNewFile,BufRead *.md set filetype=markdown
	autocmd FileType markdown setlocal spell spelllang=en_gb
endif

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

""""""""""""""""""""""Saving session"""""""""""""""""""""""""""""""""

"""""""""""""""""""NETRW Settings"""""""""""""""""""""""""""""""""""""
function! Create()
  let l:filename = input("please enter filename: ")
  execute 'silent !touch ' . b:netrw_curdir.'/'.l:filename 
  Explore
  redraw!
endf

command! -nargs=? MyTerm execute 'term <args>' | let b:my_term = 1

autocmd filetype netrw call Netrw_mappings()
function! Netrw_mappings()
  noremap <buffer>% :call Create()<cr>
endfunction

""""""""""""""Split Window settings""""""""""""""""""""""""""""""""""
hi VertSplit	guifg=white gui=none ctermfg=white term=none cterm=none
hi FoldColumn	guifg=white guibg=NONE ctermbg=NONE ctermfg=white cterm=bold term=bold
hi Folded	guifg=white guibg=NONE ctermbg=NONE ctermfg=white cterm=none term=none

"let g:netrw_winsize = 85
autocmd! BufEnter * if &ft ==# 'help' | wincmd L | endif

augroup DimInactiveWindows
  au!
  au WinEnter * set cursorline
  au WinLeave * set nocursorline
augroup END
