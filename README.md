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

\<minutes>: update every <minutes> minutes. Default value is 10.

### 3. tips

If you want to run ddns_updater as daemon, you can write shell scripts like below.

example:
```sh
#!/bin/sh
cd $(dirname $0)
./ddns_updater mydns <username> <password> 30 &
```
