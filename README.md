# V360 Case Todolist

Todo app com fluxo SPA-like usando Turbo, lists com items e UI em Tailwind. Inclui autenticação via Devise.

## Motivação
- Entregar uma base sólida de app shell com navegação rápida via Turbo Streams.
- Manter a UI simples e consistente para evoluir UX/UI.
- Separar bem as responsabilidades (listas, itens, autenticação).

## Stack
- Rails 8.1
- PostgreSQL
- Turbo + Stimulus
- Tailwind CSS
- Simple Form
- Devise (auth)

## Arquitetura (resumo)
- Monolito Rails com Hotwire (Turbo/Stimulus).
- UI renderizada no servidor com updates parciais via Turbo Streams.
- Models principais: `User`, `List`, `Item`.
- Listas e itens são filtrados pelo usuário autenticado.

## Diagrama de Classes

- [Visualizar diagrama UML no Canva](https://www.canva.com/design/DAG-o4udieA/5r0w90PsqXyHx43L0G6UeQ/edit?utm_content=DAG-o4udieA&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)


## Requisitos
- Ruby 3.4+
- PostgreSQL 16+

## Setup local
1) Instale gems
```bash
bundle install
```

2) Configure variaveis de ambiente
Crie `.env` com:
```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=v360
DB_PASSWORD=v360
```

3) Suba o banco (opcional via Docker)
```bash
docker compose up -d
```

4) Crie e migre o banco
```bash
bin/rails db:create db:migrate
```

5) Rode o app (server + tailwind)
```bash
bin/dev
```

App em `http://localhost:3000`.

## Comandos uteis
- `bin/dev` -> server + tailwind watch
- `bin/rails db:migrate` -> migracoes
- `bin/rails routes` -> rotas

## Auth (Devise)
- Registro e login via Devise.
- Todas as rotas de app protegidas, exceto `HomeController#index`.
- Para customizar views:
```bash
bin/rails generate devise:views
```

## Banco de dados
Em producao, use `DATABASE_URL`:
```env
DATABASE_URL=postgresql://user:pass@host:5432/dbname
```

## Fluxo SPA (Turbo)
- Lists/Items usam Turbo Streams para atualizar navbar, listagem e modal.
- Modais usam `modal_frame`.

## Estrutura de pastas (resumo)
- `app/controllers` -> controllers Rails
- `app/models` -> models (User, List, Item)
- `app/views` -> views e partials
- `app/javascript` -> controllers Stimulus
- `app/assets` -> imagens e tailwind

## Deploy
- Configure `DATABASE_URL` (e demais variaveis) no provedor.
- Rode `bin/rails db:migrate` no ambiente.

## Licença
Uso interno para o case.
