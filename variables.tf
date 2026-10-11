variable "gkeonprem_bare_metal_admin_clusters" {
  description = <<EOT
Map of gkeonprem_bare_metal_admin_clusters, attributes below
Required:
    - location
    - name
Optional:
    - annotations
    - bare_metal_version
    - description
    - project
    - cluster_operations (block):
        - enable_application_logs (optional)
    - control_plane (block):
        - api_server_args (optional, block):
            - argument (required)
            - value (required)
        - control_plane_node_pool_config (required, block):
            - node_pool_config (required, block):
                - labels (optional)
                - node_configs (optional, block):
                    - labels (optional)
                    - node_ip (optional)
                - operating_system (optional)
                - taints (optional, block):
                    - effect (optional)
                    - key (optional)
                    - value (optional)
    - load_balancer (block):
        - bgp_lb_config (optional, block):
            - address_pools (optional, block):
                - addresses (optional)
                - avoid_buggy_ips (optional)
                - manual_assign (optional)
                - pool (optional)
            - asn (optional)
            - bgp_peer_configs (optional, block):
                - asn (optional)
                - control_plane_nodes (optional)
                - ip_address (optional)
            - load_balancer_node_pool_config (optional, block):
                - node_pool_config (optional, block):
                    - kubelet_config (optional, block):
                        - registry_burst (optional)
                        - registry_pull_qps (optional)
                        - serialize_image_pulls_disabled (optional)
                    - labels (optional)
                    - node_configs (optional, block):
                        - labels (optional)
                        - node_ip (optional)
                    - operating_system (optional)
                    - taints (optional, block):
                        - effect (optional)
                        - key (optional)
                        - value (optional)
        - manual_lb_config (optional, block):
            - enabled (required)
        - port_config (required, block):
            - control_plane_load_balancer_port (required)
        - vip_config (required, block):
            - control_plane_vip (required)
    - maintenance_config (block):
        - maintenance_address_cidr_blocks (required)
    - network_config (block):
        - advanced_networking (optional)
        - island_mode_cidr (optional, block):
            - pod_address_cidr_blocks (required)
            - service_address_cidr_blocks (required)
        - multiple_network_interfaces_config (optional, block):
            - enabled (optional)
    - node_access_config (block):
        - login_user (optional)
    - node_config (block):
        - max_pods_per_node (optional)
    - proxy (block):
        - no_proxy (optional)
        - uri (required)
    - security_config (block):
        - authorization (optional, block):
            - admin_users (required, block):
                - username (required)
    - storage (block):
        - lvp_node_mounts_config (required, block):
            - path (required)
            - storage_class (required)
        - lvp_share_config (required, block):
            - lvp_config (required, block):
                - path (required)
                - storage_class (required)
            - shared_path_pv_count (optional)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    location           = string
    name               = string
    annotations        = optional(map(string))
    bare_metal_version = optional(string)
    description        = optional(string)
    project            = optional(string)
    cluster_operations = optional(object({
      enable_application_logs = optional(bool)
    }))
    control_plane = optional(object({
      api_server_args = optional(list(object({
        argument = string
        value    = string
      })))
      control_plane_node_pool_config = object({
        node_pool_config = object({
          labels = optional(map(string))
          node_configs = optional(list(object({
            labels  = optional(map(string))
            node_ip = optional(string)
          })))
          operating_system = optional(string)
          taints = optional(list(object({
            effect = optional(string)
            key    = optional(string)
            value  = optional(string)
          })))
        })
      })
    }))
    load_balancer = optional(object({
      bgp_lb_config = optional(object({
        address_pools = optional(list(object({
          addresses       = optional(list(string))
          avoid_buggy_ips = optional(bool)
          manual_assign   = optional(bool)
          pool            = optional(string)
        })))
        asn = optional(number)
        bgp_peer_configs = optional(list(object({
          asn                 = optional(number)
          control_plane_nodes = optional(list(string))
          ip_address          = optional(string)
        })))
        load_balancer_node_pool_config = optional(object({
          node_pool_config = optional(object({
            kubelet_config = optional(object({
              registry_burst                 = optional(number)
              registry_pull_qps              = optional(number)
              serialize_image_pulls_disabled = optional(bool)
            }))
            labels = optional(map(string))
            node_configs = optional(list(object({
              labels  = optional(map(string))
              node_ip = optional(string)
            })))
            operating_system = optional(string)
            taints = optional(list(object({
              effect = optional(string)
              key    = optional(string)
              value  = optional(string)
            })))
          }))
        }))
      }))
      manual_lb_config = optional(object({
        enabled = bool
      }))
      port_config = object({
        control_plane_load_balancer_port = number
      })
      vip_config = object({
        control_plane_vip = string
      })
    }))
    maintenance_config = optional(object({
      maintenance_address_cidr_blocks = list(string)
    }))
    network_config = optional(object({
      advanced_networking = optional(bool)
      island_mode_cidr = optional(object({
        pod_address_cidr_blocks     = list(string)
        service_address_cidr_blocks = list(string)
      }))
      multiple_network_interfaces_config = optional(object({
        enabled = optional(bool)
      }))
    }))
    node_access_config = optional(object({
      login_user = optional(string)
    }))
    node_config = optional(object({
      max_pods_per_node = optional(number)
    }))
    proxy = optional(object({
      no_proxy = optional(list(string))
      uri      = string
    }))
    security_config = optional(object({
      authorization = optional(object({
        admin_users = list(object({
          username = string
        }))
      }))
    }))
    storage = optional(object({
      lvp_node_mounts_config = object({
        path          = string
        storage_class = string
      })
      lvp_share_config = object({
        lvp_config = object({
          path          = string
          storage_class = string
        })
        shared_path_pv_count = optional(number)
      })
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.gkeonprem_bare_metal_admin_clusters : (
        v.security_config == null || (v.security_config.authorization == null || (length(v.security_config.authorization.admin_users) >= 1))
      )
    ])
    error_message = "Each admin_users list must contain at least 1 items"
  }
  # Note: 1 additional provider-side validator is enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

