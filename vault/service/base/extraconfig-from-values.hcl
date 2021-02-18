# We disable locking memory pages for maximum compatibility. However, if this works on your
# platform, you should enable it for increased performance. If it does not work on your platform,
# and it is enabled, Vault will fail to start. Therefore, it should be easy to determine whether it
# works on your platform.
disable_mlock = true
ui = false

listener "tcp" {
  tls_disable = 1
  address = "[::]:8200"
  cluster_address = "[::]:8201"
}

listener "tcp" {
  tls_disable = 1
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
}

storage "file" {
  path = "/vault/data"
}

# Example configuration for using auto-unseal, using Google Cloud KMS. The
# GKMS keys must already exist, and the cluster must have a service account
# that is authorized to access GCP KMS.
#seal "gcpckms" {
#   project     = "vault-dev"
#   region      = "global"
#   key_ring    = "vault-unseal-kr"
#   crypto_key  = "vault-unseal-key"
#}
