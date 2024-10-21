# -----------------------------------------------------------------------------
# AI-powered Git Commit Function
# Based on Andrej Karpathy's code: 
# https://gist.github.com/karpathy/1dd0294ef9567971c1e4348a90d69285
#
# This function:
# 1) gets the current staged changed diff
# 2) sends them to an LLM to write the git commit message
# 3) allows you to easily accept, edit, re-write, regenerate, cancel
# But - just read and edit the code however you like
# the `llm` CLI util is awesome, can get it here: https://llm.datasette.io/en/stable/
# 
# To use this script, add the following line to your ~/.zshrc or ~/.bashrc:
# source /path/to/ai_git_commit.sh
# -----------------------------------------------------------------------------

gcm() {
    local use_conventional=true
    local llm_model=""

    # Parse command line options
    while getopts ":cm:" opt; do
        case ${opt} in
            c )
                use_conventional=false
                ;;
            m )
                llm_model=$OPTARG
                ;;
            \? )
                echo "Usage: gcm [-c] [-m model]"
                echo "  -c    Disable conventional commit format"
                echo "  -m    Specify the LLM model to use"
                return 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    # Check if there are any staged changes
    if [ -z "$(git diff --cached --name-only)" ]; then
        echo "No staged changes found. Please stage your changes before committing."
        return 1
    fi

    # Function to generate commit message
    generate_commit_message() {
        local format_instruction=""
        if $use_conventional; then
            format_instruction="1) Use conventional commit format, but without scopes"
        else
            format_instruction="1) Use a clear and concise format"
        fi

        local llm_command="llm"
        if [ -n "$llm_model" ]; then
            llm_command="llm -m $llm_model"
        fi

        git diff --cached | $llm_command "
Below is a diff of all staged changes, coming from the command:

\`\`\`
git diff --cached
\`\`\`

Create a concise and consistent git commit message for these changes, 
adhering to the following guidelines: 
1) $format_instruction 
2) Limit the subject line to about 75 characters 
3) Do not end the subject line with a period 
4) Only provide a single line subject message"
    }

    # Function to read user input compatibly with both Bash and Zsh
    read_input() {
        if [ -n "$ZSH_VERSION" ]; then
            echo -n "$1"
            read -r REPLY
        else
            read -p "$1" -r REPLY
        fi
    }

    # Main script
    echo "Generating AI-powered commit message..."
    commit_message=$(generate_commit_message)


    while true; do
        echo -e "\nProposed commit message:"
        echo "$commit_message"

        read_input "Do you want to (a)ccept, (e)dit, re-(w)rite, (r)egenerate, or (c)ancel? "
        choice=$REPLY

        case "$choice" in
            a|A )
                if git commit -m "$commit_message"; then
                    echo "Changes committed successfully!"
                    return 0
                else
                    echo "Commit failed. Please check your changes and try again."
                    return 1
                fi
                ;;
            e|E )
                # Create a temporary file
                temp_file=$(mktemp)
                trap "rm -f $temp_file" EXIT

                echo "$commit_message" > "$temp_file"
                original_content=$(cat "$temp_file")

                ${EDITOR:-nano} "$temp_file"

                edited_content=$(cat "$temp_file")

                if [ "$original_content" = "$edited_content" ]; then
                    echo "No changes made to the commit message."
                    continue
                fi

                commit_message="$edited_content"

                echo -e "\nEdited commit message:"
                echo "$commit_message"

                read_input "Do you want to commit with this message? (y/n) "
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    if git commit -m "$commit_message"; then
                        echo "Changes committed successfully with your edited message!"
                        return 0
                    else
                        echo "Commit failed. Please check your message and try again."
                        return 1
                    fi
                else
                    echo "Commit cancelled. Returning to main menu."
                    continue
                fi
                ;;
            w|W )
                read_input "Enter your commit message: "
                commit_message=$REPLY
                if [ -n "$commit_message" ] && git commit -m "$commit_message"; then
                    echo "Changes committed successfully with your message!"
                    return 0
                else
                    echo "Commit failed. Please check your message and try again."
                    return 1
                fi
                ;;
            r|R )
                echo "Regenerating commit message..."
                commit_message=$(generate_commit_message)
                ;;
            c|C )
                echo "Commit cancelled."
                return 1
                ;;
            * )
                echo "Invalid choice. Please try again."
                ;;
        esac
    done
}
