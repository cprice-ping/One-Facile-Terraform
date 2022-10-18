# output "authz_url" {
#   value = "https://auth.pingone.com/v1/environments/${pingone_environment.youniverse_migrations.id}/as"
# }

# output "client_id" {
#   value = pingone_application.login_app.id
# }

# output "client_secret" {
#   value     = pingone_application.login_app.oidc_options[0].client_secret
#   sensitive = true
# }

# output "dns_zone_id" {
#   value     = data.dnsimple_zone.prettierbaby.id
#   sensitive = false
# }

# output "custom_domain" {
#   value     = pingone_custom_domain.custom_domain.canonical_name
#   sensitive = false
# }

# output "certificate" {
#   value     = acme_certificate.certificate
#   sensitive = true
# }

# output "ingress" {
#   value = kubernetes_ingress_v1.package_ingress.status.0.load_balancer.0.ingress.0.hostname
# }

# output "bxterraform" {
#   value = kubernetes_deployment.sample_app
# }