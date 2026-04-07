USE POSFAPCENTERPLUS;

/* Sual 1 (Real ERP ssenarisi)
Bir şirkət satılan məhsulların məlumatını görmək istəyir.
Aşağıdakı məlumatları çıxaran SQL sorğusu yaz:
Faktura nömrəsi, Faktura tarixi
Müştərinin adı, Məhsulun adı
Məhsulun barcode-u, Satılan miqdar
Məhsulun qiyməti, Ümumi məbləğ (Quantity × Price) */

select 
	INV_FICHENO,
	INV_DATETIME,
	CLC_NAME,
	ITM_NAME,
	IBR_BARCODE,
	STL_AMOUNT,
	PRC_PRICE,
	STL_AMOUNT * PRC_PRICE as total_amount
from OPR_INVOICE
left join CRD_CLIENTS
on CLC_ID = INV_CLCODE
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
left join CRD_ITEMS
on ITM_CODE = STL_ITMCODE
left join CRD_ITEMBARCODES
on IBR_ITM_CODE = ITM_CODE
left join CRD_PRICES
on PRC_ITM_CODE = ITM_CODE;


/* Sual 2: Hər müştərinin toplam alış məbləğini çıxar */

select 
	CLC_NAME,
	COUNT(distinct INV_FICHENO),
	SUM(STL_AMOUNT * PRC_PRICE)
from CRD_CLIENTS
left join  OPR_INVOICE
on INV_CLCODE = CLC_ID
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
left join CRD_ITEMS
on ITM_CODE = STL_ITMCODE
left join CRD_PRICES
on PRC_ITM_CODE = ITM_CODE
group by CLC_NAME;


/* Sual 3: Ən çox satılan 5 məhsulu tap */

select top 5
	ITM_NAME,
	SUM(STL_AMOUNT),
	SUM(STL_AMOUNT * PRC_PRICE)
from CRD_ITEMS
left join OPR_STLINE 
on STL_ITMCODE = ITM_CODE
left join CRD_PRICES
on PRC_ITM_CODE = ITM_CODE
group by ITM_NAME
order by SUM(STL_AMOUNT) desc;


/* Sual 4: Heç satış olunmayan məhsulları tap */

select 
	ITM_CODE, 
	ITM_NAME,
	STL_AMOUNT
from CRD_ITEMS 
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
where STL_ITMCODE is null;


/* Sual 5: Hər fakturanın ümumi məbləğini çıxar */

select 
	INV_FICHENO,
	INV_DATETIME,
	CLC_NAME,
	SUM(STL_AMOUNT * PRC_PRICE)
from OPR_INVOICE
left join CRD_CLIENTS 
on CLC_ID = INV_CLCODE
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
left join CRD_PRICES
on PRC_ITM_CODE = STL_ITMCODE
group by
	INV_FICHENO,
	INV_DATETIME,
	CLC_NAME;


/* Sual 6: Ən çox pul qazandıran müştərini tap */

select top 1
	CLC_NAME,
	SUM(STL_AMOUNT * PRC_PRICE) as total_price
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
left join OPR_STLINE 
on STL_FICHENO = INV_FICHENO
left join CRD_PRICES
on PRC_ITM_CODE = STL_ITMCODE
group by CLC_NAME
order by total_price desc;


/* Sual 7: Hər müştərinin ən son etdiyi alış tarixini tap */

select 
	CLC_NAME,
	MAX(INV_DATETIME)
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
group by CLC_NAME;


/* Sual 8: Heç faktura yazmayan müştəriləri tap */

select 
	INV_FICHENO,
	CLC_ID,
	CLC_NAME
from OPR_INVOICE
left join CRD_CLIENTS
on CLC_ID = INV_CLCODE
where INV_FICHENO is null;


/* Sual 9: Ən çox satılan məhsulun adını tap */

select top 1
	ITM_NAME,
	MAX(STL_AMOUNT) as max_saled
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
group by ITM_NAME
order by max_saled desc;


/* Sual 10: Hər müştərinin neçə fərqli məhsul aldığını tap */

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
