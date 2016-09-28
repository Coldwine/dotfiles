scriptencoding utf-8

let g:neomake_open_list = 2
let g:neomake_error_sign = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '⚠', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_scss_enabled_makers = ['stylelint']

let g:neomake_scss_stylelint_maker = {
      \ 'errorformat':
      \ '%+P%f,' .
      \ '%*\s%l:%c %t %m,' .
      \ '%-Q'
      \ }
