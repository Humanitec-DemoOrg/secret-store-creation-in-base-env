# secret-store-creation-in-base-env

This illustrates how a `SecretStore` in Kubernetes can be dynamically created via a `base-env` resource definition, using the `humanitec/template` driver. This requires the Humanitec Operator container version v0.21.0.

_Important note: this is a POC, not Production ready._

Configure this `base-env` in your Humanitec Organization:
```bash
export HUMANITEC_ORG=FIXME

humctl login

terraform init -upgrade

terraform plan \
    -var org_id=${HUMANITEC_ORG} \
    -out out.tfplan

terraform apply out.tfplan
```

When you will deploy your first deployment in a specific App/Env, the associated `SecretStore` will be created.

The only caveat at this stage is that if your Developers are referring to Shared Values&Secrets from their Score file in the very first deployment in this App/Env, they will have this error:
```none
Humanitec Operator error
secret mapping status: False. Reason: MappingError. Message: resolving secrets: creating secret store client for test-res-type-development: secret store test-res-type-development is not found in application and operator system namespaces
```

At this stage, the `SecretStore` is successfully created, but the `SecretMapping` didn't wait for its creation, so if you re-run the deployment, it will successfully go through now.