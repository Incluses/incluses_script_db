-- tipo perfil
INSERT INTO tipo_perfil (nome) VALUES ('Empresa');
INSERT INTO tipo_perfil (nome) VALUES ('Usuário');

-- situação trabalhista
INSERT INTO situacao_trabalhista (nome) VALUES ('Empregado');
INSERT INTO situacao_trabalhista (nome) VALUES ('Procurando emprego');

-- setor
INSERT INTO setor (nome) VALUES ('Alimentação');
INSERT INTO setor (nome) VALUES ('Energia');

-- status_curso
INSERT INTO status_curso (nome) VALUES ('Concluído');
INSERT INTO status_curso (nome) VALUES ('Em andamento');
INSERT INTO status_curso (nome) VALUES ('Não iniciado');

-- tipo_arquivo
INSERT INTO tipo_arquivo (nome) VALUES ('Postagem');
INSERT INTO tipo_arquivo (nome) VALUES ('Foto de perfil');

-- turno
INSERT INTO turno (nome) VALUES ('Matutino');
INSERT INTO turno (nome) VALUES ('Vespertino');
INSERT INTO turno (nome) VALUES ('Integral');
INSERT INTO turno (nome) VALUES ('Noturno');

-- tipo_vaga
INSERT INTO tipo_vaga (nome) VALUES ('Aberta');
INSERT INTO tipo_vaga (nome) VALUES ('Fechada');

-- endereco
INSERT INTO endereco (rua, estado, numero) VALUES ('Rua A', 'São Paulo', 123);
INSERT INTO endereco (rua, estado, numero) VALUES ('Rua B', 'Rio de Janeiro', 456);
INSERT INTO endereco (rua, estado, numero) VALUES ('Avenida Paulista', 'São Paulo', 1000);

-- perfil
INSERT INTO perfil (nome, senha, email, biografia, fk_tipo_perfil_id) VALUES ('João', 'senha123', 'joao@exemplo.com', 'Biografia do João', 1);
INSERT INTO perfil (nome, senha, email, biografia, fk_tipo_perfil_id) VALUES ('Maria', 'senha456', 'maria@exemplo.com', 'Biografia da Maria', 2);

-- telefone
INSERT INTO telefone (telefone, fk_perfil_id) VALUES ('123456789', 1);
INSERT INTO telefone (telefone, fk_perfil_id) VALUES ('987654321', 2);

-- usuario
INSERT INTO usuario (cpf, fk_perfil_id, fk_situacao_trabalhista_id, dt_nascimento) VALUES ('12345678901', 1, 1, '1990-01-01');
INSERT INTO usuario (cpf, fk_perfil_id, fk_situacao_trabalhista_id, dt_nascimento) VALUES ('10987654321', 2, 2, '1985-05-15');

-- empresa
INSERT INTO empresa (cnpj, razao_social, fk_perfil_id, website, matriz_id, fk_endereco_id) VALUES ('12345678000195', 'J&F', 1, 'http://www.empresaA.com', 1, 3);
INSERT INTO empresa (cnpj, razao_social, fk_perfil_id, website, matriz_id, fk_endereco_id) VALUES ('12345678000195', 'Swift', 1, 'http://www.empresaA.com', 1, 1);
INSERT INTO empresa (cnpj, razao_social, fk_perfil_id, website, matriz_id, fk_endereco_id) VALUES ('10987654000196', 'Âmbar', 2, 'http://www.empresaB.com', 1, 2);

-- setor_empresa
INSERT INTO setor_empresa (fk_empresa_id, fk_setor_id) VALUES (1, 1);
INSERT INTO setor_empresa (fk_empresa_id, fk_setor_id) VALUES (1, 2);
INSERT INTO setor_empresa (fk_empresa_id, fk_setor_id) VALUES (2, 1);
INSERT INTO setor_empresa (fk_empresa_id, fk_setor_id) VALUES (3, 2);

-- configuracao
INSERT INTO configuracao (notificacao, fk_perfil_id) VALUES (TRUE, 1);
INSERT INTO configuracao (notificacao, fk_perfil_id) VALUES (FALSE, 2);

-- curso
INSERT INTO curso (nome, fk_perfil_id, carga_horaria, descricao, fk_status_curso_id) VALUES ('Curso de Programação', 1, 40, 'Programação 101', 1);
INSERT INTO curso (nome, fk_perfil_id, carga_horaria, descricao, fk_status_curso_id) VALUES ('Curso de Design', 2, 30, 'Design 101', 2);

-- arquivo
INSERT INTO arquivo (nome, s3_url, s3_key, tamanho, fk_tipo_arquivo_id) VALUES ('documento1.pdf', 'http://s3.amazonaws.com/arquivo1.pdf', 'key1', '1MB', 1);
INSERT INTO arquivo (nome, s3_url, s3_key, tamanho, fk_tipo_arquivo_id) VALUES ('documento2.docx', 'http://s3.amazonaws.com/arquivo2.docx', 'key2', '500KB', 2);

-- material_curso
INSERT INTO material_curso (nome, fk_curso_id, fk_arquivo_id, descricao) VALUES ('Material A', 1, 1, 'Material de estudo A');
INSERT INTO material_curso (nome, fk_curso_id, fk_arquivo_id, descricao) VALUES ('Material B', 2, 2, 'Material de estudo B');

-- inscricao_curso
INSERT INTO inscricao_curso (fk_curso_id, fk_usuario_id) VALUES (1, 1);
INSERT INTO inscricao_curso (fk_curso_id, fk_usuario_id) VALUES (2, 2);

-- vaga
INSERT INTO vaga (descricao, emprego, jornada, salario, fk_turno_id, qnt_vagas, fk_empresa_id, fk_tipo_vaga) VALUES ('Desenvolvedor Júnior', 'Tempo Integral', 8, 5000.00, 1, 5, 1, 1);
INSERT INTO vaga (descricao, emprego, jornada, salario, fk_turno_id, qnt_vagas, fk_empresa_id, fk_tipo_vaga) VALUES ('Analista de Sistemas', 'Tempo Parcial', 4, 3000.00, 2, 2, 2, 2);
