# bashMarks
A shell script that allows you to bookmark and jump to commonly used directories.

*A modernized combination of pedramamini's [lazy-cd](https://github.com/pedramamini/lazy-cd) and huyng's [bashmarks](https://github.com/huyng/bashmarks).*

## Installation
 1. `wget https://raw.githubusercontent.com/EncryptedCurse/bashMarks/master/bashMarks.sh`
 2. `mkdir -p ~/.local/bin` (or an installation directory of your choice)
 3. `cp bashMarks.sh ~/.local/bin`
 4. Add the following line to `.bashrc`: `source ~/.local/bin/bashMarks.sh`

## Usage
A file named `.bmarks` will be created in your home directory. The name and path of your bookmark storage may be changed through the `FILE` variable at the top of the script.

| command | alias | description |
|---------|-------|-------------|
|`save <name>`|`s`|save current directory|
|`jump <name>`|`j`|go to bookmark|
|`del <name>`|`d`|delete bookmark|
|`ren <old> <new>`|`r`|rename bookmark|
|`list`|`l`|list all bookmarks|

By default, aliases are enabled for easier use. These may be modified or removed entirely at the end of the script.
