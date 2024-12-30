""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Simple codeql plugin for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"  This plugin aims to provide a simple command to jump back and forth to and
"  from a codeql list of results.
"
"  It creates the following maps, where @ represents a space and the script,
"  assumes that the cursor is over a codeql result with the format
"  `file://...` (e.g file:///home/jiaozi/linux/kernel/bpf/verifier.c:1:1:1:1)
"  
"  Ctrl-@ + k: Jumps to the file and line under the cursor
"  Ctrl-@ + l: Jumps back to the codeql results
"  Ctrl-@ + j: Create a vertical split with the current result
"  Ctrl-@ + h: Creates a horizontal split with the current result
"
"  PRs and bugfixes are welcome.
"
"  Juan Jose Lopez Jaimez thatjiaozi@ 12/2024
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("g:simple_codeql")
    finish
endif

let g:simple_codeql = 1
let g:last_pos = getpos('.')

function! ExtractInfo()
    echo "extract info"
    let fileLine = expand("<cfile>")
    if matchstr(fileLine, 'file://*') == ""
        let saved_pos_a = getpos("'a")
        let saved_b = @b
        execute "normal! ma"
        let res = search('file://', 'bW')
        if res == 0
            echo "Not a valid codeql result line?"
            return []
        endif
        execute "normal! vf \"by"
        execute "normal! `a"

        let fileLine = @b
        let @b = saved_b
        call setpos("'a", saved_pos_a)

        if matchstr(fileLine, "file://*") == ""
            echo "Not a valid codeql result line?"
            return []
        endif
    endif
    let fileLine = fileLine[7:]
    let fileLine = split(fileLine, ":")

    if len(fileLine) < 2 
        echo "Malformed codeql result line"
        return []
    endif
    return [fileLine[0], fileLine[1]]
endfunction

function! simple_codeql#Jump()

    let fileLine = ExtractInfo()
    if len(fileLine) != 2
        echo "could not extract info on codeql result"
        return
    endif

    let file = fileLine[0]
    let line = fileLine[1]

    let saved_A = getpos("'A")
    execute "normal! mA"
    let g:last_pos = getpos("'A")
    call setpos("'A", saved_A)

    execute "edit ".file
    execute "normal! ". line . "G"
endfunction

function! simple_codeql#OpenVertical()

    let fileLine = ExtractInfo()
    if len(fileLine) != 2
        echo "could not extract info on codeql result"
        return
    endif

    let file = fileLine[0]
    let line = fileLine[1]

    execute "vnew ".file
    execute "normal! ". line . "G"
endfunction

function! simple_codeql#OpenHorizontal()

    let fileLine = ExtractInfo()
    if len(fileLine) != 2
        echo "could not extract info on codeql result"
        return
    endif

    let file = fileLine[0]
    let line = fileLine[1]

    execute "split ".file
    execute "normal! ". line . "G"
endfunction


function! simple_codeql#Back()
    let saved_A = getpos("'A")
    call setpos("'A", g:last_pos)
    execute "normal! `A"
    call setpos("'A", saved_A)
endfunction

command! -nargs=0 CodeqlJmp call simple_codeql#Jump()
command! -nargs=0 CodeqlBack call simple_codeql#Back()
command! -nargs=0 CodeqlOpenVertical call simple_codeql#OpenVertical()
command! -nargs=0 CodeqlOpenHorizontal call simple_codeql#OpenHorizontal()

nmap <C-@>k :CodeqlJmp<Cr>
nmap <C-@>l :CodeqlBack<Cr>
nmap <C-@>j :CodeqlOpenVertical<Cr>
nmap <C-@>h :CodeqlOpenHorizontal<Cr>
