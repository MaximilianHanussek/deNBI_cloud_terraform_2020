resource "tls_private_key" "internal_connection_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "openstack_compute_keypair_v2" "internal_connection_key_openstack" {
  name = var.internal-key-name
  public_key = tls_private_key.internal_connection_key.public_key_openssh
} 


resource "openstack_compute_keypair_v2" "workshop_keypair" {
  name 	     = var.workshop-key-name
  public_key = var.public-key
}
