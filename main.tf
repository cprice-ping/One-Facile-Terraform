terraform {
  required_providers {
    pingone = {
      source = "pingidentity/pingone"
      # version = "~> 0.4"
    }
  }
}

provider "pingone" {
  client_id                    = var.worker_id
  client_secret                = var.worker_secret
  environment_id               = var.admin_env_id
  region                       = var.region
  force_delete_production_type = false
}

data "pingone_licenses" "internal_license" {
  organization_id = var.org_id

  data_filter {
    name   = "package"
    values = ["INTERNAL"]
  }

  data_filter {
    name   = "status"
    values = ["ACTIVE"]
  }
}

# resource "pingone_environment" "release_environment" {
#   name        = var.env_name
#   description = "Created by Terraform"
#   type        = "PRODUCTION"
#   license_id  = data.pingone_licenses.internal_license.id

#   default_population {}
#   service {
#     type = "SSO"
#   }
#   service {
#     type = "MFA"
#   }
#   service {
#     type = "Risk"
#   }
#   # service {
#   #   type = "Authorize"
#   # }
#   service {
#     type = "DaVinci"
#   }
# }

# resource "pingone_application" "oidc_login_app" {
#   environment_id = pingone_environment.release_environment.id
#   name           = "OIDC Login"
#   enabled        = true

#   oidc_options {
#     type                        = "WEB_APP"
#     grant_types                 = ["AUTHORIZATION_CODE", "REFRESH_TOKEN"]
#     response_types              = ["CODE"]
#     token_endpoint_authn_method = "CLIENT_SECRET_BASIC"
#     redirect_uris               = ["https://decoder.pingidentity.cloud/oidc", "https://decoder.pingidentity.cloud/hybrid"]
#   }
# }