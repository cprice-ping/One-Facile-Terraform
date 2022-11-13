# One-Facile-Terraform

Rework of One-Facile with Terrafom

## Terraform Config

This repo contains a set of HCL that builds out a set of [PingOne](https://www.pingidentity.com/en/try-ping.html) components to provide Identity services into an application.

The HCL configures the following:

* PingOne Environment
* PingOne SSO
  * PingOne Application (OIDC)

## To Do

Things not yet placed into the config:

* PingOne MFA Policy
  * Method - SMS
  * Method - EMail

* PingOne SSO
  * Sample User
  * Application (SAML)
  * Agreement
  * Sign-On-Policies
    * Multi_Factor
    * Multi-Step (Progressive + Consent)
