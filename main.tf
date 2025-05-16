resource "humanitec_resource_definition" "base_env" {
  driver_type = "humanitec/template"
  id          = "secret-store"
  name        = "secret-store"
  type        = "base-env"

  driver_inputs = {
    values_string = jsonencode({
      "templates" = {
        "init"      = <<END_OF_TEXT
namespace: $${resources['k8s-namespace#k8s-namespace'].outputs.namespace}
END_OF_TEXT
        "manifests" = <<END_OF_TEXT
secretstore.yaml:
  data:
    apiVersion: humanitec.io/v1alpha1
    kind: SecretStore
    metadata:
      name: {{ .init.namespace }}
    spec:
      gcpsm:
        auth: {}
        projectID: REDACTED-AND-SHOULD-COME-FROM-A-CONFIG-PATTERN
  location: namespace
END_OF_TEXT
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "base_env" {
  resource_definition_id = humanitec_resource_definition.base_env.id
  force_delete           = true
}
