USE <db>
GO

/*
 * DROP VIEW dbo.<view_name>
 */

IF  EXISTS (SELECT *
            FROM sys.views
            WHERE object_id = OBJECT_ID('[dbo].[<view_name>]'))
BEGIN
    DROP VIEW dbo.<view_name>
    PRINT '<<< DROPPED VIEW dbo.<view_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
GO

CREATE VIEW dbo.<view_name> 
AS

/*****************************************************************************
*  Object Type:     V
*  Function:
*  Created By:
*  Create Date:
*  Maintenance Log:
*  Date          Modified By             Description
*  ----------    --------------------    -------------------------------------
******************************************************************************/
SELECT ...
GO

IF  EXISTS (SELECT *
            FROM sys.views
            WHERE object_id = OBJECT_ID('[dbo].[<view_name>]'))
BEGIN
    PRINT '<<< CREATED VIEW dbo.<view_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.<view_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
GO


