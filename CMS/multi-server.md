For multi-server deploy
--------
Use more servers if you expect high loads.

host1: main server(CWS, AWS, worker)
host2: Worker

We should modify `cms.conf, pg_hba.conf, postgresql.conf`.

cms.conf
--------

```
"core_services":
    {
        "LogService":        [["$host1", 29000]],
        "ResourceService":   [["$host1", 28000],
                              ["$host2", 28000]],
        "ScoringService":    [["$host1", 28500]],
        "Checker":           [["$host1", 22000]],
        "EvaluationService": [["$host1", 25000]],
        "Worker":            [["$host2", 26000],
                              ["$host2", 26001],
                              ["$host2", 26002]],
        "ContestWebServer":  [["$host1", 21000]],
        "AdminWebServer":    [["$host1", 21100]],
        "ProxyService":      [["$host1", 28600]],
        "PrintingService":   [["$host1", 25123]]
    },
```
host1 should also be in ipv4(not localhost, not 127.0.0.1) in order to share the same cms.conf with other servers. Otherwise use different config files for each servers.

pg_hba.conf
--------
location: `/etc/postgresql/<ver>/main/pg_hba.conf`

add all foreign servers to line 59~60(?), listen_addresses.
```
listen_addresses = 'localhost, host2, host3, ...'
```

postgresql.conf
--------
location: `/etc/postgresql/<ver>/main/postgresql.conf`
```
host cmsdb cmsuser <IP address of servers>/32 md5
```

Starting the contest
--------
You should install cms to all servers(stop right before making the database).
Then using the same cms.conf, bash


```cmsResourceService -a #(ID)```
