resource "oci_core_instance" "FoggyKitchenWebserver1" {
  provider = oci.requestor
  availability_domain = lookup(data.oci_identity_availability_domains.R-ADs.availability_domains[1], "name")
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name = "FoggyKitchenWebServer1"
  shape = var.Shapes[0]
  subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.R-OSImageLocal.images[0], "id")
  }
  metadata = {
      ssh_authorized_keys = file(var.public_key_oci)
  }
  create_vnic_details {
     subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
     assign_public_ip = false
  }
}

data "oci_core_vnic_attachments" "FoggyKitchenWebserver1_VNIC1_attach" {
  provider = oci.requestor
  availability_domain = lookup(data.oci_identity_availability_domains.R-ADs.availability_domains[1], "name")
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  instance_id = oci_core_instance.FoggyKitchenWebserver1.id
}

data "oci_core_vnic" "FoggyKitchenWebserver1_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.FoggyKitchenWebserver1_VNIC1_attach.vnic_attachments.0.vnic_id
}

output "FoggyKitchenWebserver1_PrivateIP" {
   value = [data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.private_ip_address]
}
