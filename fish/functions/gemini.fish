function gemini
    set -l api_key (vault kv get -field=api_key secret/gemini)
    if test $status -ne 0
        echo "Error retrieving Gemini API key from Vault." >&2
        return 1
    end
    GEMINI_API_KEY=$api_key command gemini $argv
end
