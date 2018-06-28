SELECT C.CountryName,
       CO.ContinentName,
	   COUNT(R.Id) AS [RiversCount],
	   ISNULL(SUM(R.Length),0) AS [TotalLength]  
FROM Countries AS C
LEFT JOIN Continents AS CO ON CO.ContinentCode = C.ContinentCode
LEFT JOIN CountriesRivers AS CR ON CR.CountryCode = C.CountryCode
LEFT JOIN Rivers AS R ON R.Id = CR.RiverId
GROUP BY C.CountryName,CO.ContinentName
ORDER  BY [RiversCount] DESC,[TotalLength] DESC,C.CountryName