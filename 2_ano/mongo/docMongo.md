# Estrutura das Collections do MongoDB

Este documento descreve a estrutura das collections usadas no aplicativo para gerenciar postagens, situações trabalhistas e conversas entre usuários.

## Collection: **postagem**

Essa collection armazena os posts dos usuários no aplicativo.

| Parâmetro      | Tipo                 | Descrição                                                                                 |
|----------------|----------------------|-------------------------------------------------------------------------------------------|
| `id`           | `Number`             | Identificador único da postagem.                                                          |
| `arquivoId`    | `Number?`            | ID de um arquivo associado à postagem, se houver.                                         |
| `perfilId`     | `UUID`               | Identificador do perfil (usuário ou empresa) que criou a postagem.                        |
| `legenda`      | `String`             | Legenda ou descrição da postagem.                                                         |
| `likes`        | `Array<Object>`      | Array de likes na postagem, onde cada like possui os seguintes campos:                    |
|                |                      | - `perfilId` (`UUID`): ID do usuário que deu o like.                                     |
|                |                      | - `data_like` (`Date`): Data em que o like foi dado.                                     |
| `comentarios`  | `Array<Object>`      | Array de comentários na postagem, onde cada comentário possui os seguintes campos:        |
|                |                      | - `perfilId` (`UUID`): ID do usuário que comentou.                                       |
|                |                      | - `comentario` (`String`): Conteúdo do comentário.                                       |

### Exemplo de Documento `postagem`

```json
{
  "id": 1,
  "arquivoId": 123,
  "perfilId": "550e8400-e29b-41d4-a716-446655440000",
  "legenda": "Esta é uma postagem de exemplo",
  "likes": [
    {
      "perfilId": "550e8400-e29b-41d4-a716-446655440001",
      "data_like": "2024-10-29T10:00:00Z"
    }
  ],
  "comentarios": [
    {
      "perfilId": "550e8400-e29b-41d4-a716-446655440002",
      "comentario": "Ótima postagem!"
    }
  ]
}
```

## Collection: **Conversas**

Essa collection armazena informações sobre as conversas entre os usuários, incluindo se são públicas ou privadas.

| Parâmetro      | Tipo                 | Descrição                                                                                 |
|----------------|----------------------|-------------------------------------------------------------------------------------------|
| `id`           | `Number`             | Identificador único da conversa.                                                          |
| `tipo`         | `String`             | Tipo da conversa, podendo ser `publico` ou `privado`.                                     |
| `nome`         | `String?`            | Nome da conversa (opcional).                                                              |
| `participantes`| `Array<Object>`      | Array com os participantes da conversa, onde cada participante possui os seguintes campos:|
|                |                      | - `perfilId` (`Number`): ID do usuário participante.                                      |
|                |                      | - `adicionado_em` (`Date`): Data em que o usuário foi adicionado à conversa.              |
| `criador_id`   | `Number`             | ID do perfil que criou a conversa.                                                        |
| `data_criacao` | `Date`               | Data de criação da conversa.                                                              |
| `mensagem`     | `Array<Object>`      | Array de mensagens na conversa, onde cada mensagem possui os seguintes campos:            |
|                |                      | - `perfilId` (`Number`): ID do usuário que enviou a mensagem.                             |
|                |                      | - `conteudo` (`String`): Conteúdo da mensagem.                                            |
|                |                      | - `data_envio` (`Date`): Data em que a mensagem foi enviada.                              |

### Exemplo de Documento `Conversas`

```json
{
  "id": 1,
  "tipo": "privado",
  "nome": "Conversa entre amigos",
  "participantes": [
    {
      "perfilId": 101,
      "adicionado_em": "2024-10-28T15:30:00Z"
    },
    {
      "perfilId": 102,
      "adicionado_em": "2024-10-28T15:31:00Z"
    }
  ],
  "criador_id": 101,
  "data_criacao": "2024-10-28T15:30:00Z",
  "mensagem": [
    {
      "perfilId": 101,
      "conteudo": "Olá, tudo bem?",
      "data_envio": "2024-10-28T15:32:00Z"
    },
    {
      "perfilId": 102,
      "conteudo": "Oi, tudo ótimo!",
      "data_envio": "2024-10-28T15:33:00Z"
    }
  ]
}
```

## Documentação

[Documentação mongoDB](https://www.mongodb.com/pt-br/docs/)


## Feito por

[Luca Almeida Lucareli](https://github.com/LucaLucareli)

[Olivia Farias Domingues](https://github.com/oliviaworks)
