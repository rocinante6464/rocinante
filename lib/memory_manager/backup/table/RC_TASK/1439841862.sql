BEGIN TRANSACTION;
DROP TABLE RC_TASK;
CREATE TABLE RC_TASK (TASK_ID INTEGER PRIMARY KEY AUTOINCREMENT, ACTION_ID TEXT NOT NULL, PRIORITY INTEGER, START_YEAR INTEGER NOT NULL, START_MONTH INTEGER NOT NULL, START_DAY INTEGER NOT NULL, START_HOUR INTEGER NOT NULL, START_MINUTE INTEGER NOT NULL, EXEC_SPAN TEXT, TASK_STATE INTEGER NOT NULL, UPDATE_DATE TEXT);
INSERT INTO RC_TASK(TASK_ID,ACTION_ID,PRIORITY,START_YEAR,START_MONTH,START_DAY,START_HOUR,START_MINUTE,EXEC_SPAN,TASK_STATE,UPDATE_DATE) VALUES(1,"TweetHobby",9,2015,8,18,0,0,"h3",0,"2015/08/18 04:30:00");
COMMIT;
