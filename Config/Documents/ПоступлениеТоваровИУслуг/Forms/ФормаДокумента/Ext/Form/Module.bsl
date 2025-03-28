﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ТекущийПользователь;
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если НЕ ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ТекущийПользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиУслугаПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТЧ.Услуга) Тогда
		СтрокаТЧ.СтатьяЗатрат = ПолучитьСтатьюЗатратПоУслуге(СтрокаТЧ.Услуга);
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтатьюЗатратПоУслуге(Услуга)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.СтатьяЗатрат КАК СтатьяЗатрат
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Услуга);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	Возврат Выборка.СтатьяЗатрат;
	
КонецФункции

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
	
КонецПроцедуры



