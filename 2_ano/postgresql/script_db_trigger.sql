-- Criação das tabelas de log
CREATE TABLE telefone_log (
    id SERIAL PRIMARY KEY,
    telefone_id UUID,
    data_alteracao DATE NOT NULL,
    operacao VARCHAR(80) NOT NULL,
    telefone_passado VARCHAR(15),
    telefone_alterado VARCHAR(15),
    alterado_por VARCHAR(255) 
);

CREATE TABLE endereco_log (
    id SERIAL PRIMARY KEY,
    endereco_id UUID,
    operacao VARCHAR(80) NOT NULL,
    rua_anterior VARCHAR(200),
    estado_anterior VARCHAR(100),
    numero_anterior INT,
    rua_nova VARCHAR(200),
    estado_novo VARCHAR(100),
    numero_novo INT,
    data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    alterado_por VARCHAR(80) NOT NULL
);

CREATE TABLE usuario_log (
    id SERIAL PRIMARY KEY,
    usuario_id UUID,
    alterado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    campo_alterado VARCHAR(255) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    alterado_por VARCHAR(255) 
);

CREATE TABLE perfil_log (
    id SERIAL PRIMARY KEY,
    perfil_id UUID,
    alterado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    campo_alterado VARCHAR(255) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    alterado_por VARCHAR(255) 
);

CREATE TABLE empresa_log (
    id SERIAL PRIMARY KEY,
    empresa_id UUID,
    alterado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    campo_alterado VARCHAR(255) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    alterado_por VARCHAR(255) 
);

CREATE TABLE configuracao_log (
    id SERIAL PRIMARY KEY,
    configuracao_id UUID,
    data_alteracao DATE NOT NULL,
    operacao VARCHAR(80) NOT NULL,
    notificacao_passado BOOLEAN,
    notificacao_alterado BOOLEAN,
    alterado_por VARCHAR(255) 
);

CREATE TABLE arquivo_log (
    id SERIAL PRIMARY KEY,
    arquivo_id UUID,
    data_alteracao DATE NOT NULL,
    operacao VARCHAR(80) NOT NULL,
    s3_url_passado VARCHAR(300),
    s3_key_passado VARCHAR(50),
    tamanho_passado VARCHAR(50),
    s3_url_alterado VARCHAR(300),
    s3_key_alterado VARCHAR(50),
    tamanho_alterado VARCHAR(50),
    alterado_por VARCHAR(255) 
);

CREATE TABLE curso_log (
    id SERIAL PRIMARY KEY,
    curso_id UUID,
    alterado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    campo_alterado VARCHAR(255) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    alterado_por VARCHAR(255),
    operacao VARCHAR(80) NOT NULL
);

CREATE TABLE vaga_log (
    id SERIAL PRIMARY KEY,
    vaga_id UUID,
    alterado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    campo_alterado VARCHAR(255) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    alterado_por VARCHAR(255),
    operacao VARCHAR(80) NOT NULL
);

-- Funções para as tabelas de log

CREATE OR REPLACE FUNCTION func_telefone_log() RETURNS trigger AS $$
DECLARE
    alterado_por VARCHAR(80);
BEGIN
    SELECT current_user INTO alterado_por;
    INSERT INTO telefone_log(telefone_id, data_alteracao, operacao, telefone_passado, telefone_alterado, alterado_por)
    VALUES(NEW.id, CURRENT_DATE, TG_OP, OLD.telefone, NEW.telefone, alterado_por);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_endereco_log() RETURNS trigger AS $$
DECLARE
    alterado_por VARCHAR(80);
BEGIN
    SELECT current_user INTO alterado_por;
    INSERT INTO endereco_log(endereco_id, operacao, rua_anterior, estado_anterior, numero_anterior, 
                             rua_nova, estado_novo, numero_novo, alterado_por)
    VALUES(OLD.id, TG_OP, OLD.rua, OLD.estado, OLD.numero, 
           NEW.rua, NEW.estado, NEW.numero, alterado_por);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_perfil_log() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.nome IS DISTINCT FROM NEW.nome THEN
        INSERT INTO perfil_log (perfil_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'nome', OLD.nome, NEW.nome, current_user);
    END IF;
    IF OLD.senha IS DISTINCT FROM NEW.senha THEN
        INSERT INTO perfil_log (perfil_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'senha', OLD.senha, NEW.senha, current_user);
    END IF;
    IF OLD.email IS DISTINCT FROM NEW.email THEN
        INSERT INTO perfil_log (perfil_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'email', OLD.email, NEW.email, current_user);
    END IF;
    IF OLD.biografia IS DISTINCT FROM NEW.biografia THEN
        INSERT INTO perfil_log (perfil_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'biografia', OLD.biografia, NEW.biografia, current_user);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_usuario_log() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.cpf IS DISTINCT FROM NEW.cpf THEN
        INSERT INTO usuario_log (usuario_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'cpf', OLD.cpf, NEW.cpf, current_user);
    END IF;
    IF OLD.pronomes IS DISTINCT FROM NEW.pronomes THEN
        INSERT INTO usuario_log (usuario_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'pronomes', OLD.pronomes, NEW.pronomes, current_user);
    END IF;
    IF OLD.nome_social IS DISTINCT FROM NEW.nome_social THEN
        INSERT INTO usuario_log (usuario_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'nome_social', OLD.nome_social, NEW.nome_social, current_user);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_empresa_log() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.cnpj IS DISTINCT FROM NEW.cnpj THEN
        INSERT INTO empresa_log (empresa_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'cnpj', OLD.cnpj, NEW.cnpj, current_user);
    END IF;
    IF OLD.razao_social IS DISTINCT FROM NEW.razao_social THEN
        INSERT INTO empresa_log (empresa_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'razao_social', OLD.razao_social, NEW.razao_social, current_user);
    END IF;
    IF OLD.website IS DISTINCT FROM NEW.website THEN
        INSERT INTO empresa_log (empresa_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES (NEW.id, 'website', OLD.website, NEW.website, current_user);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_configuracao_log() RETURNS trigger AS $$
DECLARE
    usuario VARCHAR(80);
BEGIN
    SELECT current_user INTO usuario;
    INSERT INTO configuracao_log(configuracao_id, data_alteracao, operacao, notificacao_passado, notificacao_alterado, alterado_por)
    VALUES(NEW.id, CURRENT_DATE, TG_OP, OLD.notificacao, NEW.notificacao, usuario);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_arquivo_log() RETURNS trigger AS $$
DECLARE
    usuario VARCHAR(80);
BEGIN
    SELECT current_user INTO usuario;
    INSERT INTO arquivo_log(arquivo_id, data_alteracao, operacao, 
                            s3_url_passado, s3_key_passado, tamanho_passado,
                            s3_url_alterado, s3_key_alterado, tamanho_alterado, alterado_por)
    VALUES(NEW.id, CURRENT_DATE, TG_OP, OLD.s3_url, OLD.s3_key, OLD.tamanho,
           NEW.s3_url, NEW.s3_key, NEW.tamanho, usuario);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_curso_log() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.descricao IS DISTINCT FROM NEW.descricao THEN
        INSERT INTO curso_log (curso_id, campo_alterado, valor_antigo, valor_novo, alterado_por, operacao)
        VALUES (NEW.id, 'descricao', OLD.descricao, NEW.descricao, current_user, TG_OP);
    END IF;
    IF OLD.nome IS DISTINCT FROM NEW.nome THEN
        INSERT INTO curso_log (curso_id, campo_alterado, valor_antigo, valor_novo, alterado_por, operacao)
        VALUES (NEW.id, 'nome', OLD.nome, NEW.nome, current_user, TG_OP);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_vaga_log() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.descricao IS DISTINCT FROM NEW.descricao THEN
        INSERT INTO vaga_log (vaga_id, campo_alterado, valor_antigo, valor_novo, alterado_por, operacao)
        VALUES (NEW.id, 'descricao', OLD.descricao, NEW.descricao, current_user, TG_OP);
    END IF;
    IF OLD.nome IS DISTINCT FROM NEW.nome THEN
        INSERT INTO curso_log (curso_id, campo_alterado, valor_antigo, valor_novo, alterado_por, operacao)
        VALUES (NEW.id, 'nome', OLD.nome, NEW.nome, current_user, TG_OP);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers

CREATE TRIGGER trig_telefone_log
AFTER INSERT OR UPDATE OR DELETE ON telefone
FOR EACH ROW
EXECUTE PROCEDURE func_telefone_log();

CREATE TRIGGER trig_endereco_log
AFTER INSERT OR UPDATE OR DELETE ON endereco
FOR EACH ROW
EXECUTE PROCEDURE func_endereco_log();

CREATE TRIGGER trig_perfil_log
AFTER INSERT OR UPDATE ON perfil
FOR EACH ROW
EXECUTE FUNCTION func_perfil_log();

CREATE TRIGGER trig_usuario_log
AFTER INSERT OR UPDATE ON usuario
FOR EACH ROW
EXECUTE FUNCTION func_usuario_log();

CREATE TRIGGER trig_empresa_log
AFTER INSERT OR UPDATE ON empresa
FOR EACH ROW
EXECUTE FUNCTION func_empresa_log();

CREATE TRIGGER trig_configuracao_log
AFTER INSERT OR UPDATE OR DELETE ON configuracao
FOR EACH ROW
EXECUTE PROCEDURE func_configuracao_log();

CREATE TRIGGER trig_arquivo_log
AFTER INSERT OR UPDATE OR DELETE ON arquivo
FOR EACH ROW
EXECUTE PROCEDURE func_arquivo_log();

CREATE TRIGGER trig_curso_log
AFTER INSERT OR UPDATE OR DELETE ON curso
FOR EACH ROW
EXECUTE PROCEDURE func_curso_log();

CREATE TRIGGER trig_vaga_log
AFTER INSERT OR UPDATE OR DELETE ON vaga
FOR EACH ROW
EXECUTE PROCEDURE func_vaga_log();