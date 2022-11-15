output "release_env_id" {
    value = pingone_environment.release_environment.id
}

output "oidc_login_url" {
    value = "https://auth.pingone.${local.pingone_domain}/${pingone_environment.release_environment.id}/as/authorize?client_id=${pingone_application.oidc_login_app.id}"
}

output "saml_sso_url" {
    value = "https://auth.pingone${local.pingone_domain}/${pingone_environment.release_environment.id}/saml20/idp/startsso?spEntityId=urn:facile:saml"
}