# Качество данных

## Оцените, насколько качественные данные хранятся в источнике.
Для проверки на наличие дублей мы сравниваем общее количество записей с количеством уникальных записей.Проверка по таблице orders показала, что эти значения, ссылающиеся на order_id оказались одинаковыми. Это показывает, что в таблице orders дубли отсутствуют. 

## Описание инструментов обеспечивающих качество данных в источнике.
Инструменты перечслены в формате таблицы со следующими столбцами:
- `Наименование таблицы` - наименование таблицы, объект которой рассматриваете.
- `Объект` - Здесь укажите название объекта в таблице, на который применён инструмент. Например, здесь стоит перечислить поля таблицы, индексы и т.д.
- `Инструмент` - тип инструмента: первичный ключ, ограничение или что-то ещё.
- `Для чего используется` - здесь в свободной форме опишите, что инструмент делает.

| Наименование аблицы             | Объект                      | Инструмент      | Для чего используется |
| ------------------------------- | --------------------------- | --------------- | --------------------- |
| production.Products | id int NOT NULL PRIMARY KEY | Первичный ключ  | Обеспечивает уникальность записей о продуктах |
| production.Products | CHECK ((price >= (0)::numeric)) | Ограничение | Проверяет, чтобы цена заказа была больше 0 |
| production.orders   | CHECH cost = payment + bonus_payment | Ограничение | Проверяет, чтобы стоимость заказа была полностью оплачена |
| production.orders   | PRIMARY KEY (order_id)  | Первичный ключ | Обеспечивает уникальность записей о заказах |
| production.orderitems | CHECK (((discount >= (0)::numeric) AND (discount <= price))) | Ограничение | 1. Проверяет, чтобы скидка не была отрицательной 2. Проверяет, чтобы скидка не была больше стоимости товара |
| production.orderitems | UNIQUE (order_id, product_id) | Первичный ключ | Обечпечивает уникальность номера товара в привязке к номеру заказа |
| production.orderitems | PRIMARY KEY (id) | Первичный ключ | Обеспечивает уникальность записей о заказах |
| production.orderitems | CHECK ((price >= (0)::numeric)) | Ограничение | Проверяет, чтобы цена заказа была больше 0 |
| production.orderitems | CHECK ((quantity > 0)) | Ограничение | Проверяет, чтобы колисество товара было больше 0 | 
| production.orderitems | FOREIGN KEY (order_id) REFERENCES production.orders(order_id) | Внешний ключ | Связывает таблицы orderitems и orders используя order_id |
| production.orderitems | FOREIGN KEY (product_id) REFERENCES production.products(id) | Внешний ключ | Связывает таблицы orderitems и products используя product_id |
| production.orderstatuslog | id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL PRIMARY KEY| Первичный ключ | Обеспечивает уникальность записей о статусе заказа, при этом генераеция id происходит автоматически |
| production.orderstatuslog | UNIQUE (order_id, status_id) | Ограничение | Проверяет уникальность в паре из номера заказа и его статуса |
| production.orderstatuslog | FOREIGN KEY (order_id) REFERENCES production.orders(order_id) | Внешний ключ | Связывает таблицы orderstatuslog и orders через order_id |
| production.orderstatuslog | FOREIGN KEY (status_id) REFERENCES production.orderstatuses(id) | Внешний ключ | Связывает таблицы orderstatuslog и orderstatus через status_id |
| production.orderstatuses | id int4 NOT NULL PRIMARY KEY | Первичный ключ| Обеспечивает уникальность записей о статусе заказа |
| production.users | id int4 NOT NULL PRIMARY KEY | Первичный ключ | Обеспчивает уникальность записей о пользователях | 