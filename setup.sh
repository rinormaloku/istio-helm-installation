kind create cluster --name istio-argo 

kubectl create namespace argocd
kubectl apply -n argocdn -f argocd-cm.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -l 'app.kubernetes.io/name != argocd-cm' 
kubectl -n argocd wait po --for condition=Ready --timeout -1s --all   

echo "Use the password shown below. Username is 'admin'"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | copy

## Needed for HPA
kubectl apply -f metrics-server.yaml

kubectl port-forward svc/argocd-server -n argocd 8080:443 

argocd login localhost:8080

echo "Open in browser: localhost:8080"

