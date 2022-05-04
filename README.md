# cg-demo-pipeline

This repo illustrates a simple concourse pipeline for executing database tests in cloudfoundry.

## Install

As a starter for your own use this repo as a template. Find the `Use this template` button above to create a copy of the repo.

## Usage

- Insert or update the sensitive variables to credhub commented out in `pipeline-config.yml`
- Create the concourse pipeline:

```sh
fly -t prod set-pipeline -p ${pipeline_name} -c ./pipeline.yml -l ./pipeline-config.yml
```

- Head over to concourse to see what the pipeline is doing, and start it if it hasnt already begun.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
