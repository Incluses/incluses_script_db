-- Teste para a procedure cadastrar_usuario
CALL cadastrar_usuario (
    '12345678901', -- CPF
    'Empregado', -- Situação trabalhista
    '1990-05-15', -- Data de nascimento
    'ele/dele', -- Pronomes
    'Pedro da Silva', -- Razão social
    'Pedro', -- Nome
    'senha123', -- Senha
    'pedro@email.com', -- Email
    'Engenheiro de Software', -- Biografia
    'ae86b38f-8995-4a85-8de9-c01a94baf1c3', -- ID da foto de perfil
    '11987654321' -- Telefone
);

-- Verificar se o usuário foi inserido corretamente
SELECT * FROM usuario WHERE cpf = '12345678901';

-- Teste para a procedure cadastrar_empresa
CALL cadastrar_empresa (
    '12345678000195', -- CNPJ
    'TechCorp', -- Razão Social
    'https://techcorp.com', -- Website
    'TechCorp', -- Matriz
    'Tecnologia', -- Setor
    'Rua 1', -- Rua
    'SP', -- Estado
    'São Paulo', -- Cidade
    100, -- Número
    'TechCorp', -- Nome
    'senhaemp', -- Senha
    'contato@techcorp.com', -- Email
    'Empresa de tecnologia', -- Biografia
    '21998765432' -- Telefone
);

-- Verificar se a empresa foi inserida corretamente
SELECT * FROM empresa WHERE cnpj = '12345678000195';

-- Teste para a procedure deletar_usuario
-- Primeiro, cadastrar um usuário para deletar
CALL cadastrar_usuario (
    '98765432100', -- CPF
    'Desempregado', -- Situação trabalhista
    '1985-01-10', -- Data de nascimento
    'ela/dela', -- Pronomes
    'Maria da Silva', -- Razão social
    'Maria', -- Nome
    'senhamaria', -- Senha
    'maria@email.com', -- Email
    'Desenvolvedora', -- Biografia
    'ae86b38f-8995-4a85-8de9-c01a94baf1c3', -- ID da foto de perfil
    '11987654321' -- Telefone
);

-- Deletar usuário
CALL deletar_usuario (
    (
        SELECT id
        FROM usuario
        WHERE
            cpf = '98765432100'
    )
);

-- Verificar se o usuário foi deletado
SELECT * FROM usuario WHERE cpf = '98765432100';

-- Teste para a procedure deletar_empresa
-- Primeiro, cadastrar uma empresa para deletar
CALL cadastrar_empresa (
    '98765432000195', -- CNPJ
    'TechCorp', -- Razão Social
    'https://techcorp.com', -- Website
    'TechCorp', -- Matriz
    'Tecnologia', -- Setor
    'Rua 1', -- Rua
    'SP', -- Estado
    'São Paulo', -- Cidade
    100, -- Número
    'TechCorp', -- Nome
    'senhaemp', -- Senha
    'contato@techcorp.com', -- Email
    'Empresa de tecnologia', -- Biografia
    '21998765432' -- Telefone
);

-- Deletar empresa
CALL deletar_empresa (
    (
        SELECT id
        FROM empresa
        WHERE
            cnpj = '98765432000195'
    )
);

-- Verificar se a empresa foi deletada
SELECT * FROM empresa WHERE cnpj = '98765432000195';

-- Teste para a procedure deletar_curso
-- Primeiro, cadastrar um curso para deletar
INSERT INTO
    curso (
        id,
        descricao,
        fk_perfil_id,
        nome
    )
VALUES (
        '12345678-1234-1234-1234-123456789012',
        'Curso de SQL',
        'd73b4235-0b82-49f6-8361-94341b423d35',
        'SQL para Iniciantes'
    );

-- Deletar curso
CALL deletar_curso ( '12345678-1234-1234-1234-123456789012' );

-- Verificar se o curso foi deletado
SELECT *
FROM curso
WHERE
    id = '12345678-1234-1234-1234-123456789012';

-- Teste para a procedure deletar_setor
-- Primeiro, cadastrar um setor para deletar
INSERT INTO
    setor (id, nome)
VALUES (
        '12345678-1234-1234-1234-123456789012',
        'Test Setor'
    );

-- Deletar setor
CALL deletar_setor ( '12345678-1234-1234-1234-123456789012' );

-- Verificar se o setor foi deletado
SELECT *
FROM setor
WHERE
    id = '12345678-1234-1234-1234-123456789012';

-- Teste para a procedure deletar_material_curso
-- Primeiro, cadastrar um material de curso para deletar
INSERT INTO
    material_curso (
        id,
        nome,
        fk_curso_id,
        fk_arquivo_id,
        descricao
    )
VALUES (
        '12345678-1234-1234-1234-123456789012',
        'Material de Teste',
        '7414f1b9-7d96-4f64-87d9-f6c610b857c9',
        'bc3db85c-17d1-4206-aec5-7c874957b29a',
        'Descrição do material'
    );

-- Deletar material do curso
CALL deletar_material_curso ( '12345678-1234-1234-1234-123456789012' );

-- Verificar se o material do curso foi deletado
SELECT *
FROM material_curso
WHERE
    id = '12345678-1234-1234-1234-123456789012';