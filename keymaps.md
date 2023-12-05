# Keymaps

- [Keymaps](#keymaps)
  - [Search](#search)
  - [Navigation](#navigation)
  - [Scroll](#scroll)
  - [Motion](#motion)
  - [Edit](#edit)
  - [Register](#register)
  - [Language](#language)
  - [File](#file)
  - [Misc](#misc)

## Search

<!-- HACK: In most of terminals, <C-S-*> and <C-*> have the same key sequence.
-- To distinguish them, map ctrl+shift+* to send <C-S-*> key sequence in your terminal setting.
-- Detail: https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/ -->

Use **Search** when the target position is unknown but the content there is known.

| Key                | Mode        | Description                                                           | Comment    |
| ------------------ | ----------- | --------------------------------------------------------------------- | ---------- |
| `/`                | **N** **V** | Search forward                                                        |            |
| `?`                | **N** **V** | Search backward                                                       |            |
| `*`                | **N** **V** | Search forward for the word nearest to the cursor (Match whole word)  |            |
| `#`                | **N** **V** | Search backward for the word nearest to the cursor (Match whole word) |            |
| `g*`               | **N** **V** | Search forward for the word nearest to the cursor                     |            |
| `g#`               | **N** **V** | Search backward for the word nearest to the cursor                    |            |
| `n`                | **N** **V** | Repeat last search in forward direction                               | Non-native |
| `N`                | **N** **V** | Repeat last search in backward direction                              | Non-native |
| `Ctrl`+`Shift`+`F` | **N** **V** | Search in workspace                                                   | Non-native |
| `Ctrl`+`Shift`+`O` | **N**       | Search symbols in file                                                | Non-native |
| `Ctrl`+`T`         | **N**       | Search symbols in workspace                                           | Non-native |
| `Ctrl`+`P`         | **N**       | Search files in workspace                                             | Non-native |
| `Ctrl`+`K` `R`     | **N**       | Search files that recently opened                                     | Non-native |
| `m/`               | **N**       | Search marks                                                          | Non-native |
| `Space` `t`        | **N**       | Search TODOs                                                          | Non-native |

> Tips:
>
> 1. For details of vim regular expression, see [`:h pattern`](https://neovim.io/doc/user/pattern.html#search-pattern)
> 2. For fzf fuzzy search syntax, see [`:h telescope-fzf-native.nvim`](https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-fzf-nativenvim)

## Navigation

Use **Navigation** when the location of your destination is unknown but its semantics is known.

| Key  | Mode        | Description                           | Comment    |
| ---- | ----------- | ------------------------------------- | ---------- |
| `gd` | **N**       | Go to definition                      | Non-native |
| `gt` | **N**       | Go to type definition                 | Non-native |
| `gr` | **N**       | Go to reference                       | Non-native |
| `gi` | **N**       | Go to implementation                  | Non-native |
| `[[` | **N** **V** | Go to previous start of scope         | Non-native |
| `]]` | **N** **V** | Go to next start of scope             | Non-native |
| `[m` | **N** **V** | Go to previous start of method        | Non-native |
| `]m` | **N** **V** | Go to next start of method            | Non-native |
| `]e` | **N**       | Go to next error, warning or info     | Non-native |
| `[e` | **N**       | Go to previous error, warning or info | Non-native |
| `]c` | **N**       | Go to next change                     | Non-native |
| `[c` | **N**       | Go to previous change                 | Non-native |

## Scroll

Use **Scroll** when the location of your destination is known but outside the screen.

| Key        | Mode        | Description                                      | Comment               |
| ---------- | ----------- | ------------------------------------------------ | --------------------- |
| `Ctrl`+`D` | **N** **V** | Scroll half a screen down                        |                       |
| `Ctrl`+`U` | **N** **V** | Scroll half a screen up                          |                       |
| `Ctrl`+`F` | **N** **V** | Scroll full screen down                          |                       |
| `Ctrl`+`B` | **N** **V** | Scroll full screen up                            |                       |
| `zz`       | **N** **V** | Scroll to leave current line at center of screen |                       |
| `zt`       | **N** **V** | Scroll to leave current line at top of screen    |                       |
| `zb`       | **N** **V** | Scroll to leave current line at bottom of screen |                       |
| `zh`       | **N** **V** | Scroll left                                      |                       |
| `zl`       | **N** **V** | Scroll right                                     |                       |
| `zH`       | **N** **V** | Scroll half a screen left                        | Unspported for VSCode |
| `zL`       | **N** **V** | Scroll half a screen right                       | Unspported for VSCode |
| `zs`       | **N** **V** | Scroll to leave current column at left of screen | Unspported for VSCode |

<!-- TODO: 条件独立事件与制表 -->
<!-- TODO: 分支的处理，用if-else还是return短路 -->
<!-- TODO: multi cursor visual A -->
<!-- TODO: vscode xmap c for <c-v> mode -->
<!-- TODO: highlight theme for vscode-plugin nvim-plugin pwsh-highlight -->
<!-- TODO: 间隔-1、距离、数量+1 -->

## Motion

Use **Motion** when your target location is known.

| Key          | Mode        | Description                                   | Comment                               |
| ------------ | ----------- | --------------------------------------------- | ------------------------------------- |
| `h`          | **N** **V** | Move Left                                     |                                       |
| `l`          | **N** **V** | Move Right                                    |                                       |
| `j`          | **N** **V** | Move Up                                       | `gj` for display lines                |
| `k`          | **N** **V** | Move Down                                     | `gk` for display lines                |
| `w`          | **N** **V** | Move to the next start of word                | `W` for WORD                          |
| `b`          | **N** **V** | Move to the previous start of word            | `B` for WORD                          |
| `e`          | **N** **V** | Move to the next end of word                  | `E` for WORD                          |
| `0`          | **N** **V** | Move to the start of the line                 | `g0` for display lines                |
| `$`          | **N** **V** | Move to the end of the line                   | `g$` for display lines                |
| `f` `{char}` | **N** **V** | Jump to the next position of `{char}`         | Non-native                            |
| `F` `{char}` | **N** **V** | Jump to the previous position of `{char}`     | Non-native                            |
| `t` `{char}` | **N** **V** | Jump to the next position before `{char}`     | Non-native                            |
| `T` `{char}` | **N** **V** | Jump to the previous position before `{char}` | Non-native                            |
| `;`          | **N** **V** | Repeat last `f` `F` `t` `T`                   | Non-native                            |
| `,`          | **N** **V** | Repeat last `f` `F` `t` `T`                   | Non-native                            |
| `%`          | **N** **V** | Jump to matching word                         | Non-native                            |
| `[%`         | **N** **V** | Jump to previous outter open word             | Non-native                            |
| `]%`         | **N** **V** | Jump to next outter close word                | Non-native                            |
| `{`          | **N** **V** | Jump to previous empty line                   |                                       |
| `}`          | **N** **V** | Jump to next empty line                       |                                       |
| `gg`         | **N** **V** | Jump to first line of file                    |                                       |
| `G`          | **N** **V** | Jump to last line of file                     |                                       |
| `{num}` `G`  | **N** **V** | Jump to the `{num}`-th line of file           |                                       |
| `m` `{mark}` | **N**       | Set mark at cursor position                   | `[a-z]` for local, `[A-Z]` for global |
| `'` `{mark}` | **N**       | Jump to mark                                  | Non-native, map to `g'`               |
| `Ctrl`+`O`   | **N**       | Go to older cursor position in jump list      | Not a motion command                  |
| `Ctrl`+`I`   | **N**       | Go to newer cursor position in jump list      | Not a motion command                  |
| `g;`         | **N**       | Go to older cursor position in change list    | Not a motion command                  |
| `g,`         | **N**       | Go to newer cursor position in change list    | Not a motion command                  |

> Tips:
>
> - **Jump** is command that normally moves the cursor several lines away.
>   If you make the cursor "jump", the position of the cursor before the jump is remembered in jump list.
>   For details, see [`:h jump-motions`](https://neovim.io/doc/user/motion.html#jump-motions)

## Edit

| Operator | Mode        | Description           | Comment                                    |
| -------- | ----------- | --------------------- | ------------------------------------------ |
| `gu`     | **N** **V** | Make text lowercase   | `guu`=`0gu$`, shortcut `u` for visual mode |
| `gU`     | **N** **V** | Make text uppercase   | `gUU`=`0gU$`, shortcut `U` for visual mode |
| `g~`     | **N** **V** | Switch case of text   | `g~~`=`0g~$`, shortcut `~` for visual mode |
| `d`      | **N** **V** | Delete text           | `dd`=`0v$d`, `D`=`d$`, `x`=`dl`, `X`=`dh`  |
| `c`      | **N** **V** | Change text           | `cc`=`0c$`, `C`=`c$`, `s`=`cl`             |
| `y`      | **N** **V** | Yank (Copy) text      | `yy`=`0v$y`, `Y`=`y$`                      |
| `v`      | **N**       | Start charwise visual | `v$` will cover the EOL                    |

| Text Object         | Description                            | Comment    |
| ------------------- | -------------------------------------- | ---------- |
| `w`                 | word                                   |            |
| `W`                 | WORD                                   |            |
| `{` and `}`         | `{block}`                              |            |
| `[` and `]`         | `[block]`                              |            |
| `(` and `)`         | `(block)`                              |            |
| `<` and `>`         | `<block>`                              |            |
| `'` and `'`         | `'string'`                             |            |
| `"` and `"`         | `"string"`                             |            |
| `` ` `` and `` ` `` | `` `string` ``                         |            |
| `t`                 | `<tag>block</tag>`                     |            |
| `,`                 | Parameter, `param1, param2, ...`       | Non-native |
| `b`                 | Block scope, support many languages    | Non-native |
| `f`                 | Function scope, support many languages | Non-native |
| `c`                 | Class scope, support many languages    | Non-native |

> Tips:
>
> - `[count]` Operator + `[count]` Motion = Do operator for all text from the start position to the end position
> - Operator + `[a|i]` + Text-Object = Do operator for all text in text object, `a` for inclusive, `i` for exclusive
> - `{Visual}` Operator = Do operator for all visual selected text

| Normal Key                           | Mode                | Description                                              | Comment              |
| ------------------------------------ | ------------------- | -------------------------------------------------------- | -------------------- |
| `Esc`                                | **ALL**             | Return to normal mode                                    |                      |
| `ds` `{char}`                        | **N**               | Delete the surrounding pair `{char}`                     | Non-native           |
| `cs` `{char1}` `{char2}`             | **N**               | Change the surrounding pair `{char}` with `{char2}`      | Non-native           |
| `ys` `{text-obj or motion}` `{char}` | **N**               | Add surround around `{text-obj or motion}` with `{char}` | Non-native           |
| `S` `{char}`                         | **V**               | Add surround around visual selection with `{char}`       | Non-native           |
| `r` `{char}`                         | **N** **V**         | Replace the character under the cursor with `{char}`     |                      |
| `J`                                  | **N** **V**         | Join lines into one line                                 |                      |
| `<`                                  | **N** **V**         | Shift lines left                                         | Non-native           |
| `>`                                  | **N** **V**         | Shift lines right                                        | Non-native           |
| `Alt`+`J`                            | **I**, **N**, **V** | Move line Down                                           | Non-native           |
| `Alt`+`K`                            | **I**, **N**, **V** | Move line Up                                             | Non-native           |
| `.`                                  | **N**               | Repeat last change                                       |                      |
| `u`                                  | **N**               | Undo                                                     | Not a change command |
| `U`                                  | **N**               | Undo all latest changes on the line                      | As a change command  |
| `Ctrl`+`R`                           | **N**               | Redo                                                     | Not a change command |
| `Space` `u`                          | **N**               | Open undo history                                        | Non-native           |

| Visual Key | Mode        | Description                               | Comment                                                                                                                                                                          |
| ---------- | ----------- | ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `v`        | **N**       | Start charwise visual                     |                                                                                                                                                                                  |
| `V`        | **N**       | Start linewise visual                     |                                                                                                                                                                                  |
| `Ctrl`+`V` | **N**       | Start blockwise visual                    |                                                                                                                                                                                  |
| `v`        | **V**       | Smart expand selection range              |                                                                                                                                                                                  |
| `V`        | **V**       | Smart shrink selection range              |                                                                                                                                                                                  |
| `I`        | **V**       | Insert to start of selection on all lines | Non-native                                                                                                                                                                       |
| `A`        | **V**       | Insert to start of selection on all lines | Non-native                                                                                                                                                                       |
| `mc`       | **N** **V** | Mulple cursor                             | see [vscode-multi-cursor.nvim](https://github.com/vscode-neovim/vscode-multi-cursor.nvim) and [multiple-cursors.nvim](https://github.com/brenton-leighton/multiple-cursors.nvim) |

| Insert Key | Mode  | Description                                    | Comment    |
| ---------- | ----- | ---------------------------------------------- | ---------- |
| `i`        | **N** | Insert before the cursor                       |            |
| `a`        | **N** | Insert after the cursor                        |            |
| `I`        | **N** | Insert before the first non-blank in the line  |            |
| `A`        | **N** | Insert before the end of the line              |            |
| `o`        | **N** | Insert a new line below the cursor             |            |
| `O`        | **N** | Insert a new line above the cursor             |            |
| `Ctrl`+`O` | **I** | Execute one command then return to Insert mode |            |
| `Ctrl`+`H` | **I** | Move left                                      | Non-native |
| `Ctrl`+`L` | **I** | Move right                                     | Non-native |
| `Ctrl`+`A` | **I** | Move to the start of the line                  | Non-native |
| `Ctrl`+`E` | **I** | Move to the end of the line                    | Non-native |
| `Ctrl`+`W` | **I** | Delete left word                               |            |
| `Ctrl`+`U` | **I** | Delete all left                                |            |
| `Ctrl`+`K` | **I** | Delete all right                               | Non-native |
| `Ctrl`+`J` | **I** | New line                                       | Non-native |
| `Ctrl`+`Z` | **I** | Undo                                           | Non-native |

## Register

| Key                              | Mode        | Description                                              | Comment               |
| -------------------------------- | ----------- | -------------------------------------------------------- | --------------------- |
| `q` `{register}`                 | **N**       | Record typed characters into register, `q` again to stop |                       |
| `@` `{register}`                 | **N**       | Execute the contents of register                         |                       |
| `@@`                             | **N**       | Repeat Previous `@`                                      |                       |
| `Q`                              | **N**       | Repeat the last recorded register                        |                       |
| `"` `{register}` `{yank or put}` | **N** **V** | Use `{register}` to copy or paste                        |                       |
| `Ctrl`+`R` `{register}`          | **I**       | Paste text from `{register}`                             |                       |
| `y`                              | **N** **V** | Copy text                                                | `yy`=`0v$y`, `Y`=`y$` |
| `gy`                             | **N** **V** | Copy text to system clipboard                            | Non-native            |
| `zg`                             | **N**       | Copy last yanked text to clipboard                       | Non-native            |
| `p`                              | **N** **V** | Paste text after cursor                                  |                       |
| `P`                              | **N**       | Paste text before cursor                                 |                       |
| `zp`                             | **N** **V** | Paste last yanked text after cursor                      | Non-native            |
| `zP`                             | **N**       | Paste last yanked text before cursor                     | Non-native            |
| `zo`                             | **N**       | Paste last yanked text to new line cursor below          | Non-native            |
| `zO`                             | **N**       | Paste last yanked text to new line cursor above          | Non-native            |
| `gp`                             | **N** **V** | Paste text from clipboard after cursor                   | Non-native            |
| `gP`                             | **N**       | Paste text from clipboard before cursor                  | Non-native            |
| `go`                             | **N**       | Paste text from clipboard to new line cursor below       | Non-native            |
| `gO`                             | **N**       | Paste text from clipboard to new line cursor above       | Non-native            |
| `Ctrl`+`C`                       | **V**       | Copy to clipboard                                        | Non-native            |
| `Ctrl`+`V`                       | **I**       | Paste from clipboard                                     | Non-native            |
| `Space` `b` `y`                  | **N**       | Copy whole file text to clipboard                        | Non-native            |
| `Space` `b` `p`                  | **N**       | Paste text from clipboard to override whole file         | Non-native            |

> Tips
>
> - Commonly used registers:
>
>   1. `+`: system clipboard
>   2. `"`: laste delet, changed or copy
>   3. `0`: last copy
>   4. `1`: late delete longer than one line
>   5. `-`: last delete shorter than one line
>   6. `.`: last inserted text
>   7. `:`: last command line
>   8. `/`: last search pattern
>
> - Use `'[` to jump to the start of last changed or copied text.

## Language

| Key                | Mode              | Description                                                                              | Comment    |
| ------------------ | ----------------- | ---------------------------------------------------------------------------------------- | ---------- |
| `Ctrl`+`I`         | **I**             | Toggle completion list                                                                   | Non-native |
| `Ctrl`+`N`         | **I**             | Select next item                                                                         | Non-native |
| `Ctrl`+`P`         | **I**             | Select previous item                                                                     | Non-native |
| `Tab`              | **I**             | Confirm selected item, or expand snippet, or jump to next snippet placeholder            | Non-native |
| `Shift`+`Tab`      | **I**             | Confirm selected item and replace exist content，or jump to previous snippet placeholder | Non-native |
| `K`                | **N**             | Hover infomation                                                                         | Non-native |
| `F2`               | **N**             | Rename symbol                                                                            | Non-native |
| `Ctrl`+`.`         | **N**             | Code Action                                                                              | Non-native |
| `Ctrl`+`/`         | **I** **N** **V** | Comment code                                                                             | Non-native |
| `Alt`+`Shift`+`F`  | **I** **N** **V** | Format code                                                                              | Non-native |
| `Ctrl`+`Shift`+`M` | **N**             | Show diagnostic                                                                          | Non-native |
| `Space`+`E`        | **N**             | Show files and outlines                                                                  | Non-native |

## File

| Explorer Key | Description       | Comment                                                   |
| ------------ | ----------------- | --------------------------------------------------------- |
| `j`          | Up                | Non-native                                                |
| `k`          | Down              | Non-native                                                |
| `h`          | Collapse          | Non-native                                                |
| `l`          | Expand or select  | Non-native                                                |
| `a`          | Add new file      | Non-native, end with `/` or `\` means directory in Neovim |
| `A`          | Add new directory | Non-native                                                |
| `r`          | Rename            | Non-native                                                |
| `d`          | Delete            | Non-native                                                |
| `x`          | Cut               | Non-native                                                |
| `y`          | Copy              | Non-native                                                |
| `p`          | Paste             | Non-native                                                |

| Key                | Mode  | Description         | Comment                               |
| ------------------ | ----- | ------------------- | ------------------------------------- |
| `H`                | **N** | Go to previous file | Non-native                            |
| `L`                | **N** | Go to next file     | Non-native                            |
| `Space` `Tab`      | **N** | Switch file         | Non-native, `Ctrl`+`Tab` for VSCode   |
| `Ctrl`+`S`         | **N** | Save file           | Non-native                            |
| `Ctrl`+`Shift`+`S` | **N** | Save file as        | Non-native                            |
| `Space` `c`        | **N** | Close file          | Non-native, `Ctrl`+`W` `q` for VSCode |

| Key            | Mode  | Description                  | Comment                            |
| -------------- | ----- | ---------------------------- | ---------------------------------- |
| `Ctrl`+`W` `v` | **N** | Vertical split window        |                                    |
| `Ctrl`+`W` `s` | **N** | Horizontal split window      |                                    |
| `Ctrl`+`W` `=` | **N** | Resize windows               |                                    |
| `Tab`          | **N** | Go to next window            | Non-native                         |
| `Shift`+`Tab`  | **N** | Go to previous window        | Non-native                         |
| `Space` `q`    | **N** | Close current window or quit | Non-native, Not support for VSCode |

> Tips:
>
> 1. The `buffer` in Neovim is similar to the `editor` in VSCode.
> 2. The `window` in Neovim is similar to the `editor group` in VSCode.
> 3. In Neovim, buffer keymaps are prefix with `Space b`, search keymaps are prefix with `Space s`
> 4. In VSCode, press `Ctrl`+`1` to refocus editor when you lose it.

## Misc

| Key                | Mode  | Description                           | Comment    |
| ------------------ | ----- | ------------------------------------- | ---------- |
| `Ctrl`+`Shift`+`P` | **N** | Find somthing                         | Non-native |
| `Ctrl`+`Shift`+`U` | **N** | Show output                           | Non-native |
| `Ctrl`+`` ` ``     | **N** | Toggle terminal                       | Non-native |
| `Alt`+`Z`          | **N** | Toggle wrap                           | Non-native |
| `Alt`+`E`          | **N** | Open system explorer                  | Non-native |
| `Ctrl`+`A`         | **N** | Add to the number under cursor        |            |
| `Ctrl`+`X`         | **N** | Subtract from the number under cursor |            |
| `za`               | **N** | Toggle fold                           |            |
| `ga`               | **N** | Unicode point                         |            |
| `g8`               | **N** | utf-8 encoding                        |            |
