CREATE OR ALTER PROCEDURE TEAMS_MEMBERS @team VARCHAR(80)
AS
BEGIN
    DECLARE @list VARCHAR(MAX) = ''
    DECLARE @cont INT = 1
    DECLARE @total INT
    DECLARE @teamname VARCHAR(80)
    DECLARE @baselocation VARCHAR(80)
    DECLARE @totalops INT

    IF @team NOT IN (SELECT TeamType FROM TEAM)
    BEGIN
        PRINT 'The team type does not exist'
        RETURN
    END

    SELECT @total = MAX(TeamID) FROM TEAM

    WHILE @cont <= @total
    BEGIN
        SELECT @teamname = NameTeam,
               @baselocation = BaseLocation
        FROM TEAM
        WHERE TeamID = @cont
          AND TeamType = @team

        IF @teamname IS NOT NULL
        BEGIN
            SELECT @list = @list +
                '    ' + CAST(tm.NameMember AS CHAR(25)) +
                CAST(YEAR(GETDATE()) - tm.YearJoinTeam AS VARCHAR(5)) + CHAR(10)
            FROM TEAM_MEMBER tm
            JOIN TEAM t ON tm.TeamID = t.TeamID
            WHERE tm.TeamID = @cont
              AND t.TeamType = @team

            SELECT @totalops = COUNT(*)
            FROM TEAM_ASSIGNMENT
            WHERE TeamID = @cont

            IF @totalops IS NULL SET @totalops = 0

            PRINT 'TEAM: ' + @teamname
            PRINT 'BASE: ' + @baselocation
            PRINT REPLICATE('*', 35)
            PRINT @list
            PRINT '    Total operations: ' + CAST(@totalops AS VARCHAR)
            PRINT REPLICATE('-', 35)

            SET @list = ''
            SET @teamname = NULL
        END

        SET @cont = @cont + 1
    END
END
-- EXEC TEAMS_MEMBERS 'Logistics'