SELECT U.Username,
	   G.Name,
	   MAX(CH.Name) AS [Character],
	   SUM(ItemStatistic.Strength) + MAX(GameTypeStatistic.Strength) + MAX(CharacterStatistic.Strength) AS Strenght,
	   SUM(ItemStatistic.Defence) + MAX(GameTypeStatistic.Defence) + MAX(CharacterStatistic.Defence) AS Defence,
	   SUM(ItemStatistic.Speed) + MAX(GameTypeStatistic.Speed) + MAX(CharacterStatistic.Speed) AS Speed,
	   SUM(ItemStatistic.Mind) + MAX(GameTypeStatistic.Mind) + MAX(CharacterStatistic.Mind) AS Mind,
	   SUM(ItemStatistic.Luck) + MAX(GameTypeStatistic.Luck) + MAX(CharacterStatistic.Luck) AS Luck

FROM Users AS U
JOIN UsersGames AS UG ON UG.UserId = U.Id
JOIN Games AS G ON G.Id = UG.GameId
JOIN Characters AS CH ON CH.Id = UG.CharacterId
JOIN GameTypes AS GT ON GT.Id = G.GameTypeId
JOIN UserGameItems AS UGI ON UGI.UserGameId = UG.Id
JOIN Items AS I ON I.Id = UGI.ItemId
JOIN [Statistics] AS ItemStatistic ON ItemStatistic.Id = I.StatisticId
JOIN [Statistics] AS GameTypeStatistic ON GameTypeStatistic.Id = GT.BonusStatsId
JOIN [Statistics] AS CharacterStatistic on CharacterStatistic.Id = CH.StatisticId
GROUP BY U.Username,G.Name
ORDER BY Strenght DESC,Defence DESC,Speed DESC,Mind DESC, Luck DESC
