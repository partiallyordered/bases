A collection of Kustomize development bases. These are not production ready.

Usage example:

Create a `deployment.yaml` depending on Redis. Start small (try to keep it small!):
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: my-deployment
  template:
    metadata:
      labels:
        app.kubernetes.io/name: my-deployment
    spec:
      containers:
      - name: service
        image: my-deployment
        ports:
        - containerPort: 8080
```

Create a `kustomization.yaml` file:
```yaml
resources:
# Reference the Redis base. The ref is a git ref and can be a tag or sha256 commit checksum.
- github.com/partiallyordered/bases/redis?ref=34db86deae2eb621b0a4122bbe8229c4f5412519
# Reference deployment.yaml in our local directory
- deployment.yaml

# It's probably better to have my-deployment default to connecting to redis on redis:6379, but for
# the sake of demonstration here, we'll inject some environment variables. Here we use an RFC6902
# JSON patch. Scroll to the table of contents here: https://tools.ietf.org/html/rfc6902 - there are
# a list of examples at the end of the table of contents, in Appendix A.
#
# Kustomize also supports strategic merge patches. See the documentation here:
# https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patches/
patches:
- target:
    kind: Deployment
    name: my-deployment
  patch: |-
    - op: add
      path: /spec/template/spec/containers/0/env
      value:
      - name: REDIS_HOST
        value: redis:6379
```

Check the result with `kustomize build .`. Note `my-deployment` has an env var `REDIS_HOST` with
value `redis:6379`:
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/name: redis
  name: redis
spec:
  ports:
  - port: 6379
    targetPort: 6379
  selector:
    app.kubernetes.io/name: redis
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: my-deployment
  template:
    metadata:
      labels:
        app.kubernetes.io/name: my-deployment
    spec:
      containers:
      - env:
        - name: REDIS_HOST
          value: redis:6379
        image: my-deployment
        name: service
        ports:
        - containerPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: redis
  template:
    metadata:
      labels:
        app.kubernetes.io/name: redis
    spec:
      containers:
      - image: redis
        name: redis
        ports:
        - containerPort: 6379
```

Validate the result with [kubeval](https://github.com/instrumenta/kubeval):
```sh
$ kustomize build . | kubeval --strict
PASS - stdin contains a valid Service (redis)
PASS - stdin contains a valid Deployment (my-deployment)
PASS - stdin contains a valid Deployment (redis)
```
