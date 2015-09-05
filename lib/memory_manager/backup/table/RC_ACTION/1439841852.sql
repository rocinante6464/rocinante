BEGIN TRANSACTION;
DROP TABLE RC_ACTION;
CREATE TABLE RC_ACTION (ACTION_ID TEXT PRIMARY KEY, ACTION_FILE TEXT, ACTION_TYPE INTEGER, ACTION_NAME TEXT, ACTIVE_FLG INTEGER, UPDATE_DATE TEXT);
INSERT INTO RC_ACTION(ACTION_ID,ACTION_FILE,ACTION_TYPE,ACTION_NAME,ACTIVE_FLG,UPDATE_DATE) VALUES("Play","play.rb",2,"ろしなんての遊び",1,"2015/08/18 03:00:00");
INSERT INTO RC_ACTION(ACTION_ID,ACTION_FILE,ACTION_TYPE,ACTION_NAME,ACTIVE_FLG,UPDATE_DATE) VALUES("TweetHobby","tweet_hobby.rb",2,"ろしなんての趣味ツイート",1,"2015/08/18 04:00:00");
COMMIT;
