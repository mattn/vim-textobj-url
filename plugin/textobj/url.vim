if exists('g:loaded_textobj_url')
  finish
endif

call textobj#user#plugin('url', {
\      '-': {
\        'select-a': 'au', '*select-a-function*': 'textobj#url#select_a',
\        'select-i': 'iu', '*select-i-function*': 'textobj#url#select_i',
\      },
\    })

let g:loaded_textobj_url = 1
