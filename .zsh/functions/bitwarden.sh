# bitwarden session function
bwsession() {
  eval $(bw unlock | grep export | sed 's/^$ //')
}

bwsetenv() {
  eval $(bw get item $1 | jq -r '.notes')
}

bwsaveenv() {
  DEFAULT_FF=".env"
  FF=${2:-$DEFAULT_FF}
  tempfile=$(mktemp)
  cat ${FF} | awk '{print "export " $0}' >"${tempfile}"
  bw get template item | jq --arg a "$(cat ${tempfile})" --arg b "$1" '.type = 2 | .secureNote.type = 0 | .notes = $a | .name = $b' | bw encode | bw create item
  rm "${tempfile}"
}

alias bwlist="bw list items | jq '.[] | .name' | $GREP"
alias bwget="bw get item"
