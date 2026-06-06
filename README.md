# 🚀 APISIX API Gateway — Deploy Gratuito no Render

Projeto de API Gateway utilizando **Apache APISIX** em modo **standalone** (sem etcd). Ideal para ambientes com recursos limitados ou para hospedar serviços de forma gratuita no [Render.com](https://render.com).

---

## 🛠️ Pré-requisitos (O que instalar na sua máquina)

Para rodar este projeto localmente, você precisa ter instalado apenas:

1. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)**: É o motor que vai executar o container do APISIX.
* *Nota:* Se você usa Windows, certifique-se de que o **WSL 2** está habilitado e configurado no Docker Desktop (é a forma mais estável de rodar).


2. **Git**: Para clonar o projeto.
3. **Terminal de sua preferência**: Pode ser o **PowerShell** (Windows), **CMD**, **Git Bash** ou o terminal do **VS Code**.

---

## 📁 Estrutura do Projeto

```text
proj_prog_distribuida/
├── apisix_conf/
│   ├── config.yaml     # Configuração do APISIX (standalone)
│   └── apisix.yaml     # Rotas, upstreams e plugins
├── Dockerfile          # Imagem otimizada para APISIX
├── docker-compose.yml  # Ambiente local
├── render.yaml         # Blueprint para deploy no Render.com
└── README.md           # Este arquivo

```

---

## 🐳 1. Teste Local (Docker)

1. **Clone o repositório** e entre na pasta do projeto.
2. **Suba o ambiente** com o comando:
```bash
docker compose up -d

```


3. **Verifique se subiu corretamente**:
```bash
docker compose ps

```


*(O container `apisix-gateway` deve estar com status "Up")*

### Comandos de Teste

**Atenção:** Se estiver usando o **PowerShell** no Windows, o comando `curl` padrão do Windows (Invoke-WebRequest) não funciona bem para APIs. **Use sempre `curl.exe**`:

* **Verificar Status (Porta 7085):**
`curl.exe http://localhost:7085/status`
* **Testar Rota de Exemplo (Porta 9080):**
`curl.exe http://localhost:9080/hello`
* **Testar Proxy para Httpbin:**
`curl.exe http://localhost:9080/httpbin/get`

---

## ☁️ 2. Deploy no Render.com

O Render permite deploy automático via Blueprint, ideal para o plano gratuito:

1. Faça **push** deste código para um repositório (GitHub ou GitLab).
2. Acesse o [Dashboard do Render](https://dashboard.render.com).
3. Clique em **New → Blueprint**.
4. Conecte seu repositório. O Render lerá o `render.yaml` e configurará tudo automaticamente.

---

## 📝 Como Adicionar Novas Rotas

Edite o arquivo `apisix_conf/apisix.yaml`. O APISIX em modo standalone recarrega este arquivo automaticamente a cada segundo.

**Exemplo de Proxy:**

```yaml
routes:
  - uri: /minha-api/*
    name: minha-api
    methods: [GET, POST]
    plugins:
      proxy-rewrite:
        regex_uri: ["^/minha-api/(.*)", "/$1"]
    upstream_id: meu-upstream

upstreams:
  - id: meu-upstream
    nodes:
      "api.exemplo.com:80": 1

```

---

## 🔍 Diagnóstico e Resolução de Problemas

* **Erro 404:** O tráfego de rotas passa pela porta **9080**. Se estiver tentando acessar o status na 9080, dará erro (o status é exclusivo da **7085**).
* **Comando `curl` estranho:** Se o seu terminal exibir "Invoke-WebRequest" ou pedir permissão para continuar, lembre-se: use sempre **`curl.exe`**.
* **Logs:** Para ver erros durante o desenvolvimento local, rode: `docker compose logs -f apisix`.
* **Hibernação no Render:** O plano gratuito hiberna após 15 minutos de inatividade. A primeira requisição pode demorar alguns segundos para "acordar" o serviço.