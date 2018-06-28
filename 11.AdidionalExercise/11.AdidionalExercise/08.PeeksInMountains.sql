SELECT P.PeakName,M.MountainRange,P.Elevation
FROM Peaks AS P
JOIN Mountains AS M ON M.Id = P.MountainId
ORDER BY P.Elevation DESC,P.PeakName