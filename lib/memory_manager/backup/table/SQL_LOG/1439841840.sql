BEGIN TRANSACTION;
DROP TABLE SQL_LOG;
CREATE TABLE SQL_LOG(SQL_ID INTEGER PRIMARY KEY AUTOINCREMENT,EXECUTE_STATE INTEGER,MESSAGE TEXT,EXECUTE_SQL TEXT,PARAMS TEXT,EXECUTE_TIME TEXT);
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(1,1,"データの登録に失敗しました。エラーメッセージ：UNIQUE constraint failed: TASK_REPORT.TASK_ID","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,action_end_time,action_time,result_detail) VALUES (?,?,?,?,?,?,?);","1,ろしなんての遊び,2015-08-16T22:57:04+09:00,2,2015-08-16T22:57:04+09:00,1.676550925925926e-09,ろしなんてはゲームをして遊びました。","2015/08/16 22:57:04");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(2,0,"データの登録に成功しました！","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,action_end_time,action_time,result_detail) VALUES (?,?,?,?,?,?,?);","1,ろしなんての遊び,2015-08-16T22:57:50+09:00,2,2015-08-16T22:57:50+09:00,1.6722569444444445e-09,ろしなんてはゲームをして遊びました。","2015/08/16 22:57:50");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(3,0,"データの登録に成功しました！","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","2,趣味ツイート,2015/08/17 00:59:59,2,以下の内容でツイートを行いました。
「お腹すいたー！」,2015/08/17 01:00:00,8.018990601851852e-06","2015/08/17 01:00:00");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(4,-1,"データの登録に失敗しました。エラーメッセージ：UNIQUE constraint failed: TASK_REPORT.TASK_ID","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","2,趣味ツイート,2015/08/17 06:01:39,2,以下の内容でツイートを行いました。
「お腹すいたー！」,2015/08/17 06:01:41,2.3232977083333334e-05","2015/08/17 06:01:41");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(5,-1,"データの登録に失敗しました。エラーメッセージ：UNIQUE constraint failed: TASK_REPORT.TASK_ID","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","2,趣味ツイート,2015/08/17 06:07:10,2,以下の内容でツイートを行いました。
「お腹すいたー！」,2015/08/17 06:07:11,1.3869767418981482e-05","2015/08/17 06:07:11");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(6,0,"データの登録に成功しました！","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","3,趣味ツイート,2015/08/17 06:30:39,2,以下の内容でツイートを行いました。
「今日雨だよー...」,2015/08/17 06:30:39,7.391644837962963e-06","2015/08/17 06:30:39");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(7,0,"データの登録に成功しました！","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","4,趣味ツイート,2015/08/17 06:59:14,2,以下の内容でツイートを行いました。
「早起きしたら飯を食う！」,2015/08/17 06:59:15,7.529138414351852e-06","2015/08/17 06:59:15");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(8,0,"データの登録に成功しました！","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","5,趣味ツイート,2015/08/17 07:03:33,2,以下の内容でツイートを行いました。
「そろそろ会社行かねばのう」,2015/08/17 07:03:34,1.6207280821759258e-05","2015/08/17 07:03:34");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(9,0,"データの登録に成功しました！","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","6,趣味ツイート,2015/08/17 07:08:06,2,以下の内容でツイートを行いました。
「今日はとりあえずいろいろできた！」,2015/08/17 07:08:06,7.686728113425927e-06","2015/08/17 07:08:06");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(10,0,"データの登録に成功しました！","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","7,趣味ツイート,2015/08/18 03:14:02,2,以下の内容でツイートを行いました。
「おやすみー！」,2015/08/18 03:14:03,8.203521053240742e-06","2015/08/18 03:14:03");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(11,0,"データの登録に成功しました！","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","8,趣味ツイート,-4712/01/01 00:00:00,2,以下の内容でツイートを行いました。
「おやすみー！」,-4712/01/01 00:00:00,0.0","2015/08/18 03:35:43");
INSERT INTO SQL_LOG(SQL_ID,EXECUTE_STATE,MESSAGE,EXECUTE_SQL,PARAMS,EXECUTE_TIME) VALUES(12,0,"データの登録に成功しました！","INSERT INTO TASK_REPORT (task_id,action_name,action_start_time,result,result_detail,action_end_time,action_time) VALUES (?,?,?,?,?,?,?);","9,趣味ツイート,2015/08/18 03:44:37,2,以下の内容でツイートを行いました。
「おやすみー！」,2015/08/18 03:44:37,0.000215903","2015/08/18 03:44:37");
COMMIT;
