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

# Grant Roles to Admin User
data "pingone_role" "identity_data_admin" {
  name = "Identity Data Admin"
}

data "pingone_role" "client_application_developer" {
  name = "Client Application Developer"
}

resource "pingone_role_assignment_user" "id_admin" {
  environment_id = var.admin_env_id
  user_id        = var.admin_user_id
  role_id        = data.pingone_role.identity_data_admin.id

  scope_environment_id = pingone_environment.release_environment.id
}

resource "pingone_role_assignment_user" "app_dev" {
  environment_id = var.admin_env_id
  user_id        = var.admin_user_id
  role_id        = data.pingone_role.client_application_developer.id

  scope_environment_id = pingone_environment.release_environment.id
}

# Create OIDC Application
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

# Collect OIDC Scopes
data "pingone_resource" "openid_resource" {
  environment_id = pingone_environment.release_environment.id

  name = "openid"
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

# Collect PingOne API scopes
data "pingone_resource" "pingone_resource" {
  environment_id = pingone_environment.release_environment.id

  name = "PingOne API"
}

data "pingone_resource_scope" "pingone_read_user" {
  environment_id = pingone_environment.release_environment.id
  resource_id    = data.pingone_resource.pingone_resource.id

  name = "p1:read:user"
}

data "pingone_resource_scope" "pingone_update_user" {
  environment_id = pingone_environment.release_environment.id
  resource_id    = data.pingone_resource.pingone_resource.id

  name = "p1:update:user"
}

data "pingone_resource_scope" "pingone_read_sessions" {
  environment_id = pingone_environment.release_environment.id
  resource_id    = data.pingone_resource.pingone_resource.id

  name = "p1:read:sessions"
}

data "pingone_resource_scope" "pingone_delete_sessions" {
  environment_id = pingone_environment.release_environment.id
  resource_id    = data.pingone_resource.pingone_resource.id

  name = "p1:delete:sessions"
}

# Apply Scopes to OIDC App
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
    data.pingone_resource_scope.pingone_read_user.id,
    data.pingone_resource_scope.pingone_update_user.id,
    data.pingone_resource_scope.pingone_read_sessions.id,
    data.pingone_resource_scope.pingone_delete_sessions.id
  ]
}

# Add SAML Application
resource "pingone_application" "saml_login_app" {
  environment_id = pingone_environment.release_environment.id
  name           = "SAML Login"
  enabled        = true

  saml_options {
    acs_urls           = ["https://decoder.pingidentity.cloud"]
    assertion_duration = 3600
    sp_entity_id       = "urn:facile:saml"
  }
}

# Add Sample User to Default Population
resource "pingone_user" "one_facile_user" {
  environment_id = pingone_environment.release_environment.id

  population_id = pingone_environment.release_environment.default_population_id

  username = "facileuser1"
  email    = "facileuser1@yourdomain.com"
}

# Create Sign-On Policies
## Multi_Step ( Login | Progressive Profiling )
resource "pingone_sign_on_policy" "multi_step" {
  environment_id = pingone_environment.release_environment.id

  name        = "Multi_Step"
  description = "Multi-step policy - login with progressive profiling"
}

resource "pingone_sign_on_policy_action" "my_policy_first_factor" {
  environment_id    = pingone_environment.release_environment.id
  sign_on_policy_id = pingone_sign_on_policy.multi_step.id

  priority = 1

  conditions {
    last_sign_on_older_than_seconds = 604800 // 7 days
  }

  login {
    recovery_enabled = true
  }
}

resource "pingone_sign_on_policy_action" "my_policy_progressive_profiling" {
  environment_id    = pingone_environment.release_environment.id
  sign_on_policy_id = pingone_sign_on_policy.multi_step.id

  priority = 2

  progressive_profiling {

    attribute {
      name     = "name.given"
      required = false
    }

    attribute {
      name     = "name.family"
      required = true
    }

    prompt_text = "For the best experience, we need a couple things from you."

  }
}