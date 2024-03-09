-- Заполняем витрину dm_rfm_segments
INSERT INTO analysis.dm_rfm_segments 
SELECT r.id user_id, recency, frequency, monetory_value 
FROM analysis.tmp_rfm_recency r 
JOIN analysis.tmp_rfm_frequency f ON r.id = f.id 
JOIN analysis.tmp_rfm_monetory_value m ON f.id = m.id;

-- Первые 10 строк полученной таблицы 
0	1	3	4
1	4	3	3
2	2	3	5
3	2	3	3
4	4	3	3
5	5	5	5
6	1	3	5
7	4	2	2
8	1	1	3
9	1	2	2