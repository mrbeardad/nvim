# Keymaps

- [Keymaps](#keymaps)
  - [Editor](#editor)
  - [Scroll](#scroll)
  - [Search](#search)
  - [Motion](#motion)
  - [Navigation](#navigation)
  - [Selection](#selection)
  - [Edit](#edit)
  - [Register](#register)
  - [Language](#language)
  - [Misc](#misc)

## Editor

| Neovim Keys | VSCode Keys        | Mode       | Description            |
| ----------- | ------------------ | ---------- | ---------------------- |
| `Space e`   | `Ctrl`+`Shift`+`E` | **N**      | Open or focus explorer |
| `[[`        |                    | _Explorer_ | Parent                 |
| `j`         | `j`                | _Explorer_ | Up                     |
| `k`         | `k`                | _Explorer_ | Down                   |
| `h`         | `h`                | _Explorer_ | Collapse               |
| `l`         | `l`                | _Explorer_ | Expand or open         |
| `o`         |                    | _Explorer_ | Open by system         |
| `a`         | `a`                | _Explorer_ | Add new file           |
| `A`         | `A`                | _Explorer_ | Add new directory      |
| `r`         | `r`                | _Explorer_ | Rename                 |
| `x`         | `x`                | _Explorer_ | Cut                    |
| `d`         | `d`                | _Explorer_ | Delete                 |
| `y`         | `y`                | _Explorer_ | Copy                   |
| `p`         | `p`                | _Explorer_ | Paste                  |

| Neovim Keys    | VSCode Keys  | Mode  | Description   |
| -------------- | ------------ | ----- | ------------- |
| `H`            | `H`          | **N** | Previous file |
| `L`            | `L`          | **N** | Next file     |
| `Space Tab`    | `Ctrl`+`Tab` | **N** | Switch file   |
| `` Space `  `` | -            | **N** | Pick file     |
| `Ctrl`+`S`     | `Ctrl`+`S`   | **N** | Save file     |
| `Space bd`     | `Ctrl+W` `q` | **N** | Close file    |

| Neovim Keys    | VSCode Keys    | Mode  | Description                                 |
| -------------- | -------------- | ----- | ------------------------------------------- |
| `Tab`          | `Tab`          | **N** | Next window                                 |
| `Shift`+`Tab`  | `Shift`+`Tab`  | **N** | Previous window                             |
| `Ctrl`+`W` `s` | `Ctrl`+`W` `s` | **N** | Horizontal split window                     |
| `Ctrl`+`W` `v` | `Ctrl`+`W` `v` | **N** | Vertical split window                       |
| `Ctrl`+`W` `=` | `Ctrl`+`W` `=` | **N** | Resize windows                              |
| `Ctrl`+`W` `q` | `Ctrl`+`W` `q` | **N** | Close `{count}`-th windows, default current |

> Tips:
>
> 1. The `buffer` in Neovim is similar to the `editor` in VSCode.
> 2. The `window` in Neovim is similar to the `editor group` in VSCode.

## Scroll

| Neovim Keys | VSCode Keys | Mode        | Description                                      |
| ----------- | ----------- | ----------- | ------------------------------------------------ |
| `Ctrl`+`D`  | `Ctrl`+`D`  | **N** **V** | Scroll half a screen down                        |
| `Ctrl`+`U`  | `Ctrl`+`U`  | **N** **V** | Scroll half a screen up                          |
| `Ctrl`+`F`  | `Ctrl`+`F`  | **N** **V** | Scroll full screen down                          |
| `Ctrl`+`B`  | `Ctrl`+`B`  | **N** **V** | Scroll full screen up                            |
| `zz`        | `zz`        | **N** **V** | Scroll to leave current line at center of screen |
| `zt`        | `zt`        | **N** **V** | Scroll to leave current line at top of screen    |
| `zb`        | `zb`        | **N** **V** | Scroll to leave current line at bottom of screen |
| `zh`        | `zh`        | **N** **V** | Scroll left                                      |
| `zl`        | `zl`        | **N** **V** | Scroll right                                     |
| `zH`        | -           | **N** **V** | Scroll half a screen left                        |
| `zL`        | -           | **N** **V** | Scroll half a screen right                       |
| `zs`        | -           | **N** **V** | Scroll to leave current column at left of screen |
| `gg`        | `gg`        | **N** **V** | Go to first line                                 |
| `G`         | `G`         | **N** **V** | Go to `{count}`-th line , default last line      |

<!-- TODO: 条件独立事件与制表 -->
<!-- TODO: 分支的处理，用if-else还是return短路 -->
<!-- TODO: multi cursor visual A -->
<!-- TODO: vscode xmap c for <c-v> mode -->
<!-- TODO: highlight theme for vscode-plugin nvim-plugin pwsh-highlight -->
<!-- TODO: 间隔-1、距离、数量+1 -->
<!-- HACK: In most of terminals, <C-S-*> and <C-*> have the same key sequence.
-- To distinguish them, map ctrl+shift+* to send <C-S-*> key sequence in your terminal setting.
-- Detail: https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/ -->

## Search

| Neovim Key | VSCode Key         | Mode        | Description                                                                   |
| ---------- | ------------------ | ----------- | ----------------------------------------------------------------------------- |
| `/`        | `/`                | **N** **V** | Search forward in file                                                        |
| `?`        | `?`                | **N** **V** | Search backward in file                                                       |
| `*`        | `*`                | **N** **V** | Search forward for the word nearest to the cursor in file (match whole word)  |
| `#`        | `#`                | **N** **V** | Search backward for the word nearest to the cursor in file (match whole word) |
| `g*`       | `g*`               | **N** **V** | Search forward for the word nearest to the cursor in file                     |
| `g#`       | `g#`               | **N** **V** | Search backward for the word nearest to the cursor in file                    |
| `n`        | `n`                | **N** **V** | Search forwar for last pattern in file                                        |
| `N`        | `N`                | **N** **V** | Search backward for last pattern in file                                      |
| `Space /`  | `Ctrl`+`Shift`+`F` | **N** **V** | Search in workspace                                                           |
| `Space sw` | -                  | **N** **V** | Search based on word in workspace                                             |
| `Space ff` | `Ctrl`+`P`         | **N**       | Search files in workspace                                                     |
| `Space fr` | `Ctrl`+`K` `R`     | **N**       | Search recently opened files                                                  |
| `Space sm` | Side Bar           | **N**       | Search marks                                                                  |
| `Space st` | Side Bar           | **N**       | Search todos                                                                  |
| `Space ss` | `Ctrl`+`Shift`+`O` | **N**       | Search symbols in file                                                        |
| `Space sS` | `Ctrl`+`T`         | **N**       | Search symbols in workspace                                                   |
| `gd`       | `gd`               | **N**       | Go to definition                                                              |
| `gt`       | `gt`               | **N**       | Go to type definition                                                         |
| `gr`       | `gr`               | **N**       | Go to reference                                                               |
| `gi`       | `gi`               | **N**       | Go to implementation                                                          |

> Tips:
>
> 1. For details of vim regular expression, see [`:h pattern`](https://neovim.io/doc/user/pattern.html#search-pattern)
> 2. For fzf fuzzy search syntax, see [`:h telescope-fzf-native.nvim`](https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-fzf-nativenvim)
> 3. In neovim, if the root workspace of the buffer is not detected, search in the current working directory instead.

## Motion

| Key              | Mode        | Description                                   |
| ---------------- | ----------- | --------------------------------------------- |
| `h`              | **N** **V** | Move Left                                     |
| `l`              | **N** **V** | Move Right                                    |
| `j`              | **N** **V** | Move Up                                       |
| `k`              | **N** **V** | Move Down                                     |
| `w`              | **N** **V** | Move to the next start of word                |
| `b`              | **N** **V** | Move to the previous start of word            |
| `e`              | **N** **V** | Move to the next end of word                  |
| `ge`             | **N** **V** | Move to the previous end of word              |
| `0`              | **N** **V** | Move to the start of the line                 |
| `$`              | **N** **V** | Move to the end of the line                   |
| `f` `{char}`     | **N** **V** | Jump to the next position of `{char}`         |
| `F` `{char}`     | **N** **V** | Jump to the previous position of `{char}`     |
| `t` `{char}`     | **N** **V** | Jump to the next position before `{char}`     |
| `T` `{char}`     | **N** **V** | Jump to the previous position before `{char}` |
| `;`              | **N** **V** | Repeat last `f` `F` `t` `T`                   |
| `,`              | **N** **V** | Repeat last `f` `F` `t` `T`                   |
| `m` `{mark}`     | **N**       | Set mark at cursor position                   |
| `` ` `` `{mark}` | **N**       | Jump to mark                                  |
| `Ctrl`+`O`       | **N**       | Go to older cursor position in jump list      |
| `Ctrl`+`I`       | **N**       | Go to newer cursor position in jump list      |
| `g;`             | **N**       | Go to older cursor position in change list    |
| `g,`             | **N**       | Go to newer cursor position in change list    |

> Tips:
>
> - **Jump** is command that normally moves the cursor several lines away.
>   If you make the cursor "jump", the position of the cursor before the jump is remembered in jump list.
>   For details, see [`:h jump-motions`](https://neovim.io/doc/user/motion.html#jump-motions)

## Navigation

| Neovim Keys | VSCode Keys | Mode  | Description                        |
| ----------- | ----------- | ----- | ---------------------------------- |
| `]t`        | `]t`        | **N** | Go to next type definition         |
| `[t`        | `[t`        | **N** | Go to previous type definition     |
| `]f`        | `]f`        | **N** | Go to next function definition     |
| `[f`        | `[f`        | **N** | Go to previous function definition |
| `[[`        | `[[`        | **N** | Go to previous outter scope        |
| `]]`        | `]]`        | **N** | Go to next outter scope            |
| `]d`        | `]d`        | **N** | Go to next diagnostic              |
| `[d`        | `[d`        | **N** | Go to previous diagnostic          |
| `]e`        | `]e`        | **N** | Go to next error diagnostic        |
| `[e`        | `[e`        | **N** | Go to previous error diagnostic    |
| `]w`        | `]w`        | **N** | Go to next warning diagnostic      |
| `[w`        | `[w`        | **N** | Go to previous warning diagnostic  |
| `]c`        | `]c`        | **N** | Go to next change                  |
| `[c`        | `[c`        | **N** | Go to previous change              |

## Selection

| Text Object (omit `a`/`i`) | Description                             |
| -------------------------- | --------------------------------------- |
| `w`                        | word                                    |
| `W`                        | WORD                                    |
| `p`                        | Paragraph                               |
| `{` and `}`                | `{block}`                               |
| `[` and `]`                | `[block]`                               |
| `(` and `)`                | `(block)`                               |
| `<` and `>`                | `<block>`                               |
| `b`                        | `{block}` or `[block]` or `(block)`     |
| `'` and `'`                | `'quote'`                               |
| `"` and `"`                | `"quote"`                               |
| `` ` `` and `` ` ``        | `` `quote` ``                           |
| `q`                        | `'quote'` or `"quote"` or `` `quote` `` |
| `t`                        | `<tag> </tag>`                          |
| `[[:punct:][:digit:]]`     |                                         |
| `t`                        | Type                                    |
| `f`                        | Function                                |
| `a`                        | Argument                                |
| `o`                        | Block                                   |

| Visual Keys | Mode        | Description                                                               |
| ----------- | ----------- | ------------------------------------------------------------------------- |
| `v`         | **N** **V** | Start charwise visual, or expand selection                                |
| `V`         | **N** **V** | Start linewise visual, or shrink selection                                |
| `Ctrl`+`V`  | **N**       | Start blockwise visual                                                    |
| `{textobj}` | **V**       | Expand selection to fit outter text object, else move to next text object |

| `I` | **V** | Insert to start of selection on all lines |
| `A` | **V** | Insert to start of selection on all lines |
| `mc` | **N** **V** | Mulple cursor |

## Edit

> Tips:
>
> - Operator + `[count]` Motion = Do operator for all text from the start position to the end position
> - Operator + `[count]` + Text-Object = Do operator for all text in text object
> - `{Visual}` Operator = Do operator for visual selected text

| Operator | Mode        | Description           | Comment                                    |
| -------- | ----------- | --------------------- | ------------------------------------------ |
| `gu`     | **N** **V** | Make text lowercase   | `guu`=`0gu$`, shortcut `u` for visual mode |
| `gU`     | **N** **V** | Make text uppercase   | `gUU`=`0gU$`, shortcut `U` for visual mode |
| `g~`     | **N** **V** | Switch case of text   | `g~~`=`0g~$`, shortcut `~` for visual mode |
| `c`      | **N** **V** | Change text           | `cc`=`0c$`, `C`=`c$`, `s`=`cl`             |
| `d`      | **N** **V** | Delete text           | `dd`=`0v$d`, `D`=`d$`, `x`=`dl`, `X`=`dh`  |
| `y`      | **N** **V** | Yank (Copy) text      | `yy`=`0v$y`, `Y`=`y$`                      |
| `v`      | **N**       | Start charwise visual | `v$` will cover the EOL                    |

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

| Key               | Mode              | Description                                                                              | Comment    |
| ----------------- | ----------------- | ---------------------------------------------------------------------------------------- | ---------- |
| `Ctrl`+`I`        | **I**             | Toggle completion list                                                                   | Non-native |
| `Ctrl`+`N`        | **I**             | Select next item                                                                         | Non-native |
| `Ctrl`+`P`        | **I**             | Select previous item                                                                     | Non-native |
| `Tab`             | **I**             | Confirm selected item, or expand snippet, or jump to next snippet placeholder            | Non-native |
| `Shift`+`Tab`     | **I**             | Confirm selected item and replace exist content，or jump to previous snippet placeholder | Non-native |
| `K`               | **N**             | Hover infomation                                                                         | Non-native |
| `F2`              | **N**             | Rename symbol                                                                            | Non-native |
| `Ctrl`+`.`        | **N**             | Code Action                                                                              | Non-native |
| `Ctrl`+`/`        | **I** **N** **V** | Comment code                                                                             | Non-native |
| `Alt`+`Shift`+`F` | **I** **N** **V** | Format code                                                                              | Non-native |

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
