output "image_name" {
  value = docker_image.this[0].name
}

output "image_id" {
  value = docker_image.this[0].image_id
}

output "container_name" {
  value = docker_container.this.name
}