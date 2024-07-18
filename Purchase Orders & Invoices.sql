-- Getting needed columns to compose the very table

SELECT DISTINCT
      cab.NUMNOTA AS NF -- Invoice #
    , ped.NUMNOTA AS OC  -- PO #
    , cab.CODPARC AS COD_PARC
    , par.NOMEPARC AS PARCEIRO 
    , ped.DTFATUR AS PREV_ENTREGA -- Estimated Time of Arrival
    , cab.DTNEG AS DATA_NEG
    , ROUND((cab.DTNEG - ped.DTFATUR), 0) AS ATRASO -- A simple DATEDIFF calculation on an Oracle database
FROM
    TGFCAB cab
INNER JOIN
    TGFPAR par ON cab.CODPARC = par.CODPARC -- Vendor's info
INNER JOIN    
    TGFVAR var ON cab.NUNOTA = var.NUNOTA -- This table contains the link between Purchase Orders and Invoices
INNER JOIN
    TGFCAB ped ON var.NUNOTAORIG = ped.NUNOTA
WHERE 
    cab.CODEMP = 1
AND cab.TIPMOV = 'C'
AND par.AD_FORNPARTAVAL = 'S' -- Filtering only suppliers which participate on ISO evaluation
AND (cab.DTNEG BETWEEN '01/01/2024' AND '31/03/2024') -- The period should be variable, as follows: AND (cab.DTNEG BETWEEN :DTNEG.ini AND :DTNEG.fin)
ORDER BY PREV_ENTREGA -- Organizing the sequence by ETA