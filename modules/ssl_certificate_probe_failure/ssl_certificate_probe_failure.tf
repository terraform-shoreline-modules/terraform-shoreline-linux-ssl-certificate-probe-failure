resource "shoreline_notebook" "ssl_certificate_probe_failure" {
  name       = "ssl_certificate_probe_failure"
  data       = file("${path.module}/data/ssl_certificate_probe_failure.json")
  depends_on = [shoreline_action.invoke_update_ssl_certificate]
}

resource "shoreline_file" "update_ssl_certificate" {
  name             = "update_ssl_certificate"
  input_file       = "${path.module}/data/update_ssl_certificate.sh"
  md5              = filemd5("${path.module}/data/update_ssl_certificate.sh")
  description      = "Update the SSL certificate for the affected instance and re-run the certificate probe to ensure that it is being recognized correctly."
  destination_path = "/agent/scripts/update_ssl_certificate.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_ssl_certificate" {
  name        = "invoke_update_ssl_certificate"
  description = "Update the SSL certificate for the affected instance and re-run the certificate probe to ensure that it is being recognized correctly."
  command     = "`chmod +x /agent/scripts/update_ssl_certificate.sh && /agent/scripts/update_ssl_certificate.sh`"
  params      = ["PATH_TO_NEW_SSL_CERTIFICATE_PRIVATE_KEY_FILE","INSTANCE_NAME_OR_IP_ADDRESS","PATH_TO_NEW_SSL_CERTIFICATE_FILE","SERVICE_OR_APPLICATION_NAME","OLD_CERTIFICATE_KEY_FILE","OLD_CERTIFICATE_FILE"]
  file_deps   = ["update_ssl_certificate"]
  enabled     = true
  depends_on  = [shoreline_file.update_ssl_certificate]
}

