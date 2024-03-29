INSERT INTO analysis.tmp_rfm_frequency  -- заполняем временную таблицу для метрики frequency
SELECT user_id id, frequency 
FROM (
	SELECT user_id, 
	 CASE -- распределяем клиентов
		WHEN num >= 1 AND num <= 200 THEN 5
		WHEN num >= 201 AND num <= 400 THEN 4
		WHEN num >= 401 AND num <= 600 THEN 3
		WHEN num >= 601 AND num <= 800 THEN 2
		ELSE 1
	 END as frequency
	FROM (
		SELECT *, ROW_NUMBER () OVER () AS num -- нумеруем отсортированные по количеству заказов данные для дальнейшего распределения
		FROM (
			SELECT COUNT(order_id), user_id
			FROM analysis.orders_view ov 
			WHERE status = 4
			GROUP BY user_id
			HAVING DATE_TRUNC('YEAR', MAX(order_ts)::DATE) >= '2022-01-01' -- ограничение с начала 2022 года
			ORDER BY COUNT(order_id) DESC) b) bb
	ORDER BY user_id) bbb;

INSERT INTO analysis.tmp_rfm_frequency  -- добаваляет user_id без заказов с frequency = 1
SELECT  uv.id user_id, 1 frequency 
FROM analysis.users_view uv
LEFT JOIN analysis.orders_view ov 
ON uv.id = ov.user_id 
WHERE uv.id NOT IN (SELECT user_id  
					FROM analysis.orders_view ov2
					WHERE status = 4
					GROUP BY user_id)
GROUP BY uv.id;

