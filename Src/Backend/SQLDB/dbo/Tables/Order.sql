CREATE TABLE [dbo].[Order] (
    [OrderId]      INT     IDENTITY (1, 1) NOT NULL,
    [Status]       TINYINT NOT NULL,
    [OrderDate]    DATE    NOT NULL,
    [RequiredDate] DATE    NOT NULL,
    [ShippedDate]  DATE    NULL,
    CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED ([OrderId] ASC)
);

