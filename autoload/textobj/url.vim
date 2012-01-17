let s:url_chars = join(
\ range(48,57)+range(65,90)+range(97,122)
\+split('_:/.-+%#?&=;@$,[]!''()*~,', '\zs'), ',')

function! textobj#url#select_a()
  if empty(getline('.'))
    return 0
  endif
  try
    let old_iskeyword = &iskeyword
    let &iskeyword = s:url_chars
	call search('\>', 'bcW')
    let head_pos = getpos('.')
	call search('.\<', 'cW')
    let tail_pos = getpos('.')
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
	call search('\>', 'bcW')
    let head_pos = getpos('.')
	call search('.\>', 'cw')
    let tail_pos = getpos('.')
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
