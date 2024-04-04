
/*
 * DROP TRIGGER dbo.<trigger_name>
 */

IF  EXISTS (SELECT *
            FROM sys.triggers
            WHERE object_id = OBJECT_ID('[dbo].[<trigger_name>]'))
BEGIN
    DROP TRIGGER dbo.<trigger_name>
    PRINT '<<< DROPPED TRIGGER dbo.<trigger_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
go

CREATE TRIGGER dbo.<trigger_name> ON dbo.<table_name> FOR <INSERT>, <UPDATE>, <DELETE> AS
AS

/*****************************************************************************
*  Object Type:	    TR
*  Function:
*  Created By:
*  Create Date:
*  Input:
*  Output:
*  Maintenance Log:
*  Date          Modified By             Description
*  ----------    --------------------    -------------------------------------
******************************************************************************/
BEGIN
SQL_statements
END
go

IF  EXISTS (SELECT *
            FROM sys.triggers
            WHERE object_id = OBJECT_ID('[dbo].[<trigger_name>]'))
BEGIN
    PRINT '<<< CREATED TRIGGER dbo.<trigger_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING TRIGGER dbo.<trigger_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
go

EXEC sys.sp_addextendedproperty @name=N'MS_Description',
                                @value=N'<trigger description>' ,
                                @level0type=N'SCHEMA',
                                @level0name=N'dbo',
                                @level1type=N'TABLE',
                                @level1name=N'<table_name>',
                                @level2type=N'TRIGGER',
                                @level2name=N'<trigger_name>'
go


