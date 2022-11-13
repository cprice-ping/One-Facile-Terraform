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

resource "pingone_environment" "release_environment" {
  name        = var.env_name
  description = "Created by Terraform"
  type        = "PRODUCTION"
  license_id  = data.pingone_licenses.internal_license.ids[0]

  default_population {}
  service {
    type = "SSO"
  }
  service {
    type = "MFA"
  }
  service {
    type = "Risk"
  }
  # service {
  #   type = "Authorize"
  # }
  service {
    type = "DaVinci"
  }
}

# Get Resource IDs used in OIDC Applications
data "pingone_resource" "openid_resource" {
  environment_id = pingone_environment.release_environment.id

  name = "openid"
}

data "pingone_resource" "pingone_resource" {
  environment_id = pingone_environment.release_environment.id

  name = "PingOne API"
}

data "pingone_resource_scope" "openid_email" {
  environment_id = pingone_environment.release_environment.id
  resource_id    = data.pingone_resource.openid_resource.id

  name = "email"
}

data "pingone_resource_scope" "openid_profile" {
  environment_id = pingone_environment.release_environment.id
  resource_id    = data.pingone_resource.openid_resource.id

  name = "profile"
}

data "pingone_resource_scope" "pingone_read_user" {
  environment_id = pingone_environment.release_environment.id
  resource_id    = data.pingone_resource.openid_resource.id

  name = "p1:read:user"
}

resource "pingone_application" "oidc_login_app" {
  environment_id = pingone_environment.release_environment.id
  name           = "OIDC Login"
  enabled        = true

  oidc_options {
    type                        = "WEB_APP"
    grant_types                 = ["AUTHORIZATION_CODE", "REFRESH_TOKEN"]
    response_types              = ["CODE"]
    token_endpoint_authn_method = "CLIENT_SECRET_BASIC"
    redirect_uris               = ["https://decoder.pingidentity.cloud/oidc", "https://decoder.pingidentity.cloud/hybrid"]
  }
}

resource "pingone_application_resource_grant" "oidc_scopes" {
  environment_id = pingone_environment.release_environment.id
  application_id = pingone_application.oidc_login_app.id

  resource_id = data.pingone_resource.openid_resource.id

  scopes = [
    data.pingone_resource_scope.openid_email.id,
    data.pingone_resource_scope.openid_profile.id
  ]
}

resource "pingone_application_resource_grant" "pingone_scopes" {
  environment_id = pingone_environment.release_environment.id
  application_id = pingone_application.oidc_login_app.id

  resource_id = data.pingone_resource.pingone_resource.id

  scopes = [
    data.pingone_resource_scope.pingone_read_user.id
  ]
}