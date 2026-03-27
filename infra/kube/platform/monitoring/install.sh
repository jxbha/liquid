CWD="$ROOT"/infra/kube/monitoring
helm install monitoring prometheus-community/kube-prometheus-stack -f "$CWD"/config/grafana.yaml --namespace monitoring
