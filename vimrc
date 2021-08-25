:set number relativenumber
:set smartindent
:set incsearch
:set hlsearch

:set scrolloff=5

:set splitbelow

:tnoremap <Esc> <C-\><C-n>:q!<CR>
:vnoremap <C-c> "+y
:noremap <silent> <C-Left> :vertical resize +3 <CR>
:noremap <silent> <C-Right> :vertical resize -3 <CR>
:noremap <silent> <C-Up> :resize -3 <CR>
:noremap <silent> <C-Down> :resize +3 <CR>

:se fdc=1

if exists("+showtabline")
     function MyTabLine()
         let s = ''
         let t = tabpagenr()
         let i = 1
         while i <= tabpagenr('$')
             let buflist = tabpagebuflist(i)
             let winnr = tabpagewinnr(i)
             let s .= '%' . i . 'T'
             let s .= (i == t ? '%1*' : '%2*')
             let s .= ' '
             let s .= i . ' ╠'
             let s .= ' %*'
             let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
             let file = bufname(buflist[winnr - 1])
             let file = fnamemodify(file, ':p:t')
             if file == ''
                 let file = '[No Name]'
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

augroup remember_folds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END

if has("autocmd")
	autocmd BufNewFile,BufRead *.md set filetype=markdown
	autocmd FileType markdown setlocal spell spelllang=en_gb
endif
