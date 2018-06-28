

SELECT U.Username,
	   G.Name,
	   COUNT(I.Id) AS [Items Count],
	   SUM(I.Price) AS [Items Price]
FROM Users AS U
JOIN UsersGames AS UG ON UG.UserId = U.Id
JOIN UserGameItems AS UGI ON UGI.UserGameId = UG.Id
JOIN Items AS I ON I.Id = UGI.ItemId
JOIN Games AS G ON G.Id = UG.GameId
GROUP BY U.Username,G.Name
HAVING COUNT(I.Id) >= 10
ORDER BY [Items Count] DESC,[Items Price] DESC,U.Username ASC