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
  let mrufs = copy(ctrlp#mrufiles#list('raw'))
  let g4 = split(system('"$(dirname '.shellescape(s:self_path).')/../../g4opened"'), "\n")
  let current_file = expand('%:p:h')

python << EOF
import json
import vim
import re

mrufs = vim.eval('l:mrufs')
current_file = vim.eval('l:current_file')
goog = '/google/src/cloud'
regex = "^%s/.+?/(.+?)/.+$" % goog

current_proj = None
current_proj_match = re.match(regex, current_file)
if current_proj_match:
  current_proj = current_proj_match.group(1)
  
def accept(f):
  if 'blaze-out' in f:
    return False

  if current_proj: 
    file_match = re.match(regex,f)
    if file_match:
      if file_match.group(1) == current_proj:
        return True
      else:
        return False
  return True

g4 = vim.eval('l:g4')
mrufs = filter(accept, mrufs)
g4 = filter(lambda x: not(x in mrufs), g4)

ret = mrufs + g4
vim.command('let ret=%s' % json.dumps(ret))
EOF

  return ret 
endfunc

function! ctrlp#dwim#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#dwim#id()
  return s:id
endfunction
