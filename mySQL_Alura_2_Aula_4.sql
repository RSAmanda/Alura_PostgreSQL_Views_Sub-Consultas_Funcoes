-- AULA 04
-- FUNÇÕES MySQL

-- STRING
-- Juntar primeiro nome com o último nome
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo FROM aluno;
-- se um dos valores for NULL, o resultado será NULL
-- SEe usar o CONCAT, esse problema não acontece
SELECT CONCAT (primeiro_nome, ' ', ultimo_nome ) AS nome_completo FROM aluno;

-- DATA
-- Calcular a idade
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo, (NOW()::DATE - data_nascimento)/365 FROM aluno;
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo, AGE(data_nascimento) FROM aluno;
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo, EXTRACT(YEAR FROM AGE(data_nascimento)) FROM aluno;


