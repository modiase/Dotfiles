 command claude $argv
9:        set api_key (security find-generic-password -w -s "anthropic-api-key" 2>/dev/null)
13:            echo 'security add-generic-password -a "$USER" -s "anthropic-api-key" -w "YOUR_API_KEY"' >&2
23:        set api_key (pass show anthropic-api-key 2>/dev/null)
25:            echo "Error: Gemini API key 'anthropic-api-key' not found in pass." >&2
27:            echo 'pass insert anthropic-api-key' >&2
34:    command claude $argv
