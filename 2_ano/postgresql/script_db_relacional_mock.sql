-- Tabela tipo_perfil
INSERT INTO
    tipo_perfil (id, nome)
VALUES (
        '2e1249e8-5731-4f7f-812e-83f18f25a79e',
        'USUARIO'
    ),
    (
        '9d8692b6-7092-4e3c-8610-9b5f591a0410',
        'EMPRESA'
    );

-- Tabela situacao_trabalhista
INSERT INTO
    situacao_trabalhista (id, nome)
VALUES (
        '1f65bff6-7d4c-43e8-a493-9e8c4d4f6d7d',
        'Empregado'
    ),
    (
        '34f67c88-86c3-4ac9-b472-9df540ed963e',
        'Desempregado'
    );

-- Tabela setor
INSERT INTO
    setor (id, nome)
VALUES (
        '53e4c6fd-23cf-487b-bd63-144db86b78d9',
        'Tecnologia'
    ),
    (
        '4b22b60b-2ef0-45cd-9444-3adcb9145a10',
        'Saúde'
    );

-- Tabela tipo_arquivo
INSERT INTO
    tipo_arquivo (id, nome)
VALUES (
        'ff7b274b-cb4f-45b4-871d-7b51a38b1045',
        'Imagem'
    ),
    (
        'eaa1c85b-d31b-41b3-8048-47d89b33e35b',
        'Documento'
    );

-- Tabela tipo_vaga
INSERT INTO
    tipo_vaga (id, nome)
VALUES (
        '11e72bfa-09c8-47f5-9f90-7bdf70a0e9c3',
        'Home Office'
    ),
    (
        'f908c11e-67cb-44b4-9436-0e7f30e11223',
        'Presencial'
    );

-- Tabela endereco
INSERT INTO
    endereco (
        id,
        rua,
        estado,
        cidade,
        cep,
        numero
    )
VALUES (
        'dde40cf8-7ed5-4b85-a3b5-38fe726d9096',
        'Rua 1',
        'SP',
        'São Paulo',
        '12345678',
        100
    ),
    (
        '9cbdfed1-4cc7-4f24-bf84-31f5784e1052',
        'Rua 2',
        'RJ',
        'Rio de Janeiro',
        '87654321',
        200
    );

-- Tabela arquivo
INSERT INTO
    arquivo (
        id,
        nome,
        s3_url,
        s3_key,
        tamanho,
        fk_tipo_arquivo_id
    )
VALUES (
        'ae86b38f-8995-4a85-8de9-c01a94baf1c3',
        'foto_perfil1.jpg',
        'https://s3.aws.com/foto1.jpg',
        'key1',
        '500KB',
        'ff7b274b-cb4f-45b4-871d-7b51a38b1045'
    ),
    (
        'bc3db85c-17d1-4206-aec5-7c874957b29a',
        'curriculo1.pdf',
        'https://s3.aws.com/curriculo1.pdf',
        'key2',
        '300KB',
        'eaa1c85b-d31b-41b3-8048-47d89b33e35b'
    );

-- Tabela perfil
INSERT INTO
    perfil (
        id,
        nome,
        senha,
        email,
        biografia,
        fk_tipo_perfil_id,
        fk_ft_perfil_id
    )
VALUES (
        'd73b4235-0b82-49f6-8361-94341b423d35',
        'Pedro',
        'senha123',
        'pedro@email.com',
        'Engenheiro de Software',
        '2e1249e8-5731-4f7f-812e-83f18f25a79e',
        'ae86b38f-8995-4a85-8de9-c01a94baf1c3'
    ),
    (
        '27b60de4-8b7c-4685-8bb7-08ad091b3b2f',
        'TechCorp',
        'senhaemp',
        'contato@techcorp.com',
        'Empresa de tecnologia',
        '9d8692b6-7092-4e3c-8610-9b5f591a0410',
        NULL
    );

-- Tabela telefone
INSERT INTO
    telefone (id, telefone, fk_perfil_id)
VALUES (
        'f91d24d4-f1b9-4340-b154-69ec9b18ed85',
        '11987654321',
        'd73b4235-0b82-49f6-8361-94341b423d35'
    ),
    (
        '2c5f1915-b195-42ad-8459-6b6f47a17cd0',
        '21998765432',
        '27b60de4-8b7c-4685-8bb7-08ad091b3b2f'
    );

-- Tabela usuario
INSERT INTO
    usuario (
        id,
        cpf,
        fk_perfil_id,
        fk_curriculo_id,
        dt_nascimento,
        pronomes,
        nome_social
    )
VALUES (
        'cb612ee4-0a25-4e98-a9e6-04a11c636ea5',
        '12345678901',
        'd73b4235-0b82-49f6-8361-94341b423d35',
        'bc3db85c-17d1-4206-aec5-7c874957b29a',
        '1990-05-15',
        'ele/dele',
        'Pedro S.'
    );

-- Tabela empresa
INSERT INTO
    empresa (
        id,
        cnpj,
        razao_social,
        website,
        fk_perfil_id,
        fk_endereco_id,
        fk_setor_id
    )
VALUES (
        'b537af34-35be-470d-8222-7558f3e2f8c9',
        '12345678000195',
        'TechCorp',
        'https://techcorp.com',
        '27b60de4-8b7c-4685-8bb7-08ad091b3b2f',
        'dde40cf8-7ed5-4b85-a3b5-38fe726d9096',
        '53e4c6fd-23cf-487b-bd63-144db86b78d9'
    );

-- Tabela configuracao
INSERT INTO
    configuracao (id, notificacao, fk_perfil_id)
VALUES (
        'b7527d52-1109-4c32-93b7-52e7b5075195',
        TRUE,
        'd73b4235-0b82-49f6-8361-94341b423d35'
    );

-- Tabela curso
INSERT INTO
    curso (
        id,
        descricao,
        fk_perfil_id,
        nome
    )
VALUES (
        '7414f1b9-7d96-4f64-87d9-f6c610b857c9',
        'Curso de Java',
        'd73b4235-0b82-49f6-8361-94341b423d35',
        'Java para Iniciantes'
    );

-- Tabela material_curso
INSERT INTO
    material_curso (
        id,
        nome,
        fk_curso_id,
        fk_arquivo_id,
        descricao
    )
VALUES (
        'd04c5f9d-65b4-4baf-bb67-bbf2125b1c38',
        'Apostila de Java',
        '7414f1b9-7d96-4f64-87d9-f6c610b857c9',
        'bc3db85c-17d1-4206-aec5-7c874957b29a',
        'Apostila completa do curso'
    );

-- Tabela inscricao_curso
INSERT INTO
    inscricao_curso (
        id,
        fk_curso_id,
        fk_usuario_id
    )
VALUES (
        '9873a36d-2b8f-4a75-84b5-e36a9e9d3743',
        '7414f1b9-7d96-4f64-87d9-f6c610b857c9',
        'cb612ee4-0a25-4e98-a9e6-04a11c636ea5'
    );

-- Tabela vaga
INSERT INTO
    vaga (
        id,
        descricao,
        nome,
        fk_empresa_id,
        fk_tipo_vaga_id
    )
VALUES (
        '39f72c56-73f3-4d7b-8c1d-bfd8f523b021',
        'Desenvolvimento Java',
        'Desenvolvedor Java Junior',
        'b537af34-35be-470d-8222-7558f3e2f8c9',
        '11e72bfa-09c8-47f5-9f90-7bdf70a0e9c3'
    );

-- Tabela inscricao_vaga
INSERT INTO inscricao_vaga (id, fk_usuario_id, fk_vaga_id) VALUES
('f87248b8-e72e-4725-b530-c7fc3f3fa32f', 'cb612ee4-0a25-4e98-a9e6-04a11c636ea5', '39f72c56-73f3-4d7b-8c1d-bfd8f523b021');

