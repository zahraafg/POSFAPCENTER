USE POSFAPCENTERPLUS;

--ERP SQL Task: Invoice, Return and Payment Details Extraction
SELECT 
	ITM_CODE,
	ITM_NAME,
	INV_FICHENO,
	INV_RTNFICHENO,
	INV_RTNPURPOSE, --qaytarma səbəbi
	INV_RTNCLNAME, --qaytaran müştəri adı
	INV_TRCODE,  --2 olarsa Qaytarma(return) olub, 1 olarsa Satış(sale)
	INV_DATETIME,
	STL_TRCODE,  --2 olarsa Qaytarma(return) olub, 1 olarsa Satış(sale)
	BNC_NAME,
	ACO_PAYTYPE,
	case 
	when STL_TRCODE = 1 then 'satilib'
	when STL_TRCODE = 2 then 'qaytarib'
	end as status
FROM CRD_ITEMS
LEFT JOIN OPR_STLINE
ON STL_ITMCODE = ITM_CODE
LEFT JOIN OPR_INVOICE
ON INV_FICHENO = STL_FICHENO
LEFT JOIN OPR_ACCOUNTS
ON ACO_INVFICHENO = INV_FICHENO
LEFT JOIN CRD_BANKCURRENCY
ON BNC_ID = ACO_BNCID
WHERE INV_FICHENO = '101001260209165125'
OR INV_RTNFICHENO = '101001260209165125';
--INV_RTNFICHECHECK 2 olarsa Qaytarma(return) olub, 1 olarsa Satış(sale)
