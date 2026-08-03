# Node API with CI/CD on Oracle Cloud

A reference pipeline that takes a Node API from a `git push` to a running container on a cloud VM,
using GitHub Actions, Terraform, Ansible and Docker.

**The application is deliberately trivial** — an Express server that answers `Hello, World!` and tells
you which environment it's running in. The point of this repository is everything around it: the
infrastructure, the delivery and the separation between them.

Built as a generalization of the pipeline from my undergraduate thesis,
[Automated CI/CD in a REST API: a case study](https://bd.centro.iff.edu.br/jspui/bitstream/123456789/4685/1/Texto.pdf)
(in Portuguese), so I could reuse the setup on other projects. The original pipeline lives in
[community-spell-backend](https://github.com/tcc-processo-entrega-automatizada/community-spell-backend) —
there the infrastructure is destroyed and recreated on every delivery, instead of living in its own
manual workflow as it does here.

---

## The five workflows

| Workflow | Trigger | What it does |
|---|---|---|
| `tests-and-docker-image` | push + manual | Runs the test suite with Vitest. On `development` or `main`, builds the image and pushes it to Docker Hub with a branch-specific tag. |
| `create-dev-infra` | manual, `development` only | `terraform init → validate → plan → apply`, provisions the VM, exports the output and prints the public IP. |
| `config-vm` | manual, takes an `environment` input | Installs Ansible, writes the SSH key and runs the playbook matching the chosen environment (`production` or `development`). |
| `check-terraform-output` | push + manual | `terraform state list` and `state show`, to inspect what currently exists without touching it. |
| `destroy-dev-infra` | manual, `development` only | Tears the development infrastructure down. |

### Why infrastructure is separate from delivery

Creating and destroying infrastructure runs **manually and on its own workflow**, not on every push.
Only tests and the image build are automatic.

That's a deliberate change from the thesis pipeline, where a deploy destroyed and recreated the VM every
single time. That worked for demonstrating the concept, but it means every delivery pays for a full
provision and every delivery can fail on an infrastructure problem that has nothing to do with the code.
Here the two concerns are split: the VM is long-lived, and shipping a new version only pushes an image.

---

## The model-file pattern

Terraform needs a state backend address, provider credentials, OCIDs and SSH keys. None of that belongs
in a repository, but Terraform expects the files to exist.

So the sensitive files are committed as **models with placeholders**, and the workflow builds the real
ones at run time from GitHub Secrets:

```
terraform/main.model.tf          →  main.tf          (sed replaces <BACKEND_HTTP_ADDRESS>)
terraform/terraform.model.tfvars →  terraform.tfvars (written from secrets via heredoc)
docker-compose.yml               →  <IMAGE_NAME> replaced at deploy time
```

The provider private key and the SSH public key are written to disk during the job and referenced by
path. The result is that the repository is complete enough to read and reproduce, and contains no
credentials.

---

## Infrastructure

**Terraform** (`terraform/`) with the `oracle/oci` provider and **remote state over an HTTP backend**:

- `oci_core_instance` — an Ubuntu VM on the `VM.Standard.E2.1.Micro` shape, which fits Oracle Cloud's
  always-free tier
- public IP assigned through `create_vnic_details`
- SSH authorized key injected via instance `metadata`
- availability domain resolved from `oci_identity_availability_domains`
- `preserve_boot_volume = false`, so destroying really destroys

**Ansible** (`ansible/`) — one playbook per environment. Both update the apt cache, create the
application directory, install Docker and Docker Compose, start the service, add the `ubuntu` user to
the `docker` group and log in to Docker Hub so private images can be pulled.

**Docker** — a multi-stage `Dockerfile` on `node:20.5-alpine`: the first stage installs everything and
builds, the second copies only `build/` and installs with `--omit=dev`. The compose file publishes
`80:3000` and reads `.env.prod`.

---

## Running locally

```bash
npm install
npm run start:dev     # nodemon
npm test              # vitest
npm run lint
npm run start:build   # build and run the compiled output
```

A Dev Container is included, so you can open the project in a ready-made environment instead of
installing Node locally.

## Required secrets

To run the infrastructure workflows, configure these in the repository:

| Group | Secrets |
|---|---|
| State backend | `BACKEND_HTTP_ADDRESS` |
| OCI provider | `PROVIDER_TENANCY_OCID`, `PROVIDER_USER_OCID`, `PROVIDER_PRIVATE_KEY`, `PROVIDER_FINGERPRINT`, `PROVIDER_REGION` |
| Compute | `COMPUTE_COMPARTMENT_ID`, `COMPUTE_SOURCE_ID`, `COMPUTE_SUBNET_ID`, `COMPUTE_SSH_AUTHORIZED_KEY` |
| Registry | `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` |

---

## Notes

`main.model.tf` and `terraform.model.tfvars` are templates — the real `main.tf` and `terraform.tfvars`
are generated inside the workflow and never committed. If you fork this, start by filling in the
secrets table above; nothing else needs editing.

Dependabot is enabled for dependency updates.
