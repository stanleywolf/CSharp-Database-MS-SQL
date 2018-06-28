
SELECT I.Name AS [Item],I.Price,I.MinLevel,GT.Name AS [Forbidden Game Type]
FROM Items AS I
 LEFT JOIN GameTypeForbiddenItems AS GTF ON GTF.ItemId = I.Id
 LEFT JOIN GameTypes AS GT ON GT.Id = GTF.GameTypeId
ORDER BY [Forbidden Game Type] DESC,[Item] ASC