DROP DATABASE IF EXISTS FORMACAO_TOTAL;
CREATE DATABASE FORMACAO_TOTAL;
USE FORMACAO_TOTAL;

CREATE TABLE utilizador(
    username VARCHAR(40) PRIMARY KEY,
    nome VARCHAR(40),
    data_nasc DATE,
    palavra_passe VARCHAR(40),
    nivel   VARCHAR(40)
);

CREATE TABLE formacao(
    nome VARCHAR(40) PRIMARY KEY,
    num_maximo INT,
    esta_fechada BOOLEAN,
    criterio_selecao VARCHAR(40),
    data_fecho DATE,
    username VARCHAR(40),
    descricao TEXT,
    FOREIGN KEY(username) REFERENCES utilizador(username)
);

CREATE TABLE inscricao(
    username VARCHAR(40),
    estado VARCHAR(40),
    nome VARCHAR(40),
    data_inscricao DATE,
    FOREIGN KEY(username) REFERENCES utilizador(username),
    FOREIGN KEY(nome) REFERENCES formacao(nome)
);

ALTER TABLE inscricao ADD CONSTRAINT PK_inscricao PRIMARY KEY(username, nome);

INSERT INTO utilizador (username, nome, data_nasc, palavra_passe, nivel) VALUES
('aluno', 'aluno', '1990-01-01', 'ca0cd09a12abade3bf0777574d9f987f ', 'aluno'),
('docente', 'docente', '1992-02-02', 'ac99fecf6fcb8c25d18788d14a5384ee ', 'docente'),
('admin', 'admin', '1995-03-03', '21232f297a57a5a743894a0e4a801fc3 ', 'admin'),
('utilizador1', 'Utilizador 1', '1988-04-04', 'password1', 'aluno'),
('utilizador2', 'Utilizador 2', '1988-04-02', 'password2', 'aluno'),
('utilizador3', 'Utilizador 3', '1988-04-03', 'password3', 'aluno'),
('utilizador4', 'Utilizador 4', '1988-04-04', 'password4', 'aluno'),
('utilizador5', 'Utilizador 5', '1985-05-05', 'password5', 'aluno'),
('utilizador6', 'Utilizador 6', '1982-06-06', 'password6', 'aluno');

INSERT INTO formacao (nome, num_maximo, esta_fechada, criterio_selecao, data_Fecho, username ,descricao) VALUES
('Java', 10, false, "Data Inscrição", "2020-01-01", 'docente', 'Esta formação meramente para fins académicos destina-se aos alunos que tenham curiosidade na área da informática e que gostam deste estilo de conteudos. Considere a sua inscrição!'),
('PHP', 10, false, "Data Inscrição", "2022-01-01", 'docente', 'Esta formação meramente para fins académicos destina-se aos alunos que tenham curiosidade na área da informática e que gostam deste estilo de conteudos. Considere a sua inscrição!'),
('PHP2', 6, false, "Ordem Alfabética", "2023-01-01", 'docente', 'Esta formação meramente para fins académicos destina-se aos alunos que tenham curiosidade na área da informática e que gostam deste estilo de conteudos. Considere a sua inscrição!'),
('PHP3', 6, false, "Menor Idade", "2024-12-12", 'docente', 'Esta formação meramente para fins académicos destina-se aos alunos que tenham curiosidade na área da informática e que gostam deste estilo de conteudos. Considere a sua inscrição!'),
('HTML', 20, false, "Maior Idade", "2025-01-01", 'docente', 'Esta formação meramente para fins académicos destina-se aos alunos que tenham curiosidade na área da informática e que gostam deste estilo de conteudos. Considere a sua inscrição!'),
('Agricultura A', 3, false, "Ordem Alfabética", "2025-01-01", 'admin', 'Esta formação meramente para fins académicos destina-se aos alunos que tenham curiosidade na área da informática e que gostam deste estilo de conteudos. Considere a sua inscrição!');

INSERT INTO inscricao (username, estado, nome, data_inscricao) VALUES
('aluno', 'pendente','HTML', CURDATE()),
('utilizador1','pendente', 'HTML', '1999-05-10'),
('utilizador2','pendente', 'HTML', '2022-05-10'),
('utilizador3','pendente', 'HTML', '2021-01-12'),
('utilizador4','pendente', 'HTML', CURDATE()),
('utilizador5','pendente', 'HTML', '2001-02-12'),
('utilizador6','pendente', 'HTML', '2001-01-12'),
('aluno','pendente', 'Java', CURDATE()),
('utilizador1','pendente', 'Java', CURDATE()),
('utilizador2','pendente', 'Java', CURDATE()),
('utilizador3','pendente', 'Java', CURDATE()),
('utilizador4','pendente', 'Java', CURDATE()),
('utilizador5','pendente', 'Java', CURDATE()),
('aluno','pendente', 'PHP', CURDATE()),
('utilizador1','pendente', 'PHP', CURDATE()),
('utilizador2','pendente', 'PHP', CURDATE()),
('utilizador3','pendente', 'PHP', CURDATE()),
('utilizador4','pendente', 'PHP', CURDATE()),
('aluno','pendente', 'PHP2', CURDATE()),
('utilizador1','pendente', 'PHP2', CURDATE()),
('utilizador2','pendente', 'PHP2', CURDATE()),
('aluno','pendente', 'PHP3', CURDATE()),
('aluno', 'pendente','Agricultura A', CURDATE()),
('utilizador6','pendente', 'Agricultura A', CURDATE()),
('utilizador5','pendente', 'Agricultura A', '2001-02-12'),
('utilizador1','pendente', 'Agricultura A', '1999-05-10');