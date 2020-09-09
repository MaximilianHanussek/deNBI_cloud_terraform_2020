variable "cinder-disc-size" {
  default = 10
}

variable "cinder-storage-backend" {
  default = "quobyte_hdd"
}

variable "volume-name" {
  type = map
  default = {
    "master" = "maxhanussek-workshop-volume-master"	#replace maxhanussek-workshop-volume-master by an own, unique name
    "compute" = "maxhanussek-workshop-volume-compute"	#replace maxhanussek-workshop-volume-comoute by an own, unique name
  }
}

variable "flavors" {
  type = map
  default = {
    "master" = "de.NBI small"
    "compute" = "de.NBI default"
  }
}

variable "vm-name" {
  type = map
  default = {
    "master" = "maxhanussek-workshop-vm-master"		#replace maxhanussek-workshop-vm-master by an own, unique name
    "compute" = "maxhanussek-workshop-vm-compute"	#replace maxhanussek-workshop-vm-compute by an own, unique name
  }
}

variable "workshop-image" {
  type = map
  default = {
     "master" = "CentOS 7.7 2020-07-07"
     "compute" = "CentOS 7.8 2020-07-07"
  }
}

variable "workshop-key-name" {
  default = "maxhanussek-keypair"		#replace maxhanussek-keypair by an own, unique name
}

variable "internal-key-name" {
  default = "maxhanussek-internal-key"		#replace maxhanussek-internal-key by an own, unique name
}

#replace the following ssh public key with your own key
variable "public-key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGCoCJq3YLZSSIQWp9E8lHoS2Uyls66498ZcEqxJIGEP6gu+W9AAw7x0FBGlvnoHAw1wEsMbcihrTVLlU0r2VKtNVdvW26ACB01Y663IsiqrgtWChmLEWxOJE/8k3F+ZQ8aIjfYWr4O33IBItr32OP3lka/3wrLqOYh27JUcc3hvo+4KNdYoEso/P2bvvrL3jU/obB5iCtpI3QHpnA3fEHCuLK6A0J13cedcNJTWnm1O8aLo0NPdimqB4I82e1WfdflabJCVQjuWjA224zNakNdxa7T11aQJjJWKWLNL5nKrM+sjeUpcKzNeMDTIrPQpF/mqqkEM/sRgDKPgYZ/uqf"
}

variable "security-groups" {
  default = [
    "maxhanussek-sec-group"			#replace maxhanussek-sec-group by an own, unique name
  ]
}

variable "network" {
  type = map
  default = {
    "master" = "denbi_uni_tuebingen_external2" 
    "compute" = "denbi_uni_tuebingen_internal"
  }
}

variable "compute-node-count" {
  default = 2
}

variable "private_key_path" {
  default = "/Users/maximilianhanussek/Documents/Zertifikate/maximilian-demo.pem"
}

