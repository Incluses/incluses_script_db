-- Criação do banco de dados e conexão
--CREATE DATABASE diversis;

-- Esta linha é usada apenas em psql e deve ser omitida se não estiver usando o cliente psql diretamente
--\c diversis

-- Criação das tabelas de log
CREATE TABLE telefone_log(
	id SERIAL PRIMARY KEY,
	id_telefone int,
	data_alteracao date not null,
	operacao varchar(80) NOT NULL,
	telefone_passado varchar(15),
	telefone_alterado varchar(15),
    alterado_por VARCHAR(255) 
);

CREATE TABLE endereco_log (
    id SERIAL PRIMARY KEY,
    endereco_id INT NOT NULL,
    operacao varchar(80) NOT NULL,
    rua_anterior VARCHAR(200),
    estado_anterior VARCHAR(100),
    numero_anterior INT,
    rua_nova VARCHAR(200),
    estado_novo VARCHAR(100),
    numero_novo INT,
    data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario varchar(80) NOT NULL
);

CREATE TABLE usuario_log (
    id SERIAL PRIMARY KEY,
    tabela_alterada VARCHAR(50) NOT NULL,
    registro_id INT NOT NULL,
    alterado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    campo_alterado VARCHAR(255) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    alterado_por VARCHAR(255) 
);

CREATE TABLE empresa_log (
    id SERIAL PRIMARY KEY,
    tabela_alterada VARCHAR(50) NOT NULL,
    registro_id INT NOT NULL,
    alterado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    campo_alterado VARCHAR(255) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    alterado_por VARCHAR(255) 
);

CREATE TABLE configuracao_log(
	id SERIAL PRIMARY KEY,
	id_configuracao int,
	data_alteracao date not null,
	operacao varchar(80) NOT NULL,
	notificacao_passado BOOLEAN,
	notificacao_alterado BOOLEAN,
    alterado_por VARCHAR(255) 
);

CREATE TABLE arquivo_log(
	id SERIAL PRIMARY KEY,
	id_arquivo int,
	data_alteracao date not null,
	operacao varchar(80) NOT NULL,
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
    curso_id INT NOT NULL,
    alterado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    campo_alterado VARCHAR(255) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    alterado_por VARCHAR(255),
	operacao varchar(80) NOT NULL
);

CREATE TABLE vaga_log (
    id SERIAL PRIMARY KEY,
    vaga_id INT NOT NULL,
    alterado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    campo_alterado VARCHAR(255) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    alterado_por VARCHAR(255),
	operacao varchar(80) NOT NULL
);


-- Function
CREATE OR REPLACE FUNCTION func_telefone_log() RETURNS trigger AS $$
DECLARE
    alterado_por varchar(80);
BEGIN
	SELECT current_user INTO usuario;
	INSERT INTO telefone_log(id_telefone,data_alteracao,operacao,telefone_passado,telefone_alterado,alterado_por)
		VALUES(NEW.id, current_date, TG_OP, old.telefone, new.telefone ,alterado_por);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_endereco_log() RETURNS trigger AS $$
DECLARE
    alterado_por varchar(80);
BEGIN
	SELECT current_user INTO usuario;
	INSERT INTO endereco_log(endereco_id, operacao, rua_anterior, estado_anterior, numero_anterior, 
                         rua_nova, estado_novo, numero_novo, alterado_por)
    VALUES(OLD.id, TG_OP, OLD.rua, OLD.estado, OLD.numero, 
           NEW.rua, NEW.estado, NEW.numero, alterado_por);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_perfil_usuario_log()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.fk_tipo_perfil_id = 2 OR NEW.fk_tipo_perfil_id = 2 THEN
        IF OLD.nome IS DISTINCT FROM NEW.nome THEN
            INSERT INTO usuario_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'nome', OLD.nome, NEW.nome, current_user);
        END IF;
        IF OLD.senha IS DISTINCT FROM NEW.senha THEN
            INSERT INTO usuario_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'senha', OLD.senha, NEW.senha, current_user);
        END IF;
        IF OLD.email IS DISTINCT FROM NEW.email THEN
            INSERT INTO usuario_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'email', OLD.email, NEW.email, current_user);
        END IF;
        IF OLD.biografia IS DISTINCT FROM NEW.biografia THEN
            INSERT INTO usuario_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'biografia', OLD.biografia, NEW.biografia, current_user);
        END IF;
        IF OLD.fk_tipo_perfil_id IS DISTINCT FROM NEW.fk_tipo_perfil_id THEN
            INSERT INTO usuario_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'fk_tipo_perfil_id', OLD.fk_tipo_perfil_id::TEXT, NEW.fk_tipo_perfil_id::TEXT, current_user);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION func_usuario_log()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.cpf IS DISTINCT FROM NEW.cpf THEN
        INSERT INTO usuario_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES ('usuario', NEW.id, 'cpf', OLD.cpf, NEW.cpf, current_user);
    END IF;
    IF OLD.fk_situacao_trabalhista_id IS DISTINCT FROM NEW.fk_situacao_trabalhista_id THEN
        INSERT INTO usuario_log (tabela_alterada, registro_id,campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES ('usuario', NEW.id, 'fk_situacao_trabalhista_id', OLD.fk_situacao_trabalhista_id::TEXT, NEW.fk_situacao_trabalhista_id::TEXT, current_user);
    END IF;
    IF OLD.fk_curriculo_id IS DISTINCT FROM NEW.fk_curriculo_id THEN
        INSERT INTO usuario_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES ('usuario', NEW.id, 'fk_curriculo_id', OLD.fk_curriculo_id::TEXT, NEW.fk_curriculo_id::TEXT, current_user);
    END IF;
    IF OLD.dt_nascimento IS DISTINCT FROM NEW.dt_nascimento THEN
        INSERT INTO usuario_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES ('usuario', NEW.id, 'dt_nascimento', OLD.dt_nascimento::TEXT, NEW.dt_nascimento::TEXT, current_user);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_perfil_empresa_log()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.fk_tipo_perfil_id = 1 OR NEW.fk_tipo_perfil_id = 1 THEN
        IF OLD.nome IS DISTINCT FROM NEW.nome THEN
            INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'nome', OLD.nome, NEW.nome, current_user);
        END IF;
        IF OLD.senha IS DISTINCT FROM NEW.senha THEN
            INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'senha', OLD.senha, NEW.senha, current_user);
        END IF;
        IF OLD.email IS DISTINCT FROM NEW.email THEN
            INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'email', OLD.email, NEW.email, current_user);
        END IF;
        IF OLD.biografia IS DISTINCT FROM NEW.biografia THEN
            INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'biografia', OLD.biografia, NEW.biografia, current_user);
        END IF;
        IF OLD.fk_tipo_perfil_id IS DISTINCT FROM NEW.fk_tipo_perfil_id THEN
            INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'fk_tipo_perfil_id', OLD.fk_tipo_perfil_id::TEXT, NEW.fk_tipo_perfil_id::TEXT, current_user);
        END IF;
        IF OLD.fk_arquivo_id IS DISTINCT FROM NEW.fk_arquivo_id THEN
            INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
            VALUES ('perfil', NEW.id, 'fk_arquivo_id', OLD.fk_arquivo_id::TEXT, NEW.fk_arquivo_id::TEXT, current_user);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION func_empresa_log()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.cnpj IS DISTINCT FROM NEW.cnpj THEN
        INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES ('empresa', NEW.id, 'cnpj', OLD.cnpj, NEW.cnpj, current_user);
    END IF;
    IF OLD.razao_social IS DISTINCT FROM NEW.razao_social THEN
        INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES ('empresa', NEW.id, 'razao_social', OLD.razao_social, NEW.razao_social, current_user);
    END IF;
    IF OLD.website IS DISTINCT FROM NEW.website THEN
        INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES ('empresa', NEW.id, 'website', OLD.website, NEW.website, current_user);
    END IF;
    IF OLD.matriz_id IS DISTINCT FROM NEW.matriz_id THEN
        INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES ('empresa', NEW.id, 'matriz_id', OLD.matriz_id, NEW.matriz_id, current_user);
    END IF;
    IF OLD.fk_setor_id IS DISTINCT FROM NEW.fk_setor_id THEN
        INSERT INTO empresa_log (tabela_alterada, registro_id, campo_alterado, valor_antigo, valor_novo, alterado_por)
        VALUES ('empresa', NEW.id, 'fk_setor_id', OLD.fk_setor_id, NEW.fk_setor_id, current_user);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_configuracao_log() RETURNS trigger AS $$
DECLARE
    usuario varchar(80);
BEGIN
	SELECT current_user INTO usuario;
	INSERT INTO configuracao_log(id_configuracao,data_alteracao,operacao,notificacao_passado,notificacao_alterado,alterado_por)
		VALUES(NEW.id, current_date, TG_OP, old.notificacao, new.notificacao ,usuario);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_arquivo_log() RETURNS trigger AS $$
DECLARE
    usuario varchar(80);
BEGIN
	SELECT current_user INTO usuario;
	INSERT INTO arquivo_log(
	id_arquivo,
	data_alteracao,
	operacao,	
	s3_url_passado,
    s3_key_passado,
    tamanho_passado,
    s3_url_alterado,
    s3_key_alterado,
    tamanho_alterado,alterado_por)
		VALUES(
	NEW.id, 
	current_date, 
	TG_OP, 
	old.s3_url,
	old.s3_key,
	old.tamanho,
	new.s3_url,
	new.s3_key,
	new.tamanho, 
	usuario);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_curso_log()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.descricao IS DISTINCT FROM NEW.descricao THEN
        INSERT INTO curso_log (curso_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'descricao', OLD.descricao, NEW.descricao, current_user,TG_OP);
    END IF;
    IF OLD.carga_horaria IS DISTINCT FROM NEW.carga_horaria THEN
        INSERT INTO curso_log (curso_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'carga_horaria', OLD.carga_horaria, NEW.carga_horaria, current_user,TG_OP);
    END IF;
    IF OLD.nome IS DISTINCT FROM NEW.nome THEN
        INSERT INTO curso_log (curso_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'nome', OLD.nome, NEW.nome, current_user,TG_OP);
    END IF;
    IF OLD.fk_status_curso_id IS DISTINCT FROM NEW.fk_status_curso_id THEN
        INSERT INTO curso_log (curso_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'fk_status_curso_id', OLD.fk_status_curso_id, NEW.fk_status_curso_id, current_user,TG_OP);
    END IF;    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func_vaga_log()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.descricao IS DISTINCT FROM NEW.descricao THEN
        INSERT INTO vaga_log (vaga_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'descricao', OLD.descricao, NEW.descricao, current_user,TG_OP);
    END IF;
    IF OLD.emprego IS DISTINCT FROM NEW.emprego THEN
        INSERT INTO vaga_log (vaga_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'emprego', OLD.emprego, NEW.emprego, current_user,TG_OP);
    END IF;
    IF OLD.jornada IS DISTINCT FROM NEW.jornada THEN
        INSERT INTO vaga_log (vaga_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'jornada', OLD.jornada, NEW.jornada, current_user,TG_OP);
    END IF;
    IF OLD.salario IS DISTINCT FROM NEW.salario THEN
        INSERT INTO vaga_log (vaga_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'salario', OLD.salario, NEW.salario, current_user,TG_OP);
    END IF;
    IF OLD.fk_turno_id IS DISTINCT FROM NEW.fk_turno_id THEN
        INSERT INTO vaga_log (vaga_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'fk_turno_id', OLD.fk_turno_id, NEW.fk_turno_id, current_user,TG_OP);
    END IF;
    IF OLD.qnt_vagas IS DISTINCT FROM NEW.qnt_vagas THEN
        INSERT INTO vaga_log (vaga_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'qnt_vagas', OLD.qnt_vagas, NEW.qnt_vagas, current_user,TG_OP);
    END IF;
    IF OLD.fk_tipo_vaga IS DISTINCT FROM NEW.fk_tipo_vaga THEN
        INSERT INTO vaga_log (vaga_id, campo_alterado, valor_antigo, valor_novo, alterado_por,operacao)
        VALUES (NEW.id, 'fk_tipo_vaga', OLD.fk_tipo_vaga, NEW.fk_tipo_vaga, current_user,TG_OP);
    END IF;
   
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trig_telefone_log
AFTER INSERT OR UPDATE OR DELETE ON telefone
FOR EACH ROW
EXECUTE PROCEDURE func_telefone_log();

CREATE TRIGGER trig_endereco_log
AFTER INSERT OR UPDATE OR DELETE ON endereco
FOR EACH ROW
EXECUTE PROCEDURE func_endereco_log();

CREATE TRIGGER trig_usuario_log
AFTER INSERT OR UPDATE ON usuario
FOR EACH ROW
EXECUTE FUNCTION func_usuario_log();

CREATE TRIGGER trig_perfil_usuario_log
after INSERT OR UPDATE ON perfil
FOR EACH ROW
EXECUTE FUNCTION func_perfil_usuario_log();

CREATE TRIGGER trig_empresa_log
AFTER INSERT OR UPDATE ON empresa
FOR EACH ROW
EXECUTE FUNCTION func_empresa_log();

CREATE TRIGGER trig_perfil_empresa_log
after INSERT OR UPDATE ON perfil
FOR EACH ROW
EXECUTE FUNCTION func_perfil_empresa_log();

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