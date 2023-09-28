resource "shoreline_notebook" "ssl_certificate_probe_failure" {
  name       = "ssl_certificate_probe_failure"
  data       = file("${path.module}/data/ssl_certificate_probe_failure.json")
  depends_on = [shoreline_action.invoke_ssl_cert_replace]
}

resource "shoreline_file" "ssl_cert_replace" {
  name             = "ssl_cert_replace"
  input_file       = "${path.module}/data/ssl_cert_replace.sh"
  md5              = filemd5("${path.module}/data/ssl_cert_replace.sh")
  description      = "Update the SSL certificate for the affected instance and re-run the certificate probe to ensure that it is being recognized correctly."
  destination_path = "/agent/scripts/ssl_cert_replace.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ssl_cert_replace" {
  name        = "invoke_ssl_cert_replace"
  description = "Update the SSL certificate for the affected instance and re-run the certificate probe to ensure that it is being recognized correctly."
  command     = "`chmod +x /agent/scripts/ssl_cert_replace.sh && /agent/scripts/ssl_cert_replace.sh`"
  params      = ["INSTANCE_NAME_OR_IP_ADDRESS","OLD_CERTIFICATE_FILE","SERVICE_OR_APPLICATION_NAME","OLD_CERTIFICATE_KEY_FILE","PATH_TO_NEW_SSL_CERTIFICATE_PRIVATE_KEY_FILE","PATH_TO_NEW_SSL_CERTIFICATE_FILE"]
  file_deps   = ["ssl_cert_replace"]
  enabled     = true
  depends_on  = [shoreline_file.ssl_cert_replace]
}

