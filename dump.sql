CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL, 
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);
INSERT INTO alembic_version VALUES('fbe879b2b87b');
CREATE TABLE user (
	id INTEGER NOT NULL, 
	username VARCHAR(64) NOT NULL, 
	email VARCHAR(120) NOT NULL, 
	password_hash VARCHAR(256), about_me VARCHAR(140), last_seen DATETIME, last_message_read_time DATETIME, token VARCHAR(32), token_expiration DATETIME, 
	PRIMARY KEY (id)
);
INSERT INTO user VALUES(1,'Silvan','r.silvan@gmx.net','scrypt:32768:8:1$EAK16AzoSnLgGL5Y$923eb0c82bc7d898b07c6720e87758e5088bce4e74ea6e8d77fa4b91b469c348c3a78dfa14366bcf63a3caf62e0a8e700fc66c0d4f1abe853a12d5b46b8b9c29',NULL,'2024-09-17 11:45:19.761548','2024-09-16 15:15:34.714187',NULL,NULL);
CREATE TABLE post (
	id INTEGER NOT NULL, 
	body VARCHAR(140) NOT NULL, 
	timestamp DATETIME NOT NULL, 
	user_id INTEGER NOT NULL, language VARCHAR(5), image_filename VARCHAR(128), 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES user (id)
);
INSERT INTO post VALUES(24,'test19','2024-09-16 14:32:13.405348',1,'fr','SanSalvatore.jpg');
INSERT INTO post VALUES(25,'test20','2024-09-16 15:12:21.891808',1,'fr','IMG_3209.jpg');
CREATE TABLE followers (
	follower_id INTEGER NOT NULL, 
	followed_id INTEGER NOT NULL, 
	PRIMARY KEY (follower_id, followed_id), 
	FOREIGN KEY(followed_id) REFERENCES user (id), 
	FOREIGN KEY(follower_id) REFERENCES user (id)
);
CREATE TABLE message (
	id INTEGER NOT NULL, 
	sender_id INTEGER NOT NULL, 
	recipient_id INTEGER NOT NULL, 
	body VARCHAR(140) NOT NULL, 
	timestamp DATETIME NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(recipient_id) REFERENCES user (id), 
	FOREIGN KEY(sender_id) REFERENCES user (id)
);
CREATE TABLE notification (
	id INTEGER NOT NULL, 
	name VARCHAR(128) NOT NULL, 
	user_id INTEGER NOT NULL, 
	timestamp FLOAT NOT NULL, 
	payload_json TEXT NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES user (id)
);
INSERT INTO notification VALUES(1,'unread_message_count',1,1726499734.7323815822,'0');
CREATE TABLE task (
	id VARCHAR(36) NOT NULL, 
	name VARCHAR(128) NOT NULL, 
	description VARCHAR(128), 
	user_id INTEGER NOT NULL, 
	complete BOOLEAN NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES user (id)
);
CREATE UNIQUE INDEX ix_user_email ON user (email);
CREATE UNIQUE INDEX ix_user_username ON user (username);
CREATE INDEX ix_post_timestamp ON post (timestamp);
CREATE INDEX ix_post_user_id ON post (user_id);
CREATE INDEX ix_message_recipient_id ON message (recipient_id);
CREATE INDEX ix_message_sender_id ON message (sender_id);
CREATE INDEX ix_message_timestamp ON message (timestamp);
CREATE INDEX ix_notification_name ON notification (name);
CREATE INDEX ix_notification_timestamp ON notification (timestamp);
CREATE INDEX ix_notification_user_id ON notification (user_id);
CREATE INDEX ix_task_name ON task (name);
CREATE UNIQUE INDEX ix_user_token ON user (token);
