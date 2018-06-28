WITH CTE_AverageStats(AverageMind, AverageLuck,AverageSpeed)AS
(
	SELECT AVG(Mind),AVG(Luck),AVG(Speed)
	 FROM [Statistics]
)
SELECT I.Name, I.Price,I.MinLevel,
	   S.Strength,
	   S.Defence,
	   S.Speed,
	   S.Luck,
	   S.Mind
FROM Items AS I
JOIN [Statistics] AS S ON S.Id = I.StatisticId
WHERE S.Mind > (SELECT AverageMind FROM CTE_AverageStats) AND
	  S.Luck > (SELECT AverageLuck FROM CTE_AverageStats) AND
	  S.Speed > (SELECT AverageSpeed FROM CTE_AverageStats) 