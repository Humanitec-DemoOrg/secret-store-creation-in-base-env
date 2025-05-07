# secret-store-creation-in-base-env

This illustrates how a `SecretStore` in Kubernetes can be dynamically created via a `base-env` resource definition, using the `humanitec/container` driver.

_Important note: this is a POC, not Production ready._

First, you need to follow the instructions for the setup of your Container Runner here.

This setup is assuming that you have the Container Runner setup in the same cluster where your Workloads are deployed (and where the Humanitec Operator is, to access the `SecretStore` that you want to dynamically create).

Then, you will need to update this setup to have the associated KSA able to create a `SecretStore` in your cluster:
```bash
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: humanitec-runner
rules:
- apiGroups: ["humanitec.io"]
  resources: ["secretstores"]
  verbs: ["create", "get", "list", "update", "patch", "delete", "deletecollection", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: humanitec-runner
subjects:
- kind: ServiceAccount
  name: humanitec-runner
  namespace: humanitec-runner
roleRef:
  kind: ClusterRole
  name: humanitec-runner
  apiGroup: rbac.authorization.k8s.io
EOF
```

Finally configure your this `base-env` in your Humanitec Organization:
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

The only caveat at this stage is that if your Developers are referring to Shared Values&Secrets from their Score file, you will have this error:
```none

```
At this stage, the `SecretStore` is successfully created and the `SecretMapping` didn't wait for its creation, so if you re-run the deployment, it will successfully go through now.