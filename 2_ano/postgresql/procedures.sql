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

CREATE OR REPLACE PROCEDURE deletar_perfil(
    id_perfil UUID
) LANGUAGE plpgsql AS $$
    DECLARE 
        id_ft_perfil UUID;
        ids_cursos UUID[];
    BEGIN
        -- Consultando o id da foto de perfil 
        SELECT fk_ft_perfil_id INTO id_ft_perfil FROM perfil WHERE id = id_perfil;

        -- Consultando os ids dos cursos referentes ao perfil da empresa
        SELECT array_agg(id) INTO ids_cursos FROM curso WHERE fk_perfil_id = id_perfil;

        -- Deletando telefone
        DELETE FROM telefone WHERE fk_perfil_id = id_perfil;

        -- Deletando curso(s)
        CALL deletar_curso(ids_cursos);

        DELETE FROM curso WHERE fk_perfil_id = id_perfil;

        -- Deletando configuração
        DELETE FROM configuracao WHERE fk_perfil_id = id_perfil;

        -- Deletando perfil
        DELETE FROM perfil WHERE id = id_perfil;

        -- Deletando foto de perfil da tabela arquivo (se necessário)
        DELETE FROM arquivo WHERE id = id_ft_perfil;
    END;
$$;

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

CREATE OR REPLACE PROCEDURE deletar_setor(
    s_setor_id UUID
) LANGUAGE plpgsql AS $$
    BEGIN 
        -- Deletando empresa(s) que tem o setor 
        DELETE FROM empresa WHERE fk_setor_id = s_setor_id;

        -- Deletando setor 
        DELETE FROM setor WHERE id = s_setor_id;
    END;
$$;

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

CREATE OR REPLACE PROCEDURE criar_inscricao_vaga(
    iv_usuario_id UUID, 
    iv_vaga_id UUID
) LANGUAGE plpgsql AS $$
    BEGIN
        -- Criando inscrição da vaga 
        INSERT INTO inscricao_vaga(fk_usuario_id, fk_vaga_id) VALUES(iv_usuario_id, iv_vaga_id);
    END; 
$$;

CREATE OR REPLACE PROCEDURE criar_inscricao_curso(
    ic_usuario_id UUID,
    ic_curso_id UUID
) LANGUAGE plpgsql AS $$
    BEGIN 
        -- Inserindo inscrição do curso
        INSERT INTO inscricao_curso(fk_usuario_id, fk_curso_id) VALUES (ic_usuario_id, ic_curso_id);
    END;
$$;

CREATE OR REPLACE PROCEDURE criar_material_curso(
    mc_descricao VARCHAR,
    mc_curso_id UUID,
    mc_arquivo_id UUID,
    mc_nome VARCHAR
) LANGUAGE plpgsql AS $$
    BEGIN
        -- Deletando material curso
        INSERT INTO material_curso(descricao, nome, fk_curso_id, fk_arquivo_id) VALUES (mc_descricao, mc_nome, mc_curso_id, mc_arquivo_id);
    END;
$$;

