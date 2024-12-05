#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ВКМ_КолвоДнейОтпуска();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВКМ_ОтпускаСотрудников

&НаКлиенте
Процедура ВКМ_ОтпускаСотрудниковВКМ_ДатаОкончанияПриИзменении(Элемент)
	ВКМ_КолвоДнейОтпуска();
КонецПроцедуры
&НаКлиенте
Процедура ВКМ_ОтпускаСотрудниковВКМ_ДатаНачалаПриИзменении(Элемент)
	ВКМ_КолвоДнейОтпуска();
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ВКМ_АнализГрафика(Команда)

	АдресВХранилище = ВКМ_ПоместитьВоВременноеХранилищеНаСервере();
	ПараметрыФормы = Новый Структура("АдресВХранилище", АдресВХранилище);
	ОткрытьФорму("Документ.ВКМ_ГрафикОтпусков.Форма.ВКМ_АнализГрафика", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВКМ_ПоместитьВоВременноеХранилищеНаСервере()

	Адрес = ПоместитьВоВременноеХранилище(Объект.ВКМ_ОтпускаСотрудников.Выгрузить( ,
		"ВКМ_Сотрудник,ВКМ_ДатаНачала,ВКМ_ДатаОкончания"), УникальныйИдентификатор);
	Возврат Адрес;

КонецФункции

&НаКлиенте
Процедура ВКМ_КолвоДнейОтпуска()

	МассивСотрудники = ВКМ_ПолучитьКоличествоДнейОтпуска();
	ВКМ_УстановитьПодсветкуСтрок(МассивСотрудники);

КонецПроцедуры

&НаСервере
Процедура ВКМ_УстановитьПодсветкуСтрок(МассивСотрудники)

	УсловноеОформление.Элементы.Очистить();
	Если МассивСотрудники.Количество() > 0 Тогда
		Для Каждого Сотрудник Из МассивСотрудники Цикл
			ЭлементОформления = УсловноеОформление.Элементы.Добавить();

			ЭлементОформления.Использование = Истина;
			ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.ЛососьСветлый);
			ЭлементУсловия = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементУсловия.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ВКМ_ОтпускаСотрудников.ВКМ_Сотрудник");
			ЭлементУсловия.ПравоеЗначение = Сотрудник;
			ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементУсловия.Использование = Истина;

			ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
			ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ВКМ_ОтпускаСотрудниковВКМ_Сотрудник");
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ВКМ_ПолучитьКоличествоДнейОтпуска()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ВложенныйЗапрос.ВКМ_Сотрудник КАК Сотрудник,
				   |	ВложенныйЗапрос.ВКМ_ДатаНачала КАК ДатаНачала,
				   |	ВложенныйЗапрос.ВКМ_ДатаОкончания КАК ДатаОкончания
				   |ПОМЕСТИТЬ ВТ_ДанныеДокумента
				   |ИЗ
				   |	&МассивТаблица КАК ВложенныйЗапрос
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ВТ_ДанныеДокумента.Сотрудник КАК Сотрудник,
				   |	СУММА(РАЗНОСТЬДАТ(ВТ_ДанныеДокумента.ДатаНачала, ВТ_ДанныеДокумента.ДатаОкончания, ДЕНЬ) + 1) КАК КоличествоДней
				   |ИЗ
				   |	ВТ_ДанныеДокумента КАК ВТ_ДанныеДокумента
				   |СГРУППИРОВАТЬ ПО
				   |	ВТ_ДанныеДокумента.Сотрудник";

	Запрос.УстановитьПараметр("МассивТаблица", Объект.ВКМ_ОтпускаСотрудников.Выгрузить());

	Результат= Запрос.Выполнить().Выбрать();

	МассивСотрудники = Новый Массив;

	Пока Результат.Следующий() Цикл

		Если Результат.КоличествоДней > 28 Тогда
			МассивСотрудники.Добавить(Результат.Сотрудник);
		КонецЕсли;

	КонецЦикла;

	Возврат МассивСотрудники;

КонецФункции

#КонецОбласти