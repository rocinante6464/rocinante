BEGIN TRANSACTION;
DROP TABLE RC_TODAY_INFO;
CREATE TABLE RC_TODAY_INFO (STATUS_DATETIME TEXT, SEASON TEXT, WEATHER TEXT, TEMPERAURE REAL, HUMIDITY REAL, UPDATE_DATE TEXT);
COMMIT;