if exists('g:loaded_ctrlp_dwim') && g:loaded_ctrlp_dwim
  finish
endif
let g:loaded_ctrlp_dwim = 1

let s:dwim_var = {
      \  'init':   'ctrlp#dwim#init()',
      \  'exit':   'ctrlp#dwim#exit()',
      \  'accept': 'ctrlp#acceptfile',
      \  'lname':  'dwim',
      \  'sname':  'dwim',
      \  'type':   'path',
      \  'sort':   0,
      \}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:dwim_var)
else
  let g:ctrlp_ext_vars = [s:dwim_var]
endif

let s:self_path = expand("<sfile>")

function! ctrlp#dwim#init()
  return split(system('"$(dirname '.shellescape(s:self_path).')/../../lib/dwim.sh"'), "\n")
endfunc

function! ctrlp#dwim#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#dwim#id()
  return s:id
endfunction
