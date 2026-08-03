.PHONY: install wait password ui apply upgrade

install:
	kubectl apply -f manifests/namespace.yaml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

wait:
	kubectl wait --for=condition=available --timeout=120s deployment/argocd-server -n argocd

password:
	kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

ui:
	kubectl port-forward svc/argocd-server -n argocd 8080:443

apply:
	kubectl apply -f manifests/root-app.yaml

upgrade:
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.14.0/manifests/install.yaml
