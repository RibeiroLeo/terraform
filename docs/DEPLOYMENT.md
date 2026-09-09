# Aplicação controlada

Este repositório para no plan por design. Se você decidir demonstrar um deploy
real em uma conta sandbox, use este processo local e nunca aplique diretamente
na conta de produção.

## Checklist

1. Configure budgets/alerts e confirme os preços da região.
2. Restrinja o endpoint do EKS, defina grupos administradores do AKS e fixe
   imagens por digest.
3. Inicialize o backend remoto conforme `PLANNING.md`.
4. Gere um arquivo de plan e revise recursos, custos e substituições.
5. Aplique exatamente o artefato revisado, sem gerar um plan novo.

```bash
terraform plan -out=tfplan
terraform show tfplan
terraform apply tfplan
```

Ao final de uma demonstração, gere e revise também um destroy plan:

```bash
terraform plan -destroy -out=destroy.tfplan
terraform show destroy.tfplan
terraform apply destroy.tfplan
```

Arquivos de plan podem carregar dados sensíveis e estão bloqueados pelo
`.gitignore`. A exclusão dos recursos pode não remover logs, imagens ou objetos
mantidos fora destas stacks; confira a conta depois.
