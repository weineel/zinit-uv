# mkvenv - Create a Python virtual environment using uv and direnv
mkvenv() {
    # Help message
    local show_help() {
        cat << 'EOF'
Usage: mkvenv [OPTIONS] [PYTHON_VERSION]

Create a Python virtual environment using uv and direnv.

Options:
  -p, --python VERSION    Specify Python version (e.g., 3.11, 3.12, python3.10)
  -h, --help              Show this help message

Examples:
  mkvenv                  # Use default Python version
  mkvenv 3.11             # Use Python 3.11
  mkvenv -p 3.12          # Use Python 3.12
  mkvenv --python 3.10    # Use Python 3.10

EOF
    }

    # Parse arguments
    local python_version=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                return 0
                ;;
            -p|--python)
                python_version="$2"
                shift 2
                ;;
            -*)
                echo "Error: Unknown option $1"
                show_help
                return 1
                ;;
            *)
                python_version="$1"
                shift
                ;;
        esac
    done

    # Check if uv is installed
    if ! command -v uv &> /dev/null; then
        echo "Error: uv is not installed. Please install it first."
        echo "Visit: https://github.com/astral-sh/uv"
        return 1
    fi

    # Check if direnv is installed
    if ! command -v direnv &> /dev/null; then
        echo "Error: direnv is not installed. Please install it first."
        echo "Visit: https://direnv.net/"
        return 1
    fi

    # Prepare .envrc content
    local envrc_content
    if [ -n "$python_version" ]; then
        envrc_content="[ -d .venv ] || uv venv --python $python_version
source .venv/bin/activate
echo \"venv activated: \$(pwd)/.venv\"
"
    else
        envrc_content="[ -d .venv ] || uv venv
source .venv/bin/activate
echo \"venv activated: \$(pwd)/.venv\"
"
    fi

    # Create or overwrite .envrc
    if [ -f .envrc ]; then
        echo "Warning: .envrc already exists"
        echo "Current content:"
        cat .envrc
        echo ""
        read "response?Overwrite? (y/N): "
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Aborted."
            return 1
        fi
    fi

    echo "Creating .envrc..."
    echo "$envrc_content" > .envrc

    # Create virtual environment with uv
    if [ ! -d .venv ]; then
        local uv_cmd="uv venv"
        if [ -n "$python_version" ]; then
            uv_cmd="$uv_cmd --python $python_version"
            echo "Creating virtual environment with Python $python_version..."
        else
            echo "Creating virtual environment with default Python..."
        fi
        eval $uv_cmd || return 1
    else
        echo "Virtual environment .venv already exists, skipping creation."
    fi

    # Allow direnv
    echo "Allowing direnv..."
    direnv allow . || return 1

    echo "✓ Virtual environment created and direnv configured!"
    echo ""
    echo "Generated .envrc:"
    cat .envrc
    echo ""
    echo "The environment will be automatically activated when you cd into this directory."
}
