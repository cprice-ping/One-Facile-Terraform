output "pingone_license" {
    value = data.pingone_licenses.internal_license.ids[0]
}