# One-Facile-Terraform

Rework of One-Facile with Terrafom

## Terraform Config

This repo contains a set of HCL that builds out a set of [PingOne](https://www.pingidentity.com/en/try-ping.html) components to provide Identity services into an application.

The HCL configures the following:

* PingOne Environment
* PingOne SSO
  * MFA Policy (Methods)
  * MFA Sign-in Policy
  * PingOne Application (OIDC)
  * PingOne Application (SAML)
