SELECT CO.ContinentName,
	  SUM(C.AreaInSqKm) as CountriesArea,
	  SUM(CAST(Population AS float)) AS CountriesPopulation
FROM Continents AS CO
JOIN Countries AS C ON C.ContinentCode = CO.ContinentCode
GROUP BY CO.ContinentName
ORDER BY CountriesPopulation DESC

--ALTER TABLE  Countries
--ADD IsDeleted BIT DEFAULT 0 NOT NULL