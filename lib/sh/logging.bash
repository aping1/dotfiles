#!/bin/bash -n
# Bash functions for providing logging

[[ -n ${__BASH_HELPERS_LOGGING_LOADED} ]] && return 0
__BASH_HELPERS_LOGGING_LOADED=1

# shellcheck source=./gentoo-functions.bash
source "$(dirname "$(realpath "${BASH_SOURCE}")")/gentoo-functions.bash" || exit 1

__BASH_HELPERS_LOGGING_LEVEL=info
__BASH_HELPERS_LOGGING_OUTPUT_LEVEL=info
__BASH_HELPERS_LOGGING_FACILITY=user
__BASH_HELPERS_LOGGING_PROGNAME="$(basename "${0%.*sh}")"
__BASH_HELPERS_LOGGING_NO_SYSLOG=
__BASH_HELPERS_LOGGING_LOGFILE=

__bash_helpers_logging_level_value() {
	local funcname="${1}" level="${2,,*}" value

	case ${level} in
		emerg) value=0;;
		alert) value=1;;
		crit) value=2;;
		err|error) value=3;;
		warning|warn) value=4;;
		notice) value=5;;
		info) value=6;;
		debug) value=7;;
		*)
			printf -- "#### BUG ####: \"%s\" called with invalid level \"%s\"" "${funcname}" "${level}" >&2
			return 1
		;;
	esac
	printf -- "%s\n" "${value}"

	return 0
}

log_set_progname() {
	if [[ -n ${1} ]]; then
		__BASH_HELPERS_LOGGING_PROGNAME="${1// /_}"
	else
		return 1
	fi

	return 0
}

log_set_output_level() {
	if __bash_helpers_logging_level_value "${FUNCNAME}" "${1}" > /dev/null; then
		__BASH_HELPERS_LOGGING_OUTPUT_LEVEL="${1,,*}"
	else
		return 1
	fi

	return 0
}

log_set_log_level() {
	if __bash_helpers_logging_level_value "${FUNCNAME}" "${1}" > /dev/null; then
		__BASH_HELPERS_LOGGING_LEVEL="${1,,*}"
	else
		return 1
	fi

	return 0
}

log_set_log_file() {
	local path="${1}" realpath retval=0

	realpath="$(realpath -qm "${path}")"

	if [[ ! -d $(dirname "${realpath}") ]]; then
		printf -- "WARNING: Attempt to log to nonexistant path '%s'\n" "${path}" >&2
		__BASH_HELPERS_LOGGING_NO_SYSLOG=1
		retval=1

	elif ! touch "${realpath}"; then
		printf -- "WARNING: Could not create logfile at '%s'\n" "${realpath}" >&2
		__BASH_HELPERS_LOGGING_NO_SYSLOG=1
		retval=1
	else
		__BASH_HELPERS_LOGGING_LOGFILE="${realpath}"
	fi

	return "${retval}"
}

log_set_facility() {
	local facility="${1,,*}"

	case ${facility} in
		auth|security) ;;
		authpriv) ;;
		cron|daemon) ;;
		ftp|lpr|mail|news|syslog|user|uucp) ;;
		kern) ;;
		local[0-7]) ;;
		*)
			printf -- "#### BUG ####: \"%s\" called with invalid facility \"%s\"" "${FUNCNAME}" "${1}" >&2
			return 1
	esac

	__BASH_HELPERS_LOGGING_FACILITY="${facility}"

	return 0
}

__bash_helpers_logging_log_message() {
	local facility="${__BASH_HELPERS_LOGGING_FACILITY}"
	local progname="${__BASH_HELPERS_LOGGING_PROGNAME// /-}"
	local logfile="${__BASH_HELPERS_LOGGING_LOGFILE}"

	local level_value loglevel outlevel msg_header spaces indent

	level_value="$(__bash_helpers_logging_level_value "${FUNCNAME}" "${level}")"
	loglevel="$(__bash_helpers_logging_level_value "${FUNCNAME}" "${__BASH_HELPERS_LOGGING_LEVEL}")"
	outlevel="$(__bash_helpers_logging_level_value "${FUNCNAME}" "${__BASH_HELPERS_LOGGING_OUTPUT_LEVEL}")"

	msg_header="${message## *}"
	spaces="$(((${#message}-${#msg_header})+${#RC_INDENTATION}))"
	indent="$(printf -- "%${spaces}s" '')"

	if [[ ${outlevel} -ge ${level_value} ]]; then
		case ${level} in
			err|error|emerg|alert|crit) RC_INDENTATION="${indent}" eerror "${message}" ;;
			warning|warn) RC_INDENTATION="${indent}" ewarn "${message}";;
			info|notice) RC_INDENTATION="${indent}" einfo "${message}";;
			debug) printf -- "%s  %s\n" "${RC_INDENTATION}" "${message}";;
		esac
	fi

	if [[ ${loglevel} -ge ${level_value} ]]; then
		if [[ -n ${logfile} ]]; then
			printf -- "%s %s[%s]: %s\n" "$(date --iso-8601=seconds)" "${progname}" $$ "${message}" >> "${logfile}"
		elif [[ -z ${__BASH_HELPERS_LOGGING_NO_SYSLOG} ]]; then
			logger --priority "${facility}.${level}" --tag "${progname}" --id=$$ -- "${message}"
		fi
	fi
}

log() {
	local level="${1,,*}"
	shift
	local message="${*}"

	__bash_helpers_logging_log_message

	return 0
}

pipelog() {
	local level="${1,,*}"
	local message

	while read -rs message; do
		__bash_helpers_logging_log_message
	done

	return 0
}

alert() { log alert "${@}"; }
crit() { log crit "${@}"; }
error() { log error "${@}"; }
warn() { log warn "${@}"; }
notice() { log notice "${@}"; }
info() { log info "${@}"; }
debug() { log debug "${@}"; }

fatal() { log error "${@}"; exit 255; }

# vim:ts=4:sw=4:sts=4:noet:
