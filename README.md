# One-Facile-Terraform

Rework of One-Facile with Terrafom

## Terraform Config

This repo contains a set of HCL that builds out a set of [PingOne](https://www.pingidentity.com/en/try-ping.html) components to provide Identity services into an application.

The HCL configures the following:

* PingOne Environment
* PingOne SSO
  * Administrator Roles
    * ID Admin
    * Client Dev
  * PingOne Application (OIDC)
    * OIDC Scopes ( `openid` | `email` | `profile` )
    * P1 API Scopes ( `p1:read:user` | `p1:update:user` | `p1:read:sessions` | `p1:delete:sessions` )
  * Sample User
    * `facileuser1@yourdomain.com`

## To Do

Things not yet placed into the config:

* PingOne MFA Policy
  * Method - SMS
  * Method - EMail

* PingOne SSO
  * Application (SAML)
  * Agreement
  * Sign-On-Policies
    * Multi_Factor
    * Multi-Step (Progressive + Consent)

* DaVinci
  * Registration & SignOn
  * Progressive Profiling
  * Adaptive SignOn \ Passwordless
