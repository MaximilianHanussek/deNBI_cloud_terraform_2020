data "openstack_images_image_v2" "workshop_image_master" {
  name = var.workshop-image["master"]
  most_recent = true
}

data "openstack_images_image_v2" "workshop_image_compute" {
  name = var.workshop-image["compute"]
  most_recent = true
}

resource "openstack_blockstorage_volume_v2" "cinder_volume_master" {
  name		= var.volume-name["master"]
  size 		= var.cinder-disc-size
  volume_type 	= var.cinder-storage-backend
}

resource "openstack_blockstorage_volume_v2" "cinder_volume_compute" {
  count 	= var.compute-node-count
  name          = "${var.volume-name["compute"]}-${count.index}"
  size          = var.cinder-disc-size
  volume_type   = var.cinder-storage-backend
}

resource "openstack_compute_instance_v2" "workshop_vm_master" {
  name		  = var.vm-name["master"]
  flavor_name     = var.flavors["master"]
  image_id        = data.openstack_images_image_v2.workshop_image_master.id
  key_pair        = openstack_compute_keypair_v2.workshop_keypair.name
  security_groups = var.security-groups

  network {
    name = var.network["compute"]
  }

  network {
    name = var.network["master"]
    access_network = true
  }

block_device {
    uuid                  = data.openstack_images_image_v2.workshop_image_master.id
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

block_device {
    uuid                  = openstack_blockstorage_volume_v2.cinder_volume_master.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }

provisioner "file" {
    content = tls_private_key.internal_connection_key.private_key_pem
    destination = "~/.ssh/connection_key.pem"  
  
    connection {
      type        = "ssh"
      private_key = file(var.private_key_path)
      user        = "centos"
      timeout     = "5m"
      host        = self.access_ip_v4
    }
  } 

provisioner "remote-exec" {
    script = "set_internal_private_key_permissions.sh"

    connection {
      type        = "ssh"
      private_key = file(var.private_key_path)
      user        = "centos"
      timeout     = "5m"
      host        = self.access_ip_v4
    }
  }

provisioner "remote-exec" {
    script = "mount_cinder_volumes.sh"

    connection {
      type        = "ssh"
      private_key = file(var.private_key_path)
      user        = "centos"
      timeout     = "5m"
      host	  = self.access_ip_v4
    }
  }

provisioner "file" {
    source = "hello_world.txt"
    destination = "/home/centos/hello_world.txt"

    connection {
      type        = "ssh"
      private_key = file(var.private_key_path)
      user        = "centos"
      timeout     = "5m"
      host        = self.access_ip_v4
    }
  }
}


resource "openstack_compute_instance_v2" "workshop_vm_compute" {
  count           = var.compute-node-count
  name            = "${var.vm-name["compute"]}-${count.index}"
  flavor_name     = var.flavors["compute"]
  image_id        = data.openstack_images_image_v2.workshop_image_compute.id
  key_pair        = var.internal-key-name
  security_groups = var.security-groups

  network {
    name = var.network["compute"]
  }

block_device {
    uuid                  = data.openstack_images_image_v2.workshop_image_compute.id
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

block_device {
    uuid                  = element(openstack_blockstorage_volume_v2.cinder_volume_compute.*.id, count.index)
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }
}
