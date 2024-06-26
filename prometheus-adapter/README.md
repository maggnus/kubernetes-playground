## Prometheus Adapter
Deploy the stack
```shell
make up
make prometheus-adapter-up
```
Command to check if the custom metrics exist
```shell
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/*/http_requests?selector=app%3Dsample-app" | jq
{
  "kind": "MetricValueList",
  "apiVersion": "custom.metrics.k8s.io/v1beta1",
  "metadata": {},
  "items": [
    {
      "describedObject": {
        "kind": "Pod",
        "namespace": "default",
        "name": "sample-app-cd788d85d-dt9vq",
        "apiVersion": "/v1"
      },
      "metricName": "http_requests",  <== metric name
      "timestamp": "2024-06-26T07:07:06Z",
      "value": "66m",                 <== metric value
      "selector": null
    }
  ]
}
```

Make pressure on the `sample-app` with the http requests
```shell
brew install hey
# Requires port forwarding or exposing of the sample-app service
# Apply 10 requests per second for 10 minutes
hey -z 10m -q 10 http://localhost:8080/metrics
```