﻿
&НаКлиенте
Процедура Зарегистрироваться(Команда)
	
	Если ЭтаФорма.Логин = "" Тогда
		Сообщить("Введите логин пользователя!");
		Возврат;
	ИначеЕсли ЭтаФорма.Телефон = "" Тогда
		Сообщить("Введите номер телефона!");
		Возврат
	КонецЕсли;
	
	РегистрацияПользователя.ВыполнитьРегистрацию(ЭтаФорма.Логин, ЭтаФорма.Телефон);
	ЗавершитьРаботуСистемы(Ложь, Истина);
	
КонецПроцедуры
