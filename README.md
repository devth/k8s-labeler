# k8s-labeler

[![Code Climate](https://img.shields.io/codeclimate/issues/github/devth/k8s-labeler.svg?style=flat-square)](https://codeclimate.com/github/devth/k8s-labeler)
[![Docker Automated build](https://img.shields.io/docker/automated/devth/k8s-labeler.svg?style=flat-square)](https://hub.docker.com/r/devth/k8s-labeler/)

Intended to be used as an init container for a Kubernetes pod.

## Usage

The `KUBE_NAMESPACE` env var is **required**. This must match the namespace of
the pod you're running in.

Any env vars containing `KUBE_LABEL_` will be applied to the pod as labels via
the API. For example:

```bash
KUBE_LABEL_hostname=foobar
```

Would result in a label `hostname: foobar` on the pod.

This can be useful for setting properties from the [Downward
API](https://kubernetes.io/docs/tasks/configure-pod-container/environment-variable-expose-pod-information/)
as labels (e.g. exposing a unique label for each pod in a stateful).

## Run locally

```bash
./run.sh
```

## Kubernetes example

This init container sets a `hostname` label equal to the pod's name:

```yaml
initContainers:
  - image: devth/k8s-labeler
    name: labeler
    env:
      - name: KUBE_NAMESPACE
        valueFrom:
          fieldRef:
            fieldPath: metadata.namespace
      - name: KUBE_LABEL_hostname
        valueFrom:
          fieldRef:
            fieldPath: metadata.name
```

Inspect the pod with:

```bash
kubectl get pod -l app=myapp --show-labels

NAME                     READY     STATUS    RESTARTS   AGE       LABELS
myapp-2768796676-c702s   2/2       Running   0          25m       app=myapp,hostname=myapp-2768796676-c702s,pod-template-hash=2768796676
```

And notice that the `hostname=myapp-2768796676-c702s` label is present.

## License

Copyright 2017 Trevor C. Hartman

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
