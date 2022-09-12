" Commands:
" gn - use this directoy as main directory              - - to go up one directory
" d - make a directory                                  D/r_click - delete with confirmation 
" zf#j - creates a fold from the cursor down # lines    za - to toggle the fold
" #gt - to jump to the #th tab
" Ctrl-x - to close terminal 
" >#[down/up] - add indent to # number of lines down/up (< to remove indent)
" * - search down word under cursor                     # - search up word under cursor
" ~ - switch letter case
" Ctrl-z, bg and fg are for suspending applications the terminal

:set autoread
:set number relativenumber
:set smartindent
:set incsearch
:set hlsearch
:set scrolloff=5
:set splitright
:set splitbelow
:let g:netrw_liststyle = 3
":let g:netrw_keepdir=-8
:set cursorline
:set foldenable
:set mouse=a
"Terminal commands
:let g:terms = 0
:tnoremap <C-x> <C-\><C-n>:q!<CR>:let g:terms = g:terms - 1<CR>
"function TR()
"  :let $VIM_DIR=expand('%:p:h')
"  :botright terminal
"  :normal \<C-w>10_<CR>cd $VIM_DIR<CR>clear<CR>
"  :let b:my_term = 1
"endf
":map <C-s> :call TR()<cr>

:map <C-s> :let $VIM_DIR=expand('%:p:h')<CR>:let g:terms = g:terms + 1<CR>:botright terminal<CR><C-w>10_<CR>cd $VIM_DIR<CR>clear<CR>
"Copy to system clipboard
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

" try with ModeChanged
au CursorMoved * call InsertStatuslineColor(mode())
au InsertEnter * call InsertStatuslineColor(v:insertmode)

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
"""""""""""""""""""NETRW Settings"""""""""""""""""""""""""""""""""""""
function! Create()
  let l:filename = input("please enter filename: ")
  execute 'silent !touch ' . b:netrw_curdir.'/'.l:filename 
  Explore
  redraw!
endf

command! -nargs=? MyTerm execute 'term <args>' | let b:my_term = 1

function! Open()
  "normal :silent on 
  ":execute "normal! \<C-w><l>"
  "let terms = filter(range(1, bufnr('$')),
  "    \ 'bufexists(v:val) && getbufvar(v:val, "my_term", 0)')
  echo g:terms
  "echo tabpagewinnr(tabpagenr(), '$')
  if tabpagewinnr(tabpagenr(), '$') - g:terms >= 2
    :silent 2q
  endif
  normal v
  "echo len(terms)
  "echo tabpagewinnr(tabpagenr(), '$') 
endf

autocmd filetype netrw call Netrw_mappings()
function! Netrw_mappings()
  noremap <buffer>% :call Create()<cr>
  noremap <buffer><space> :call Open()<cr>
  "noremap <buffer><space> <C-w><l> 
endfunction

"map <F6> :let $VIM_DIR=expand('%:p:h')<CR>:botright terminal<CR><C-w>10_<CR>cd $VIM_DIR<CR>clear<CR>

""""""""""""""Split Window settings""""""""""""""""""""""""""""""""""
hi VertSplit	guifg=white gui=none ctermfg=white term=none cterm=none
hi FoldColumn	guifg=white guibg=NONE ctermbg=NONE ctermfg=white cterm=bold term=bold
hi Folded	guifg=white guibg=NONE ctermbg=NONE ctermfg=white cterm=none term=none

let g:netrw_winsize = 85
autocmd! BufEnter * if &ft ==# 'help' | wincmd L | endif

augroup DimInactiveWindows
  au!
  au WinEnter * set cursorline
  au WinLeave * set nocursorline
augroup END
