USE POSFAPCENTERPLUS;

-- Hər müştərinin ümumi faktura sayı və toplam xərcləri
select 
	CLC_NAME,
	COUNT(distinct INV_FICHENO) as faktura_sayi,
	SUM(STL_AMOUNT * PRC_PRICE) as toplam_xerc
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
left join CRD_PRICES
on PRC_ITM_CODE = STL_ITMCODE
group by CLC_NAME;


-- Hər müştərinin ən son alış tarixi
select 
	CLC_NAME,
	MAX(INV_DATETIME) as son_alis
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
group by CLC_NAME;


-- Heç faktura etməyən müştərilər
select 
	CLC_NAME,
	INV_FICHENO
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
where INV_FICHENO is null;


-- Ən çox satılan məhsulu tap
select top 10
	ITM_NAME,
	SUM(STL_AMOUNT) as cox_satilan
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
group by ITM_NAME
order by cox_satilan desc;


-- Hansı müştəri ən çox pul xərcləyib?
select top 1
	CLC_NAME,
	SUM(STL_AMOUNT * PRC_PRICE) as cox_xercleyen
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
left join CRD_PRICES
on PRC_ITM_CODE = STL_ITMCODE
group by CLC_NAME
order by cox_xercleyen desc;


-- Hər müştərinin ən çox aldığı məhsulu tap
select 
	CLC_NAME,
	ITM_NAME,
	SUM(STL_AMOUNT)
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
left join CRD_ITEMS
on ITM_CODE = STL_ITMCODE
group by CLC_NAME, ITM_NAME;


-- Hər məhsulun neçə dəfə satıldığını tap 
select 
	ITM_NAME,
	COUNT(STL_ITMCODE) as sale_count
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
group by ITM_NAME;


-- Ən çox faktura edən müştərini tap 
select top 1
	CLC_NAME,
	COUNT(INV_FICHENO) as count_faktura
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
group by CLC_NAME
order by count_faktura desc;


-- Ən çox fərqli məhsul alan müştərini tap 
select 
	CLC_NAME,
	COUNT(distinct ITM_CODE)
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
left join CRD_ITEMS
on ITM_CODE = STL_ITMCODE
group by CLC_NAME;


-- Heç vaxt satılmamış məhsulları tap 
select 
	ITM_NAME,
	STL_ITMCODE
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
where STL_ITMCODE is null;


-- Hər məhsul üçün toplam satış miqdarını və toplam satış məbləğini tap
select 
	ITM_NAME,
	COALESCE(SUM(STL_AMOUNT), 0) as total_amount,
	COALESCE(SUM(STL_AMOUNT * PRC_PRICE), 0) as total_price
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
left join CRD_PRICES
on PRC_ITM_CODE = STL_ITMCODE
group by ITM_NAME;


-- Son 30 gündə satış olunan məhsulları tap 
select 
	ITM_NAME,
	INV_DATETIME
from CRD_ITEMS
join OPR_STLINE
on STL_ITMCODE = ITM_CODE
join OPR_INVOICE
on INV_FICHENO = STL_FICHENO
where INV_DATETIME >= DATEADD(DAY, -30, GETDATE());


-- Ən çox satılan 3 məhsulu tap 
select top 3
	ITM_NAME,
	SUM(STL_AMOUNT) as total_amount
from CRD_ITEMS
join OPR_STLINE
on STL_ITMCODE = ITM_CODE
group by ITM_NAME
order by total_amount desc;


-- Heç alış etməmiş müştəriləri tap 
select 
	CLC_NAME
from CRD_CLIENTS 
left join OPR_INVOICE 
on INV_CLCODE = CLC_ID
where INV_FICHENO is null;


-- Hər müştərinin toplam xərclədiyi pul 
select 
	CLC_NAME,
	SUM(STL_AMOUNT * PRC_PRICE)
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
left join CRD_PRICES
on PRC_ITM_CODE = STL_ITMCODE
group by CLC_NAME;


-- Ən çox satış edən məhsul qrupunu tap  
select top 1
	GRP_NAME,
	SUM(STL_AMOUNT * PRC_PRICE) as total_amount
from CRD_ITEMS
left join CRD_ITEMGROUPS
on GRP_CODE = ITM_GRP_CODE
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
left join CRD_PRICES
on PRC_ITM_CODE = STL_ITMCODE
group by 
	GRP_NAME
order by total_amount desc;
