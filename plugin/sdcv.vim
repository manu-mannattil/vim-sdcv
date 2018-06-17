" Vim plugin to search for word definitions using sdcv.
" Version: 0.1

if exists('g:sdcv_loaded') || !executable('sdcv') || &compatible || v:version < 700
  finish
endif
let g:sdcv_loaded = 1

" Search for the definition of word(s).
function! s:search(...)
  let cmd = 'sdcv --non-interactive'

  for word in a:000
    let cmd .= ' ' . shellescape(word)
  endfor

  if exists('g:sdcv_args')
    for arg in g:sdcv_args
      let cmd .= ' ' . shellescape(arg)
    endfor
  endif

  if exists('g:sdcv_filter')
    let cmd .= ' | ' . shellescape(g:sdcv_filter)
  endif
  let lines = split(system(cmd), '\n')

  " This will fail if there's already a (real) buffer called *sdcv*
  " opened (in which case that buffer will be wiped out).  This can be
  " fixed by iterating through different scratch buffer names until one
  " that doesn't cause any conflicts is found.  However, the resulting
  " complexity wouldn't be worth it since such conflicts arise rarely.
  if bufnr('\*sdcv\*') >= 0
    bwipeout \*sdcv\*
  endif
  split \*sdcv\*

  call append('$', lines)
  0delete _

  setlocal bufhidden=wipe
  setlocal buftype=nofile
  setlocal cursorline
  setlocal nobuflisted
  setlocal nolist
  setlocal nospell
  setlocal noswapfile
  setlocal nowrap
  setlocal tabstop=8
  setlocal keywordprg=:Sdcv
  setlocal nomodifiable

  nnoremap <buffer> <silent> q :bwipeout<cr>

  syntax match SdcvDict /^-->.*$/
  highlight default link SdcvDict Identifier

  syntax match SdcvPron  /^\[[^]]\+\]/
  highlight default link SdcvPron String
endfunction

function! s:complete(...)
  " 'spell' must be turned on for spellsuggest() to work.
  let spell_opt = &spell
  set spell

  " Get (< 10) spelling suggestions, restore state and return.
  let suggestions = spellsuggest(a:1, 10)
  let &spell = spell_opt
  return suggestions
endfunction

if exists('+syntax')
  command! -nargs=+ -complete=customlist,s:complete Sdcv silent call s:search(<f-args>)
else
  command! -nargs=+ Sdcv silent call s:search(<f-args>)
endif
