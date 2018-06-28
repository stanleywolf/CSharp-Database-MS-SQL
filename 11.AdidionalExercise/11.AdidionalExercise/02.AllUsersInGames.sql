
SELECT  G.Name AS Game,
		GT.Name AS [Game Type],
		U.Username,
		UG.Level,
		UG.Cash,
		CH.Name AS [Character]
FROM Games as G
JOIN GameTypes AS GT ON GT.Id = G.GameTypeId
JOIN UsersGames as UG ON UG.GameId = G.Id
JOIN Users AS U ON U.Id = UG.UserId
JOIN Characters AS CH ON CH.Id = UG.CharacterId
ORDER BY UG.Level DESC,U.Username ASC,G.Name ASC
