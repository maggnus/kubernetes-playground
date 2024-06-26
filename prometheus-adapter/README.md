

Command to check if the custom metrics exists
```shell
	kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/*/http_requests?selector=app%3Dsample-app" | jq
```

Make pressure on the sample-app with http requests
```shell
brew install hey
# Requires port forwarding or exposing of the sample-app service
# Apply 10 requests per second for 10 minutes
hey -z 10m -q 10 http://localhost:8080/metrics
```