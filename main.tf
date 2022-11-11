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

resource "pingone_environment" "release_environment" {
  name        = var.deploy_name
  description = "Created by Terraform"
  type        = "PRODUCTION"
  license_id  = var.license_id
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
  # service {
  #   type= "Fraud"
  # }
}

resource "pingone_application" "login_app" {
  environment_id = pingone_environment.release_environment.id
  name           = var.app_client_name
  enabled        = true

  oidc_options {
    type                        = "WEB_APP"
    grant_types                 = ["AUTHORIZATION_CODE", "REFRESH_TOKEN"]
    response_types              = ["CODE"]
    token_endpoint_authn_method = "CLIENT_SECRET_BASIC"
    redirect_uris               = var.app_redirect_uris
  }
}

# resource "pingone_custom_domain" "custom_domain" {
#   environment_id = pingone_environment.release_environment.id

#   domain_name = "login.${var.dns_domain_name}"
# }

# resource "pingone_custom_domain_verify" "custom_domain" {
#   environment_id = pingone_environment.release_environment.id

#   custom_domain_id = pingone_custom_domain.custom_domain.id

#   depends_on = [
#     dnsimple_zone_record.prettierbaby_login
#   ]
# }

# resource "pingone_custom_domain_ssl" "custom_domain" {
#   environment_id = pingone_environment.release_environment.id

#   custom_domain_id = pingone_custom_domain.custom_domain.id

#   certificate_pem_file               = acme_certificate.certificate.certificate_pem
#   intermediate_certificates_pem_file = acme_certificate.certificate.issuer_pem
#   private_key_pem_file               = acme_certificate.certificate.private_key_pem

#   depends_on = [
#     pingone_custom_domain_verify.custom_domain
#   ]
# }