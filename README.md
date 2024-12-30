# simple-vim-codeql
 Simple codeql plugin for vim           

  This plugin aims to provide a simple command to jump back and forth to and
  from a codeql list of results.

  It creates the following maps, where @ represents a space and the script,
  assumes that the cursor is over a codeql result with the format
  `file://...` (e.g file:///home/jiaozi/linux/kernel/bpf/verifier.c:1:1:1:1)
  
  Ctrl-@ + k: Jumps to the file and line under the cursor
  Ctrl-@ + l: Jumps back to the codeql results
  Ctrl-@ + j: Create a vertical split with the current result
  Ctrl-@ + h: Creates a horizontal split with the current result

  PRs and bugfixes are welcome.

  Juan Jose Lopez Jaimez thatjiaozi@ 12/2024

