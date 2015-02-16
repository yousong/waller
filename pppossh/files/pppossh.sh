#!/bin/sh

SSH=/usr/bin/ssh
[ -x "$SSH" ] || {
	echo "Cannot find executable $SSH." >&2
	exit 1
}

_orig="$INCLUDE_ONLY"
INCLUDE_ONLY=1 . ppp.sh;
INCLUDE_ONLY="$_orig"
[ -n "$INCLUDE_ONLY" ] || {
	. /lib/functions.sh
	. ../netifd-proto.sh
	init_proto "$@"
}

proto_pppossh_init_config() {
	ppp_generic_init_config
	config_add_string server sshuser ipaddr peeraddr ssh_options
	config_add_array 'identity:list(string)'
	config_add_int port
	available=1
	no_device=1
}

proto_pppossh_setup() {
	local config="$1"
	local iface="$2"
	local user="$(id -nu)"
	local home=$(sh -c "echo ~$user")
	local ip serv_addr errmsg
	local opts pty
	local fn identity

	json_get_vars port sshuser ipaddr peeraddr ssh_options
	json_get_var server server && {
		for ip in $(resolveip -t 5 "$server"); do
			( proto_add_host_dependency "$config" "$ip" )
			serv_addr=1
		done
	}
	[ -n "$serv_addr" ] || errmsg="${errmsg}Could not resolve $server.\n"
	[ -n "$sshuser" ] || errmsg="${errmsg}Missing sshuser option.\n"

	json_get_values identity identity
	[ -z "$identity" ] && identity="'$home/.ssh/id_rsa' '$home/.ssh/id_dsa'"
	for fn in $identity; do
		[ -f "$fn" ] && opts="$opts -i $fn"
	done
	[ -n "$opts" ] || errmsg="${errmsg}Cannot find valid identity file.\n"

	[ -n "$errmsg" ] && {
		echo -ne "$errmsg" >&2
		proto_setup_failed "$config"
		exit 1
	}
	opts="$opts ${port:+-p $port}"
	opts="$opts ${ssh_options}"
	opts="$opts $sshuser@$server"
	pty="env 'HOME=$home' "$SSH" $opts pppd nodetach notty noauth"

	ppp_generic_setup "$config" noauth pty "$pty" "$ipaddr:$peeraddr"
}

proto_pppossh_teardown() {
	ppp_generic_teardown "$@"
}

[ -n "$INCLUDE_ONLY" ] || {
	add_protocol pppossh
}
