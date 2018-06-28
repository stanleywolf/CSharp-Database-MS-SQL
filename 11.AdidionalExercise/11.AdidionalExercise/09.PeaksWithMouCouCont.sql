SELECT P.PeakName,
	   M.MountainRange AS Mountain,
	   c.CountryName,
	   CO.ContinentName
FROM Peaks AS P
JOIN Mountains AS M ON M.Id = P.MountainId
JOIN MountainsCountries AS MC ON MC.MountainId = M.Id
JOIN Countries AS C ON C.CountryCode = MC.CountryCode
JOIN Continents AS CO ON CO.ContinentCode = C.ContinentCode
ORDER BY P.PeakName,C.CountryName