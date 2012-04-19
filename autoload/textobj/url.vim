let s:url_chars = join(
\ range(48,57)+range(65,90)+range(97,122)
\+split('_:/.-+%#?&=;@$,!''*~', '\zs'), ',')

function! s:extract_url(url)
  let mx = '\(http\|https\|ftp\)://\a[a-zA-Z0-9_-]*\(\.[a-zA-Z0-9][a-zA-Z0-9_-]*\)*\(:\d+\)\{0,1}\(/[a-zA-Z0-9_/.\-+%#?&=;@$,!''*~]*\)\{0,1}'
  let cpos = getpos('.')[2]
  let [mpos, mlen, spos] = [0, 0, 0]
  while 1
    let mpos = match(a:url, mx, spos)
    if mpos == -1
      break
    endif
    let mlen = len(matchstr(a:url[(mpos == 0 ? 0 : mpos-1):], mx))
    if mpos <= cpos && cpos <= mpos + mlen
      break
    endif
    let spos = mpos + mlen
  endwhile
  return [mpos, mlen]
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
    let [mpos, mlen] = s:extract_url(expand('<cword>'))
    if mpos == -1
      return 0
    endif
    let head_pos[2] += mpos
    let tail_pos[2] = head_pos[2] + mlen - 1
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
    let [mpos, mlen] = s:extract_url(expand('<cword>'))
    if mpos == -1
      return 0
    endif
    let head_pos[2] += mpos
    let tail_pos[2] = head_pos[2] + mlen - 1
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
