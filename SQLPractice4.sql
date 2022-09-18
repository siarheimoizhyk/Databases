fine_id					name		number_plate	violation						sum_fine		date_violation	date_payment
INT PRIMARY KEY													
AUTO_INCREMENT		VARCHAR(30)		   VARCHAR(6)		VARCHAR(50)	                    DECIMAL(8,2)	DATЕ       DATE

1                         Баранов П.Е.             Р523ВТ           Превышение скорости(от 40 до 60)        500.00          2020-01-12      2020-01-17
2                         Абрамова К.А.            О111АВ           Проезд назапрещающий сигнал             1000.00         2020-01-14      2020-02-27
3                         Яковлев Г.Р.             Т330ТТ           Превышение скорости(от 20 до 40)        500.00          2020-01-23      2020-02-23
4                         Яковлев Г.Р.             М701АА           Превышение скорости(от 20 до 40)                        2020-01-12	 
5                         Колесов С.П.	           К892АХ           Превышение скорости(от 20 до 40)                        2020-02-01	 
6                         Баранов П.Е.	           Р523ВТ           Превышение скорости(от 40 до 60)                        2020-02-14	 
7                         Абрамова К.А.	           О111АВ           Проезд назапрещающий сигнал                             2020-02-23	 
8                         Яковлев Г.Р.	           Т330ТТ           Проезд назапрещающий сигнал                             2020-03-03	 

/*Создать таблицу fine следующей структуры:
Поле	Описание
fine_id	ключевой столбец целого типа с автоматическим увеличением значения ключа на 1
name	строка длиной 30
number_plate	строка длиной 6
violation	строка длиной 50
sum_fine	вещественное число, максимальная длина 8, количество знаков после запятой 2
date_violation	дата
date_payment	дата*/

CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation Date,
    date_payment Date
);


/* В таблицу fine первые 5 строк уже занесены. Добавить в таблицу записи с ключевыми значениями 6, 7, 8.*/

INSERT INTO fine (name , number_plate,violation , sum_fine, date_violation, date_payment  ) 
VALUES 
('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', null, '2020-02-14', null),
('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', null, '2020-02-23', null),
('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', null, '2020-03-03', null);


/*Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. 
При этом суммы заносить только в пустые поля столбца  sum_fine.
Таблица traffic_violation создана и заполнена.
Важно! Сравнение значения столбца с пустым значением осуществляется с помощью оператора IS NULL*/

UPDATE fine AS f, traffic_violation AS tv
SET f.sum_fine = tv.sum_fine
WHERE f.violation = tv.violation AND f.sum_fine IS NULL;



/*Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило   два и более раз.
 При этом учитывать все нарушения, независимо от того оплачены они или нет. Информацию отсортировать в алфавитном порядке,
 сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению*/
 
SELECT name, number_plate, violation FROM fine
GROUP BY name, number_plate, violation
Having count(violation)>1
ORDER by name, number_plate, violation;



В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей.
/*
В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей.*/

UPDATE fine,(
    SELECT	name, number_plate, violation
    FROM fine
    group by  1, 2, 3
    having count(3)>=2
    order by 1,2,3) as new
SET sum_fine = IF(date_payment is NULL,sum_fine*2,sum_fine)
WHERE fine.name = new.name;



/*Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. */

DELETE FROM fine
WHERE date_violation < '2020-02-01 00:00:00';



/*Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine*/


CREATE TABLE back_payment as
(SELECT name, number_plate, violation, sum_fine, date_violation From fine
 Where date_payment is NULL);
 
 
 
 /**/