USE POSFAPCENTERPLUS;

/* Bütün məhsulları və onların barcode-larını çıxart:
məhsul adı, barcode */
select 
	ITM_CODE,
	ITM_NAME,
	IBR_BARCODE
from CRD_ITEMS 
left join CRD_ITEMBARCODES
on IBR_ITM_CODE = ITM_CODE;

/* Hər məhsulun qiymətini göstər:
məhsul adı, qiymət */
select 
	ITM_CODE,
	ITM_NAME,
	PRC_PRICE
from CRD_ITEMS
left join CRD_PRICES
on PRC_ITM_CODE = ITM_CODE;

/* Satılan məhsulları tap:
məhsul adı, satış miqdarı (STL_AMOUNT), satış qiyməti (STL_PRICE) */
select 
	ITM_CODE,
	ITM_NAME,
	STL_AMOUNT,
	STL_PRICE
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE;

/* Hər müştərinin etdiyi alışları göstər:
müştəri adı, invoice nömrəsi */
select 
	CLC_NAME,
	INV_FICHENO
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID;

/* Hər məhsul üzrə ümumi satış məbləğini tap:
məhsul adı, total satış = SUM(STL_AMOUNT * STL_PRICE) */
select 
	ITM_NAME,
	SUM(STL_AMOUNT * STL_PRICE) as total_sales
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
group by 
	ITM_NAME;

/* Ən çox satılan məhsulu tap (total satışa görə TOP 1) */
select top 1
	ITM_CODE,
	ITM_NAME,
	SUM(STL_AMOUNT * STL_PRICE) as total_sales
from CRD_ITEMS
left join OPR_STLINE 
on STL_ITMCODE = ITM_CODE
group by 
	ITM_CODE,
	ITM_NAME
order by total_sales desc;

/* Hər məhsul üçün son satış qiymətini (latest price) tap:
məhsul adı
son satış tarixi
son satış qiyməti */
with cte as(
select 
	ITM_NAME,
	INV_DATETIME,
	STL_PRICE,
	ROW_NUMBER() over(
	partition by ITM_NAME
	order by INV_DATETIME desc
	) as rn
from CRD_ITEMS
left join OPR_STLINE 
on STL_ITMCODE = ITM_CODE
left join OPR_INVOICE
on INV_FICHENO = STL_FICHENO
)
select 
	ITM_NAME,
	INV_DATETIME,
	STL_PRICE,
	rn
from cte
where rn = 1;

--OR
select 
	ITM_NAME,
	STL_PRICE,
	MAX(INV_DATETIME) as last_date
from CRD_ITEMS
left join OPR_STLINE 
on STL_ITMCODE = ITM_CODE
left join OPR_INVOICE
on INV_FICHENO = STL_FICHENO
group by 
	ITM_NAME, 
	STL_PRICE
order by last_date desc;

/* Ən çox alış edən TOP 3 müştərini tap:
müştəri adı
ümumi alış məbləği */
select top 3
	CLC_NAME,
	SUM(STL_AMOUNT * STL_PRICE) as total_alis
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_CODE
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
group by CLC_NAME
order by total_alis desc;

/* Elə məhsulları tap ki:
ümumi satış > 1000
amma satış sayı (invoice count) < 50 */
select 
	ITM_NAME,
	COUNT(distinct INV_FICHENO) as count_invoice,
	SUM(STL_AMOUNT * STL_PRICE) as total_price
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
left join OPR_INVOICE
on INV_FICHENO = STL_FICHENO
group by 
	ITM_NAME
having  SUM(STL_AMOUNT * STL_PRICE) > 1000 
and COUNT(distinct INV_FICHENO) < 50;

/* Hər gün üzrə satışları çıxart:
tarix (INV_DATETIME → date format)
ümumi satış məbləği
satılan invoice sayı */
select 
	ITM_NAME,
	cast(INV_DATETIME as date) as INV_DATETIME,
	SUM(STL_AMOUNT * STL_PRICE) as total_sales,
	COUNT(distinct INV_FICHENO) as count_invoice
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
left join OPR_INVOICE
on STL_FICHENO = INV_FICHENO
group by ITM_NAME, INV_DATETIME
order by total_sales desc;

/* Ən çox qaytarılan məhsulları tap:
məhsul adı
return sayı
return ümumi məbləği */
select 
	ITM_NAME,
	COUNT(STL_TRCODE) as return_sayı,
	SUM(STL_AMOUNT * STL_PRICE) as total_məbləğ
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
group by ITM_NAME;

/* Hər məhsul üçün:
məhsul adı
total satış
invoice count
average sale price */
select 
	ITM_NAME,
	SUM(STL_AMOUNT * STL_PRICE) as total_sales,
	COUNT(distinct INV_FICHENO) as count_invoice,
	SUM(STL_AMOUNT * STL_PRICE) * 1.0 / sum(STL_AMOUNT) as avg_sale_price
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
left join OPR_INVOICE
on INV_FICHENO = STL_FICHENO
group by ITM_NAME
having COUNT(distinct INV_FICHENO) > 3;

/* Hər məhsul üçün:
məhsul adı
total satış məbləği
satılan ümumi quantity
average unit price (weighted)
max price (ən baha satış qiyməti) */
select 
	ITM_NAME,
	STL_TRCODE,
	SUM(STL_AMOUNT * STL_PRICE) as total_sales,
	SUM(STL_AMOUNT) as total_amount,
	SUM(STL_AMOUNT * STL_PRICE) * 1.0 / SUM(STL_AMOUNT) as avg_price,
	MAX(STL_PRICE) as max_price
from CRD_ITEMS
left join OPR_STLINE 
on STL_ITMCODE = ITM_CODE
where STL_TRCODE = 1
group by 
	ITM_NAME,
	STL_TRCODE;

/* Hər müştəri (client) üçün çıxart:
client adı
total sales (ümumi alış məbləği)
invoice count
average order value
customer segment */
select 
	CLC_NAME,
	SUM(STL_AMOUNT * STL_PRICE) as total_sales,
	COUNT(distinct INV_FICHENO) as count_invoice,
	SUM(STL_AMOUNT * STL_PRICE) * 1.0 / COUNT(distinct INV_FICHENO) as avg_order_value,
	case
		when SUM(STL_AMOUNT * STL_PRICE) >= 5000 then 'VIP'
		when SUM(STL_AMOUNT * STL_PRICE) between 2000 and 4999 then 'GOLD'
		else 'NORMAL'
	end as segment
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_CODE
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
group by CLC_NAME;

/* '5449000189332' bu barcode gore mehsul tap 
nece defe satilib 
her cekine gore tap
umumi satis qiymeti 
ne vaxt satilib
mehsul qaytarib ya satilib STL_TRCODE*/
select 
	ITM_CODE,
	ITM_NAME,
	IBR_BARCODE,
	INV_FICHENO,
	STL_TRCODE,
	INV_DATETIME,
	SUM(STL_AMOUNT * STL_PRICE) as total_sales,
	COUNT(distinct INV_FICHENO) as count_invoice,
	case
	when STL_TRCODE = 1 then 1 else 0 end as satilib,
	case
	when STL_TRCODE <> 1 then 1 else 0 end as qaytarib
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
left join CRD_ITEMBARCODES
on IBR_ITM_CODE = ITM_CODE
left join OPR_INVOICE
on INV_FICHENO = STL_FICHENO
where IBR_BARCODE = '5449000189332'
group by 
	ITM_CODE,
	ITM_NAME,
	IBR_BARCODE,
	INV_FICHENO,
	STL_TRCODE,
	INV_DATETIME;


	

