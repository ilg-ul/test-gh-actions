# GitHub Actions tests

GitHub Workflows, part of Actions, represent a GitHub integrated
solution to CI/CD, able to replace
the traditional Travis/AppVeyor tests.

The results of the tests are visible at:

- https://github.com/ilg-ul/test-gh-actions/actions

## Links

- https://help.github.com/en/actions
- https://github.com/actions
- https://github.com/actions/checkout
- https://github.com/actions/setup-node
- https://help.github.com/en/actions/automating-your-workflow-with-github-actions/configuring-a-workflow#adding-a-workflow-status-badge-to-your-repository
- https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners

## Notes

## npm/xpm actions

These are actions automatically triggered for commits.

Use a matrix of node versions and operating systems to run the tests.

### npm ^10.24.x

This explicit semver was used instead of `8.x`, as suggested by the
documentation, as an workaround to a GitHub configuration problem
that offered an older version node on Windows.

- https://github.com/actions/setup-node/issues/27

For consistency, the other versions were updated to this syntax too.

## Manually dispatched actions

These are actions triggered by an external event (like via a script
or in the GitHub web interface).

There are two kind of manually dispatched actions, workflow and repository.

### Authentication

- <https://docs.github.com/en/actions/reference/authentication-in-a-workflow>

The manually dispatched actions require an authorization token to be
passed in a header line.

It can be created in the user settings page -> Developper Settings -> 
Personal access tokens.

It needs the **workflow** scope to be enabled.

### Workflow dispatch actions

Used to trigger individual workflow actions. There can be multiple
actions defined, each with its own .yml file.

In addition to the .yml defaults, there can be custom inputs passed
via the triggering event, which also must pass the Git reference.

These actions respond to `workflow_dispatch` events and may have up to
10 inputs.

```yml
on:
  workflow_dispatch:
    inputs:
      name:
        description: 'Person to greet'
        required: true
        default: 'Mona the Octocat'
      home:
        description: 'location'
        required: false
        default: 'The Octoverse'
```

To trigger them, use a POST request to pass the mandatory **Git reference**
and possibly any additional **inputs**.

The **workflow-id** is the full file name (like `workflow-dispatch.yml`).

```sh
curl \
  --request POST \
  --include \
  --header "Authorization: token ${GITHUB_API_DISPATCH_TOKEN}" \
  --header "Content-Type: application/json" \
  --header "Accept: application/vnd.github.v3+json" \
  --data '{"ref": "master", "inputs": {"name": "Baburiba"}}' \
  https://api.github.com/repos/ilg-ul/test-gh-actions/actions/workflows/workflow-dispatch.yml/dispatches
```

References:

- <https://docs.github.com/en/developers/webhooks-and-events/webhooks/webhook-events-and-payloads#workflow_dispatch>
- <https://docs.github.com/en/rest/reference/actions#create-a-workflow-dispatch-event>

### Repository dispatch actions

Used to trigger repository related actions.

They respond to `repository_dispatch` events:

```sh
curl \
  --request POST \
  --include \
  --header "Authorization: token ${GITHUB_API_DISPATCH_TOKEN}" \
  --header "Content-Type: application/json" \
  --header "Accept: application/vnd.github.v3+json" \
  --data '{"event_type": "on-demand-test", "client_payload": {"key": "value"}}' \
  https://api.github.com/repos/ilg-ul/test-gh-actions/dispatches
```

References:

- <https://docs.github.com/en/developers/webhooks-and-events/webhooks/webhook-events-and-payloads#repository_dispatch>
- <https://docs.github.com/en/rest/reference/repos#create-a-repository-dispatch-event>

## Windows shell

On windows, the commands are started via the Power Shell:

```yml
shell: C:\Program Files\PowerShell\7\pwsh.EXE -command ". '{0}'"
```

However the Windows environemnt includes a bash from MSYS2, so to
execute bash scripts, start them explicitly with `bash`:

```yml
    - name: Say Hello
      run: bash test/scripts/hello.sh
```

## TODO

### Caches

Enable caching, in Travis and AppVeyor the `node_modules` was cached.

```yml
cache:
  directories:
    - node_modules # NPM packages
```

```yml
cache:
  - node_modules # NPM packages
```

### Skip tags

In Travis and AppVeyour commits related to tags were skipped:

```yml
branches:
  except:
    - /^v\d+\.\d+(\.\d+)?([-.]\d+)?$/
```

```yml
# Do not build on tags (GitHub and BitBucket)
skip_tags: true
```

### Notifications

In travis there were email notifications for success too:

```yml
# https://docs.travis-ci.com/user/notifications/#Configuring-email-notifications
notifications:
  email:
    on_success: always # default: change
    on_failure: always # default: always
```

### Git depth

In Travis and AppVeyour the depth was limited to 3.

```yml
# https://docs.travis-ci.com/user/customizing-the-build/#Git-Clone-Depth
git:
  # Limit the clone depth; default is 50.
  depth: 3
```

```yml
# set clone depth
clone_depth: 3  # clone entire repository history if not defined
```

Actions syntax:

```yml
    - name: Checkout
      uses: actions/checkout@v1
      with:
        fetch-depth: 3
```
