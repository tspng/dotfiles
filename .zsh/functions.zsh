function append_path () {
    if [[ -d $1 ]] && path=($path $1)
}

function prepend_path () {
    if [[ -d $1 ]] && path=($1 $path)
}

function path_is_in_path () {
    if [[ -d $1 ]] && [[ "$path" == *" $1 "* ]]; then
        return 0  # True
    else
        return 1  # False
    fi
}
