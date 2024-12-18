#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт

	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда

		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(
			Метаданные.Документы.РеализацияТоваровУслуг);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";

		Возврат КомандаСоздатьНаОсновании;

	КонецЕсли;

	Возврат Неопределено;

КонецФункции

//ВКМ Кушнир А.А. добавление команды печати акта
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Акт оказанных услуг
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктОбОказанииУслуг";
	КомандаПечати.Представление = НСтр("ru = 'Акт об оказании услуг'");
	КомандаПечати.Порядок = 5;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктОбОказанииУслуг");
	Если ПечатнаяФорма <> Неопределено Тогда
		ПечатнаяФорма.ТабличныйДокумент = ПечатьАкта(МассивОбъектов, ОбъектыПечати);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт об оказании услуг'");
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ВКМ_ПФ_MXL_АктОбОУ";
	КонецЕсли;

КонецПроцедуры
//ВКМ
#КонецОбласти

//ВКМ Кушнир А.А. добавление команды печати акта
#Область СлужебныеПроцедурыИФункции

Функция ПечатьАкта(МассивОбъектов, ОбъектыПечати)

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Акт";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ВКМ_ПФ_MXL_АктОбОУ");

	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);

	ПервыйДокумент = Истина;

	Пока ДанныеДокументов.Следующий() Цикл

		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ПервыйДокумент = Ложь;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет);

		ВывестиТелоТаблицыАкт(ДанныеДокументов, ТабличныйДокумент, Макет);

		ВывестиПодвалАкта(ДанныеДокументов, ТабличныйДокумент, Макет);
		
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,
			ДанныеДокументов.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

Функция ПолучитьДанныеДокументов(МассивОбъектов)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	РеализацияТоваровУслуг.Дата,
				   |	РеализацияТоваровУслуг.Номер,
				   |	РеализацияТоваровУслуг.Ссылка,
				   |	РеализацияТоваровУслуг.Организация,
				   |	РеализацияТоваровУслуг.Контрагент,
				   |	РеализацияТоваровУслуг.Договор,
				   |	РеализацияТоваровУслуг.СуммаДокумента,
				   |	РеализацияТоваровУслуг.Основание,
				   |	РеализацияТоваровУслуг.Ответственный,
				   |	РеализацияТоваровУслуг.Комментарий,
				   |	РеализацияТоваровУслуг.Услуги.(
				   |		Ссылка,
				   |		НомерСтроки,
				   |		Номенклатура,
				   |		Количество,
				   |		Цена,
				   |		Сумма)
				   |ИЗ
				   |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
				   |ГДЕ
				   |	РеализацияТоваровУслуг.Ссылка В (&МассивДокументов)";

	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);

	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

Процедура ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет)

	ОбластьЗаголовокАкта = Макет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблица");

	ДанныеПечати = Новый Структура;

	ШаблонЗаголовка = "Акт об оказании услуг №%1 от %2";
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка, ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);

	ДанныеПечати.Вставить("Исполнитель", ДанныеДокументов.Организация);
	ДанныеПечати.Вставить("Заказчик", ДанныеДокументов.Контрагент);

	ОбластьЗаголовокАкта.Параметры.Заполнить(ДанныеПечати);

	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("Договор", ДанныеДокументов.Договор);

	ОбластьЗаголовокТаблицы.Параметры.Заполнить(ДанныеПечати);

	ТабличныйДокумент.Вывести(ОбластьЗаголовокАкта);

	ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);

КонецПроцедуры

Процедура ВывестиТелоТаблицыАкт(ДанныеДокументов, ТабличныйДокумент, Макет)

	ОбластьТело = Макет.ПолучитьОбласть("ТелоТаблицы");

	Выборка = ДанныеДокументов.Услуги.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбластьТело.Параметры.Заполнить(Выборка);
		ТабличныйДокумент.Вывести(ОбластьТело);
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиПодвалАкта(ДанныеДокументов, ТабличныйДокумент, Макет)

	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");

	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("Итого", ДанныеДокументов.СуммаДокумента);

	ШаблонТекста = "Оказано услуг на общую сумму: %1 (%2)";
	ТекстСтроки = СтрШаблон(ШаблонТекста, ДанныеДокументов.СуммаДокумента, ЧислоПрописью(ДанныеДокументов.СуммаДокумента, "Л=ru_RU;ДП=Истина",
		"рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2"));
	ДанныеПечати.Вставить("ОказаноУслуг", ТекстСтроки);

	ОбластьПодвал.Параметры.Заполнить(ДанныеПечати);

	ТабличныйДокумент.Вывести(ОбластьПодвал);

КонецПроцедуры
#КонецОбласти
//ВКМ 

#КонецЕсли