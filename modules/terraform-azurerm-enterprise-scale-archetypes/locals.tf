# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = {}
  empty_string = ""
}

# The following locals are used to convert basic input
# variables to locals before use elsewhere in the module
locals {
  root_id                = var.root_id
  scope_id               = var.scope_id
  archetype_id           = var.archetype_id
  archetype_parameters   = var.archetype_parameters
  archetype_library_path = var.archetype_library_path
  default_location       = var.default_location
}

# The following locals are used to define the built-in
# library path, and determine whether a custom library
# path has been provided to enable conditional logic on
# loading configuration files from the library path(s).
locals {
  builtin_library_path          = "${path.module}/lib"
  custom_library_path_specified = try(length(local.archetype_library_path) > 0, false)
  custom_library_path           = local.custom_library_path_specified ? replace(local.archetype_library_path, "//$/", "") : null
}

# The following locals are used to define base Azure
# provider paths and resource types
locals {
  scope_is_management_group = length(regexall("^/providers/Microsoft.Management/managementGroups/.*", local.scope_id)) > 0
  scope_is_subscription     = length(regexall("^/subscriptions/.*", local.scope_id)) > 0
  resource_types = {
    policy_assignment     = "Microsoft.Authorization/policyAssignments"
    policy_definition     = "Microsoft.Authorization/policyDefinitions"
    policy_set_definition = "Microsoft.Authorization/policySetDefinitions"
    role_assignment       = "Microsoft.Authorization/roleAssignments"
    role_definition       = "Microsoft.Authorization/roleDefinitions"
  }
  provider_path = {
    policy_assignment     = "${local.scope_id}/providers/Microsoft.Authorization/policyAssignments/"
    policy_definition     = "${local.scope_id}/providers/Microsoft.Authorization/policyDefinitions/"
    policy_set_definition = "${local.scope_id}/providers/Microsoft.Authorization/policySetDefinitions/"
    role_assignment       = "${local.scope_id}/providers/Microsoft.Authorization/roleAssignments/"
    role_definition       = "/providers/Microsoft.Authorization/roleDefinitions/"
  }
}
