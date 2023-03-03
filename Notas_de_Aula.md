# Notas de Aula - PostgreSQL: Views, Sub-consultas e Funções

# Link do Curso

[Curso Online PostgreSQL: Views, Sub-Consultas e Funções | Alura](https://cursos.alura.com.br/course/postgresql-views-sub-consultas-funcoes)

# Materiais de Apoio

## Funções MySQL

[Chapter 9. Functions and Operators](https://www.postgresql.org/docs/current/functions.html)

- String

[String Functions and Operators](https://www.postgresql.org/docs/9.1/functions-string.html)

- Data e Hora

[Date/Time Functions and Operators](https://www.postgresql.org/docs/9.1/functions-datetime.html)

- Matemática

[Mathematical Functions and Operators](https://www.postgresql.org/docs/9.5/functions-math.html)

- Formatação

[Data Type Formatting Functions](https://www.postgresql.org/docs/9.5/functions-formatting.html)

- Visualização

[CREATE VIEW](https://www.postgresql.org/docs/9.2/sql-createview.html)

## Projeto Inicial do Treinamento

### Aula 01

[banco-inicial.sql](https://github.com/RSAmanda/Alura_PostgreSQL_Views_Sub-Consultas_Funcoes/blob/7d5bb80071cc60160bfde92f3279787a4884a156/banco-inicial.sql)

### Aula 02

[dados-aula-2.sql](https://github.com/RSAmanda/Alura_PostgreSQL_Views_Sub-Consultas_Funcoes/blob/7d5bb80071cc60160bfde92f3279787a4884a156/dados-aula-2.sql)

[relatorios-aula-2.sql](https://github.com/RSAmanda/Alura_PostgreSQL_Views_Sub-Consultas_Funcoes/blob/7d5bb80071cc60160bfde92f3279787a4884a156/relatorios-aula-2.sql)

# Aulas

## Chaves estrangeiras e Tipos

### Chaves Estrangeiras

Uma chave estrangeira sempre faz a referência entre o campo de uma tabela com um campo de outra tabela. 

- A chave estrangeira tem que referenciar um campo com registro único, comumente é usado o id como chave estrangeira.
- É uma boa prática usar a chave primária de uma tabela como chave estrangeira da outra tabela.

### Tipos (cardinalidades)

- 1:1 → Um registro de uma tabela se relaciona com um registro de outra tabela:
    - Um aluno tem apenas um endereço e cada endereço pertence a um único aluno.
- 1:N → Um registro de uma tabela se relaciona com vários registros da outra tabela:
    - Um curso pertence a uma categoria, porém essa categoria tem vários cursos.
- N:N → Vários registros de  uma tabela se relacionam com vários registros de outra tabela
    - Um aluno pode fazer vários cursos e cada curso pode ter vários alunos

<aside>
❗ Atenção:

Para relacionamento do tipo muitos-para-muitos, nós precisamos criar uma tabela de junção, ou tabela de relacionamento.

Relacionamentos do tipo um-para-muitos ou um-para-um não precisam dessa tabela extra e possuem a chave estrangeira definida diretamente em uma das tabelas.

</aside>

## Praticando comandos

No processo de geração de relatórios completos, por precisarmos “passar” por diversas tabelas, às vezes acabamos nos perguntando: por onde começo?

O ideal é sempre começar pela tabela que possui a informação central do relatório, e a partir dela ir fazendo todos os relacionamentos com os `JOINs` corretos.

**Exemplos de Relatórios:**

- O aluno matriculado em mais cursos:
    
    ```sql
    SELECT  aluno.primeiro_nome,
    		aluno.ultimo_nome,
    		COUNT(aluno_curso.curso_id) AS numero_cursos
    	FROM aluno
    	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    GROUP BY 1, 2
    ORDER BY numero_cursos DESC
    	LIMIT 1;
    ```
    
- Cursos com mais alunos
    
    ```sql
    SELECT  curso.nome,
    		COUNT(aluno_curso.aluno_id) AS numero_alunos -- AS não é obrigatório
    	FROM curso
    	JOIN aluno_curso ON aluno_curso.curso_id = curso.id
    -- SE TEM UMA FUNÇÃO DE AGREGAÇÃO, É NECESSÁRIO O GROUP BY
    GROUP BY 1 -- É mais comum a utilização da posição da coluna que pelo nome
    -- OBS: GROUP BY 1 -> primeiro campo do SELECT
    ORDER BY numero_alunos DESC;
    ```
    
- Categorias de cursos ordenados pela quantidade de alunos
    
    ```sql
    SELECT  categoria.nome AS Categoria,
    	COUNT (aluno_curso.aluno_id) AS numero_alunos
    	FROM aluno
    	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    	JOIN curso ON curso.id = aluno_curso.curso_id
    	JOIN categoria ON curso.categoria_id = categoria.id
    GROUP BY 1
    ORDER BY numero_alunos DESC;
    ```
    

## Executando Sub-consultas

### Operador IN

```sql
-- Selecionando cursos da categoria Front-end (id = 1) e Programação (id = 2)
SELECT * FROM curso WHERE categoria_id IN (1,2);
```

### Queries Alinhadas

Quando usamos o resultado de uma query como parâmetro de outra. Exemplo:

```sql
-- Exemplo: selecionando o curso no qual sua categoria não tem espaço no nome
SELECT * FROM curso WHERE categoria_id IN (
	SELECT id FROM categoria WHERE nome NOT LIKE '% %'
);
```

### Personalizando Tabela

```sql
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
```

Na maioria das ocasiões, uma sub-query pode ser substituída pelo uso do HAVING

```sql
SELECT curso.nome,
         COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
     HAVING COUNT(aluno_curso.aluno_id) > 2
ORDER BY numero_alunos DESC;

-- o mesmo que

SELECT t.curso,
       t.numero_alunos
    FROM (
        SELECT curso.nome AS curso,
               COUNT(aluno_curso.aluno_id) numero_alunos
          FROM curso
          JOIN aluno_curso ON aluno_curso.curso_id = curso.id
      GROUP BY 1
    ) AS t
    WHERE t.numero_alunos > 2
  ORDER BY t.numero_alunos DESC;

```

## Usando funções

### String

```sql
-- Juntar primeiro nome com o último nome
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo FROM aluno;
-- se um dos valores for NULL, o resultado será NULL
-- SEe usar o CONCAT, esse problema não acontece
SELECT CONCAT (primeiro_nome, ' ', ultimo_nome ) AS nome_completo FROM aluno;
```

### Data

```sql
-- DATA
-- Calcular a idade
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo, (NOW()::DATE - data_nascimento)/365 FROM aluno;
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo, AGE(data_nascimento) FROM aluno;
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo, EXTRACT(YEAR FROM AGE(data_nascimento)) FROM aluno;
```

## Criando *views*

- Maior legibilidade nos relatórios;
- Mais segurança com os acessos de terceiros;
- Funciona de forma parecida a uma tabela:
    - Podemos aplicar filtros;
    - join, etc.
- Pode ocorrer problemas de performance com a utilização de *****views.*****

```sql
-- view todos os cursos da categoria de programação
CREATE VIEW vw_cursos_programacao AS SELECT nome FROM curso WHERE categoria_id = 2;

SELECT * FROM vw_cursos_programacao;
```
