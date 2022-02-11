" Comment

:set number relativenumber
:set smartindent
:set incsearch
:set hlsearch
:set scrolloff=5
:set splitbelow
:let g:netrw_liststyle = 4

:tnoremap <Esc> <C-\><C-n>:q!<CR>
:vnoremap <C-c> "+y

:se fdc=1

""""""""""""""Tab Bar""""""""""""""""""""""""""""""""""""""""""
hi iconcolor ctermfg=Black ctermbg=LightGreen 
hi tabcolor ctermfg=DarkBlue ctermbg=LightGreen
hi nscolor ctermfg=Black ctermbg=DarkGray 
hi nsmun ctermfg=Black ctermbg=White
if exists("+showtabline")
     function MyTabLine()
         let s = '%#iconcolor#≡VIM≡'
         let t = tabpagenr()
         let i = 1
         while i <= tabpagenr('$')
             let buflist = tabpagebuflist(i)
             let winnr = tabpagewinnr(i)
             let s .= '%' . i . 'T'
             let s .= (i == t ? '%1*' : '%2*')
             let s .= (i == t ? '%#TabLineSel#' : '%#nsnum#')
             let s .= '¦'
             let s .= i . '¦'
             let s .= '%*'
             let s .= (i == t ? '%#TabLineSel#' : '%#nscolor#')
             "let s .= (i == t ? '%#tabcolor#' : '%#TabLine#')
             let file = bufname(buflist[winnr - 1])
             let file = fnamemodify(file, ':p:t')
             if file == ''
                 let file = '[netrw]'
             endif
             let s .= file
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
"if version >= 700
"  au InsertEnter * hi StatusLine ctermfg=DarkBlue ctermbg=LightBlue
"  au InsertLeave * hi StatusLine ctermfg=DarkRed ctermbg=LightRed
"endif

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
"au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black

""""""""""""Specific File settings"""""""""""""""""""""""""""""""
augroup remember_folds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
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
