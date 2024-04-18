# -------------------
# General variables
# -------------------
variable "region" {
  default     = "us-east-2"
  type        = string
  description = "The region where the infrastructure will be deployed"
}

variable "environment" {
  default     = "dev"
  type        = string
  description = "The environment for which the infrastructure is intended (e.g., dev, test, prod)"
}

# --------------------------
# Docker provider variables
# --------------------------
variable "remote_user" {
  description = "The username used to connect to the remote host via SSH."
  type        = string  
}

variable "remote_host" {
  description = "The hostname or IP address of the remote host running Docker."
  type        = string  
}

variable "path2ssh_key" {
  description = "The local path to the SSH private key file used for connecting to the remote host."
  type        = string  
}

# --------------------------
# Docker network variables
# --------------------------
variable "docker_networks" {    
  description = <<EOD
  List of custom networks to create
  ```hcl
  
  example: 
  docker_networks = [
    {
      name = "proxy"
      ipam_config = {
        aux_address = {}
        gateway     = "10.0.100.1"
        subnet      = "10.0.100.0/24"
      }
    }
  ]

  ```
  EOD
  type        = any
  default     = []
}

# --------------------------
# Docker variables
# --------------------------
variable "image" {
  description = "The Docker image to use for the container."
  type        = string
  default     = null
}

variable "container_name" {
  description = "The name of the Docker container."
  type        = string  
  default     = null
}


variable "named_volumes" {
  description = <<EOD
  "Mount named volumes"
  ```hcl
  
  example: 
  named_volumes = {
    nginx = {
      container_path = "/etc/nginx/conf.d"
      read_only      = true/false
      create         = true/false
    }
  }

  ```
  EOD

  type = map(object({
    container_path = string
    read_only      = bool
    create         = bool
  }))
  default = {}
}

variable "host_paths" {
  description = <<EOD
  "Mount host paths"
  ```hcl
  
  example: 
  host_paths = {
      "/srv/nginx.conf" = {
          container_path = "/etc/nginx/conf.d/nginx.conf"
          read_only      = false
          create         = true
      }
  }

  ```
  EOD
    
  type = map(object({
    container_path = string
    read_only      = bool
  }))
  default = {}
}

variable "networks_advanced" {        
  description = <<EOD
  A list of advanced networks connect to container.
  ```hcl
  
  example: 
  networks_advanced = [
  {
      name         = "front"
      ipv4_address = "10.0.10.7"
  },
  {
      name         = "backend"
      ipv4_address = "10.0.20.7"
  }
  ]

  ```
  EOD  

  type        = any
  default     = null
}

variable "ports" {
  description = <<EOD
  "Expose ports"
  ```hcl

  example: 
  ports = [
    {
      internal = 80
      external = 8800
      protocol = "tcp"
    },
    {
      internal = 70
      external = 7700
      protocol = "tcp"
    }
  ]

  ```
  EOD

  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = null

}

variable "env" {
  description = <<EOD
  "Add environment variables"
  ```ecl

  example: 
  env = {
      ENV_VAR_1 = "value1"
      ENV_VAR_2 = "value2"
  }      
  ```
  EOD

  type        = map(string)
  default = null
}