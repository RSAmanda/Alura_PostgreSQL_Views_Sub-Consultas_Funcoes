CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);

INSERT INTO aluno (primeiro_nome, ultimo_nome, data_nascimento) VALUES (
	'Vinicius', 'Dias', '1997-10-15'
), (
	'Patricia', 'Freitas', '1986-10-25'
), (
	'Diogo', 'Oliveira', '1984-08-27'
), (
	'Maria', 'Rosa', '1985-01-01'
);

INSERT INTO categoria (nome) VALUES ('Front-end'), ('Programação'), ('Bancos de dados'), ('Data Science');

INSERT INTO curso (nome, categoria_id) VALUES
	('HTML', 1),
	('CSS', 1),
	('JS', 1),
	('PHP', 2),
	('Java', 2),
	('C++', 2),
	('PostgreSQL', 3),
	('MySQL', 3),
	('Oracle', 3),
	('SQL Server', 3),
	('SQLite', 3),
	('Pandas', 4),
	('Machine Learning', 4),
	('Power BI', 4);
	
INSERT INTO aluno_curso VALUES (1, 4), (1, 11), (2, 1), (2, 2), (3, 4), (3, 3), (4, 4), (4, 6), (4, 5);

UPDATE categoria SET nome = 'Ciência de Dados' WHERE id = 4;

-- RELATÓRIO: O ALUNOS MATRICULADO EM MAIS CURSOS
SELECT  aluno.primeiro_nome,
		aluno.ultimo_nome,
		COUNT(aluno_curso.curso_id) AS numero_cursos -- AS não é obrigatório
	FROM aluno
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
--	JOIN curso ON curso.id = aluno_curso.curso_id -- como o objetivo é apenas a qtd, não precisamos desse join para saber os nomes
--GROUP BY aluno.primeiro_nome, aluno.ultimo_nome;
GROUP BY 1, 2 -- É mais comum a utilização da posição da coluna que pelo nome
ORDER BY numero_cursos DESC
-- o group by vai agrupar todos os campos antes da função de agregação (ex: count)	
	LIMIT 1;

-- RELATÓRIO: LISTA DOS CURSOS ORDENADOS DE FORMA DECRESCENTE PELA QUANTIDADE DE ALUNOS
	-- INCLUINDO CURSOS SEM ALUNO (obs: left joinn)
SELECT  curso.nome,
		COUNT(aluno_curso.aluno_id) AS numero_alunos -- AS não é obrigatório
	FROM curso
	LEFT JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1 -- É mais comum a utilização da posição da coluna que pelo nome
ORDER BY numero_alunos DESC;

-- RELATÓRIO: OS CURSOS COM MAIOR QUANTIDADE DE ALUNOS
SELECT  curso.nome,
		COUNT(aluno_curso.aluno_id) AS numero_alunos -- AS não é obrigatório
	FROM curso
	JOIN aluno_curso ON aluno_curso.curso_id = curso.id
-- SE TEM UMA FUNÇÃO DE AGREGAÇÃO, É NECESSÁRIO O GROUP BY
GROUP BY 1 -- É mais comum a utilização da posição da coluna que pelo nome
-- OBS: GROUP BY 1 -> primeiro campo do SELECT
ORDER BY numero_alunos DESC;

--SELECT * FROM curso;

-- RELATÓRIO: Categorias ordenadas pela quantidade de alunos
SELECT  categoria.nome AS Categoria,
	COUNT (aluno_curso.aluno_id) AS numero_alunos
	FROM aluno
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
	JOIN curso ON curso.id = aluno_curso.curso_id
	JOIN categoria ON curso.categoria_id = categoria.id
GROUP BY 1
ORDER BY numero_alunos DESC;


/*Aula 03*/
