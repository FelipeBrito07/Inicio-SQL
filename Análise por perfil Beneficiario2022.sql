-- An�lise de perfil de benefic�arios de plano de sa�de por atendimento.

SELECT DISTINCT faixa_etaria FROM BENEFICIARIO2022;

-- POR SEXO:
SELECT 
    SEXO_BENEFICIARIO,
    COUNT(*) "QTD ATENDIMENTO",
    TO_CHAR(COUNT(*) / (SELECT COUNT(*) FROM BENEFICIARIO2022) *100, '999.99') || '%' AS "% DE ATENDIMENTO" 
FROM beneficiario2022
GROUP BY SEXO_BENEFICIARIO;

/* 
No ano de 2022, benef�ci�rio do sexo femenino foram mairoia nos atendimentos por plano de sa�de no Brasil. 
Totalizando 300.605 atendimentos, mais de 50% do total. 
*/

-- POR UF:
SELECT 
    UF_BENEFICIARIO,
    COUNT(*) QTD_ATENDIMENTO,
    TO_CHAR(COUNT(*) / (SELECT COUNT(*) FROM beneficiario2022) *100, '09.99') || '%' AS "% DE ATENDIMENTO" 
FROM beneficiario2022
GROUP BY UF_BENEFICIARIO
ORDER BY COUNT(*) DESC;

/*
Maioria dos benefici�rios de plano de sa�de em 2022, nasceram no estado de S�o Paulo. 
Normal, por se o estado mais populoso do Brasil.
*/
-- POR M�S:
SELECT 
    TO_CHAR(COMPETENCIA, 'MONTH'),
    COUNT(*) QTD_ATENDIMENTO,
    TO_CHAR(COUNT(*) / (SELECT COUNT(*) FROM BENEFICIARIO2022) * 100, '999.99') || '%' AS "% DE ATENDIMENTO" 
FROM beneficiario2022
GROUP BY TO_CHAR(COMPETENCIA, 'MONTH')
ORDER BY COUNT(*) DESC;
/*
Outubro foi o m�s com mais atendimentos em 2022.
*/
-- POR M�S E SEXO FEMENINO:
SELECT 
    TO_CHAR(COMPETENCIA, 'MONTH') AS M�S,
    COUNT(*) AS QTD_ATENDIMENTO_MULHERES,
    TO_CHAR(COUNT(*) / (SELECT COUNT(*) FROM BENEFICIARIO2022 WHERE SEXO_BENEFICIARIO = 'F') * 100, '999.99') || '%' "% DE ATENDIMENTO"
FROM beneficiario2022
WHERE SEXO_BENEFICIARIO = 'F'
GROUP BY TO_CHAR(COMPETENCIA, 'MONTH')
ORDER BY COUNT(*) DESC;


-- POR ANO E SEXO MASCULINO:
SELECT 
    TO_CHAR(COMPETENCIA, 'MONTH'),
    COUNT(*) QTD_ATENDIMENTO
FROM beneficiario2022
WHERE SEXO_BENEFICIARIO = 'M'
GROUP BY TO_CHAR(COMPETENCIA, 'MONTH')
ORDER BY COUNT(*) DESC;

-- POR IDADE:

SELECT 
    FAIXA_ETARIA,
    sexo_beneficiario,
    COUNT(*)
FROM BENEFICIARIO2022
GROUP BY FAIXA_ETARIA, sexo_beneficiario
ORDER BY COUNT(*) DESC;

-- POR FAIXA DE IDADE E POR REGI�O.
/* OBS:
Sabe-se que essa BD s� benefici�rios de 0 at� 27 anos, ou seja, 
menor de idade e adulto de acordo com as faixas. 
As outras faixas s�o para demonstra��o de uso da ferramenta. */

SELECT 
    CASE
        WHEN FAIXA_ETARIA <= 17 THEN 'MENOR DE IDADE'
        WHEN FAIXA_ETARIA >= 18 AND FAIXA_ETARIA < 40 THEN 'ADULTO'
        WHEN FAIXA_ETARIA >= 40 AND FAIXA_ETARIA > 60 THEN 'MEIA IDADE'
        ELSE 'IDOSO'
    END AS FAIXA_DE_IDADE,
    CASE
        WHEN UF_BENEFICIARIO IN ('RJ', 'SP', 'MG', 'ES') THEN 'SUDESTE'
        WHEN UF_BENEFICIARIO IN ('RS', 'PR', 'SC') THEN 'SUL'
        WHEN UF_BENEFICIARIO IN ('BA', 'PE', 'CE', 'SE', 'AL', 'RN', 'PI', 'PB', 'MA') THEN 'NORDESTE'
        WHEN UF_BENEFICIARIO IN ('AC', 'AP', 'AM', 'PA', 'RO', 'RR', 'TO') THEN  'NORTE'
        ELSE 'CENTRO-OESTE'
    END AS REGIAO,
    REPLACE(TO_CHAR(COUNT(*), '999,999'), ',' , '.') QTD_ATENDIMENTO
FROM beneficiario2022
GROUP BY 
    CASE
        WHEN FAIXA_ETARIA <= 17 THEN 'MENOR DE IDADE'
        WHEN FAIXA_ETARIA >= 18 AND FAIXA_ETARIA < 40 THEN 'ADULTO'
        WHEN FAIXA_ETARIA >= 40 AND FAIXA_ETARIA > 60 THEN 'MEIA IDADE'
        ELSE 'IDOSO'
    END, 
     CASE
        WHEN UF_BENEFICIARIO IN ('RJ', 'SP', 'MG', 'ES') THEN 'SUDESTE'
        WHEN UF_BENEFICIARIO IN ('RS', 'PR', 'SC') THEN 'SUL'
        WHEN UF_BENEFICIARIO IN ('BA', 'PE', 'CE', 'SE', 'AL', 'RN', 'PI', 'PB', 'MA') THEN 'NORDESTE'
        WHEN UF_BENEFICIARIO IN ('AC', 'AP', 'AM', 'PA', 'RO', 'RR', 'TO') THEN  'NORTE'
        ELSE 'CENTRO-OESTE'
    END
ORDER BY FAIXA_DE_IDADE ASC;


