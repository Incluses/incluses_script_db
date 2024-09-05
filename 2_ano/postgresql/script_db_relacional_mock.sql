--tipo_perfil
INSERT INTO tipo_perfil (nome) VALUES ('USUARIO'), ('EMPRESA');

--situacao_trabalhista
INSERT INTO
    situacao_trabalhista (nome)
VALUES ('DESEMPREGADO'),
    ('EMPREGADO'),
    ('AUTONOMO');

-- setor
INSERT INTO
    setor (nome)
VALUES ('TECNOLOGIA DA INFORMAÇÃO'),
    ('RECURSOS HUMANOS'),
    ('FINANCEIRO');

--status_curso
INSERT INTO
    status_curso (nome)
VALUES ('CONCLUIDO'),
    ('EM ANDAMENTO'),
    ('PENDENTE');

--tipo_arquivo
INSERT INTO
    tipo_arquivo (nome)
VALUES ('CURRICULO'),
    ('FOTO DE PERFIL'),
    ('MATERIAL CURSO');

--turno
INSERT INTO
    turno (nome)
VALUES ('MATUTINO'),
    ('VESPERTINO'),
    ('NOTURNO');

--tipo_vaga
INSERT INTO tipo_vaga (nome) VALUES ('ABERTA'), ('FECHADA');

--endereco
INSERT INTO
    endereco (rua, estado, numero)
VALUES ('Rua A', 'São Paulo', 123),
    (
        'Rua B',
        'Rio de Janeiro',
        456
    ),
    ('Rua C', 'Minas Gerais', 789);

--arquivo
INSERT INTO
    arquivo (
        nome,
        s3_url,
        s3_key,
        tamanho,
        fk_tipo_arquivo_id
    )
VALUES (
        'Curriculo_Joao.pdf',
        'https://s3.amazonaws.com/curriculos/Curriculo_Joao.pdf',
        'Curriculo_Joao',
        '200KB',
        1
    ),
    (
        'Foto_Maria.jpg',
        'https://s3.amazonaws.com/fotos/Foto_Maria.jpg',
        'Foto_Maria',
        '500KB',
        2
    ),
    (
        'Material_Curso_01.pdf',
        'https://s3.amazonaws.com/materiais/Material_Curso_01.pdf',
        'Material_Curso_01',
        '2MB',
        3
    );

--perfil
INSERT INTO
    perfil (
        nome,
        senha,
        email,
        biografia,
        fk_tipo_perfil_id,
        fk_ft_perfil_id
    )
VALUES (
        'João Silva',
        'senha123',
        'joao@email.com',
        'Desenvolvedor de software com 5 anos de experiência',
        2,
        1
    ),
    (
        'Maria Oliveira',
        'senha456',
        'maria@email.com',
        'Gerente de projetos apaixonada por inovação',
        2,
        2
    );

--telefone
INSERT INTO
    telefone (telefone, fk_perfil_id)
VALUES ('11999999999', 1),
    ('21888888888', 2);

--usuario
INSERT INTO
    usuario (
        cpf,
        fk_perfil_id,
        fk_situacao_trabalhista_id,
        fk_curriculo_id,
        dt_nascimento
    )
VALUES (
        '12345678901',
        1,
        2,
        1,
        '1985-01-15'
    ),
    (
        '98765432100',
        2,
        1,
        2,
        '1990-06-25'
    );

--empresa
INSERT INTO
    empresa (
        cnpj,
        razao_social,
        website,
        fk_perfil_id,
        fk_endereco_id,
        fk_setor_id
    )
VALUES (
        '12345678000100',
        'Tech Solutions Ltda',
        'https://techsolutions.com',
        1,
        1,
        1
    ),
    (
        '98765432000100',
        'Financorp SA',
        'https://financorp.com',
        2,
        2,
        2
    );

--configuracao
INSERT INTO
    configuracao (notificacao, fk_perfil_id)
VALUES (TRUE, 1),
    (FALSE, 2);

--curso
INSERT INTO
    curso (
        descricao,
        fk_perfil_id,
        carga_horaria,
        nome,
        fk_status_curso_id
    )
VALUES (
        'Curso de Programação em Python',
        1,
        40,
        'Python para Iniciantes',
        2
    ),
    (
        'Curso de Gerenciamento de Projetos',
        2,
        60,
        'PMP Essentials',
        1
    );

--material_curso
INSERT INTO
    material_curso (
        nome,
        fk_curso_id,
        fk_arquivo_id,
        descricao
    )
VALUES (
        'Apostila de Python',
        1,
        3,
        'Material complementar para o curso de Python'
    ),
    (
        'Slides do Curso PMP',
        2,
        3,
        'Slides utilizados no curso de Gerenciamento de Projetos'
    );

--inscricao_curso
INSERT INTO
    inscricao_curso (fk_curso_id, fk_usuario_id)
VALUES (1, 1),
    (2, 2);

--vaga
INSERT INTO
    vaga (
        descricao,
        emprego,
        jornada,
        salario,
        fk_turno_id,
        qnt_vagas,
        fk_empresa_id,
        fk_tipo_vaga
    )
VALUES (
        'Desenvolvedor Backend',
        'Programador',
        40,
        6000,
        1,
        3,
        1,
        2
    ),
    (
        'Analista Financeiro',
        'Financeiro',
        40,
        5000,
        2,
        2,
        2,
        2
    );