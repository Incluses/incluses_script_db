# Estrutura do Redis

Este documento descreve a estrutura das chaves usadas no aplicativo para gerenciar administradores e códigos de acesso.

## Chave: **admin**

Essa chave armazena os dados dos administradores do aplicativo.

| Parâmetro      | Tipo                 | Descrição  |
|----------------|----------------------|---------------------------------------------------------------|
| `id`           | `UUID`             | Identificador único do admin. |
| `email`        | `String`            | Email do admin.|
| `password`      | `String`             | Senha do admin. |

### Exemplo da chave `admin`

```json
{
  "id": "4ff99d29-272d-4088-96dd-b70cecaeb64e",
  "email": "admin@incluses.com",
  "password": "admin@Incluses2024"
}
```

## Chave: **cod**

Essa chave armazena, temporariamente, informações sobre os códigos de acesso entre os usuários.

| Parâmetro              | Tipo                 | Descrição                                                        |
|------------------------|----------------------|------------------------------------------------------------------|
| `code`                 | `UUID`               | Identificador único da codigo.                                   |
| `value`                | `String`             | Codigo de acesso.                                                |
| `expiration`           | `Number`             | Tempo, em segundos, que o código ficará ativo.                   |

### Exemplo da chaave `cod`

```json
{
    "code": "6c53c53a-a84f-4572-bd9a-a1c76ecabbf8",
    "value": "9101",
    "expiration": 300
}
```

## Documentação

[Documentação redis](https://redis.io/docs/latest/)


## Feito por

[Luca Almeida Lucareli](https://github.com/LucaLucareli)

[Olivia Farias Domingues](https://github.com/oliviaworks)
