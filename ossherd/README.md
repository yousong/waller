`ossherd` is a OpenWrt package that tries to run redsocks with multiple SSH
SOCKS5 proxies.

## UCI configuration

There are 2 unique global sections with names `ossherd`, `redsocks` for SSH
instances and redsocks respectively.

### `ossherd`

- `loglevel`, `int`
	- how many `-v` option for `ssh` command
	- defaults to `0`
- `localip`
	- bind address for `-D` option
	- defaults to `127.0.0.1`
- `localport`
	- starting port for `-D` option of each `ssh` instance
	- required
- `runas`
	- the default user `ssh` will run as
	- optional
- `networks`
	- on events of which networks will the service be triggered to do a restart
	- optional
- `config`
	- base content for `ssh_config` file to be passed to `ssh` with `-F` option
	- optional
	- `ossherd` will not overwrite system-level or user-level `ssh_config` file
	- the genrated `ssh_config` file will be used by `ssh` with `-F` option

Sample `ossherd` section follows.

	config ossherd ossherd
		option loglevel		0
		option localip		127.0.0.1
		option localport	7001
		option runas		nobody
		option networks		wan
		option config		'
	TCPKeepAlive yes
	ConnectTimeout 5
	ServerAliveCountMax 3
	ServerAliveInterval 10
	'

There are times you only need password authentication.  To disable pubkey authentication to for saving connect time.

	PubkeyAuthentication no
	RSAAuthentication no
	PreferredAuthentications password
	NumberOfPasswordPrompts 1

If you dont't care about host footprint check, the following can disable it.

	UserKnownHostsFile /dev/null
	StrictHostKeyChecking no

### `redsocks`

- `localip`
	- bind address redsocks will listen to.
	- defaults to `127.0.0.1`
	- `0.0.0.0` is the recommended value for a router
	- `192.168.1.1` will not cover `OUTPUT` traffic
- `localport`
	- starting port redsocks will listen to
	- required
- `baseconf`
	- `base` section of `redsocks.conf`
	- optional but recommended to give a explicit setting
	- ossherd do not overwrite `/etc/redsocks.conf`
	- the generated `redsocks.conf` will be used by redsocks with `-c` option

Sample `redsocks` section follows.

	config redsocks redsocks
		option localip		0.0.0.0
		option localport	12345
		option baseconf '
	base {
		log = "syslog:daemon";
		daemon = off;
		user = nobody;
		group = nogroup;
		redirector = iptables;
	}
	'

### `ossheep`

- `nclone`
	- number of clones of this this
	- `0` means to disable it
	- defaults to `1`
- `host`
	- ssh server host to connect to
	- required
- `port`
	- ssh server port to connect to
	- defaults to `22`
- `user`
	- login name to use (`-l` option to `ssh` command)
	- required
- `runas`
	- the user to run this `ssh` instance
	- defaults to `runas` value in global `ossherd` section
- `pass`
	- login password to use
	- no default value
- `identity`
	- identity file to use (`-i` option to `ssh` command)
	- no default value

Caveats should be noted.

- SSH authentication credentials are exposed in the wild.  So restricted users with minimal privileges, throw-away passwords or identity files is recommened for use with `ossherd`.
- at least one of `pass` or `identiy` must be available
- be sure that corresponding authentication method is enabled in the config
- if pubkey authentication is to be used
	- make sure the identity files' access permission is up to the standard of ssh command

			chmod 600 /path/to/identityfile

	- make sure the identity file can be accessed by the user as specified with `runas`

			chown nobody:nogroup /path/to/identityfile

Sample `ossheep` section.

	config ossheep
		option nclone 0
		option host '1.2.3.4'
		option port '8022'
		option user 'foo'
		option pass 'bar'

## Firewall

A firewall rules file is included in this package and will be installed to `/etc/firewall.ossherd`.

- It is disabled by default
- Add a `include` section like the following to `/etc/config/firewall` to enable it

		config include ossherd
			option path /etc/firewall.ossherd
			option reload 1

	Setting `reload` to `1` is needed for triggering the rules referred by `path` be executed on firewall reload event.

It is recommended that you review the rules in there and tailor them to your specific situation.

Below are some facts about the included rules.

- Rules will be active on service start and teared down on service stop
- Firewall rules will be appended to `prerouting_lan_rule` and `OUTPUT` chain

		iptables -t nat -A prerouting_lan_rule -p tcp -j ossherd_go
		iptables -t nat -A OUTPUT -p tcp -j ossherd_go

- `prerouting_lan_rule` will be flushed on service stop
- `ipset` is used to record whether sets of ip addresses need to `REDIRECT` to redsocks or not
	- `setblocked` and `setrst` will definitly go though `ossherd_redsocks`
	- `setnormal` and `setdev` will never go though `ossherd_redsocks`
	- Entries in `setrst` has a stale out value of 3600 seconds
- `recent` match is used to track addresses that send TCP RST to us with a perceived frequency

## Issues

- There is currently no liveness check on the SOCKS proxy, not in this package itself, nor with redsocks.
- `REDIRECT` is setup with `--toports mm-nn --random`, which means should there be any holes within that range, users may receive connection refused error sometimes.
