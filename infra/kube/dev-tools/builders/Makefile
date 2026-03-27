
.PHONY: apply
apply:
	kubectl apply -k overlays/ci-golang

.PHONY: clean
clean:
	-kubectl delete -k overlays/ci-golang

.PHONY logs:
logs:
	sleep 3
	kubectl logs job/build-ci-golang

.PHONY: run
run: apply logs

.PHONY: reset
reset: clean apply
