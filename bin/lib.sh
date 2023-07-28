# Useful functions
#!/bin/sh

EXIT_FAILURE=1
check(){
	local CMD="$1"
	command -v "${CMD}" &>/dev/null && printf "1" || printf "0"
}

debug(){
	local MSG="$1"
	if [[ ${DEBUG:-0} -gt 0 ]]
	then
		echo "${MSG}"
	fi
}
log(){
	local MSG="$1"
	echo "${MSG}"
}
perror(){
	local MSG="$1"
	echo "${MSG}" >&2
}

get_profile_file(){
	local platform=$1
	case "${PLATFORM}" in
		Darwin)
			printf ".zprofile"
			;;
		*)
			perror "Unsupported platform"
			exit $EXIT_FAILURE
			;;
	esac
	

}
get_rc_file(){
	local platform=$1
	case "${PLATFORM}" in
		Darwin)
			printf ".zshrc"
			;;
		*)
			perror "Unsupported platform"
			exit $EXIT_FAILURE
			;;
	esac
}

ensure_profile(){
	if [[ ! -f "~/${PROFILE_FILE}" ]]; then
		touch ~/"${PROFILE_FILE}"
	fi
}

profile_add(){
	local statement="$1"
	debug "profile add: ${statement}"

	ensure_profile
	if [[ "$(grep ${statement} ~/"${PROFILE_FILE}" && printf "1" || printf "0")" == "0" ]]; then
		debug "Adding '${statement}' to "${PROFILE_FILE}""
		echo "${statement}" >> ~/"${PROFILE_FILE}"
	else
		debug "statement already found in "${PROFILE_FILE}""
	fi	
}

ensure_rc(){
	if [[ ! -f "~/${RC_FILE}" ]]; then
		touch ~/"${RC_FILE}"
	fi
}

rc_add(){
	local statement="$1"
	debug "rc add: ${statement}"

	ensure_rc
	if [[ "$(grep "${statement}" ~/"${RC_FILE}" && printf "1" || printf "0")" == "0" ]]; then
		debug "Adding '${statement}' to "${RC_FILE}""
		echo "${statement}" >> ~/"${RC_FILE}"
	else
		debug "statement already found in "${RC_FILE}""
	fi	
}

if [[ ${DEBUG:-0} -gt 1 ]]; then
	set -x
fi
