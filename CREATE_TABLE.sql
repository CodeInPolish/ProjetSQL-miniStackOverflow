/***************************
//
//		DROP SCHEMA
//
***************************/
DROP SCHEMA IF EXISTS ProjetSQL CASCADE;
/***************************
//
//		CREATE SCHEMA
//
***************************/
CREATE SCHEMA ProjetSQL;
/***************************
//
//		CREATE ENUM
//w
***************************/
CREATE TYPE ProjetSQL.status_rep AS ENUM('normal','advanced','expert');
/***************************
//
//		CREATE TABLE
//
***************************/
CREATE TABLE IF NOT EXISTS ProjetSQL.users(
	
	user_id SERIAL PRIMARY KEY,
	email VARCHAR(50) NOT NULL UNIQUE CHECK (email LIKE('%_@%_')),
	password VARCHAR(20) NOT NULL,
	pseudo VARCHAR(30) NOT NULL UNIQUE,
	rank ProjetSQL.status_rep NOT NULL DEFAULT 'normal',
	reputation INTEGER NOT NULL DEFAULT 0, 
	last_vote_date TIMESTAMP NULL CHECK (last_vote_date <= now()),
	closed BOOLEAN NOT NULL DEFAULT false	

);

CREATE TABLE IF NOT EXISTS ProjetSQL.questions(

	question_id SERIAL PRIMARY KEY,
	title VARCHAR(50) NOT NULL,
	content VARCHAR(200) NOT NULL,
	user_id INTEGER NOT NULL,
	date TIMESTAMP NOT NULL DEFAULT now(),
	edit_user_id INTEGER NULL DEFAULT NULL,
	edit_date TIMESTAMP NULL CHECK (edit_date >= date AND edit_date <= now()),
	closed BOOLEAN NOT NULL DEFAULT false,
	FOREIGN KEY (user_id) REFERENCES ProjetSQL.users(user_id),
	FOREIGN KEY (edit_user_id) REFERENCES ProjetSQL.users(user_id)

);

CREATE TABLE IF NOT EXISTS ProjetSQL.tags(

	tag_id SERIAL PRIMARY KEY,
	name VARCHAR(10) NOT NULL UNIQUE

);

CREATE TABLE IF NOT EXISTS ProjetSQL.tags_question(

	tq_id SERIAL PRIMARY KEY,
	tag_id INTEGER NOT NULL,
	question_id INTEGER NOT NULL,
	FOREIGN KEY (tag_id) REFERENCES ProjetSQL.tags(tag_id),
	FOREIGN KEY (question_id) REFERENCES ProjetSQL.questions(question_id)

);

CREATE TABLE IF NOT EXISTS ProjetSQL.answers(

	answer_id SERIAL PRIMARY KEY,
	answer_no INTEGER NULL,
	content VARCHAR(200) NOT NULL,
	date TIMESTAMP NOT NULL DEFAULT now(),
	user_id INTEGER NOT NULL,
	score INTEGER NOT NULL DEFAULT 0,
	question_id INTEGER NOT NULL,
	FOREIGN KEY (user_id) REFERENCES ProjetSQL.users(user_id),
	FOREIGN KEY (question_id) REFERENCES ProjetSQL.questions(question_id)

);

CREATE TABLE IF NOT EXISTS ProjetSQL.answer_votes(

		vote INTEGER NOT NULL,
		answer_id INTEGER NOT NULL,
		scoring_user_id INTEGER NOT NULL,
		FOREIGN KEY (answer_id) REFERENCES ProjetSQL.answers(answer_id),
		FOREIGN KEY (scoring_user_id) REFERENCES ProjetSQL.users(user_id),
		CONSTRAINT PK_evaluation PRIMARY KEY (answer_id, scoring_user_id)

);
