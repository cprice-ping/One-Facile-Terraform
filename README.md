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
  * Sign-On-Policies
    * Single_Factor (DV)
    * Multi-Step (DV)
  * PingOne Application (OIDC)
    * OIDC Scopes ( `openid` | `email` | `profile` )
    * P1 API Scopes ( `p1:read:user` | `p1:update:user` | `p1:read:sessions` | `p1:delete:sessions` )
  * PingOne Application (SAML)
  * Sample User
    * `facileuser1@yourdomain.com`

## Variables

| Name | Description |
| --- | --- |
| `region` | PingOne Region ( NorthAmerica | Europe | Asia ) |
| `org_id` | PingOne Organization Id (located on Environment -> Properties)
| `admin_env_id` | PingOne Environment where Administration is managed |
| `admin_user_id` | PingOne Admin User (User -> API) |
| `worker_id` | PingOne Worker App (must have roles to create Environments \ Users \ Applications)
| `worker_secret` | PingOne Worker App secret |
| `env_name` | Name of the PingOne Environment to create |

## To Do

Things not yet placed into the config:

* PingOne MFA Policy
  * Method - SMS
  * Method - EMail

* PingOne SSO
  * Agreement

* DaVinci
  * Registration & SignOn
  * Progressive Profiling
  * Adaptive SignOn \ Passwordless
