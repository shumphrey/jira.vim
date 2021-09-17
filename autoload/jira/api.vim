if exists('g:autoloaded_jira_vim_api')
    finish
endif
let g:autoloaded_jira_vim_api = 1

function! s:url_encode(text) abort
    return substitute(a:text, '[?@=&<>%#/:+[:space:]]', '\=submatch(0)==" "?"+":printf("%%%02X", char2nr(submatch(0)))', 'g')
endfunction

" :call setreg('+', b:jira_last_curl)
function! jira#api#request(path, ...) abort
    let domain = get(b:, 'jira_domain', get(g:, 'jira_domain'))
    let root = get(b:, 'jira_api_path', get(g:, 'jira_api_path', '/rest/api/latest'))

    if empty(domain) || empty(root)
        call jira#utils#throw('Missing g:jira_domain config')
    endif

    if !executable('curl')
        call jira#utils#throw('curl is required for jira')
    endif

    let data = ['--silent', '-A', 'shumphrey/jira.vim']

    let url = domain . root . a:path

    call extend(data, [url])

    let options = join(map(copy(data), 'shellescape(v:val)'), ' ')
    let b:jira_last_curl = 'curl '.options
    silent let raw = system('curl '.options)
    let b:jira_last_raw = raw

    if !empty(v:shell_error)
        if !empty(b:jira_last_raw)
            echoerr b:jira_last_raw
        endif
        call jira#utils#throw('Error running curl command. See b:jira_last_curl')
    endif

    return json_decode(raw)
endfunction

" curl
" 'https://jira/rest/api/latest/search?fields=summary,project,issuetype,description,creator,created,assignee,components&jql=project=DEINFRA%20AND%20text%20~sounds&maxResults=1000'
function! jira#api#search(jql)
    try
        return jira#api#request('/search?fields=summary,project,issuetype,description,assignee,reporter,components&maxResults=1000&jql='.s:url_encode(a:jql))
    catch /^Jira:/
        echoerr v:errmsg
    endtry
    return []
endfunction
