# bashMarks
A shell script that allows you to bookmark and jump to commonly used directories.

*A more modern combination of pedramamini's [lazy-cd](https://github.com/pedramamini/lazy-cd) and huyng's [bashmarks](https://github.com/huyng/bashmarks).*

## Installation
 1. `wget https://raw.githubusercontent.com/EncryptedCurse/bashMarks/master/bashMarks.sh`
 2. `mkdir -p ~/.local/bin` (or an installation directory of your choice)
 3. `cp bashMarks.sh ~/.local/bin`
 4. Add the following line to `.bashrc`: `source ~/.local/bin/bashMarks.sh`

## Usage
A file named **.bmarks** will be created in your home directory. The name and path of your bookmark storage may be changed through the `BOOKMARKS_FILE` variable.

| command | alias | description |
|---------|-------|-------------|
|`save <name> [dir]`|`s`|save current directory|
|`jump <name>`|`j`|go to bookmark|
|`back`|`b`|go to last directory|
|`del [name]`|`d`|delete bookmark|
|`ren <old> <new>`|`r`|rename bookmark|
|`list [name]`|`l`|list all bookmarks|

<sup>also accessible using the `--help` or `-h` flag</sup> 

* By default, aliases are enabled for easier use; these may be modified or removed entirely.
* `save` can take an optional second parameter to bookmark directories outside of the current one.   
* `del` without any parameter will purge all bookmarks that point to nonexistent directories.
* `list` can take an optinal parameter to display a particular bookmark's associated directory.
* `save`, `jump`, `ren`, and `list` support tab completion.
