use ww_etl;
DELIMITER $$

CREATE PROCEDURE ww_etl.`raise_error`(`errno` BIGINT UNSIGNED, `message` VARCHAR(256))
BEGIN
SIGNAL SQLSTATE
    'ERR0R'
SET
    MESSAGE_TEXT = `message`,
    MYSQL_ERRNO = `errno`;
END

/*
Example:

CALL ww_etl.raise(999, 'My Error Message');
*/


