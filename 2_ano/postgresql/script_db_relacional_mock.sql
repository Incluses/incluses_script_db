--Tabela tipo_perfil
INSERT INTO tipo_perfil (nome) VALUES 
('Pessoa Física'),
('Empresa');

--Tabela situacao_trabalhista
INSERT INTO situacao_trabalhista (nome) VALUES 
('Desempregado'),
('Empregado');

--Tabela setor
INSERT INTO setor (nome) VALUES 
('Tecnologia'),
('Recursos Humanos'),
('Financeiro');

--Tabela tipo_arquivo
INSERT INTO tipo_arquivo (nome) VALUES 
('Currículo'),
('Certificado'),
('Outros');

--Tabela tipo_vaga
INSERT INTO tipo_vaga (nome) VALUES 
('Estágio'),
('Efetivo'),
('Freelancer');

--Tabela endereco
INSERT INTO endereco (rua, estado, cidade, cep, numero) VALUES 
('Rua A', 'São Paulo', 'São Paulo', '01234567', 123),
('Rua B', 'Rio de Janeiro', 'Rio de Janeiro', '87654321', 456);

--Tabela arquivo
INSERT INTO arquivo (nome, s3_url, s3_key, tamanho, fk_tipo_arquivo_id) VALUES 
('Currículo João', 'https://s3.amazonaws.com/curriculos/joao.pdf', 'curriculos/joao.pdf', '150KB', 1),
('Certificado Maria', 'https://s3.amazonaws.com/certificados/maria.pdf', 'certificados/maria.pdf', '100KB', 2);

--Tabela perfil
INSERT INTO perfil (nome, senha, email, biografia, fk_tipo_perfil_id, fk_ft_perfil_id) VALUES 
('João Silva', 'senha123', 'joao@email.com', 'Desenvolvedor de software', 1, 1),
('Empresa XYZ', 'emp12345', 'contato@xyz.com', 'Empresa especializada em tecnologia', 2, NULL);

--Tabela telefone
INSERT INTO telefone (telefone, fk_perfil_id) VALUES 
('11987654321', 1),
('21912345678', 2);

--Tabela usuario
INSERT INTO usuario (cpf, fk_perfil_id, fk_curriculo_id, dt_nascimento, pronomes, nome_social) VALUES 
('12345678901', 1, 1, '1990-01-01', 'Ele/Dele', NULL),
('98765432100', 1, NULL, '1985-05-05', 'Ela/Dela', 'Maria Souza');

--Tabela empresa
INSERT INTO empresa (cnpj, razao_social, website, fk_perfil_id, fk_endereco_id, fk_setor_id) VALUES 
('12345678000199', 'Empresa XYZ Ltda', 'http://xyz.com.br', 2, 1, 1);

--Tabela configuracao
INSERT INTO configuracao (notificacao, fk_perfil_id) VALUES 
(TRUE, 1),
(FALSE, 2);

--Tabela curso
INSERT INTO curso (descricao, fk_perfil_id, nome) VALUES 
('Curso de Programação Avançada', 1, 'Programação Avançada'),
('Curso de Gestão de Projetos', 2, 'Gestão de Projetos');

--Tabela material_curso
INSERT INTO material_curso (nome, fk_curso_id, fk_arquivo_id, descricao) VALUES 
('Apostila de Programação', 1, 1, 'Material complementar sobre programação.'),
('Slide de Gestão', 2, 2, 'Slides do curso de gestão.');

--Tabela inscricao_curso
INSERT INTO inscricao_curso (fk_curso_id, fk_usuario_id) VALUES 
(1, 1),
(2, 1);

--Tabela vaga
INSERT INTO vaga (descricao, nome, fk_empresa_id, fk_tipo_vaga_id) VALUES 
('Desenvolvedor Web', 'Vaga Desenvolvedor Web', 1, 2),
('Gerente de Projetos', 'Vaga Gerente de Projetos', 1, 2);

--Tabela inscricao_vaga
INSERT INTO inscricao_vaga (fk_usuario_id, fk_vaga_id) VALUES 
(1, 1),
(1, 2);

--Tabela avaliacao_curso
INSERT INTO avaliacao_curso (nota, fk_curso_id, fk_usuario_id) VALUES 
(4.5, 1, 1),
(5.0, 2, 1);
