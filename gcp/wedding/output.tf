output "instance_hosts_entry" {
  description = "The public IP address of the instance in /etc/hosts format"
  value       = format("%s %s", google_compute_address.main.address, local.name)
}
