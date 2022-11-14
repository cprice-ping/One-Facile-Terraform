output "release_env_id" {
    value = pingone_environment.release_environment.id
}

output "oidc_client_id" {
    value = pingone_application.oidc_login_app.id
}