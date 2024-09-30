CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE tipo_perfil (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE situacao_trabalhista (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE setor (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(200) NOT NULL
);

CREATE TABLE tipo_arquivo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE tipo_vaga (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE endereco (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rua VARCHAR(200) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    cep VARCHAR(8) NOT NULL,
    numero INT NOT NULL
);

CREATE TABLE arquivo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(150) NOT NULL,
    s3_url VARCHAR(1500),
    s3_key VARCHAR(1024),
    tamanho VARCHAR(50) NOT NULL,
    fk_tipo_arquivo_id UUID NOT NULL,
    FOREIGN KEY (fk_tipo_arquivo_id) REFERENCES tipo_arquivo (id)
);

CREATE TABLE perfil (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    senha VARCHAR(8) NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL,
    biografia VARCHAR(300),
    fk_tipo_perfil_id UUID NOT NULL,
    fk_ft_perfil_id UUID,
    FOREIGN KEY (fk_ft_perfil_id) REFERENCES arquivo (id),
    FOREIGN KEY (fk_tipo_perfil_id) REFERENCES tipo_perfil (id)
);

CREATE TABLE telefone (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    telefone VARCHAR(11) NOT NULL,
    fk_perfil_id UUID NOT NULL,
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id)
);

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

CREATE TABLE configuracao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notificacao BOOLEAN,
    fk_perfil_id UUID NOT NULL,
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id)
);

CREATE TABLE curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    descricao VARCHAR(300),
    fk_perfil_id UUID NOT NULL,
    nome VARCHAR(100) NOT NULL,
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id)
);

CREATE TABLE material_curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(255) NOT NULL,
    fk_curso_id UUID NOT NULL,
    fk_arquivo_id UUID NOT NULL,
    descricao VARCHAR(500),
    FOREIGN KEY (fk_curso_id) REFERENCES curso (id),
    FOREIGN KEY (fk_arquivo_id) REFERENCES arquivo (id)
);

CREATE TABLE inscricao_curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fk_curso_id UUID NOT NULL,
    fk_usuario_id UUID NOT NULL,
    FOREIGN KEY (fk_curso_id) REFERENCES curso (id),
    FOREIGN KEY (fk_usuario_id) REFERENCES usuario (id)
);

CREATE TABLE vaga (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    descricao VARCHAR(300) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    fk_empresa_id UUID NOT NULL,
    fk_tipo_vaga_id UUID NOT NULL,
    FOREIGN KEY (fk_empresa_id) REFERENCES empresa (id),
    FOREIGN KEY (fk_tipo_vaga_id) REFERENCES tipo_vaga (id)
);

CREATE TABLE inscricao_vaga (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fk_usuario_id UUID NOT NULL,
    fk_vaga_id UUID NOT NULL,
    FOREIGN KEY (fk_vaga_id) REFERENCES vaga (id),
    FOREIGN KEY (fk_usuario_id) REFERENCES usuario (id)
);

CREATE TABLE avaliacao_curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nota NUMERIC NOT NULL,
    fk_curso_id UUID REFERENCES curso (id),
    fk_usuario_id UUID REFERENCES usuario (id)
);

CREATE TABLE permissao_vaga (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    permissao BOOLEAN DEFAULT false,
    id_vaga UUID REFERENCES vaga (id)
);

CREATE TABLE permissao_curso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    permissao BOOLEAN DEFAULT false,
    fk_curso_id UUID REFERENCES curso (id)
);
