## CICD pipelines example
### infrastucture

 - gitops push модель;
 - пайплайн создает всю необходимую инфраструктуру для развертывания приложения в yandex cloud c помощью terraform;
 - terraform state хранит в Gitlab c http backend;
 - передает kubernetes конфиг в переменной в проект приложения и триггерит его.

### k8s-agentless

- push модель;
- автоматически запускается из инфраструктурного пайплайна;
- выполняет развертывание приложения в yandex cloud;
- stages (lint, build, test, cleanup, push, deploy, rollback).

### k8s-agent

- gitlab agent в кластере;
- применяются инструменты DevSecOps (SAST, DAST, Secret Detection)
- сборка с помощью kaniko.

### vault-jwt

- получаем секреты из Hashicorp Vault в пайплайне (метод gitlab jwt).