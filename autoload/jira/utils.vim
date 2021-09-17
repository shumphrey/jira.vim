if exists('g:autoloaded_jira_vim_utils')
    finish
endif
let g:autoloaded_jira_vim_utils = 1

function! jira#utils#throw(string) abort
    let v:errmsg = 'Jira: '.a:string
    throw v:errmsg
endfunction
