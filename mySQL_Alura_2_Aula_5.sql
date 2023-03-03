/*Aula 03*/

SELECT * FROM curso;
SELECT * FROM categoria;

-- Selecionando cursos da categoria Front-end (id = 1) e Programação (id = 2)
-- Duas formas de se fazer
SELECT * FROM curso WHERE categoria_id = 1 OR categoria_id = 2;
SELECT * FROM curso WHERE categoria_id IN (1,2);

-- Selecionando o id das categorias que não tem espaço no nome
SELECT id FROM categoria WHERE nome NOT LIKE '% %';

-- SUB QUERIES
-- quando utilizamos o resultado de uma query como parâmetro de outra.

-- Exemplo: selecionando o curso no qual sua categoria não tem espaço no nome
SELECT * FROM curso WHERE categoria_id IN (
	SELECT id FROM categoria WHERE nome NOT LIKE '% %'
);

-- PERSONALIZANDO TABELAS:
-- Podemos utilizar um SELECT dentro de um FROM
SELECT categoria, 
	   numero_cursos
  FROM (
		SELECT categoria.nome AS categoria,
        	   COUNT(curso.id) as numero_cursos
    	  FROM categoria
          JOIN curso ON curso.categoria_id = categoria.id
	  GROUP BY categoria
	) AS categoria_cursos
	WHERE numero_cursos > 3;

-- Continuação AULA 05
-- VIEW: NOMEAÇÃO DE CONSULTAS
-- views são parecidas com tabelas
CREATE VIEW vw_cursos_por_categoria AS SELECT categoria.nome AS categoria,
		COUNT (curso.id) AS numero_cursos
	FROM categoria
	JOIN curso ON curso.categoria_id = categoria_id
GROUP BY categoria;

-- view todos os cursos da categoria de programação
CREATE VIEW vw_cursos_programacao AS SELECT nome FROM curso WHERE categoria_id = 2;

SELECT * FROM vw_cursos_programacao;
