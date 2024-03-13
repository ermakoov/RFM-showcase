DROP VIEW analysis.orders_view; -- удаляем старое представление

CREATE VIEW analysis.orders_view AS -- создаем новое представления с необходимым полем status
SELECT o.*, MAX(ol.status_id) new_status
FROM production.orders o  , production.orderstatuslog ol
WHERE o.order_id = ol.order_id
GROUP BY o.order_id;
