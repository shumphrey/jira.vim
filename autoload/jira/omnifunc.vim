if exists('g:autoloaded_jira_vim_omnicomplete')
    finish
endif
let g:autoloaded_jira_vim_omnicomplete = 1

function! s:map_jira_issue(key, value)
    let info = a:value.fields.summary
    let info .= "\n\n" . substitute(a:value.fields.description, '^\s*', '', '')
    let info = substitute(info, "\r", '', 'g')
    return {
        \'word': a:value.key,
        \'abbr': a:value.key,
        \'menu': a:value.fields.summary[0:70],
        \'info': info,
    \}
endfunction

function s:sort_jira_issue(i1, i2) abort
    let one = split(a:i1.key, '-')
    let two = split(a:i2.key, '-')

    return str2nr(one[1]) >= str2nr(two[1]) ? -1 : 1
endfunction

function! jira#omnifunc#handler(findstart, base) abort
    if a:findstart
        let line = getline('.')[0:col('.')-1]

        let existing = matchstr(line, '[[:alnum:]]\+-[[:alnum:]]*\s*$')
        return col('.') - 1 - strlen(existing)
    endif

        let match = matchlist(a:base, '\([[:alnum:]]\+\)-\([[:alnum:]]*\)\s*$')
        if len(match) == 0
            return []
        endif

        let project = match[1]
        let search = match[2]
        let jql = 'statusCategory != done'
        if empty(search)
            let jql .= ' AND project=' . toupper(project)
        else
            let jql .= ' AND project=' . toupper(project) . ' AND text ~ ' . search
        endif
        echom 'jql='.jql
        let res = jira#api#search(jql)
        if !has_key(res, 'issues')
            return []
        endif
        return map(sort(res.issues, function('s:sort_jira_issue')), function('s:map_jira_issue'))
    return []

endfunction
