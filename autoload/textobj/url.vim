function! s:extract_url(line)
  let l:mx = '[a-z0-9]\+://'
  \ .. '[a-zA-Z0-9][a-zA-Z0-9_-]*'
  \ .. '\(\.[a-zA-Z0-9][a-zA-Z0-9_-]*\)*'
  \ .. '\(:\d\+\)\?'
  \ .. '\(/[a-zA-Z0-9_/.\-+%&=;@$,!''*~]*\)\?'
  \ .. '\(?[a-zA-Z0-9_/.\-+%?&=;@$,!''*~]*\)\?'
  \ .. '\(#[a-zA-Z0-9_/.\-+%#?&=;@$,!''*~]*\)\?'
  let l:pos1 = getpos('.')
  let l:pos2 = copy(l:pos1)
  let l:cpos = l:pos1[2]
  let [l:mops, l:mlen, l:spos] = [0, 0, 0]
  while 1
    let l:mops = match(a:line, l:mx, l:spos)
    if l:mops == -1
      throw "don't match"
    endif
    let l:mstr = matchstr(a:line[(l:mops == 0 ? 0 : l:mops-1):], l:mx)
    let l:mlen = len(l:mstr)
    if l:mstr =~ '[.,]$'
      let l:mlen -= 1
    endif
    if l:mops <= l:cpos && l:cpos <= l:mops + l:mlen
      break
    endif
    let l:spos = l:mops + l:mlen
  endwhile
  let l:pos1[2] = l:mops + 1
  let l:pos2[2] = l:mops + l:mlen
  return [l:pos1, l:pos2]
endfunction

function! textobj#url#select_a()
  try
    let l:line = getline('.')
    let [l:head_pos, l:tail_pos] = s:extract_url(l:line)
    if l:tail_pos[2] == len(l:line)
      let l:tail_pos[2] += 1
    endif
    return ['v', l:head_pos, l:tail_pos]
  catch
    return 0
  endtry
endfunction

function! textobj#url#select_i()
  try
    let l:line = getline('.')
    let [l:head_pos, l:tail_pos] = s:extract_url(l:line)
    let l:non_blank_char_exists_p = l:line[l:head_pos[2] - 1] !~# '\s'
    return l:non_blank_char_exists_p ? ['v', l:head_pos, l:tail_pos] : 0
  catch
    return 0
  endtry
endfunction
