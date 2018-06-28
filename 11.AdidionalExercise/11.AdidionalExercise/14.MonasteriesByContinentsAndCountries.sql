UPDATE Countries
SET CountryName = 'Burma'
WHERE CountryName = 'Myanmar'

INSERT INTO Monasteries(Name,CountryCode)
(SELECT 'Hanga Abbey', CountryCode
	FROM Countries AS C
	WHERE CountryName = 'Tanzania')

INSERT INTO Monasteries(Name,CountryCode)
(SELECT 'Myin-Tin-Daik', CountryCode
	FROM Countries AS C
	WHERE CountryName = 'Myanmar')

SELECT CO.ContinentName,
	   C.CountryName,
	   COUNT(M.Name) AS [MonasteriesCount]
FROM Countries AS C
 LEFT JOIN Continents AS CO ON CO.ContinentCode = C.ContinentCode
LEFT JOIN Monasteries AS M ON M.CountryCode = C.CountryCode
WHERE C.IsDeleted = 0
GROUP BY CO.ContinentName,C.CountryName
ORDER BY [MonasteriesCount] DESC, C.CountryName