resource "google_gkeonprem_bare_metal_admin_cluster" "gkeonprem_bare_metal_admin_clusters" {
  for_each = var.gkeonprem_bare_metal_admin_clusters

  location           = each.value.location
  name               = each.value.name
  annotations        = each.value.annotations
  bare_metal_version = each.value.bare_metal_version
  description        = each.value.description
  project            = each.value.project

  dynamic "cluster_operations" {
    for_each = each.value.cluster_operations != null ? [each.value.cluster_operations] : []
    content {
      enable_application_logs = cluster_operations.value.enable_application_logs
    }
  }

  dynamic "control_plane" {
    for_each = each.value.control_plane != null ? [each.value.control_plane] : []
    content {
      dynamic "api_server_args" {
        for_each = control_plane.value.api_server_args != null ? control_plane.value.api_server_args : []
        content {
          argument = api_server_args.value.argument
          value    = api_server_args.value.value
        }
      }
      control_plane_node_pool_config {
        node_pool_config {
          labels = control_plane.value.control_plane_node_pool_config.node_pool_config.labels
          dynamic "node_configs" {
            for_each = control_plane.value.control_plane_node_pool_config.node_pool_config.node_configs != null ? control_plane.value.control_plane_node_pool_config.node_pool_config.node_configs : []
            content {
              labels  = node_configs.value.labels
              node_ip = node_configs.value.node_ip
            }
          }
          operating_system = control_plane.value.control_plane_node_pool_config.node_pool_config.operating_system
          dynamic "taints" {
            for_each = control_plane.value.control_plane_node_pool_config.node_pool_config.taints != null ? control_plane.value.control_plane_node_pool_config.node_pool_config.taints : []
            content {
              effect = taints.value.effect
              key    = taints.value.key
              value  = taints.value.value
            }
          }
        }
      }
    }
  }

  dynamic "load_balancer" {
    for_each = each.value.load_balancer != null ? [each.value.load_balancer] : []
    content {
      dynamic "bgp_lb_config" {
        for_each = load_balancer.value.bgp_lb_config != null ? [load_balancer.value.bgp_lb_config] : []
        content {
          dynamic "address_pools" {
            for_each = bgp_lb_config.value.address_pools != null ? bgp_lb_config.value.address_pools : []
            content {
              addresses       = address_pools.value.addresses
              avoid_buggy_ips = address_pools.value.avoid_buggy_ips
              manual_assign   = address_pools.value.manual_assign
              pool            = address_pools.value.pool
            }
          }
          asn = bgp_lb_config.value.asn
          dynamic "bgp_peer_configs" {
            for_each = bgp_lb_config.value.bgp_peer_configs != null ? bgp_lb_config.value.bgp_peer_configs : []
            content {
              asn                 = bgp_peer_configs.value.asn
              control_plane_nodes = bgp_peer_configs.value.control_plane_nodes
              ip_address          = bgp_peer_configs.value.ip_address
            }
          }
          dynamic "load_balancer_node_pool_config" {
            for_each = bgp_lb_config.value.load_balancer_node_pool_config != null ? [bgp_lb_config.value.load_balancer_node_pool_config] : []
            content {
              dynamic "node_pool_config" {
                for_each = load_balancer_node_pool_config.value.node_pool_config != null ? [load_balancer_node_pool_config.value.node_pool_config] : []
                content {
                  dynamic "kubelet_config" {
                    for_each = node_pool_config.value.kubelet_config != null ? [node_pool_config.value.kubelet_config] : []
                    content {
                      registry_burst                 = kubelet_config.value.registry_burst
                      registry_pull_qps              = kubelet_config.value.registry_pull_qps
                      serialize_image_pulls_disabled = kubelet_config.value.serialize_image_pulls_disabled
                    }
                  }
                  labels = node_pool_config.value.labels
                  dynamic "node_configs" {
                    for_each = node_pool_config.value.node_configs != null ? node_pool_config.value.node_configs : []
                    content {
                      labels  = node_configs.value.labels
                      node_ip = node_configs.value.node_ip
                    }
                  }
                  operating_system = node_pool_config.value.operating_system
                  dynamic "taints" {
                    for_each = node_pool_config.value.taints != null ? node_pool_config.value.taints : []
                    content {
                      effect = taints.value.effect
                      key    = taints.value.key
                      value  = taints.value.value
                    }
                  }
                }
              }
            }
          }
        }
      }
      dynamic "manual_lb_config" {
        for_each = load_balancer.value.manual_lb_config != null ? [load_balancer.value.manual_lb_config] : []
        content {
          enabled = manual_lb_config.value.enabled
        }
      }
      port_config {
        control_plane_load_balancer_port = load_balancer.value.port_config.control_plane_load_balancer_port
      }
      vip_config {
        control_plane_vip = load_balancer.value.vip_config.control_plane_vip
      }
    }
  }

  dynamic "maintenance_config" {
    for_each = each.value.maintenance_config != null ? [each.value.maintenance_config] : []
    content {
      maintenance_address_cidr_blocks = maintenance_config.value.maintenance_address_cidr_blocks
    }
  }

  dynamic "network_config" {
    for_each = each.value.network_config != null ? [each.value.network_config] : []
    content {
      advanced_networking = network_config.value.advanced_networking
      dynamic "island_mode_cidr" {
        for_each = network_config.value.island_mode_cidr != null ? [network_config.value.island_mode_cidr] : []
        content {
          pod_address_cidr_blocks     = island_mode_cidr.value.pod_address_cidr_blocks
          service_address_cidr_blocks = island_mode_cidr.value.service_address_cidr_blocks
        }
      }
      dynamic "multiple_network_interfaces_config" {
        for_each = network_config.value.multiple_network_interfaces_config != null ? [network_config.value.multiple_network_interfaces_config] : []
        content {
          enabled = multiple_network_interfaces_config.value.enabled
        }
      }
    }
  }

  dynamic "node_access_config" {
    for_each = each.value.node_access_config != null ? [each.value.node_access_config] : []
    content {
      login_user = node_access_config.value.login_user
    }
  }

  dynamic "node_config" {
    for_each = each.value.node_config != null ? [each.value.node_config] : []
    content {
      max_pods_per_node = node_config.value.max_pods_per_node
    }
  }

  dynamic "proxy" {
    for_each = each.value.proxy != null ? [each.value.proxy] : []
    content {
      no_proxy = proxy.value.no_proxy
      uri      = proxy.value.uri
    }
  }

  dynamic "security_config" {
    for_each = each.value.security_config != null ? [each.value.security_config] : []
    content {
      dynamic "authorization" {
        for_each = security_config.value.authorization != null ? [security_config.value.authorization] : []
        content {
          dynamic "admin_users" {
            for_each = authorization.value.admin_users
            content {
              username = admin_users.value.username
            }
          }
        }
      }
    }
  }

  dynamic "storage" {
    for_each = each.value.storage != null ? [each.value.storage] : []
    content {
      lvp_node_mounts_config {
        path          = storage.value.lvp_node_mounts_config.path
        storage_class = storage.value.lvp_node_mounts_config.storage_class
      }
      lvp_share_config {
        lvp_config {
          path          = storage.value.lvp_share_config.lvp_config.path
          storage_class = storage.value.lvp_share_config.lvp_config.storage_class
        }
        shared_path_pv_count = storage.value.lvp_share_config.shared_path_pv_count
      }
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

