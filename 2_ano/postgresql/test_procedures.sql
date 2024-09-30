-- Procedures
CREATE OR REPLACE FUNCTION criar_perfil (
    p_nome VARCHAR,
    p_senha VARCHAR,
    p_email VARCHAR,
    p_tipo_perfil_id UUID,
    t_telefone VARCHAR
) RETURNS UUID LANGUAGE plpgsql AS $$

    DECLARE 
        id_perfil UUID;

    BEGIN
        -- criando perfil
        INSERT INTO perfil(nome, senha, email, fk_tipo_perfil_id) 
        VALUES(p_nome, p_senha, p_email, p_tipo_perfil_id)
        RETURNING id INTO id_perfil;

        -- criando telefone
        INSERT INTO telefone(telefone, fk_perfil_id)
        VALUES(t_telefone, id_perfil); 

        -- criando configuração
        INSERT INTO configuracao(notificacao, fk_perfil_id) VALUES (false, id_perfil);

        -- retornando o id_perfil
        RETURN id_perfil;
    END;

$$;
-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE deletar_perfil(
    id_perfil UUID
) LANGUAGE plpgsql AS $$
    DECLARE 
        id_ft_perfil UUID;
        ids_cursos UUID[];
    BEGIN
        -- Consultando o id da foto de perfil 
        SELECT fk_ft_perfil_id INTO id_ft_perfil FROM perfil WHERE id = id_perfil;

        -- Consultando os ids dos cursos referentes ao perfil 
        SELECT array_agg(id) INTO ids_cursos FROM curso WHERE fk_perfil_id = id_perfil;

        -- Deletando telefone
        DELETE FROM telefone WHERE fk_perfil_id = id_perfil;

        -- Deletando curso(s)
        CALL deletar_curso(ids_cursos);

        -- Deletando configuração
        DELETE FROM configuracao WHERE fk_perfil_id = id_perfil;

        -- Deletando perfil
        DELETE FROM perfil WHERE id = id_perfil;

        -- Deletando foto de perfil da tabela arquivo (se necessário)
        DELETE FROM arquivo WHERE id = id_ft_perfil;
    END;
$$;
----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE deletar_curso(
    c_uuids UUID[]                                                                                       
) LANGUAGE plpgsql AS $$
    BEGIN
        -- Deletando inscrições do curso 
        DELETE FROM inscricao_curso WHERE fk_curso_id = ANY(c_uuids);

        -- Deletando curso(s)
        DELETE FROM curso WHERE id = ANY(c_uuids);
    END;
$$;
-----------------------------------------------------------
CREATE OR REPLACE PROCEDURE deletar_vaga(
    v_uuids UUID[] 
) LANGUAGE plpgsql AS $$
    BEGIN
        -- Deletando inscrições das vagas
        DELETE FROM inscricao_vaga WHERE fk_vaga_id = ANY(v_uuids);

        -- Deletando vaga(s)
        DELETE FROM vaga WHERE id = ANY(v_uuids);
    END;
$$;
--------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE criar_setor(
    s_nome VARCHAR
) LANGUAGE plpgsql AS $$
    DECLARE 
        id_setor UUID;
    BEGIN
        -- Inserindo setor
        INSERT INTO setor(nome) VALUES(s_nome) RETURNING id INTO id_setor;
    END;
$$;
----------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE criar_usuario(
    -- parâmetros do usuário
    u_cpf VARCHAR,
    u_dt_nascimento DATE,
    u_pronomes VARCHAR,
    u_nome_social VARCHAR,
    -- parâmetros do perfil
    p_nome VARCHAR,
    p_senha VARCHAR,
    p_email VARCHAR,
    t_telefone VARCHAR
) LANGUAGE plpgsql AS $$
    DECLARE 
        id_perfil UUID;
        id_tipo_perfil UUID;
    BEGIN
        -- Consultando o id do tipo do perfil USUARIO
        SELECT id INTO id_tipo_perfil FROM tipo_perfil WHERE nome = 'USUARIO';

        -- Criando perfil para o usuário
        SELECT criar_perfil(p_nome, p_senha, p_email, id_tipo_perfil, t_telefone) INTO id_perfil;

        -- Criando usuário
        INSERT INTO usuario(cpf, dt_nascimento, pronomes, nome_social, fk_perfil_id) 
        VALUES (u_cpf, u_dt_nascimento, u_pronomes, u_nome_social, id_perfil);

    END;
$$;

CALL criar_usuario(
	'78956703459',
	'01-01-2000',
	'Ela/Dela',
	'Laura',
	'Laura Farias',
	'lau1234',
	'lauraFariaso@gmail.com',
	'97758680357'
);

select * from usuario;
select * from perfil;
----------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE criar_empresa(
    -- parâmetros da empresa
    e_cnpj VARCHAR,
    e_razao_social VARCHAR,
    e_website VARCHAR,
    e_setor VARCHAR,

    -- parâmetros de endereço
    en_rua VARCHAR,
    en_estado VARCHAR,
    en_cidade VARCHAR,
    en_cep VARCHAR,
    en_numero INT,

    -- parâmetros de perfil
    p_nome VARCHAR,
    p_senha VARCHAR,
    p_email VARCHAR,
    t_telefone VARCHAR

) LANGUAGE plpgsql AS $$
    DECLARE 
        id_endereco UUID;
        id_tipo_perfil UUID;
        id_perfil UUID;
		id_setor UUID;

    BEGIN
	
        -- Consultando o ID do tipo_perfil para EMPRESA
        SELECT id INTO id_tipo_perfil FROM tipo_perfil WHERE nome = 'EMPRESA';

        -- Criando perfil
        SELECT criar_perfil(p_nome, p_senha, p_email, id_tipo_perfil, t_telefone) INTO id_perfil;

        -- Criando endereço
        INSERT INTO endereco(rua, estado, cidade, cep, numero) 
        VALUES (en_rua, en_estado, en_cidade, en_cep, en_numero) 
        RETURNING id INTO id_endereco;
		
		-- Verificando se o setor existe (caso ele não exista, nós criamos)
		IF e_setor NOT IN (SELECT nome FROM setor) THEN 
			CALL criar_setor(e_setor);
		END IF;

		-- Consultando ID do setor referente à empresa
		SELECT id INTO id_setor FROM setor WHERE nome = e_setor;
		
        -- Criando empresa
        INSERT INTO empresa(cnpj, razao_social, website, fk_perfil_id, fk_endereco_id, fk_setor_id) 
        VALUES (e_cnpj, e_razao_social, e_website, id_perfil, id_endereco, id_setor);

    END;
$$;

INSERT INTO setor(nome) VALUES ('Tecnologia')
select * from setor;

CALL criar_empresa(
	'09567894567916',
	'Swifft',
	'https://swifft.com',
	'Alimentação',
	'Rua das carnes',
	'São Paulo',
	'São Paulo',
	'78560158',
	16,
	'Swifft',
	'boi12345',
	'swifft@gmail.com',
	'78560157825'
);

select * from empresa;
select * from setor;
select * from perfil;
-------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE deletar_usuario(
    id_usuario UUID
) LANGUAGE plpgsql AS $$
    DECLARE 
        id_perfil UUID;
    BEGIN
        -- Pegando id do perfil do usuário 
        SELECT fk_perfil_id INTO id_perfil FROM usuario WHERE id = id_usuario;

        -- Deletando inscrição do curso 
        DELETE FROM inscricao_curso WHERE fk_usuario_id = id_usuario;

        -- Deletando inscrição da vaga
        DELETE FROM inscricao_vaga WHERE fk_usuario_id = id_usuario;

        -- Deletando usuário 
        DELETE FROM usuario WHERE id = id_usuario;

        -- Deletando perfil 
        CALL deletar_perfil(id_perfil);
    END;
$$;

select * from usuario;
-- 9b5e1e3f-cbb8-4787-8f17-b48623081673
CALL deletar_usuario('9b5e1e3f-cbb8-4787-8f17-b48623081673');
select * from usuario;
select * from telefone;
select * from inscricao_curso;
select * from inscricao_vaga;
select * from curso;
-------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE deletar_empresa(
    id_empresa UUID
) LANGUAGE plpgsql AS $$
    DECLARE  
        id_perfil UUID;
        id_endereco UUID;
        ids_vagas UUID[];
    BEGIN 
        -- Pegando id do perfil referente à empresa 
        SELECT fk_perfil_id INTO id_perfil FROM empresa WHERE id = id_empresa;

        -- Pegando os ids de todas as vagas referentes à empresa
        SELECT array_agg(id) INTO ids_vagas FROM vaga WHERE fk_empresa_id = id_empresa;

        -- Pegando o id do endereço referente à empresa
        SELECT fk_endereco_id INTO id_endereco FROM empresa WHERE id = id_empresa;

        -- Deletando vaga
        CALL deletar_vaga(ids_vagas);

        -- Deletando empresa 
        DELETE FROM empresa WHERE id = id_empresa;

        -- Deletando endereço 
        DELETE FROM endereco WHERE id = id_endereco;

        -- Deletando perfil 
        CALL deletar_perfil(id_perfil);
    END;
$$;

select * from empresa;
select * from vaga;
select * from inscricao_vaga;
-- c89d3227-dbc0-40c5-a48f-8f558e4d3e05
select * from telefone;
CALL deletar_empresa('c89d3227-dbc0-40c5-a48f-8f558e4d3e05');
select * from empresa where id =  '25489041-febd-43d8-b4b6-e584132687d3';
--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE criar_curso(
    c_descricao VARCHAR,
    c_nome VARCHAR,
    c_perfil_id UUID
) LANGUAGE plpgsql AS $$
    BEGIN 
        -- Inserindo curso 
        INSERT INTO curso(descricao, nome, fk_perfil_id) VALUES (c_descricao, c_nome, c_perfil_id);
    END;
$$;
select * from perfil; -- b69b7e0c-7001-4264-9ddb-5c2e1e1d5928
CALL criar_curso(
	'Aqui vc vai aprender mobile',
	'Curso de Python',
	'b69b7e0c-7001-4264-9ddb-5c2e1e1d5928'
);
select * from curso;
--------------------------------------------------------------
CREATE OR REPLACE PROCEDURE criar_inscricao_curso(
    ic_usuario_id UUID,
    ic_curso_id UUID
) LANGUAGE plpgsql AS $$
    BEGIN 
        -- Inserindo inscrição do curso
        INSERT INTO inscricao_curso(fk_usuario_id, fk_curso_id) VALUES (ic_usuario_id, ic_curso_id);
    END;
$$;

select * from usuario;
-- 38a68310-e28f-41f7-b827-456b6cc6cf01 -> USER
-- fe7e01bc-74fa-4d83-bd37-930abdb031c8 -> Curso

CALL criar_inscricao_curso(
	'38a68310-e28f-41f7-b827-456b6cc6cf01',
	'fe7e01bc-74fa-4d83-bd37-930abdb031c8'
);
select * from inscricao_curso;
---------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE criar_vaga(
    -- Parâmetros da vaga
    v_descricao VARCHAR, 
    v_nome VARCHAR,
    v_empresa_id UUID,
    v_tipo_vaga_id UUID
) LANGUAGE plpgsql AS $$
    BEGIN 
        -- Inserindo vaga
        INSERT INTO vaga(descricao, nome, fk_empresa_id, fk_tipo_vaga_id) VALUES (v_descricao, v_nome, v_empresa_id, v_tipo_vaga_id);
    END;
$$;

select * from empresa;
select * from tipo_vaga;
-- c89d3227-dbc0-40c5-a48f-8f558e4d3e05 -> empresa
-- a0f07581-ecd3-421a-8e8f-aa15b710e16c -> tipo_vaga presencial
select * from usuario;
CALL criar_vaga(
	'Horas: 8, Salário: 9387298 milhões',
	'Programador Back-end',
	'c89d3227-dbc0-40c5-a48f-8f558e4d3e05',
	'a0f07581-ecd3-421a-8e8f-aa15b710e16c'
);
select * from vaga;
-----------------------------------------------------------
-- 1a621243-f719-45d2-8501-21c5466d25e2 -> vaga
-- bd3bf613-333b-4821-8a12-b7e2efb85211 -> USER
CREATE OR REPLACE PROCEDURE criar_inscricao_vaga(
    iv_usuario_id UUID, 
    iv_vaga_id UUID
) LANGUAGE plpgsql AS $$
    BEGIN
        -- Criando inscrição da vaga 
        INSERT INTO inscricao_vaga(fk_usuario_id, fk_vaga_id) VALUES(iv_usuario_id, iv_vaga_id);
    END; 
$$;
select * from inscricao_vaga;
select * from usuario;
select * from vaga;
CALL criar_inscricao_vaga('bd3bf613-333b-4821-8a12-b7e2efb85211', '1a621243-f719-45d2-8501-21c5466d25e2');