#!/bin/bash

# Shared notification hook that works with both Factory and Claude Code
# Sends desktop notifications when waiting for user input

# Detect which project directory variable is available
if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    PROJECT_DIR="$CLAUDE_PROJECT_DIR"
elif [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="$FACTORY_PROJECT_DIR"
else
    PROJECT_DIR=""  # No project directory
fi

# Read JSON from stdin
INPUT=$(cat)

# Extract notification type
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type' 2>/dev/null || echo "")
MESSAGE=$(echo "$INPUT" | jq -r '.message' 2>/dev/null || echo "")

# Function to send notification on macOS
send_macos_notification() {
    local title="$1"
    local message="$2"
    osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null || true
}

# Function to send notification on Linux
send_linux_notification() {
    local title="$1"
    local message="$2"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message" 2>/dev/null || true
    fi
}

# Detect OS and send notification
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    NOTIFICATION_FUNC="send_macos_notification"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    NOTIFICATION_FUNC="send_linux_notification"
else
    exit 0  # Unsupported OS
fi

# Send notification based on type
case "$NOTIFICATION_TYPE" in
    "permission_prompt")
        $NOTIFICATION_FUNC "Droid" "Permission required: ${MESSAGE:0:100}"
        ;;
    "idle_prompt")
        $NOTIFICATION_FUNC "Droid" "Awaiting your input"
        ;;
    "auth_success")
        $NOTIFICATION_FUNC "Droid" "Authentication successful"
        ;;
    *)
        # Generic notification
        $NOTIFICATION_FUNC "Droid" "Awaiting your input"
        ;;
esac

exit 0
