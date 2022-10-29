# Ingress

In this task we will setup an Ingress and expose an app showing a blue screen and an app showing a green screen.

## Create the green application

```bash
kubectl create -f green.yaml
```

## Create the blue application

```bash
kubectl create -f blue.yaml
```

## Verify your steps

```bash
kubectl get pods,svc
```

## Inspect and create the resources for the ingress controller

```bash
kubectl create -f ingress-controller.yaml
```

## Verify everything is running

```bash
kubectl get deployments,pods,services
kubectl get deployments,pods,services -n ingress-nginx
```

## Inspect and create the ingress

```bash
kubectl create -f ingress.yaml
```

## Verify your steps

```bash
kubectl describe ing my-ingress
```

## Visit the applications "green" and "blue" in your browser via

```bash
# Get the external IP of your LoadBalancer
kubectl get svc -n ingress-nginx
```

* `http://<EXTERNAL-IP>/green`
* `http://<EXTERNAL-IP>/blue`

## Clean up

```bash
kubectl delete -f .
```
