SELECT CU.CurrencyCode,
	   CU.Description AS Currency,
	   COUNT(C.CountryCode) AS NumberOfCountries
FROM Countries AS C
RIGHT JOIN Currencies AS CU ON CU.CurrencyCode = C.CurrencyCode
GROUP BY CU.CurrencyCode, CU.Description
ORDER BY NumberOfCountries DESC,CU.Description