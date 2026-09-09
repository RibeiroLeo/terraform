# AWS EKS

Creates an encrypted EKS control plane, a managed node group, control-plane logs
and the CoreDNS, kube-proxy and VPC CNI managed add-ons. Nodes run in the subnets
provided by the caller.

After apply:

```bash
aws eks update-kubeconfig --region <region> --name <cluster_name>
kubectl get nodes
```

For a real deployment, restrict `public_access_cidrs` to a trusted corporate or
VPN CIDR, or disable the public endpoint entirely.
