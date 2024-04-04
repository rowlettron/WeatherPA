/*
 * DROP FUNCTION dbo.<function_name>
 */

IF  EXISTS (SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID('[dbo].<function_name>')
              AND type in ('AF','FN','FS','FT','IF','IS','TF'))
BEGIN
    DROP FUNCTION dbo.<function_name>
    PRINT '<<< DROPPED FUNCTION dbo.<function_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
go

CREATE FUNCTION dbo.<function_name> (<parameter list>)
RETURNS <return type>
AS

/*****************************************************************************
*  Object Type:	    Function
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
            FROM sys.objects
            WHERE object_id = OBJECT_ID('[dbo].<function_name>')
              AND type in ('AF','FN','FS','FT','IF','IS','TF'))
BEGIN
    PRINT '<<< CREATED FUNCTION dbo.<function_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING FUNCTION dbo.<function_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
go
