# concourse-appcenter-resource
Concourse resource for distributing a build artifacts to Microsoft [App Center](https://appcenter.ms/apps).

## Source configuration
- `api_token`: Required.
- `owner`: Required.
- `app_name`: Required.
- `group_id`: Required. Now only support releasing to group

### Example
```yaml
resource_types:
- name: appcenter
  type: docker-image
  source:
    repository: tomoyukim/concourse-appcenter-resource
    tag: latest

resources:
- name: distribtion
  type: appcenter
  source:
    api_token: aaa-bbb-ccc
    owner: your_owner_name
    app_name: your_app_name
    group_id: your_group_id
```
## Bahavior

### `check`: Not implemented
There is no `check` in this resource.

### `in`: Not implemented
There is not `in` in this resource.

### `out`: Release build artifact to App Center in your group

#### Parameters
- `binary_name`: Required. The target binary file name to release.
- `path`: Optional. The path to a directory containing target binary file to release.

#### Example
```yaml
jobs:
- name: archive
  plan:
    - get: my-master # git resource
      trigger: true
    - task: target-build
      config:
        platform: linux
        inputs:
          - name: my-master
        outputs:
          - name: artifact
        run:
          path: sh
          args:
            - -c
            - |
              (cd my-master/; make)
              cp -a my-master/* artifact
    - put: my-release
      inputs:
        - my-master
        - artifact
      params:
        path: artifact/
        binary_name: my_app.ipa
```