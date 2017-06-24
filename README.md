# DDNS_Updater

update client for DDNS written in Elixir.

## Usage

### 1. build
```
$ cd ddns_updater
$ mix escript.build
```
and a file "ddns_updater" will be generated.

### 2. run
```
$ ./ddns_updater <service> <username> <password> (<minutes>)
```
\<service>: specify the name of DDNS service. Now only "mydns" is supported.

\<username>: your username of DDNS service.

\<password>: your password of DDNS service.

\<minutes>: update every \<minutes> minutes. Default value is 10.

### 3. tips

If you want to run ddns_updater as daemon, you can write shell scripts like below.

example: "ddns_updater.sh"
```sh
#!/bin/sh
cd $(dirname $0)
export HOME=/path/to/home
./ddns_updater mydns <username> <password> 30
```
And you can use systemd to run "ddns_updater.sh" as daemon.

Write code like below and save it to "/etc/systemd/system/ddns_updater.service".
```
[Unit]
Description = ddns_updater daemon

[Service]
ExecStart = /path/to/ddns_updater.sh

[Install]
WantedBy = multi-user.target
```
To enable the daemon:
```
$ sudo systemctl enable ddns_updater
```
To start the daemon:
```
$ sudo systemctl start ddns_updater
```
To check the daemon is successfully running:
```
$ sudo systemctl status ddns_updater
```
