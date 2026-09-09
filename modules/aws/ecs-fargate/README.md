# AWS ECS Fargate

Runs one OCI image on ECS Fargate behind an Application Load Balancer. Tasks stay
in private subnets and emit logs to CloudWatch. CPU target tracking is enabled by
default.

The module deliberately exposes only HTTP for a portfolio demo. For production,
add an ACM certificate, HTTPS listener and HTTP-to-HTTPS redirect.
