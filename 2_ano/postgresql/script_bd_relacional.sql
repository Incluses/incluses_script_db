--CREATE DATABASE diversis;

--/c diversis

CREATE TABLE tipo_perfil (
    id serial PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE situacao_trabalhista (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE setor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(200)
);

CREATE TABLE status_curso (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE tipo_arquivo (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE turno (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE tipo_vaga (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE endereco (
    id SERIAL PRIMARY KEY,
    rua VARCHAR(200),
    estado VARCHAR(100),
    numero INT
);

CREATE TABLE perfil (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    senha VARCHAR(50),
    email VARCHAR(100),
    biografia VARCHAR(300),
    fk_tipo_perfil_id INT,
    FOREIGN KEY (fk_tipo_perfil_id) REFERENCES tipo_perfil (id)
);

CREATE TABLE telefone (
    id SERIAL PRIMARY KEY,
    telefone VARCHAR(9),
    fk_perfil_id INT, 
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id)
);

CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(11),
    fk_perfil_id INT,
    fk_situacao_trabalhista_id INT,
    dt_nascimento DATE,
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id),
    FOREIGN KEY (fk_situacao_trabalhista_id) REFERENCES situacao_trabalhista (id)
);

CREATE TABLE empresa (
    id SERIAL PRIMARY KEY,
    cnpj VARCHAR(14),
    razao_social VARCHAR(100),
    fk_perfil_id INT,
    website VARCHAR(220),
    matriz_id INT,
    fk_endereco_id INT,
    FOREIGN KEY (fk_endereco_id) REFERENCES endereco (id),
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id)
);

CREATE TABLE setor_empresa (
    id SERIAL PRIMARY KEY,
    fk_empresa_id INT,
    fk_setor_id INT,
    FOREIGN KEY (fk_setor_id) REFERENCES setor (id),
    FOREIGN KEY (fk_empresa_id) REFERENCES empresa (id)
);

CREATE TABLE configuracao (
    id SERIAL PRIMARY KEY,
    notificacao BOOLEAN,
    fk_perfil_id INT,
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id)
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
    descricao VARCHAR(300),
    fk_perfil_id INT,
    carga_horaria INT,
    nome VARCHAR(100),
    fk_status_curso_id INT,
    FOREIGN KEY (fk_perfil_id) REFERENCES perfil (id),
    FOREIGN KEY (fk_status_curso_id) REFERENCES status_curso (id)
);

CREATE TABLE arquivo (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150),
    s3_url VARCHAR(300), 
    s3_key VARCHAR(50),
    tamanho VARCHAR(50),
    fk_tipo_arquivo_id INT,
    FOREIGN KEY (fk_tipo_arquivo_id) REFERENCES tipo_arquivo (id)
);

CREATE TABLE material_curso (
    id SERIAL PRIMARY KEY,  
    nome VARCHAR(255),
    fk_curso_id INT,
    fk_arquivo_id INT,
    descricao VARCHAR(300),
    FOREIGN KEY (fk_curso_id) REFERENCES curso (id),
    FOREIGN KEY (fk_arquivo_id) REFERENCES arquivo (id)
);

CREATE TABLE inscricao_curso (
    id SERIAL PRIMARY KEY,
    fk_curso_id INT,
    fk_usuario_id INT,
    FOREIGN KEY (fk_curso_id) REFERENCES curso (id),
    FOREIGN KEY (fk_usuario_id) REFERENCES usuario (id)
);

CREATE TABLE vaga (
    id SERIAL PRIMARY KEY,
    descricao VARCHAR(300),
    emprego VARCHAR(100), 
    jornada INT,
    salario DECIMAL, 
    fk_turno_id INT, 
    qnt_vagas INT,
    fk_empresa_id INT, 
    fk_tipo_vaga INT,
    FOREIGN KEY (fk_turno_id) REFERENCES turno (id),
    FOREIGN KEY (fk_empresa_id) REFERENCES empresa (id),
    FOREIGN KEY (fk_tipo_vaga) REFERENCES tipo_vaga (id)
);
