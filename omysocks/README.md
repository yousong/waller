`omysocks` is a OpenWrt package trying to direct selected network traffics to SOCKS5 proxies (raw SOCKSv5 proxy or those created with `ssh -D` option) with the help of redsocks, ipset, iproute2, iptables.

## How it works

[Redsocks](http://darkk.net.ru/redsocks/) is a transparent proxy service that can be used to directing TCP connections through other SOCKS proxies.

## UCI configuration

There are 3 unique global sections with predefined names

- `omysocks`, global configs for the service
- `ossherd`, global configs for ssh initiated SOCKS
- `redsocks`, global configs for redsocks instance

There can also exist more than one instances of section type `ossheep` and `osocks` section for ssh-initiated socks and raw socks respectively

### `omysocks`

- `networks`
	- on events of which networks will the service be triggered to do a restart
	- optional

### `ossherd`

- `loglevel`, `int`
	- how many `-v` option for `ssh` command
	- defaults to `0`
- `localip`
	- bind address for ssh `-D` option
	- defaults to `127.0.0.1`
- `localport`
	- starting port for `-D` option of each `ssh` instance
	- required
- `runas`
	- the default user `ssh` will run as
	- optional, defaults to `nobody`
- `config`
	- base content of `ssh_config` file to be passed to `ssh` with `-F` option
	- optional
	- `ossherd` will not overwrite system-level or user-level `ssh_config` file

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

There are times when you only need password authentication.  To disable pubkey authentication for saving connection time.

	PubkeyAuthentication no
	GSSAPIAuthentication no
	RSAAuthentication no
	PreferredAuthentications password
	NumberOfPasswordPrompts 1

If you dont't care about host check, the following can disable it.

	UserKnownHostsFile /dev/null
	StrictHostKeyChecking no

### `redsocks`

- `localip`
	- bind address of redsocks, defaults to `127.0.0.1`
	- `0.0.0.0` is the recommended value for a router
	- note that `192.168.1.1` will not cover `OUTPUT` traffic
- `localport`
	- starting port redsocks will serve on
	- required
- `baseconf`
	- content of `base` section of `redsocks.conf`
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

### `osocks`

- `host`, hostname or ip address of the socks server
- `port`, port to connect
- `type`, socks server type, defaults to `socks5`, can be `socks4`

## Firewall

A firewall rules file is included in this package and will be installed to `/etc/firewall.ossherd`.

- It is disabled by default
- Add a `include` section like the following to `/etc/config/firewall` to enable it

		config include ossherd
			option path /etc/firewall.omysocks
			option reload 1

	Setting `reload` to `1` is needed for triggering the rules referred to by `path` be executed on firewall reload event.

It is recommended that you review the rules in there and tailor them to your specific situation.

Below are some facts about those rules.

- Rules will be active on service start and teared down on service stop
- Firewall rules will be appended to `prerouting_lan_rule` and `OUTPUT` chain

		iptables -t nat -D prerouting_lan_rule -p tcp -j omysocks_go
		iptables -t nat -D OUTPUT -p tcp -j omysocks_go

- `prerouting_lan_rule` will be flushed on service stop
- `ipset` is used to record whether sets of ip addresses need to `REDIRECT` to redsocks or not
	- `setblocked` and `setrst` will definitly go though `ossherd_redsocks`
	- `setnormal` and `setdev` will never go though `ossherd_redsocks`
	- Entries in `setrst` has a stale out value of 3600 seconds
- `recent` match is used to track addresses that send TCP RST to us with a perceived frequency

## Issues

- There is currently no liveness check on the SOCKS proxy, not in this package itself, nor with redsocks.
- `REDIRECT` is setup with `--toports mm-nn --random`, which means should there be any holes within that range, users may receive connection refused error sometimes.
