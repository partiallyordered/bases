disable_mlock = false
ui = false

listener "tcp" {
  tls_disable = 1
  address = "[::]:8200"
  cluster_address = "[::]:8201"
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
