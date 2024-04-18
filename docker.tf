# --------------------------------
# Create network
# --------------------------------
resource "docker_network" "this" {
  for_each = {
    for i, v in var.docker_networks : v.name => v
  }
  name = each.value.name

  ipam_config {
    aux_address = lookup(each.value.ipam_config, "aux_address", null)
    gateway     = lookup(each.value.ipam_config, "gateway", null)
    subnet      = lookup(each.value.ipam_config, "subnet", null)
  }
}

# --------------------------------
# Create volume
# --------------------------------
resource "docker_volume" "this" {
  for_each = {
    for k, v in var.named_volumes : k => v
    if lookup(v, "create", false) != false
  }
  name = each.key
}

# --------------------------------
# Pull image
# --------------------------------
data "docker_registry_image" "this" {
  count = var.image == null ? 0 : 1
  name  = var.image
}

resource "docker_image" "this" {
  count         = var.image == null ? 0 : 1
  name          = data.docker_registry_image.this[0].name
  pull_triggers = [data.docker_registry_image.this[0].sha256_digest]
}

# --------------------------------
# Create container
# --------------------------------
resource "docker_container" "this" {
  name  = var.container_name
  image = docker_image.this[0].image_id
  env = var.env != null ? [for k, v in var.env : "${k}=${v}"] : null  

  dynamic "networks_advanced" {
    for_each = var.networks_advanced == null ? [] : var.networks_advanced
    content {
      name         = lookup(networks_advanced.value, "name", null)
      ipv4_address = lookup(networks_advanced.value, "ipv4_address", null)
      ipv6_address = lookup(networks_advanced.value, "ipv6_address", null)
      aliases      = lookup(networks_advanced.value, "aliases", null)
    }
    
  }

  

  dynamic "ports" {
    for_each = var.ports == null ? [] : var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
      protocol = ports.value.protocol
    }
  }

  dynamic "volumes" {
    for_each = var.named_volumes
    content {
      volume_name    = volumes.key
      container_path = volumes.value.container_path
      read_only      = volumes.value.read_only
    }
  }

  dynamic "volumes" {
    for_each = var.host_paths
    content {
      host_path      = volumes.key
      container_path = volumes.value.container_path
      read_only      = volumes.value.read_only
    }
  }

}







