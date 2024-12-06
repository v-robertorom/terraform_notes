# Why to use IaC (Infrastructure as code)?

It's used to automate your deployments, increase confidence in your deployments, and increase efficiency and repeatability.

# Common scenarios

- Deployments of new applications for internal teams and customers.
- Multiple region deployments to support your customers and partners around the world.
- Multiple environment deployments to ensure consistency.

**Idempotence** is a term associated with infrastructure as code. This means that each run the same result is returned. This is done to avoid configuration drift. **Azure CLI** follows this practice. If for example you create a new resource group with CLI and you run the same command no duplicate resource group will be created or error message will be shown.

When using Terraform you can redeploy your environment each time you release a solution



