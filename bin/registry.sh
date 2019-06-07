#!/usr/bin/env bash


usage() {
	printf "%s" '
usage
-----

  [env] vue-cli-template-registry [-h] [-v] install|uninstall|update <source>

'
}

function info {
    printf "%s%s" "$(usage)" '


overview
--------

  a local registry for your vue-cli custom templates.
  to be used with private/enterprise hosted custom-template repositories.


environment
-----------

  INSTALL_DIR
    a local path for the registry storage area.
    defaults to "~/.vue-cli-templates".

  REPO_REF
    a github branch, tag, commitish etc., to pull from when cloning from a remote repository.
    defaults to "master".


flags
-----

  -v
    switch on verbose logging.
    off by default.


arguments
---------

  source
    the custom template source. can be either:
      - a local directory path, pointing at a custom template project on your filesystem.
      - a clone URL of the remote repository hosting that project.
    this argument is mandatory.


'
}

main() {
	local args
	local command
	local source
	local custom_template_name
	local custom_template_source_path
	local custom_template_target_path

	# handle env vars before other stuff, other methods may rely on them
	handle_environment_variables

	# break command-line apart to separate the flags from the operands
	handle_options "$@"
	# OPERANDS is now set by the handler, to hold the arguments list, filtered from flags

	# require what the CLI states
	if (( ${#OPERANDS[@]} < 2 )); then
		quit
	fi
	set ${OPERANDS[@]}

	# extract the command and discard it
	command="$1"
	shift

	# validate command's value is part of the public CLI
	if ! is_available "cmd_$command"; then
		quit
	fi

	# validate source has a legal value
	source="$1"
	if [[ -z "$source" ]] || ! is_local "$source" && ! is_remote "$source"; then
		quit "$(info)"
	fi

	# sets cleanup handlers on exit, and wraps the prompt with greeting messages
	set_traps

	custom_template_name="$(resolve_custom_template_name "$source")"
    custom_template_source_path="$(resolve_custom_template_source_path "$source" "$custom_template_name")"
    custom_template_target_path=${INSTALL_DIR}/${custom_template_name}

	# invoke the main command
	cmd_${command} "$source" "$custom_template_name" "$custom_template_target_path" "$custom_template_source_path"
}

cmd_install() {
	local source="$1"
	local custom_template_name="$2"
	local custom_template_target_path="$3"
	local custom_template_source_path="$4"
	local output

	if is_remote "$source"; then
		log "cloning custom template from github ($REPO_REF)..."
		output="$(light_clone "$source" "$custom_template_source_path" "$REPO_REF" 2>&1)"
		status_log "cloned ok" "clone failed:
      ${output}"
	fi

	log "installing global registry directory..."
	install_dir "$INSTALL_DIR"
	status_log "installed ok" "installation failed"

	log "installing base directory..."
	install_dir "$custom_template_target_path"
	status_log "installed ok" "installation failed"

	log "installing template directory tree..."
	install_dir_tree "$custom_template_source_path" "$custom_template_target_path" '\/template*'
	status_log "installed ok" "installation failed"

	log "installing meta file..."
	install_file ${custom_template_source_path}/meta.* ${custom_template_target_path}
	status_log "installed ok" "installation failed"

	log "installing template file tree..."
	install_file_tree "$custom_template_source_path" "$custom_template_target_path" '\/template*'
	status_log "installed ok" "installation failed"

	log_header 'setup done!'
	log 'type `vue init ~/.vue-cli-templates/'"$custom_template_name"' my-app` from anywhere to generate this template.'
}

cmd_uninstall() {
	local source="$1"
	local custom_template_name="$2"
	local custom_template_target_path="$3"

	log "removing '$custom_template_name' from the registry..."
	if [[ -d "$custom_template_target_path" ]]; then
		remove_dir "$custom_template_target_path"
		status_log "removed ok" "remove failed"
	else
		log_info "remove skipped (item not found)"
	fi
}

cmd_update() {
	cmd_uninstall "$@"
	cmd_install "$@"
}

handle_options() {
	local OPTIND
	local opt

	# reset to default state
	TRACE_RM=''
	TRACE_INST=''
	TRACE_GIT='-q'

	# parse command line and set globals
	while getopts ":vh" opt; do
		case "$opt" in
			v)
				TRACE_RM='-v'
				TRACE_INST='-v'
				TRACE_GIT=''
				;;
			h) info; exit ;;
			\?) usage; exit ;;
		esac
		# always remove the flag, to send back a filtered list
		shift
	done

	# use another global var to export the non-option parameters (the program's mass arguments) as a list.
	# don't just echo them back, to not force the function user to use a subshell (which blocks setting
	# global variables in the parent shell).
    OPERANDS=( ${@} )
}

handle_environment_variables() {
	ensure_repo_ref
	ensure_install_dir
}

set_traps() {
	log_header 'hi :)'
	trap 'log_header "bye ♥
" ; clear_cache' EXIT
}

init_cache() {
	CACHE_DIR="$(create_temp_dir)"
}

clear_cache() {
	remove_dir ${CACHE_DIR}
}

light_clone() {
	local url="${1:?}"
	local dir="$2"
	local ref="${3:-master}"

	git clone ${TRACE_GIT} \
	          --depth 1 \
	          --single-branch \
	          --branch "$ref" \
	          "$url" "$dir"
}

remove_dir() {
	local dir="$1"
	if  [[ -d "$dir" ]]; then
		rm ${TRACE_RM} -rf "${dir:?}"
	fi
}

install_dir() {
	install ${TRACE_INST} -d -m 0755 ${1}
}

install_file() {
	local src="$1"
	local dest="$2"
	install ${TRACE_INST} -m 0644 ${src} ${dest}
}

install_dir_tree() {
	local rel_dir
	local source_path="$1"
	local target_path="$2"
	local pattern="$3"
	local status=0

	# root directory and its deeply nested directories
	for dir in $(find ${source_path} -path "${source_path}${pattern}" -type d); do
		rel_dir="${dir#${source_path}/}"
		install_dir "${target_path}/${rel_dir}"
		status=$(($? + status))
	done
	return ${status}
}

install_file_tree() {
	local rel_file
	local source_path="$1"
	local target_path="$2"
	local pattern="$3"
	local status=0

	# files in the root directory and its deeply nested directories
	for file in $(find ${source_path} -path "${source_path}${pattern}" -type f); do
		rel_file="${file#${source_path}/}"
		install_file ${file} "${target_path}/${rel_file}"
		status=$(($? + status))
	done
	return ${status}
}

resolve_custom_template_name() {
	local source="$1"
	if is_local "$source"; then
		basename "$source"
	elif is_remote "$source"; then
		filename "$source"
	fi
}

resolve_custom_template_source_path() {
	local source="$1"
	local custom_template_name="$2"
	if is_local "$source"; then
		printf "%s" "$source"
	elif is_remote "$source"; then
		# only initialize the cache when it's needed
		init_cache
		# prepare an area for cloning the remote
		printf "%s" "$CACHE_DIR/$custom_template_name"
	fi
}

# remove the directory path and file extension, leaving only the file name
filename() {
	basename "${1%.*}"
}

ensure_repo_ref() {
	REPO_REF="${REPO_REF:-master}"
}

ensure_install_dir() {
	if [[ -z $INSTALL_DIR || ! -d $INSTALL_DIR ]]; then
		INSTALL_DIR=~/.vue-cli-templates
	fi
}

create_temp_dir() {
	mktemp -d 2>/dev/null || mktemp -d -t 'vue-cli-templates'
}

is_available() {
	type "$1" >/dev/null 2>&1
}

is_local() {
	local source="$1"
	[[ -d $source ]]
}

is_remote() {
	local source="$1"
	local pattern='^http.+\.git$'
	[[ $source =~ $pattern ]]
}

has_param() {
	local term="$1"
	shift
	for arg; do
		if [[ $arg == "$term" ]]; then
			return 0
		fi
	done
	return 1
}

log() {
	printf "\n  %s\n" "$1"
}

log_header() {
	printf "\n\n  %s\n\n" "$1"
}

log_ok() {
	printf "    ✔ %s\n" "$1"
}

log_info() {
	printf "    ℹ %s\n" "$1"
}

log_error() {
	printf "    ✘ %s\n" "$1"
}

status_log() {
	local status=$?
	local success_msg="$1"
	local error_msg="$2"
	if (( $status == 0 )); then
		log_ok "$success_msg"
	else
		log_error "$error_msg"
		exit ${status}
	fi
}

quit() {
	local status=$?
	local msg="$1"
	if [[ -n "$msg" ]]; then
		log "$msg
"
	else
		usage
	fi
	exit ${status}
}


main "$@"

