# concourse-appcenter-resource
Concourse resource for distributing a build artifact to Microsoft [App Center](https://docs.microsoft.com/en-us/appcenter/distribution/uploading).

## Source configuration
- `api_token`: Required. Prepare API token to call App Center API and set here. See [how to get API token](https://docs.microsoft.com/en-us/appcenter/api-docs/index).
- `owner`: Required. The `owner_name` used in the URL for the API calls of App Center. See [the detail](https://docs.microsoft.com/en-us/appcenter/distribution/uploading#distributing-using-the-apis).
- `app_name`: Required. Your `app_name` used in the URL for the API calls of App Center. See [the detail](https://docs.microsoft.com/en-us/appcenter/distribution/uploading#distributing-using-the-apis).
- Distribute to group
  - `group_id`: Required. Group ID to [distribute group](https://docs.microsoft.com/ja-jp/appcenter/distribution/groups).
  - `mandatory_update`: Optional. (default value is false)
  - `notify_testers`: Optional. (default value is false)
- Distribute to testers
  - `email`: Required. Target tester's email
  - `mandatory_update`: Optional. (default value is false)
  - `notify_testers`: Optional. (default value is false)
- Distribute to store
  - `store_id`: Required.

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
- `binary_name`: Optional. The target binary file name to release. (default value is `app_name`)
- `release_notes`: Optional. File name of release notes.
- `path`: Optional. The path to a directory containing target files to release like binary or release_notes.

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
        release_notes: readme.md
```