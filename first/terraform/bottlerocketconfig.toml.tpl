[settings.kubernetes]
cluster-name = "${cluster_name}"
api-server = "${cluster_endpoint}"
cluster-certificate = "${cluster_ca_data}"
image-gc-high-threshold-percent = 80
image-gc-low-threshold-percent = 50

[settings.host-containers.admin]
enabled = true
