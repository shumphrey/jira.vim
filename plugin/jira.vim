if exists('g:loaded_fugitive_jira')
    finish
endif
let g:loaded_fugitive_jira = 1

function! s:SetUpMessage(filename) abort
    if a:filename !~# '\.git[\/].*MSG$'
        return
    endif
    let dir = exists('*FugitiveConfigGetRegexp') ? FugitiveGitDir() : FugitiveExtractGitDir(a:filename)
    " work out conditions to set the omnifunc
    if !empty(dir)
        setlocal omnifunc=jira#omnifunc#handler
    endif
endfunction

augroup my_jira
    autocmd!
    if exists('+omnifunc') && !empty(get(g:, 'jira_domain')) && empty(get(g:, 'jira_ignore_setup'))
        autocmd FileType gitcommit call s:SetUpMessage(expand('<afile>:p'))
        " Must be some way to set the filetype of the popup
        autocmd BufEnter *
            \ if expand('%') ==# '' && &previewwindow && pumvisible() && getbufvar('#', '&omnifunc') ==# 'jira#omnifunc#handler' |
            \    setlocal nolist filetype=confluencewiki |
            \ endif
        endif
augroup END
