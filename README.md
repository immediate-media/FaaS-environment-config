# FaaS-environment-config
A Terraform module for deploying Lambda functions with an API gateway from an S3 bucket.

These branches are important:

- `master` - main production branch
- `develop` - original and default development branch
- `test` - Added for development of GoodFood Lambdas, but not merged (and currently used by production pipeline for deploying those Lambda functions).

Note: we need to merge the test branch eventually, it needs careful unpicking.

To aid this process we've added tags to commits on the `test` branch with a __tf__ suffix:

- 2.0.0gf - the point at which the `test` branch was in sync with `develop`.
- 2.0.1gf - the head of the `test` branch at the time of writing.

We can now swap to using _tag references_ in the consuming code instead of using the _branch name reference_ .
