Setting up NATS.io for MCollective
==================================

A module will be written, but for now here's a manual guide to installing NATS.io.

NATS is a Go application so distributed as a single binary, there is also a Docker image.

Deployment Overview
-------------------

By default the NATS connector will attmpet to connect to `puppet:4222`, you can also add
SRV records to the NATS servers:

```
_mcollective-server._tcp.example.net. 2951 IN SRV 0 0 4222 nats1.example.net.
_mcollective-server._tcp.example.net. 2951 IN SRV 0 0 4222 nats2.example.net.
_mcollective-server._tcp.example.net. 2951 IN SRV 0 0 4222 nats3.example.net.
```

The connection MUST use SSL and MUST be setup using certs sign by the same CA as your
Puppet infrastructure.

This is in aid of getting a Just Works setup when combined with the `mcolective_connector_nats`
and `mcollective_security_puppet` plugins.

Configuring:
------------

A 3 node cluster is recommended, but to test or get going you can happily use 1 node, it will
scale to a very large number of nodes even on one node

Setting up a 3 node cluster is easy, here's a full config including verified SSL, verified SSL
is a requirement for MCollective:

```
port: 4222

monitor_port: 8222

tls {
  cert_file: "/etc/puppetlabs/puppet/ssl/certs/nats1.example.net.pem"
  key_file: "/etc/puppetlabs/puppet/ssl/private_keys/nats1.example.net.pem"
  ca_file: "/etc/puppetlabs/puppet/ssl/certs/ca.pem"
  verify: true
  timeout: 2
}

cluster {
  port: 4223

  tls {
    cert_file: "/etc/puppetlabs/puppet/ssl/certs/nats1.example.net.pem"
    key_file: "/etc/puppetlabs/puppet/ssl/private_keys/nats1.example.net.pem"
    ca_file: "/etc/puppetlabs/puppet/ssl/certs/ca.pem"
    verify: true
    timeout: 2
  }

  authorization {
    user: routes
    password: secret
    timeout: 0.75
  }

  routes = [
    nats-route://routes:secret@nats2.example.net:4223
    nats-route://routes:secret@nats3.example.net:4223
  ]
}
```

This uses the nodes puppet SSL certs, they have to be signed by the Puppet CA you use on all your
nodes, you can generate unique new certificates if you like.

In the `routes` section just configure a full mesh, node 1 to 2 and 3, node 2 to 1 and 3 and so forth.

NATS can be downloaded from [GitHub Release Page][https://github.com/nats-io/gnatsd/releases).

Run NATS:

```
gnatsd --config /path/to/gnatsd.conf -DV
```

You can also use the official Docker containers:

```
docker run -d -p 4222:4222 -p 4223:4223 \
  -v /path/to/your/gnatsd.conf:/config/gnatsd.conf \
  -v /etc/puppetlabs/puppet/ssl:/etc/puppetlabs/puppet/ssl \
  --name nats nats --config /config/gnatsd.conf -DV
````

This mounts your config and certs into a container and starts the NATS daemon.
