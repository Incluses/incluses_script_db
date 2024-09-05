-- Só falta testar :)

-- Function para criar perfil
CREATE OR REPLACE FUNCTION criar_perfil ( 
    p_nome VARCHAR,
    p_senha VARCHAR,
    p_email VARCHAR,
    p_biografia VARCHAR,
    p_tipo_perfil VARCHAR,
    p_foto_perfil_id INT,
    t_telefone VARCHAR
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    tipo_perfil_id INT;

    tipo_arquivo_id INT;
    perfil_id INT;
BEGIN
    -- Query para pegar o tipo do perfil
    SELECT tp.id INTO tipo_perfil_id FROM tipo_perfil tp WHERE tp.nome = p_tipo_perfil;

    -- Inserindo perfil
    INSERT INTO perfil (nome, senha, email, biografia, tipo_perfil_id, p_foto_perfil_id)
    VALUES (p_nome, p_senha, p_email, p_biografia, tipo_perfil_id, foto_perfil_id)
    RETURNING id INTO perfil_id;

    -- Inserindo telefone
    INSERT INTO telefone (numero, fk_perfil_id)
    VALUES (t_telefone, perfil_id);

    RETURN perfil_id; -- Retornando o ID do perfil 
END;
$$;

-- Function para deletar perfil
CREATE OR REPLACE FUNCTION deletar_perfil( 
    perfil_id INT
) 
RETURNS VOID
LANGUAGE plpgsql AS
$$
BEGIN
    -- Deletando configuração do perfil 
    DELETE FROM configuracao WHERE fk_perfil_id = perfil_id;

    -- Deletando telefone do perfil 
    DELETE FROM telefone WHERE fk_perfil_id = perfil_id;

    -- Deletando material dos cursos do perfil
    DELETE FROM material_curso WHERE fk_curso_id IN (SELECT c.id FROM curso c WHERE c.fk_perfil_id = perfil_id);

    -- Deletando cursos do perfil  
    DELETE FROM curso WHERE fk_perfil_id = perfil_id;

END;
$$;

-- Procedure para cadastrar usuário
CREATE OR REPLACE PROCEDURE cadastrar_usuario(
    -- Parâmetros do usuário
    u_cpf VARCHAR,
    u_situacao_trabalhista VARCHAR,
    u_dt_nascimento DATE,
    u_pronomes VARCHAR,
    u_razao_social VARCHAR,

    -- Parâmetros do perfil
    p_nome VARCHAR,
    p_senha VARCHAR,
    p_email VARCHAR,
    p_biografia VARCHAR,
    p_foto_perfil_id INT,
    t_telefone VARCHAR
)
LANGUAGE plpgsql AS
$$
DECLARE
    perfil_id INT;
    curriculo_id INT;
    tipo_arquivo_id INT;
    situacao_trabalhista_id INT;

BEGIN
    -- Criando perfil para o usuário
    SELECT criar_perfil(
        p_nome,
        p_senha,
        p_email,
        p_biografia,
        'USUARIO',
        p_foto_perfil_id,
        t_telefone
    ) INTO perfil_id;

    -- Criando currículo em arquivo
    INSERT INTO arquivo (nome, s3_url, s3_key, tamanho, tipo_arquivo_id)
    VALUES (a_nome_curriculo, a_s3_url_curriculo, a_s3_key_curriculo, a_tamanho_curriculo, tipo_arquivo_id)
    RETURNING id INTO curriculo_id;

    -- Query para pegar o id da situação trabalhista
    SELECT st.id INTO situacao_trabalhista_id FROM situacao_trabalhista st WHERE st.nome = u_situacao_trabalhista;

    -- Inserindo usuário
    INSERT INTO usuario (cpf, fk_perfil_id, fk_situacao_trabalhista_id, fk_curriculo_id, dt_nascimento, pronomes, razao_social)
    VALUES (u_cpf, perfil_id, situacao_trabalhista_id, curriculo_id, u_dt_nascimento, u_pronomes, u_razao_social);

    -- Inserindo configuração
    INSERT INTO configuracao (alguma_configuracao, fk_perfil_id)
    VALUES (FALSE, perfil_id);

    COMMIT;
END;
$$;

-- Procedure para cadastrar empresa
CREATE OR REPLACE PROCEDURE cadastrar_empresa(
    -- Parâmetros da empresa
    e_cnpj VARCHAR,
    e_razao_social VARCHAR,
    e_website VARCHAR,
    e_matriz VARCHAR,
    e_setor VARCHAR,  -- Adicionado o tipo VARCHAR

    -- Parâmetros do endereço
    en_rua VARCHAR,
    en_estado VARCHAR,
    en_numero INT, 

    -- Parâmetros do perfil
    p_nome VARCHAR,
    p_senha VARCHAR,
    p_email VARCHAR,
    p_biografia VARCHAR,
    p_foto_perfil_id INT,
    t_telefone VARCHAR
) LANGUAGE plpgsql AS
$$
DECLARE 
    perfil_id INT;
    matriz_id INT; 
    endereco_id INT;
    setor_id INT;

BEGIN
    -- Criando perfil para a empresa
    SELECT criar_perfil(
        p_nome,
        p_senha,
        p_email,
        p_biografia,
        'EMPRESA',
        p_foto_perfil_id,
        t_telefone
    ) INTO perfil_id;

    -- Query para pegar o ID da empresa matriz
    SELECT e.id INTO matriz_id FROM empresa e WHERE e.nome = e_matriz;

    -- Query para pegar o ID do setor da empresa
    SELECT s.id INTO setor_id FROM setor s WHERE s.nome = e_setor;

    -- Inserindo configuração
    INSERT INTO configuracao (alguma_configuracao, fk_perfil_id)
    VALUES (FALSE, perfil_id);
    
    -- Inserindo telefone
    INSERT INTO telefone (numero, fk_perfil_id)
    VALUES (t_telefone, perfil_id);

    -- Inserindo endereço
    INSERT INTO endereco (rua, estado, numero)
    VALUES (en_rua, en_estado, en_numero)
    RETURNING id INTO endereco_id;

    -- Inserindo empresa
    INSERT INTO empresa (cnpj, razao_social, website, fk_matriz_id, fk_perfil_id, fk_endereco_id, fk_setor_id)
    VALUES (e_cnpj, e_razao_social, e_website, matriz_id, perfil_id, endereco_id, setor_id);

    COMMIT; 
END;
$$;

-- Procedure para deletar curso
CREATE OR REPLACE PROCEDURE deletar_curso (
    c_curso_id INT
) 
LANGUAGE plpgsql AS
$$
DECLARE
    arquivos_ids INT[];

BEGIN
    -- Deletando material curso 
    DELETE FROM material_curso WHERE fk_curso_id = c_curso_id RETURNING fk_arquivos_id INTO arquivos_ids;

    -- Deletando os arquivos referentes ao material do curso
    DELETE FROM arquivo WHERE id = ANY(arquivos_ids);

    -- Deletando inscrição do curso 
    DELETE FROM inscricao_curso WHERE fk_curso_id = c_curso_id;

    -- Deletando curso
    DELETE FROM curso WHERE id = c_curso_id;

    COMMIT;
END;
$$;

-- Procedure para deletar usuário
CREATE OR REPLACE PROCEDURE deletar_usuario(
    u_usuario_id INT
)
LANGUAGE plpgsql AS
$$ 
DECLARE 
    perfil_id INT;
    arquivo_id INT;

BEGIN
    -- Pegando o ID do perfil
    SELECT u.fk_perfil_id INTO perfil_id FROM usuario u WHERE u.id = u_usuario_id;

    -- Deletando inscrição do curso do usuário
    DELETE FROM inscricao_curso WHERE fk_usuario_id = u_usuario_id;

    -- Deletando inscrição da vaga do usuário  
    DELETE FROM inscricao_vaga WHERE fk_usuario_id = u_usuario_id;

    -- Deletando usuário
    DELETE FROM usuario WHERE id = u_usuario_id RETURNING fk_curriculo_id INTO arquivo_id;

    -- Deletando currículo do usuário na tabela de arquivo
    DELETE FROM arquivo WHERE id = arquivo_id;

    -- Deletando perfil
    SELECT deletar_perfil(perfil_id);

    COMMIT; 
END;
$$;

-- Procedure para deletar empresa
CREATE OR REPLACE PROCEDURE deletar_empresa(
    e_empresa_id INT
) LANGUAGE plpgsql AS
$$
DECLARE
    perfil_id INT;

BEGIN 
    -- Pegando ID do perfil 
    SELECT e.fk_perfil_id INTO perfil_id FROM empresa e WHERE e.id = e_empresa_id;

    -- Deletando vagas da empresa
    DELETE FROM vaga WHERE fk_empresa_id = e_empresa_id;
    
    -- Deletando inscrições das vagas
    DELETE FROM inscricao_vaga WHERE fk_vaga_id IN (SELECT id FROM vaga WHERE fk_empresa_id = e_empresa_id);

    -- Deletando empresa
    DELETE FROM empresa WHERE id = e_empresa_id;

    -- Deletando perfil
    SELECT deletar_perfil(perfil_id);

    COMMIT;
END;
$$;

-- Procedure para deletar setor
CREATE OR REPLACE PROCEDURE deletar_setor(
    setor_id INT
)
LANGUAGE plpgsql AS
$$
BEGIN
    -- Deletando empresas com o respectivo setor
    DELETE FROM empresa WHERE fk_setor_id = setor_id;

    -- Deletando setor 
    DELETE FROM setor WHERE id = setor_id;
END;
$$;

-- Procedure para deletar material do curso
CREATE OR REPLACE PROCEDURE deletar_material_curso(
    material_curso_id INT
)
LANGUAGE plpgsql AS
$$
DECLARE 
    arquivo_id INT;
    
BEGIN
    -- Deletando material do curso 
    DELETE FROM material_curso WHERE id = material_curso_id RETURNING fk_arquivo_id INTO arquivo_id;

    -- Deletando arquivo referente ao material do curso 
    DELETE FROM arquivo WHERE id = arquivo_id;

END;
$$;