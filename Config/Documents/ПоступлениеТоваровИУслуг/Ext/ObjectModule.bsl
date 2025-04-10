﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	СтруктураУчетнаяПолитика = РегистрыСведений.УчетнаяПолитика.ПолучитьПоследнее(Дата);
	Если СтруктураУчетнаяПолитика.СпособУчетаЗапасов = Перечисления.СпособыСписанияЗапасов.FEFO Тогда
		ОтражатьСрокГодности = Истина;
	Иначе 
		ОтражатьСрокГодности = Ложь;
	КонецЕсли;
	
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Движения.УчетЗатрат.Записывать = Истина;
	Движения.Хозрасчетный.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеТоваровИУслугТовары.Номенклатура КАК Номенклатура,
	|	ПоступлениеТоваровИУслугТовары.Цена КАК Цена,
	|	СУММА(ПоступлениеТоваровИУслугТовары.Количество) КАК Количество,
	|	СУММА(ПоступлениеТоваровИУслугТовары.Сумма) КАК Сумма,
	|	ПоступлениеТоваровИУслугТовары.СрокГодности КАК СрокГодности,
	|	ПоступлениеТоваровИУслугТовары.Номенклатура.СчетБухгалтерскогоУчета КАК СчетБухгалтерскогоУчета,
	|	ПоступлениеТоваровИУслугТовары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры
	|ПОМЕСТИТЬ ВТ_Номенклатура
	|ИЗ
	|	Документ.ПоступлениеТоваровИУслуг.Товары КАК ПоступлениеТоваровИУслугТовары
	|ГДЕ
	|	ПоступлениеТоваровИУслугТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеТоваровИУслугТовары.Номенклатура,
	|	ПоступлениеТоваровИУслугТовары.Цена,
	|	ПоступлениеТоваровИУслугТовары.СрокГодности,
	|	ПоступлениеТоваровИУслугТовары.Номенклатура.СчетБухгалтерскогоУчета,
	|	ПоступлениеТоваровИУслугТовары.Номенклатура.ТипНоменклатуры
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТоваровИУслугУслуги.Услуга,
	|	NULL,
	|	ПоступлениеТоваровИУслугУслуги.Количество,
	|	ПоступлениеТоваровИУслугУслуги.Сумма,
	|	NULL,
	|	ПоступлениеТоваровИУслугУслуги.Услуга.СчетБухгалтерскогоУчета,
	|	ПоступлениеТоваровИУслугУслуги.Услуга.ТипНоменклатуры
	|ИЗ
	|	Документ.ПоступлениеТоваровИУслуг.Услуги КАК ПоступлениеТоваровИУслугУслуги
	|ГДЕ
	|	ПоступлениеТоваровИУслугУслуги.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Номенклатура.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ВТ_Номенклатура.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЭтоТовар,
	|	ВТ_Номенклатура.Количество КАК Количество,
	|	ВТ_Номенклатура.Сумма КАК Сумма,
	|	ВТ_Номенклатура.СрокГодности КАК СрокГодности,
	|	ВТ_Номенклатура.СчетБухгалтерскогоУчета КАК СчетБухгалтерскогоУчета,
	|	ВТ_Номенклатура.Номенклатура.СтатьяЗатрат КАК СтатьяЗатрат
	|ИЗ
	|	ВТ_Номенклатура КАК ВТ_Номенклатура";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
			Если Выборка.ЭтоТовар Тогда
				Движение = Движения.ТоварыНаСкладах.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				Движение.Период = Дата;
				Движение.Номенклатура = Выборка.Номенклатура;
				Движение.Склад = Склад;
				Движение.Количество = Выборка.Количество;
				Движение.Сумма = Выборка.Сумма;
				Если ОтражатьСрокГодности Тогда
					Движение.СрокГодности = Выборка.СрокГодности;
				КонецЕсли;
				
				Движение = Движения.Хозрасчетный.Добавить();
				Движение.СчетДт = Выборка.СчетБухгалтерскогоУчета;
				Движение.СчетКт = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
				Движение.Период = Дата;
				Движение.Сумма = Выборка.Сумма;
				Движение.Содержание = "Отражено поступление товарно-материальных ценностей от поставщика";
				БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, Выборка.Номенклатура);
				БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетКт, Движение.СубконтоКт, Контрагент);
			Иначе 
				Движение = Движения.Хозрасчетный.Добавить();
				Движение.СчетДт = Выборка.СчетБухгалтерскогоУчета;
				Движение.СчетКт = ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками;
				Движение.Период = Дата;
				Движение.Сумма = Выборка.Сумма;
				Движение.Содержание = "Отражено поступление услуг от поставщика";
				БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, Выборка.СтатьяЗатрат);
				БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетКт, Движение.СубконтоКт, Контрагент);
			КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеТоваровИУслугУслуги.СтатьяЗатрат КАК СтатьяЗатрат,
	|	СУММА(ПоступлениеТоваровИУслугУслуги.Сумма) КАК Сумма
	|ИЗ
	|	Документ.ПоступлениеТоваровИУслуг.Услуги КАК ПоступлениеТоваровИУслугУслуги
	|ГДЕ
	|	ПоступлениеТоваровИУслугУслуги.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеТоваровИУслугУслуги.СтатьяЗатрат";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		Движение = Движения.УчетЗатрат.Добавить();
		Движение.Период = Дата;
		Движение.СтатьяЗатрат = Выборка.СтатьяЗатрат;
		Движение.Сумма = Выборка.Сумма;
	КонецЦикла;
КонецПроцедуры
