resource "humanitec_resource_definition" "base_env" {
  driver_type = "humanitec/container"
  id          = "secret-store"
  name        = "secret-store"
  type        = "base-env"

  driver_inputs = {
    values_string = jsonencode({
      job = {
        image = "bitnami/kubectl:latest"
        command = [
          "/bin/sh",
          "/home/runneruser/workspace/run.sh"
        ]
        shared_directory = "/home/runneruser/workspace"
        namespace        = "humanitec-runner"
        service_account  = "humanitec-runner"
      }
      cluster = {
        account = "REDACTED"
        cluster = {
          name         = "REDACTED"
          project_id   = "REDACTED"
          zone         = "REDACTED"
          cluster_type = "gke"
        }
      }
      files = {
        "run.sh"            = file("${path.module}/run-kubectl.sh")
        "secret-store.yaml" = file("${path.module}/secret-store.yaml")
      }
    })
    secret_refs = jsonencode({
      cluster = {
        agent_url = {
          value = "$${resources['agent.default#agent'].outputs.url}"
        }
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "base_env" {
  resource_definition_id = humanitec_resource_definition.base_env.id
  force_delete           = true
}
