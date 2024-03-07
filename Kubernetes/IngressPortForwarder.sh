#!/bin/bash

# Forward traffic to the Ingress controller
# Can't access the localhost in port 80/443
kubectl port-forward service/frontend-service 8081:80 &