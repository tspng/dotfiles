# -----------------------------------------------------------------------------
# AI-powered Git Commit Function
# Based on Andrej Karpathy's code: 
# https://gist.github.com/karpathy/1dd0294ef9567971c1e4348a90d69285
#
# This function:
# 1) gets the current staged changed diff
# 2) sends them to an LLM to write the git commit message
# 3) allows you to easily accept, edit, re-write, regenerate, cancel
# Uses `llm` CLI tool to communicate with llm APIs (https://llm.datasette.io/)
# 
# To use this script, add the following line to your ~/.zshrc or ~/.bashrc:
# source /path/to/THIS_FILE.sh
# -----------------------------------------------------------------------------

gcm() {
    local use_conventional=true
    local verbose=false
    local llm_model=""

    # Parse command line options
    while getopts ":cvm:" opt; do
        case ${opt} in
            c )
                use_conventional=false
                ;;
            v )
                verbose=true
                ;;
            m )
                llm_model=$OPTARG
                ;;
            \? )
                echo "Usage: gcm [-c] [-m model]"
                echo "  -c    Disable conventional commit format"
                echo "  -v    Verbose mode"
                echo "  -m    Specify the LLM model to use"
                return 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    # Check for llm CLI tool availability
    if ! command -v llm &> /dev/null; then
        echo "Error: llm command not found. Please install it first (https://llm.datasette.io/)."
        return 1
    fi

    # Check if we are in a git repository
    if ! git rev-parse --is-inside-work-tree &> /dev/null; then
        echo "Error: Not in a git repository"
        return 1
    fi

    # Check if there are any staged changes
    if [ -z "$(git diff --cached --name-only)" ]; then
        echo "No staged changes found. Please stage your changes before committing."
        return 1
    fi

    # Function to generate commit message
    generate_commit_message() {
        local format_instruction=""
        if $use_conventional; then
            format_instruction="You must use the conventional commit format, but without scopes"
        else
            format_instruction="Use a clear and concise format, but do NOT use conventional commit format"
        fi

        local llm_command="llm"
        if [ -n "$llm_model" ]; then
            llm_command="llm -m $llm_model"
        fi

        # Get the last 5 commit messages for context
        local message_examples=$(git log --oneline -n 5 --no-decorate --no-merges --pretty=format:"%s")
        local prompt="
Below is a diff of all staged changes, coming from the command:

\`\`\`
git diff --cached
\`\`\`

Create a concise and consistent git commit message for these changes, 
adhering to the following guidelines: 
- $format_instruction 
- Limit the subject line to about 75 characters 
- Do not end the subject line with a period 
- Only provide a single line subject message
- Keep consistent tense and style

Here are the last 5 commit messages for context:
<COMMIT_MESSAGES>
$message_examples
</COMMIT_MESSAGES>
"

        if $verbose; then
            echo -e "\n===== PROMPT TO LLM =====\n"
            echo "$prompt"
            echo -e "\n=========================\n"
        fi

        git diff --cached | $llm_command "$prompt"
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

