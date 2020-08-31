
#kubectl get node --selector='!node-role.kubernetes.io/agent'

kubectl run random-logger --image=chentex/random-logger -n elf
cat <<EOF > ingress.yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: cluster
  namespace: elf
  annotations:
    ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /elf
        backend:
          serviceName: kibana-kibana
          servicePort: 80
EOF
kubectl apply -f ingress.yaml


kubectl get service/kibana-kibana  -n elf
kubectl get service/prometheus-operator-grafana -n monitor  

kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces
