SHELL := /bin/bash
export

login:
	argocd login argocd.kefych.net --username admin --password Sayuri721!

argocd_app:
	#kc create namespace examples
	argocd app delete -y guestbook || true
	argocd app create guestbook --repo https://github.com/xhumiq/argorepo.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace examples

argocd_app2:
	argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace examples
	# --ssh-private-key-path ~/id_rsa

golang:
	argo submit https://raw.githubusercontent.com/xhumiq/argorepo/master/workflow/golang-ci.yaml --watch

influxdb:
	argo submit https://raw.githubusercontent.com/xhumiq/argorepo/master/workflow/influxdb-ci.yaml --watch

argowk-check:
	kubectl logs $$(kubectl get pod -o name --field-selector=status.phase==Running -n argocd | grep argo-workflows-server) -n argocd -f
	kubectl logs $$(kubectl get pod -o name --field-selector=status.phase==Running -n argocd | grep argo-workflows-workflow-controller) -n argocd -f

install:
	sudo install ./argo-linux-amd64 /usr/local/bin/argo

traefik-check:
	kubectl logs $$(kubectl get pod -n traefik -o name --field-selector=status.phase==Running) -n traefik -f

tls-create:
	kubectl create secret tls tls-argocd \
		--cert=/ntc/assets/.secrets/certs/kefych.net/active/kefych.net.pem \
		--key=/ntc/assets/.secrets/certs/kefych.net/active/kefych.net.key \
		--namespace examples
