{минутные срезы}
/*ReportName=ТС "Западная" (минутные срезы)*/
/*Mode=минутные*/
/*UpQuery="часовые срезы"*/

SET QUOTED_IDENTIFIER OFF
SELECT
	DateTime as "Дата", 
	null,
	CAST(U05_UM11F001*U05_SY00A700 as decimal(6,0)) as "G ПСВ, т/ч [U05_UM11F001]",
	CAST(U05_UM11P001*U05_SY00A700 as decimal(6,2)) as "P ПСВ, изб.МПа [U05_UM11P001]",
	CAST(U05_UM11T001*U05_SY00A700 as decimal(6,2)) as "Т ПСВ, °С [U05_UM11T001]",
	CAST(U05_UM21F001*U05_SY00A700 as decimal(6,0)) as "G ОСВ, т/ч [U05_UM21F001]",
	CAST(U05_UM21P001*U05_SY00A700 as decimal(6,2)) as "P ОСВ, изб.МПа [U05_UM21P001]",
	CAST(U05_UM21T001*U05_SY00A700 as decimal(6,2)) as "Т ОСВ, °С [U05_UM21T001]",
	CAST(U05_VB00T001*U05_SY00A700 as decimal(6,2)) as "Тхв, °С [U05_VB00T001]"
FROM
	OpenQuery(INSQL, 
	"SELECT DateTime, U05_VB00T001, U05_SY00A700, U05_UM11P001, U05_UM21P001, U05_UM11T001, U05_UM21T001, U05_UM11F001, U05_UM21F001
	FROM Runtime.dbo.AnalogWideHistory 
	WHERE wwVersion = 'Latest'
	AND wwRetrievalMode = 'Cyclic'
	AND wwResolution = @resolution
	AND DateTime >= @start
	AND DateTime <= @finish")


{часовые срезы}
/*ReportName=ТС "Западная" (срезы на конец часа)*/
/*Mode=часовые-1*/
/*DownQuery="минутные срезы"*/
/*UpQuery="суточные срезы"*/

SET QUOTED_IDENTIFIER OFF
SELECT
	DateAdd(mi, -5, DateTime) as "Дата",
	null,
	CAST(U05_UM11F001_H1 as decimal(15,0)) as "G ПСВ за п/ч, т/ч [U05_UM11F001_H1]",
	CAST(U05_UM11F001_H1*dbo.vst_SafeDIV(U00_UM10F702_H1,U00_UM10F701_H1) as decimal(15,0)) as "корр G ПСВ за п/ч, т/ч [U05_UM11F002_H1]",
	null,
	CAST(U05_UM11P001_H1 as decimal(15,2)) as "P ПСВ за п/ч, абс.МПа [U05_UM11P001_H1]",
	CAST(U05_UM11T001_H1 as decimal(15,2)) as "T ПСВ за п/ч, °С [U05_UM11T001_H1]",
	CAST(U05_UM21F001_H1 as decimal(15,0)) as "G ОСВ за п/ч, т/ч [U05_UM21F001_H1]",
	CAST(U05_UM21F001_H1*dbo.vst_SafeDIV(U00_UM20F702_H1,U00_UM20F701_H1) as decimal(15,0)) as "корр G ОСВ за п/ч, т/ч ",
	null,
	CAST(U05_UM21P001_H1 as decimal(15,2)) as "P ОСВ за п/ч, абс.МПа [U05_UM21P001_H1]",
	CAST(U05_UM21T001_H1 as decimal(15,2)) as "T ОСВ за п/ч, °С [U05_UM21T001_H1]",
	CAST(U05_UM11W001_H1 as decimal(15,0)) as "W ПСВ за п/ч, ГДж [U05_UM11W001_H1]",
	CAST(isnull(U05_UM11W002_H1,0) as decimal(15,2)) as "корр W ПСВ за п/ч, ГКал",
	null,
	CAST(U05_UM21W001_H1 as decimal(15,0)) as "W ОСВ за п/ч, ГДж [U05_UM21W001_H1]",
	CAST(isnull(U05_UM21W002_H1,0) as decimal(15,0)) as "корр W ОСВ за п/ч, ГКал",
	null,
	CAST(U05_UM31W001_H1 as decimal(15,0)) as "dW по маг.за п/ч, ГДж [U05_UM31W001_H1]",
	CAST(U05_UM11W002_H1-isnull(U05_UM21W002_H1,0) as decimal(15,0)) as "корр dW по маг.за п/ч, ГКал ",
	CAST(U05_VB00T001*U05_SY00A700 as decimal(15,2)) as "Тхв мгн, °С [Мгновенный срез Т источника на конец часа]",
	CAST(U05_UM11F001_H1-U05_UM21F001_H1 as decimal(15,0)) as "Бал. G за п/ч, т/ч [Баланс ПСВ-ОСВ за пр. час]",
	CAST((U05_UM11F001_H1*dbo.vst_SafeDIV(U00_UM10F702_H1,U00_UM10F701_H1))-(U05_UM21F001_H1*dbo.vst_SafeDIV(U00_UM20F702_H1,U00_UM20F701_H1)) as decimal(15,0)) as "корр Бал. G за п/ч, т/ч [Баланс ПСВ-ОСВ за пр. час]",
	CAST(dbo.vst_SafeDIV((U05_UM11F001_H1-U05_UM21F001_H1),(U05_UM11F001_H1))*100 as decimal(15,2)) as "Бал. G за п/ч, % [Баланс ПСВ-ОСВ за пр. час]",
	CAST(dbo.vst_SafeDIV(((U05_UM11F001_H1*dbo.vst_SafeDIV(U00_UM10F702_H1,U00_UM10F701_H1))-(U05_UM21F001_H1*dbo.vst_SafeDIV(U00_UM20F702_H1,U00_UM20F701_H1))),(U05_UM11F001_H1))*100 as decimal(15,2)) as "корр Бал. G за п/ч, % [Баланс ПСВ-ОСВ за пр. час]"
FROM
	OpenQuery(INSQL, 
	"SELECT DateTime, 
	U05_UM11W002_H1, U05_UM21W002_H1, U00_UM10F702_H1, U00_UM10F701_H1, U00_UM20F702_H1, U00_UM20F701_H1,
	U05_UM11T001_H1, U05_UM21T001_H1, U05_UM11P001_H1, U05_UM21P001_H1, U05_UM11F001_H1, U05_UM21F001_H1, U05_SY00A700, U05_VB00T001, U05_UM11W001_H1, U05_UM21W001_H1, U05_UM31W001_H1
	FROM Runtime.dbo.AnalogWideHistory 
	WHERE wwVersion = 'Latest'
	AND wwRetrievalMode = 'Cyclic'
	AND wwResolution = @resolution
	AND DateTime >= @start
	AND DateTime <= @finish")


{суточные срезы}
/*ReportName=ТС "Западная" (срезы на конец суток)*/
/*Mode=суточные-1*/
/*DownQuery="часовые срезы"*/
/*UpQuery="смены за месяц"*/

SET QUOTED_IDENTIFIER OFF
SELECT
	DateAdd(mi, -1445, DateTime) as "Дата",
	null,
	CAST(U05_UM11F001_S1 as decimal(15,0)) as "G ПСВ за п/с, т/cут [U05_UM11F001_S1]",
	CAST(U05_UM11P001_S1 as decimal(15,2)) as "P ПСВ за п/с, абс.МПа [U05_UM11P001_S1]",
	CAST(U05_UM11T001_S1 as decimal(15,2)) as "T ПСВ за п/с, °С [U05_UM11T001_S1]",
	CAST(U05_UM11T002_S1 as decimal(15,2)) as "Tср.взв. ПСВ за п/с, °С [U05_UM11T002_S1]",
	null,
	CAST(U05_UM21F001_S1 as decimal(15,0)) as "G ОСВ за п/с, т/cут [U05_UM21F001_S1]",
	CAST(U05_UM21P001_S1 as decimal(15,2)) as "P ОСВ за п/с, абс.МПа [U05_UM21P001_S1]",
	CAST(U05_UM21T001_S1 as decimal(15,2)) as "T ОСВ за п/с, °С [U05_UM21T001_S1]",
	CAST(U05_UM21T002_S1 as decimal(15,2)) as "Tср.взв. ОСВ за п/с, °С [U05_UM21T002_S1]",
	null,
	CAST(U05_UM11W001_S1 as decimal(15,0)) as "W ПСВ за п/с, ГДж [U05_UM11W001_S1]",
	CAST(U05_UM21W001_S1 as decimal(15,0)) as "W ОСВ за п/с, ГДж [U05_UM21W001_S1]",
	CAST(U05_UM31W001_S1 as decimal(15,0)) as "dW по МАГ за п/с, ГДж [U05_UM31W001_S1]",
	CAST(U05_VB01T001_S1 as decimal(15,2)) as "Tхв за п/с, °С [U05_VB01T001_S1]",
	CAST(U05_UM11F001_S1+U05_UM21F001_S1 as decimal(15,0)) as "Бал. G за п/с, т/cут [Баланс ПСВ-ОСВ за П/с]",
	CAST(dbo.vst_SafeDIV((U05_UM11F001_S1-U05_UM21F001_S1),(U05_UM11F001_S1))*100 as decimal(15,2)) as "Бал. G за п/с, % [Баланс ПСВ-ОСВ за П/с]",
	null,
	/*
	CAST(dbo.vst_SafeDIV((U05_UM11F001_S1),(U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1))*(U04_UM41F001_S1+U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1+U04_UM21F001_S1+U06_UM21F001_S1+U06_UM22F001_S1+/*U07_UM21G001_S1+*/U05_UM21F001_S1)/2 as decimal(15,0)) as "кор G ПСВ",
	CAST(dbo.vst_SafeDIV((U05_UM21F001_S1),(U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1-U04_UM41F001_S1))*(((U04_UM41F001_S1+U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1+U04_UM21F001_S1+U06_UM21F001_S1+U06_UM22F001_S1+/*U07_UM21G001_S1+*/U05_UM21F001_S1)/2))-U04_UM41F001_S1 as decimal(15,0)) as "кор G ОСВ",
	CAST((U05_UM11T002_S1-U05_VB01T001_S1)*dbo.vst_SafeDIV((U05_UM11F001_S1),  (U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1))*(U04_UM41F001_S1+U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1+U04_UM21F001_S1+U06_UM21F001_S1+U06_UM22F001_S1+/*U07_UM21G001_S1+*/U05_UM21F001_S1)/2000 as decimal(15,0)) as "кор W ПСВ за п/с, Гкал",
	CAST((U05_UM21T002_S1-U05_VB01T001_S1)*((dbo.vst_SafeDIV((U05_UM21F001_S1),(U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1-U04_UM41F001_S1))*((U04_UM41F001_S1+U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1+U04_UM21F001_S1+U06_UM21F001_S1+U06_UM22F001_S1+/*U07_UM21G001_S1+*/U05_UM21F001_S1)/2))-U04_UM41F001_S1)/1000 as decimal(15,0)) as "кор W ОСВ за п/с, Гкал [U04_UM21W002_S1]",
	CAST(((U05_UM11T002_S1-U05_VB01T001_S1)*dbo.vst_SafeDIV((U05_UM11F001_S1), (U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1))*(U04_UM41F001_S1+U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1+U04_UM21F001_S1+U06_UM21F001_S1+U06_UM22F001_S1+/*U07_UM21G001_S1+*/U05_UM21F001_S1)/2000) - ((U05_UM21T002_S1-U05_VB01T001_S1)*((dbo.vst_SafeDIV((U05_UM21F001_S1),(U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1-U04_UM41F001_S1))*((U04_UM41F001_S1+U04_UM11F001_S1+U06_UM11F001_S1+U07_UM11G001_S1+U05_UM11F001_S1+U04_UM21F001_S1+U06_UM21F001_S1+U06_UM22F001_S1+/*U07_UM21G001_S1+*/U05_UM21F001_S1)/2))-U04_UM41F001_S1)/1000) as decimal(15,0)) as "кор dW по МАГ за п/с, Гкал "
	*/
	CAST(isnull(U05_UM11W002_S1,0) as decimal(15,0)) as "кор W ПСВ за п/с, Гкал [U05_UM11W002_S1]",
	CAST(isnull(U05_UM21W002_S1,0) as decimal(15,0)) as "кор W ОСВ за п/с, Гкал [U05_UM21W002_S1]",
	CAST(isnull(U05_UM11W002_S1,0)-isnull(U05_UM21W002_S1,0) as decimal(15,0)) as "кор dW по МАГ за п/с, Гкал "
FROM
	OpenQuery(INSQL,
	"SELECT DateTime, U05_VB01T001_S1, U05_UM11T001_S1, U05_UM21T001_S1, U05_UM11P001_S1, U05_UM21P001_S1, U05_UM11F001_S1, U05_UM21F001_S1, U05_UM11W001_S1, U05_UM21W001_S1, U05_UM31W001_S1,
	U05_UM11T002_S1, U05_UM21T002_S1,
	U04_UM41F001_S1, U04_UM11F001_S1, U04_UM21F001_S1,
	U05_UM11F001_S1, U05_UM21F001_S1,
	U06_UM11F001_S1, U06_UM21F001_S1, U06_UM22F001_S1,
	U07_UM11G001_S1,
	U05_UM11W002_S1,U05_UM21W002_S1
	FROM Runtime.dbo.AnalogWideHistory
	WHERE wwVersion = 'Latest'
	AND wwRetrievalMode = 'Cyclic'
	AND wwResolution = @resolution
	AND DateTime >= @start
	AND DateTime <= @finish")


{часовые срезы по сменам 8/12}
/*ReportName=ТС "Западная" (часовые срезы по сменам 8/12)*/
/*Mode=8-12*/
/*DownQuery="минутные срезы"*/
/*UpQuery="посменный"*/

SET QUOTED_IDENTIFIER OFF
SELECT
	DateAdd(mi, -5, DateTime) as "Дата",
	null,
	CHAR(192+CLC_ShiftDuty) as "Cме- на [CLC_ShiftDuty]",
	CAST(U05_UM11F001_H1 as decimal(15,0)) as "G ПСВ за п/ч, т/ч [U05_UM11F001_H1]",
	CAST(U05_UM11P001_H1 as decimal(15,2)) as "P ПСВ за п/ч, абс.МПа [U05_UM11P001_H1]",
	CAST(U05_UM11T001_H1 as decimal(15,2)) as "T ПСВ за п/ч, °С [U05_UM11T001_H1]",
	CAST(U05_UM21F001_H1 as decimal(15,0)) as "G ОСВ за п/ч, т/ч [U05_UM21F001_H1]",
	CAST(U05_UM21P001_H1 as decimal(15,2)) as "P ОСВ за п/ч, абс.МПа [U05_UM21P001_H1]",
	CAST(U05_UM21T001_H1 as decimal(15,2)) as "T ОСВ за п/ч, °С [U05_UM21T001_H1]",
	CAST(U05_UM11W001_H1 as decimal(15,0)) as "W ПСВ за п/ч, ГДж [U05_UM11W001_H1]",
	CAST(U05_UM21W001_H1 as decimal(15,0)) as "W ОСВ за п/ч, ГДж [U05_UM21W001_H1]",
	CAST(U05_UM31W001_H1 as decimal(15,0)) as "dW по маг.за п/ч, ГДж [U05_UM31W001_H1]",
	CAST(U05_UM11F001_H1-U05_UM21F001_H1 as decimal(15,0)) as "Бал. G за п/ч, т/ч [Баланс ПСВ-ОСВ за пр. час]",
	CAST(dbo.vst_SafeDIV((U05_UM11F001_H1-U05_UM21F001_H1),(U05_UM11F001_H1))*100 as decimal(15,2)) as "Бал. G за п/ч, % [Баланс ПСВ-ОСВ за пр. час]"
FROM
	OpenQuery(INSQL, 
	"SELECT DateTime, U05_UM11T001_H1, U05_UM21T001_H1, U05_UM11P001_H1, U05_UM21P001_H1, U05_UM11F001_H1, U05_UM21F001_H1,
	CLC_ShiftDuty, U05_UM11W001_H1, U05_UM21W001_H1, U05_UM31W001_H1
	FROM Runtime.dbo.AnalogWideHistory 
	WHERE wwVersion = 'Latest'
	AND wwRetrievalMode = 'Cyclic'
	AND wwResolution = @resolution
	AND DateTime >= @start
	AND DateTime <= @finish")


{посменный}
/*ReportName=ТС "Западная"(агрегированные часовые данные по сменам)*/
/*Mode=посменный*/
/*DownQuery="часовые срезы по сменам 8/12"*/
/*UpQuery="смены за месяц"*/

SET QUOTED_IDENTIFIER OFF
SELECT
	DateAdd(hh, 20, Convert(DateTime, Round(Convert(float, DateAdd(mi, -500, Max(DateTime))) * 2, 0, 1) / 2)) as 'DateMarker',
	DateAdd(mi,480,Convert(DateTime,Round(Convert(float,DateAdd(mi,-500,DateTime))*2,0,1)/2)) as 'Дата',
	null, 
	CHAR(192+Runtime.dbo.vst_GetShiftNumber(MIN(DateTime))) as "Cмена [CLC_ShiftDuty]",
	CAST(sum(U05_UM11F001_H1) as decimal(15,0)) as "G ПСВ за смену, т/см [U05_UM11F001_H1]",
	CAST(avg(U05_UM11P001_H1) as decimal(15,2)) as "P ПСВ ср, абс.МПа [U05_UM11P001_H1]",
	CAST(avg(U05_UM11T001_H1) as decimal(15,2)) as "T ПСВ ср, °С [U05_UM11T001_H1]",
	CAST(sum(U05_UM21F001_H1) as decimal(15,0)) as "G ОСВ за смену, т/см [U05_UM21F001_H1]",
	CAST(avg(U05_UM21P001_H1) as decimal(15,2)) as "P ОСВ ср, абс.МПа [U05_UM21P001_H1]",
	CAST(avg(U05_UM21T001_H1) as decimal(15,2)) as "T ОСВ ср, °С [U05_UM21T001_H1]",
	CAST(sum(U05_UM11W001_H1) as decimal(15,0)) as "W ПСВ за смену, ГДж [U05_UM11W001_H1]",
	CAST(sum(U05_UM21W001_H1) as decimal(15,0)) as "W ОСВ за смену, ГДж [U05_UM21W001_H1]",
	CAST(sum(U05_UM31W001_H1) as decimal(15,0)) as "dW по маг.за смену, ГДж [U05_UM31W001_H1]",
	CAST(sum(U05_UM11F001_H1-U05_UM21F001_H1) as decimal(15,0)) as "Бал. G за смену, т/см [Баланс ПСВ-ОСВ за смену]",
	CAST(avg(dbo.vst_SafeDIV((U05_UM11F001_H1-U05_UM21F001_H1),(U05_UM11F001_H1))*100) as decimal(15,2)) as "Бал. G средн, % [Баланс ПСВ-ОСВ за смену]"
FROM
	OpenQuery(INSQL, 
	"SELECT DateTime, U05_UM11T001_H1, U05_UM21T001_H1, U05_UM11P001_H1, U05_UM21P001_H1, U05_UM11F001_H1, U05_UM21F001_H1, 
	CLC_ShiftDuty, U05_UM11W001_H1, U05_UM21W001_H1, U05_UM31W001_H1
	FROM Runtime.dbo.AnalogWideHistory 
	WHERE wwVersion = 'Latest'
	AND wwRetrievalMode = 'Cyclic'
	AND wwResolution = @resolution
	AND DateTime >= @start
	AND DateTime <= @finish")
GROUP BY
	DateAdd(mi,480,Convert(DateTime,Round(Convert(float,DateAdd(mi,-500,DateTime))*2,0,1)/2))	
Order By
	DateAdd(mi,480,Convert(DateTime,Round(Convert(float,DateAdd(mi,-500,DateTime))*2,0,1)/2))	


{смены за месяц}
/*ReportName=ТС "Западная" (агрегированные по сменам за месяц)*/
/*Mode=смены за месяц*/
/*DownQuery="посменный"*/
/*UpQuery="суточные срезы"*/

SET QUOTED_IDENTIFIER OFF
SET LANGUAGE 'Russian'
SELECT
	'02' + Right(Convert(char(10), MIN(DateTime), 104), 8) as 'DateMarker',
	DateName(mm,MIN(DateTime))+' '+DateName(yyyy,MIN(DateTime))  as 'Дата',
	null,
	CHAR(192+Runtime.dbo.vst_GetShiftNumber(DateTime)) as "Cмена [CLC_ShiftDuty]",
	Count(*) as "Час [Время, отработанное сменой за месяц, час]",
	CAST(sum(U05_UM11F001_H1) as decimal(15,0)) as "G ПСВ сум, т/см [U05_UM11F001_H1]",
	CAST(avg(U05_UM11P001_H1) as decimal(15,2)) as "P ПСВ сред, абс.МПа [U05_UM11P001_H1]",
	CAST(avg(U05_UM11T001_H1) as decimal(15,2)) as "T ПСВ сред, °С [U05_UM11T001_H1]",
	CAST(sum(U05_UM21F001_H1) as decimal(15,0)) as "G ОСВ сум, т/см [U05_UM21F001_H1]",
	CAST(avg(U05_UM21P001_H1) as decimal(15,2)) as "P ОСВ сред, абс.МПа [U05_UM21P001_H1]",
	CAST(avg(U05_UM21T001_H1) as decimal(15,2)) as "T ОСВ сред, °С [U05_UM21T001_H1]",
	CAST(sum(U05_UM11W001_H1) as decimal(15,0)) as "W ПСВ сум, ГДж [U05_UM11W001_H1]",
	CAST(sum(U05_UM21W001_H1) as decimal(15,0)) as "W ОСВ сум, ГДж [U05_UM21W001_H1]",
	CAST(sum(U05_UM31W001_H1) as decimal(15,0)) as "dW по маг. сум, ГДж [U05_UM31W001_H1]",
	CAST(sum(U05_UM11F001_H1-U05_UM21F001_H1) as decimal(15,0)) as "Бал. G сум, т/см [Баланс ПСВ-ОСВ]",
	CAST(avg(dbo.vst_SafeDIV((U05_UM11F001_H1-U05_UM21F001_H1),(U05_UM11F001_H1))*100) as decimal(15,2)) as "Бал. G средн, % [Баланс ПСВ-ОСВ ]"
FROM
	OpenQuery(INSQL, 
	"SELECT DateTime, U05_UM11T001_H1, U05_UM21T001_H1, U05_UM11P001_H1, U05_UM21P001_H1, U05_UM11F001_H1, U05_UM21F001_H1,
	CLC_ShiftDuty, U05_UM11W001_H1, U05_UM21W001_H1, U05_UM31W001_H1
	FROM Runtime.dbo.AnalogWideHistory
	WHERE wwVersion = 'Latest'
	AND wwRetrievalMode = 'Cyclic'
	AND wwResolution = @resolution
	AND DateTime >= @start
	AND DateTime <= @finish")
GROUP BY
	CHAR(192+Runtime.dbo.vst_GetShiftNumber(DateTime))
ORDER BY
	CHAR(192+Runtime.dbo.vst_GetShiftNumber(DateTime))