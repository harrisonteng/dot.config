" Additional filetypes by extention

if exists("did\_load\_filetypes")
  finish
endif

augroup markdown
  au! BufRead,BufNewFile *.mkd,*.markdown   setfiletype mkd
  au! BufRead,BufNewFile *.nse   setfiletype lua
augroup END
