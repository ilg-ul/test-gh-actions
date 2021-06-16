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

### ^8.16.x

This explicit semver was used instead of `8.x`, as suggested by the
documentation, as an workaround to a GitHub configuration problem
that offered an older version node on Windows.

- https://github.com/actions/setup-node/issues/27

For consistency, the other versions were updated to this syntax too.

## TODO

### Caches

Enable caching, in Travis and AppVeyor the `node_modules` was cached.

```
cache:
  directories:
    - node_modules # NPM packages
```

```
cache:
  - node_modules # NPM packages
```

### Skip tags

In Travis and AppVeyour commits related to tags were skipped:

```
branches:
  except:
    - /^v\d+\.\d+(\.\d+)?([-.]\d+)?$/
```

```
# Do not build on tags (GitHub and BitBucket)
skip_tags: true
```

### Notifications

In travis there were email notifications for success too:

```
# https://docs.travis-ci.com/user/notifications/#Configuring-email-notifications
notifications:
  email:
    on_success: always # default: change
    on_failure: always # default: always
```

### Git depth

In Travis and AppVeyour the depth was limited to 3.

```
# https://docs.travis-ci.com/user/customizing-the-build/#Git-Clone-Depth
git:
  # Limit the clone depth; default is 50.
  depth: 3
```

```
# set clone depth
clone_depth: 3  # clone entire repository history if not defined
```

Actions syntax:

```
    - name: Checkout
      uses: actions/checkout@v1
      with:
        fetch-depth: 3
```

