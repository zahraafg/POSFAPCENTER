use POSFAPCENTERPLUS;

-- Hər müştərinin ümumi alış məbləğini tap
select 
	c.CLC_NAME,
	SUM(s.STL_AMOUNT * s.STL_PRICE) total_alis
from CRD_CLIENTS c
left join OPR_INVOICE i
on i.INV_CLCODE = c.CLC_ID
left join OPR_STLINE s
on s.STL_FICHENO = i.INV_FICHENO
group by c.CLC_NAME
order by total_alis desc;

-- Ən çox gəlir gətirən 5 məhsulu tap
select top 5
	i.ITM_CODE,
	i.ITM_NAME,
	isnull(SUM(s.STL_AMOUNT * s.STL_PRICE), 0) as total_price
from CRD_ITEMS i
left join OPR_STLINE s
on s.STL_ITMCODE = i.ITM_CODE
group by i.ITM_CODE, i.ITM_NAME
order by total_price desc;

-- Heç alış etməmiş müştəriləri tap
select 
	c.CLC_NAME,
	i.INV_FICHENO
from CRD_CLIENTS c
left join OPR_INVOICE i
on i.INV_CLCODE = c.CLC_ID
where i.INV_FICHENO is null;

-- Hər terminal üzrə neçə satış olub
select 
	b.POS_TERMINAL,
	COUNT(a.ACO_TERMINAL) as count_satis
from CRD_BANKTERMINAL b
left join OPR_ACCOUNTS a
on a.ACO_TERMINAL = b.POS_TERMINAL
group by b.POS_TERMINAL
order by count_satis desc;

-- Hər müştərinin ən bahalı alışını tap
with cte as (
select 
	c.CLC_NAME,
	i.INV_FICHENO,
	SUM(s.STL_AMOUNT * s.STL_PRICE) as total_price
from CRD_CLIENTS c
left join OPR_INVOICE i
on i.INV_CLCODE = c.CLC_ID
left join OPR_STLINE s
on s.STL_FICHENO = i.INV_FICHENO
group by 
	c.CLC_NAME,
	i.INV_FICHENO
)
select 
	CLC_NAME,
	MAX(total_price) as max_purchase
from cte
group by CLC_NAME
order by max_purchase desc;

-- Hər invoice daxilində ən bahalı məhsulu tap
with cte as(
select 
	INV_FICHENO,
	ITM_NAME,
	SUM(STL_AMOUNT * STL_PRICE) as total_price,
	ROW_NUMBER() over(
	partition by INV_FICHENO
	order by SUM(STL_AMOUNT * STL_PRICE) desc
) as rn
from OPR_INVOICE
left join OPR_STLINE
on STL_FICHENO = INV_FICHENO
left join CRD_ITEMS
on ITM_CODE = STL_ITMCODE
group by 
	INV_FICHENO, 
	ITM_NAME
)
select 
	INV_FICHENO
	ITM_NAME,
	total_price
from cte
where rn = 1;

-- Ən çox satılan məhsul qrupunu tap
select 
	GRP_NAME,
	SUM(STL_AMOUNT * STL_PRICE) as total_price
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
left join CRD_ITEMGROUPS
on GRP_ID = ITM_GRPID
group by GRP_NAME
order by total_price desc;

-- Hər müştərinin ən son alışını tap
with cte as(
select 
	CLC_NAME,
	INV_FICHENO,
	INV_DATETIME,
	ROW_NUMBER() over(
	partition by CLC_NAME
	order by INV_DATETIME desc
) as rn
from CRD_CLIENTS
left join OPR_INVOICE
on INV_CLCODE = CLC_ID
)
select 
	CLC_NAME,
	INV_FICHENO,
	INV_DATETIME
from cte
where rn = 1;

-- Hər məhsulun ən son satıldığı tarix
with cte as(
select 
	ITM_NAME,
	INV_DATETIME,
	ROW_NUMBER() over(
	partition by ITM_NAME
	order by INV_DATETIME desc
	) as rn
from CRD_ITEMS
left join OPR_STLINE
on STL_ITMCODE = ITM_CODE
join OPR_INVOICE
on INV_FICHENO = STL_FICHENO
)
select 
	ITM_NAME,
	INV_DATETIME
from cte
where rn = 1;
