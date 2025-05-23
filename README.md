**Repo now archived, officially supported there https://developer.humanitec.com/examples/resource-definitions/template-driver/secret-store/.**

# secret-store-creation-in-base-env

This illustrates how a `SecretStore` in Kubernetes can be dynamically created via a `base-env` resource definition, using the `humanitec/template` driver. This requires the Humanitec Operator container version v0.21.0.

Now officially supported and publicly documented: https://developer.humanitec.com/examples/resource-definitions/template-driver/secret-store/.

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
