SELECT 
T1.offerId
, T1.date
, T1.nombre_dia
, T1.tipo_dia
, SUM(COALESCE(T2.Ingreso,0)) Ingreso
, SUM(COALESCE(T2.Cantidad_Vendidos,0)) Cantidad_Vendidos
, SUM(consumo_INTERNET) consumo_INTERNET
, SUM(T1.Consumo_Whatsapp) Consumo_Whatsapp 
, SUM(T1.Consumo_Facebook)   Consumo_Facebook
, SUM(T1.Consumo_Twitter)    Consumo_Twitter
, SUM(T1.Consumo_Instagram)  Consumo_Instagram
, SUM(T1.Consumo_Snapchat)   Consumo_Snapchat
, SUM(T1.Consumo_Youtube)    Consumo_Youtube
, SUM(T1.Consumo_ClaroVideo) Consumo_ClaroVideo
, SUM(T1.Consumo_Waze)       Consumo_Waze
, SUM(T1.Consumo_GoogleMaps) Consumo_GoogleMaps
, SUM(T1.Consumo_EasyTaxi)   Consumo_EasyTaxi
, SUM(T1.Consumo_AppTaxi)    Consumo_AppTaxi
, SUM(T1.Consumo_WAP) Consumo_WAP
, T1.tipoPaquete
FROM (
		SELECT
		edn.`date` 
		, edn.offerId
		, cc.nombre_dia
		, cc.tipo_dia
		, SUM(CASE WHEN edn.serviceID IN ('1','3','32101000','32101101') THEN edn.volume ELSE 0 END) Consumo_INTERNET
		, SUM(CASE WHEN edn.serviceID IN ('32101002','4','49') THEN edn.volume ELSE 0 END) Consumo_WAP
		, SUM(CASE WHEN edn.serviceID IN ('32101216') THEN edn.volume ELSE 0 END) Consumo_ClaroVideo
		, SUM(CASE WHEN edn.serviceID IN ('32101225','53') THEN edn.volume ELSE 0 END) Consumo_Whatsapp
		, SUM(CASE WHEN edn.serviceID IN ('32101281') THEN edn.volume ELSE 0 END) Consumo_Twitter
		, SUM(CASE WHEN edn.serviceID IN ('32101282') THEN edn.volume ELSE 0 END) Consumo_Facebook
		, SUM(CASE WHEN edn.serviceID IN ('32101283') THEN edn.volume ELSE 0 END) Consumo_Instagram
		, SUM(CASE WHEN edn.serviceID IN ('32101285') THEN edn.volume ELSE 0 END) Consumo_Waze
		, SUM(CASE WHEN edn.serviceID IN ('32101286') THEN edn.volume ELSE 0 END) Consumo_Snapchat
		, SUM(CASE WHEN edn.serviceID IN ('32101288') THEN edn.volume ELSE 0 END) Consumo_GoogleMaps
		, SUM(CASE WHEN edn.serviceID IN ('32101289') THEN edn.volume ELSE 0 END) Consumo_Youtube
		, SUM(CASE WHEN edn.serviceID IN ('32101324') THEN edn.volume ELSE 0 END) Consumo_EasyTaxi
		, SUM(CASE WHEN edn.serviceID IN ('32101362') THEN edn.volume ELSE 0 END) Consumo_AppTaxi
		, COALESCE(catOfer.type,'DESCONOCIDO') AS tipoPaquete
		FROM EMM_DETALLE_NAVEGACION edn
		INNER JOIN vwCalendarioColombia as cc
			ON edn.`date` = cc.fecha 
		LEFT OUTER JOIN CAT_OFFERID_PAQUETES as catOfer
			ON edn.offerID  = catOfer.offerId 
		WHERE edn.offerId <> 0 
		AND edn.offerId <> 520
		GROUP BY edn.`date` 
		, edn.offerId 
		, cc.nombre_dia
		, cc.tipo_dia
	) AS T1
LEFT OUTER JOIN (
					SELECT 
					STR_TO_DATE(eot.`date`,'%Y%m%d') AS fecha
					,eot.offerId
					, cc2.tipo_dia 
					, cc2.nombre_dia 
					, SUM(ABS(eot.value)) AS Ingreso
					, SUM(eot.quantity) AS Cantidad_Vendidos
					FROM EMM_OFFERID_TRENDS eot 
					INNER JOIN vwCalendarioColombia as cc2
						ON STR_TO_DATE(eot.`date`,'%Y%m%d') = cc2.fecha 
					WHERE eot.account  = 0
						AND eot.`date` >='20200616'
					GROUP BY STR_TO_DATE(eot.`date`,'%Y%m%d')
					, eot.offerId 
					, cc2.tipo_dia
					, cc2.nombre_dia 
				) AS T2
ON T1.offerId = T2.offerId
	AND T1.nombre_dia = T2.nombre_dia
	AND T1.tipo_dia = T2.tipo_dia
	AND T1.date = T2.fecha
WHERE T1.date <= '2020-10-31'
GROUP BY T1.date
, T1.offerId
, T1.nombre_dia
, T1.tipo_dia
, T1.tipoPaquete
;