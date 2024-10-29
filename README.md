# Banco Relacional Incluses

## Objetivo do Banco de Dados
O objetivo desse banco de dados é centralizar e organizar informações normalizadas essenciais para o funcionamento aplicativo Incluses. Ele foi desenvolvido para armazenar e gerenciar dados relacionados a usuários, empresas, cursos, vagas e etc.

## Extensões Necessárias
```sql
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
```

## Tabelas

### `usuario`
#### Objetivo

Armazenar as informações dos usuários comuns no nosso app.

#### Script
```sql
CREATE TABLE usuario (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cpf VARCHAR(11) UNIQUE NOT NULL,
    fk_perfil_id UUID NOT NULL,
    fk_curriculo_id UUID,
    dt_nascimento DATE NOT NULL,
    pronomes VARCHAR(50) NOT NULL,
    nome_social VARCHAR(100),
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id),
    FOREIGN KEY (fk_curriculo_id) REFERENCES arquivo (id)
);
```
#### Campos
| Coluna           | Tipo       | Descrição                     | Restrições                                       |
|------------------|------------|-------------------------------|--------------------------------------------------|
| `id`             | UUID       | Identificador único           | PRIMARY KEY, DEFAULT gen_random_uuid()           |
| `cpf`            | VARCHAR(11)| CPF do usuário                | UNIQUE, NOT NULL                                 |
| `fk_perfil_id`   | UUID       | Chave estrangeira para `perfil` | NOT NULL, FOREIGN KEY (REFERENCES `perfil(id)`)|
| `fk_curriculo_id`| UUID       | Chave estrangeira para `arquivo` | FOREIGN KEY (REFERENCES `arquivo(id)`)        |
| `dt_nascimento`  | DATE       | Data de nascimento do usuário | NOT NULL                                         |
| `pronomes`       | VARCHAR(50)| Pronomes de tratamento        | NOT NULL                                         |
| `nome_social`    | VARCHAR(100)| Nome social do usuário       | NULL                                             |

--- 

### `empresa`
#### Objetivo

Armazenar as informações das empresas no nosso app.

#### Script
```sql
CREATE TABLE empresa (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cnpj VARCHAR(14) UNIQUE NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    website VARCHAR(220),
    fk_perfil_id UUID NOT NULL,
    fk_endereco_id UUID NOT NULL,
    fk_setor_id UUID NOT NULL,
    FOREIGN KEY (fk_setor_id) REFERENCES setor (id),
    FOREIGN KEY (fk_endereco_id) REFERENCES endereco (id),
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id)
);
```
#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                         |
|------------------|------------|---------------------------------|----------------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()             |
| `cnpj`           | VARCHAR(14)| CNPJ da empresa                 | UNIQUE, NOT NULL                                   |
| `razao_social`   | VARCHAR(100)| Razão social da empresa        | NOT NULL                                           |
| `website`        | VARCHAR(220)| Website da empresa             | NULL                                              |
| `fk_perfil_id`   | UUID       | Chave estrangeira para `perfil` | NOT NULL, FOREIGN KEY (REFERENCES `perfil(id)`)    |
| `fk_endereco_id` | UUID       | Chave estrangeira para `endereco`| NOT NULL, FOREIGN KEY (REFERENCES `endereco(id)`)  |
| `fk_setor_id`    | UUID       | Chave estrangeira para `setor`  | NOT NULL, FOREIGN KEY (REFERENCES `setor(id)`)     |

---

### `tipo_perfil`
#### Objetivo
Armazenar campos normalizados do tipo do perfil. Exemplos de dados: empresa, usuário.

#### Script
```sql
CREATE TABLE tipo_perfil (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) NOT NULL
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `nome`           | VARCHAR(50)| Nome do tipo de perfil          | NOT NULL                                    |

### `situacao_trabalhista`
#### Objetivo 
Armazenar campos normalizados da situação trabalhista. Exemplos de dados: empregado, desempregado, autônomo.

#### Script
```sql
CREATE TABLE situacao_trabalhista (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) NOT NULL
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `nome`           | VARCHAR(50)| Nome da situação trabalhista    | NOT NULL                                    |

---

### `setor`
#### Objetivo
Armazenar os setores das empresas.

#### Script
```sql
CREATE TABLE setor (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(200) NOT NULL
);
```
#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `nome`           | VARCHAR(200)| Nome do setor                  | NOT NULL                                    |

---

## `tipo_arquivo`
#### Objetivo
Armazenar campos normalizados dos tipos de arquivos permitidos. Exemplo de dados: currículo, foto de perfil, postagem.

#### Script
```sql
CREATE TABLE tipo_arquivo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) NOT NULL
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `nome`           | VARCHAR(50)| Nome do tipo de arquivo         | NOT NULL                                    |

--- 

### `tipo_vaga`
#### Objetivo
Armazenar campos normalizados dos tipos de vagas. Exemplos de dados: presencial, home office.

#### Script
```sql
CREATE TABLE tipo_vaga (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) NOT NULL
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `nome`           | VARCHAR(50)| Nome do tipo de vaga            | NOT NULL                                    |

--- 

### `endereco`
#### Objetivo
Armazenar os endereços.

#### Script
```sql
CREATE TABLE endereco (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rua VARCHAR(200) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    cep VARCHAR(8) NOT NULL,
    numero INT NOT NULL
);
```
#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `rua`            | VARCHAR(200)| Nome da rua                    | NOT NULL                                    |
| `estado`         | VARCHAR(100)| Nome do estado                 | NOT NULL                                    |
| `cidade`         | VARCHAR(100)| Nome da cidade                 | NOT NULL                                    |
| `cep`            | VARCHAR(8) | Código Postal                   | NOT NULL                                    |
| `numero`         | INT        | Número do endereço              | NOT NULL                                    |

---

### `arquivo`
#### Objetivo
Armazenar informações sobre arquivos.

#### Script
```sql
CREATE TABLE arquivo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(150) NOT NULL,
    tamanho VARCHAR(50) NOT NULL,
    fk_tipo_arquivo_id UUID NOT NULL,
    FOREIGN KEY (fk_tipo_arquivo_id) REFERENCES tipo_arquivo (id)
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `nome`           | VARCHAR(150)| Nome do arquivo                | NOT NULL                                    |
| `tamanho`        | VARCHAR(50)| Tamanho do arquivo              | NOT NULL                                    |
| `fk_tipo_arquivo_id` | UUID   | Chave estrangeira para `tipo_arquivo` | NOT NULL, FOREIGN KEY (REFERENCES `tipo_arquivo(id)`) |

---

### `perfil` 
#### Objetivo
Armazenar as informações comuns dos perfis empresa e usuário comum.

#### Script
```sql
CREATE TABLE perfil (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    senha VARCHAR(8) NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL,
    biografia VARCHAR(300),
    fk_tipo_perfil_id UUID NOT NULL,
    FOREIGN KEY (fk_tipo_perfil_id) REFERENCES tipo_perfil (id)
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `nome`           | VARCHAR(100)| Nome do usuário                | NOT NULL                                    |
| `senha`          | VARCHAR(8) | Senha do usuário                | NOT NULL                                    |
| `email`          | VARCHAR(100)| E-mail do usuário              | UNIQUE, NOT NULL                            |
| `biografia`      | VARCHAR(300)| Biografia do usuário           | NULL                                        |
| `fk_tipo_perfil_id` | UUID     | Chave estrangeira para `tipo_perfil` | NOT NULL, FOREIGN KEY (REFERENCES `tipo_perfil(id)`) |

---

### `telefone`
#### Objetivo
Armazenar os telefones dos perfis.

#### Script
```sql
CREATE TABLE telefone (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    telefone VARCHAR(11) NOT NULL,
    fk_perfil_id UUID NOT NULL,
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id)
);
```
#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `telefone`       | VARCHAR(11)| Número de telefone              | NOT NULL                                    |
| `fk_perfil_id`   | UUID       | Chave estrangeira para `perfil` | NOT NULL, FOREIGN KEY (REFERENCES `perfil(id)`) |

---
### `curso`
#### Objetivo
Armazenar informações sobre cursos.

#### Script
```sql
CREATE TABLE curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    descricao VARCHAR(300),
    fk_perfil_id UUID NOT NULL,
    nome VARCHAR(100) NOT NULL,
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id)
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `descricao`      | VARCHAR(300)| Descrição do curso             | NULL                                        |
| `fk_perfil_id`   | UUID       | Chave estrangeira para perfil   | NOT NULL, FOREIGN KEY (REFERENCES perfil(id))|
| `nome`           | VARCHAR(100)| Nome do curso                  | NOT NULL                                    |

---

### `material_curso`
#### Objetivo
Armazenar materiais relacionados aos cursos.

#### Script
```sql
CREATE TABLE material_curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(255) NOT NULL,
    fk_curso_id UUID NOT NULL,
    fk_arquivo_id UUID NOT NULL,
    descricao VARCHAR(500),
    FOREIGN KEY (fk_curso_id) REFERENCES curso (id),
    FOREIGN KEY (fk_arquivo_id) REFERENCES arquivo (id)
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `nome`           | VARCHAR(255)| Nome do material               | NOT NULL                                    |
| `fk_curso_id`    | UUID       | Chave estrangeira para curso    | NOT NULL, FOREIGN KEY (REFERENCES curso(id))|
| `fk_arquivo_id`  | UUID       | Chave estrangeira para arquivo  | NOT NULL, FOREIGN KEY (REFERENCES arquivo(id))|
| `descricao`      | VARCHAR(500)| Descrição do material          | NULL                                        |

--- 

### `inscricao_curso`
#### Objetivo
Armazenar inscrições dos usuários comuns em cursos. Uma empresa não pode se inscrever em um curso, apenas criar.

#### Script
```sql
CREATE TABLE inscricao_curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fk_curso_id UUID NOT NULL,
    fk_usuario_id UUID NOT NULL,
    FOREIGN KEY (fk_curso_id) REFERENCES curso (id),
    FOREIGN KEY (fk_usuario_id) REFERENCES usuario (id)
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `fk_curso_id`    | UUID       | Chave estrangeira para curso    | NOT NULL, FOREIGN KEY (REFERENCES curso(id))|
| `fk_usuario_id`  | UUID       | Chave estrangeira para usuário   | NOT NULL, FOREIGN KEY (REFERENCES usuario(id))|

### `vaga`
#### Objetivo
Armazenar informações sobre vagas. Um usuário comum não pode criar uma vaga, apenas se inscrever. Uma empresa não pode se inscrever em uma vaga, apenas criar.

#### Script
```sql
CREATE TABLE vaga (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    descricao VARCHAR(300) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    fk_empresa_id UUID NOT NULL,
    fk_tipo_vaga_id UUID NOT NULL,
    FOREIGN KEY (fk_empresa_id) REFERENCES empresa (id),
    FOREIGN KEY (fk_tipo_vaga_id) REFERENCES tipo_vaga (id)
);
```
#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `descricao`      | VARCHAR(300)| Descrição da vaga              | NOT NULL                                    |
| `nome`           | VARCHAR(100)| Nome da vaga                   | NOT NULL                                    |
| `fk_empresa_id`  | UUID       | Chave estrangeira para empresa  | NOT NULL, FOREIGN KEY (REFERENCES empresa(id))|
| `fk_tipo_vaga_id`| UUID       | Chave estrangeira para tipo de vaga | NOT NULL, FOREIGN KEY (REFERENCES tipo_vaga(id))|

---

### `inscricao_vaga`
#### Objetivo
Ligar as vagas com os usuários comuns.

#### Script
```sql
CREATE TABLE inscricao_vaga (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fk_usuario_id UUID NOT NULL,
    fk_vaga_id UUID NOT NULL,
    FOREIGN KEY (fk_vaga_id) REFERENCES vaga (id),
    FOREIGN KEY (fk_usuario_id) REFERENCES usuario (id)
);
```

#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `fk_usuario_id`  | UUID       | Chave estrangeira para usuário   | NOT NULL, FOREIGN KEY (REFERENCES usuario(id))|
| `fk_vaga_id`     | UUID       | Chave estrangeira para vaga     | NOT NULL, FOREIGN KEY (REFERENCES vaga(id)) |

---

### `avaliacao_curso`
#### Objetivo
Armazenar avaliações de cursos.

#### Script
```sql
CREATE TABLE avaliacao_curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nota NUMERIC NOT NULL,
    fk_curso_id UUID REFERENCES curso (id),
    fk_usuario_id UUID REFERENCES usuario (id)
);
```
#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `nota`           | NUMERIC    | Nota da avaliação               | NOT NULL                                    |
| `fk_curso_id`    | UUID       | Chave estrangeira para curso    | FOREIGN KEY (REFERENCES curso(id))          |
| `fk_usuario_id`  | UUID       | Chave estrangeira para usuário   | FOREIGN KEY (REFERENCES usuario(id))        |

---

### `permissao_vaga` 
#### Objetivo
Armazenar permissões relacionadas às vagas.

#### Script
```sql
CREATE TABLE permissao_vaga (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    permissao BOOLEAN DEFAULT false,
    fk_vaga_id UUID REFERENCES vaga (id)
);
```
#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `permissao`      | BOOLEAN    | Indica se a permissão é concedida| DEFAULT false                               |
| `fk_vaga_id`     | UUID       | Chave estrangeira para vaga     | FOREIGN KEY (REFERENCES vaga(id))           |

--- 

### `permissao_curso`
#### Objetivo
Armazenar permissões relacionadas a cursos.

#### Script
```sql
CREATE TABLE permissao_curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    permissao BOOLEAN DEFAULT false,
    fk_curso_id UUID REFERENCES curso (id)
);
```
#### Campos
| Coluna           | Tipo       | Descrição                       | Restrições                                  |
|------------------|------------|---------------------------------|---------------------------------------------|
| `id`             | UUID       | Identificador único             | PRIMARY KEY, DEFAULT gen_random_uuid()      |
| `permissao`      | BOOLEAN    | Indica se a permissão é concedida| DEFAULT false                               |
