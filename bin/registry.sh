#!/usr/bin/env bash


usage() {
	echo "
usage: [environment] vue-cli-template-registry.sh install|uninstall|update [-h] [-v]
environment:
   REPO_URL=$REPO_URL
   REPO_REF=$REPO_REF
   LOCAL_PATH=$LOCAL_PATH
   INSTALL_DIR=$INSTALL_DIR
"
}

main() {
	local command="${1:-install}"

	# handle environment variables first, usage() relies on them
	ensure_repo_url
	ensure_repo_ref
	ensure_install_dir
	handle_flags "$@"

	if ! is_available "cmd_$command"; then
		quit
	fi

	register_cache
	set_traps "$TEMP_DIR"

	shift
	cmd_${command}
}

cmd_install() {
	local rel_dir
	local rel_file
	local clone_dir
	local custom_template_name
	local template_app_dir_pattern
	local custom_template_source_path
	local custom_template_target_path

	custom_template_name="$(resolve_custom_template_name)"
	custom_template_target_path=${INSTALL_DIR}/${custom_template_name}


	if [[ -d "$LOCAL_PATH" ]]; then
		log "resolving custom template local path..."
		custom_template_source_path="$LOCAL_PATH"
		log_ok "resolved ok"
	else
		clone_dir="$TEMP_DIR/$custom_template_name" # we know TEMP_DIR is available in this case
		log "cloning custom template from github ($REPO_REF)..."
		light_clone "$REPO_URL" "$clone_dir" "$REPO_REF"
		status_log "cloned ok" "clone failed"
		custom_template_source_path="$clone_dir"
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
	local custom_template_name

	custom_template_name="$(resolve_custom_template_name)"

	log "removing custom template '$custom_template_name' from registry..."
	remove_dir "$INSTALL_DIR/$custom_template_name"
	status_log "removed ok" "remove failed"
}

cmd_update() {
	cmd_uninstall
	cmd_install
}

handle_flags() {
	if [[ "$@" =~ '-h' ]]; then
		quit
	fi
	if [[ "$@" =~ '-v' ]]; then
		TRACE_RM='-v'
		TRACE_INST='-v'
	else
		TRACE_GIT='-q'
	fi
}

# creates a cache area (temp dir) if necessary
register_cache() {
	if [[ ! -d "$LOCAL_PATH" ]]; then
		TEMP_DIR="$(create_temp_dir)"
	fi
}

set_traps() {
	log_header 'hi :)'
	trap 'remove_dir '"$@"' ; log_header "bye ♥
"' EXIT
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
	if [[ -d "$LOCAL_PATH" ]]; then
		basename "$LOCAL_PATH"
	else
		filename "$REPO_URL"
	fi
}

# remove the directory path and file extension, leaving only the file name
filename() {
	basename "${1%.*}"
}

# todo - require REPO_URL env-var to be mutually exclusive with the LOCAL_PATH env-var.
# todo - i could even make them both into a single one, and test if it's a local directory to know if i should tread it like a url or not. e.g. SOURCE_URI
# todo - make this a validator and not an ensurer when passing repo url from outside.
ensure_repo_url() {
	REPO_URL="${REPO_URL:-***REMOVED***}"
}

#require_source_uri() {
#	if [[ -z "$REPO_URL" && -z "$LOCAL_PATH" ]]; then
#	fi
#	REPO_URL="${REPO_URL:-***REMOVED***}"
#}

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

log() {
	printf "\n  %s\n" "$1"
}

log_header() {
	printf "\n\n  %s\n\n" "$1"
}

log_ok() {
	printf "    ✔ %s\n" "$1"
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
		log "$msg"
	else
		usage
	fi
	exit ${status}
}


main "$@"

