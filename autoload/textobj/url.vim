let s:url_chars = join(
\ range(48,57)+range(65,90)+range(97,122)
\+split('_:/.-+%#?&=;@$,!''*~,', '\zs'), ',')

function! s:check_url(url)
  return a:url =~ '^\(http\|https\|ftp\)://\a[a-zA-Z0-9_-]*\(\.[a-zA-Z0-9][a-zA-Z0-9_-]*\)*\(:\d+\)\{0,1}'
endfunction

function! textobj#url#select_a()
  if empty(getline('.'))
    return 0
  endif
  try
    let old_iskeyword = &iskeyword
    let &iskeyword = s:url_chars
    let head_pos = [0]+searchpos('\<', 'bcnW')+[0]
    let tail_pos = [0]+searchpos('.\<\|$', 'cnW')+[0]
    let !s:check_url(expand('<cword>'))
      return 0
    endif
  catch
  finally
    let &iskeyword = old_iskeyword
  endtry
  return ['v', head_pos, tail_pos]
endfunction

function! textobj#url#select_i()
  if empty(getline('.'))
    return 0
  endif
  try
    let old_iskeyword = &iskeyword
    let &iskeyword = s:url_chars
    let head_pos = [0]+searchpos('\<', 'bcnW')+[0]
    let tail_pos = [0]+searchpos('.\>', 'cnW')+[0]
    if !s:check_url(expand('<cword>'))
      return 0
    endif
    let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  catch
    let non_blank_char_exists_p = 0
  finally
    let &iskeyword = old_iskeyword
  endtry
  return
  \ non_blank_char_exists_p
  \ ? ['v', head_pos, tail_pos]
  \ : 0
endfunction
