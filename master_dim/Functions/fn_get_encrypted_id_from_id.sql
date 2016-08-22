CREATE DEFINER=`etl`@`%` FUNCTION `fn_get_encrypted_id_from_id`(in_id BIGINT) RETURNS varchar(150) CHARSET utf8
BEGIN
	DECLARE encrypted_id_out VARCHAR(150);
	SET encrypted_id_out = (SELECT encrypted_id FROM vendor_dw.lu_id_encoding WHERE id = in_id);
	RETURN encrypted_id_out;
END