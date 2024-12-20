﻿#language: ru

@tree

Функционал: Проверка корректности массового создания актов (реализации товаров и услуг)

Как Бухгалтер ИТ фирмы я хочу
создать недостающие акты (реализации товаров и услуг) за месяц 
чтобы проверить корректность работы обработки по массовому созданию актов (реализации товаров и услуг)  

Контекст:
	Дано Я подключаю клиент тестирования "БухгалтерИТФирмы" из таблицы клиентов тестирования

Сценарий: Проверка массового создания актов (реализации товаров и услуг)
*Я открываю обработку массового создания актов
	И В командном интерфейсе я выбираю 'Обслуживание клиентов' 'Массовое создание актов'
	Тогда открылось окно 'Массовое создание актов'
	* Я выбираю период создания актов
		И я нажимаю кнопку выбора у поля с именем "ВКМ_Период"
		И в поле с именем 'ВКМ_Период' я ввожу текст '05.2024'
	* Я нажимаю кнопку "заполнить" для формирования перечня актов за период
		И в таблице "ВКМ_Список" я нажимаю на кнопку с именем 'ФормаВКМ_Заполнить'
	* Я массово создаю акты (реализации товаров и услуг)
		И я нажимаю на кнопку с именем 'ФормаВКМ_СоздатьРеализацию'

