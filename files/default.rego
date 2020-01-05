# This is the default rego policy that will apply to all
# agents that do not have a specific rego policy set.
#
# This particular one is from the choria/mcollective module
# and you can supply the source of your own by setting the
# hiera data mcollective::default_rego_policy_source to a
# Puppet file source of your choice
package io.choria.mcorpc.authpolicy

default allow = false

allow {
  input.agent == "rpcutil"
  input.action == "ping"
}

allow {
  input.agent == "choria_util"
  input.action == "info"
}
