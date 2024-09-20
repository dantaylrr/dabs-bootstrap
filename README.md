# Scalable Databricks Asset Bundles (DABs) mono-repo.

This project aims to give users an idea of how you can structure your DABs git repositories in a scalable & effective manner, as well as some general best practices & CI/CD examples.

**This repo is only intended to be used for demonstrative purposes. Myself & Databricks are not liable for any short-comings in this project.**

## Getting started

1\. Install the Databricks CLI from https://docs.databricks.com/dev-tools/cli/databricks-cli.html

2a. Authenticate to your Sandbox / Development workspace, if you have not done so already:
   ```
   $ databricks configure
   ```

2b. Setup your default Databricks profile in `.databrickscfg` so that any validation & deployment requests are made against that workspace:
   ```
   host = <you_workspace_uri>
   serverless_compute_id = auto
   token = <your_personal_access_token>
   ```

**Note:** it is advised that you use serverless compute where possible to run your tests, this provides the shortest feedback loop for development. If you want to use an interactive cluster instead, remove the `serverless_compute_id = auto` flag & replace it with the `cluster_id = <your_cluster_id>` flag.

3\. Setup your local environment for development purposes by running:
   ```
   make setup
   ```
This creates a local python virtual environment & installs all project dependencies, it also installs `pre-commit` hooks, these are entirely optional.

4\. Verify that your environment is correctly configured by running:

   ```
   make test
   ```

This will run all package tests defined in `./tests/` remotely in your Databricks workspace on serverless or interactive compute, depending on which you have specified. Alternatively, you _could_ run this locally by containerising spark & integrating it to run your tests.

5\. To deploy a development copy of this project, type:
   ```
   $ databricks bundle deploy --target dev
   ```
(Note that "dev" is the default target, so the `--target` parameter is optional here.)

This deploys everything that's defined for this project.
For example, the default template would deploy a job called
`[dev yourname] my_project_job` to your workspace.
You can find that job by opening your workpace and clicking on **Workflows**.

## Intended Usage.

The intended workflow for this project / demo looks something like the following:

1\. Contributors branch off of the remote staging branch for their new features.

2\. As contributors make their development changes locally on this new branch, they can run their tests either locally or in their remote sandbox / development Databricks workspace using a compute resource of their choice & on a DBR of their choice.

3\. Contributors can also deploy their changes to this sandbox / development workspace for integrated testing & to run jobs or workflows if they want to.

4\. Once the contributor is happy with their changes, they can commit their changes up to the remote feature branch & open a PR.

5\. Upon merge into the `staging` branch, the github workflow defined at `.github/workflows` will run the same tests, validation & deployment in a controlled environment & using a service principle. This will deploy all changes to the staging workspace.

6\. Once the deployment has succeeded & further testing in staging has been done, the same process is carried out to deploy into production (this is still to be done).

## Current limitations (internal usage).

* You cannot deploy from github actions outside of a self-hosted runner, as `E2-Demo-Field-Eng` does not allow for remote deployments outside of the companies' VPN.
