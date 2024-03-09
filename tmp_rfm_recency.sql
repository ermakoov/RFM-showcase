INSERT INTO analysis.tmp_rfm_recency -- заполняем временную таблицу для метрики recency
SELECT user_id id, recency 
FROM (
	SELECT user_id, 
	 CASE -- распределяем клиентов
		WHEN num >= 1 AND num <= 200 THEN 5
		WHEN num >= 201 AND num <= 400 THEN 4
		WHEN num >= 401 AND num <= 600 THEN 3
		WHEN num >= 601 AND num <= 800 THEN 2
		ELSE 1
	 END as recency
	FROM (
		SELECT *, ROW_NUMBER () OVER () AS num -- нумеруем отсортированные по давности данные для дальнейшего распределения
		FROM (
			SELECT MAX(order_ts) order_ts, user_id -- выводим для каждого пользователя время последнего заказа
			FROM analysis.orders_view ov
			WHERE status = 4
			GROUP BY user_id
			HAVING DATE_TRUNC('YEAR', MAX(order_ts)::DATE) >= '2022-01-01' -- ограничение с начала 2022 года
			ORDER BY MAX(order_ts) DESC) a) aa
	ORDER BY user_id) aaa;

INSERT INTO analysis.tmp_rfm_recency -- добаваляет user_id без заказов с recency = 1
SELECT  uv.id user_id, 1 recency 
FROM analysis.users_view uv
LEFT JOIN analysis.orders_view ov 
ON uv.id = ov.user_id 
WHERE uv.id NOT IN (SELECT user_id  
					FROM analysis.orders_view ov2
					WHERE status = 4
					GROUP BY user_id)
GROUP BY uv.id;