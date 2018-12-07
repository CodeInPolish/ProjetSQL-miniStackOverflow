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
//
***************************/
CREATE TYPE ProjetSQL.status_rep AS ENUM('normal','advanced','expert');
/***************************
//
//		CREATE TABLES
//
***************************/
CREATE TABLE IF NOT EXISTS ProjetSQL.users(
	
	user_id SERIAL PRIMARY KEY,
	pseudo VARCHAR(30) NOT NULL UNIQUE,
	email VARCHAR(50) NOT NULL UNIQUE CHECK (email LIKE('%_@%_')),
	password VARCHAR(60) NOT NULL,
	rank ProjetSQL.status_rep NOT NULL DEFAULT 'normal',
	reputation INTEGER NOT NULL DEFAULT 0, 
	last_vote_date TIMESTAMP NULL CHECK (last_vote_date <= now()) DEFAULT NULL,
	closed BOOLEAN NOT NULL DEFAULT false	

);

CREATE TABLE IF NOT EXISTS ProjetSQL.questions(

	question_id SERIAL PRIMARY KEY,
	title VARCHAR(50) NOT NULL,
	content VARCHAR(200) NOT NULL,
	user_id INTEGER NOT NULL,
	date TIMESTAMP NOT NULL DEFAULT now(),
	edit_user_id INTEGER NULL DEFAULT NULL,
	edit_date TIMESTAMP NULL CHECK (edit_date >= date AND edit_date <= now()) DEFAULT NULL,
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
	content VARCHAR(200) NOT NULL,
	date TIMESTAMP NOT NULL DEFAULT now(),
	user_id INTEGER NOT NULL,
	score INTEGER NOT NULL DEFAULT 0,
	question_id INTEGER NOT NULL,
	answer_no INTEGER NULL,
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

/********************************
//
//
//  VIEWS
//		
//
*********************************/	
CREATE OR REPLACE VIEW projetsql.questionsviewbydate AS 
SELECT qt.date, qt.question_id, qt.content AS question, u1.pseudo AS create_user, qt.edit_date, NULL::varchar(30) AS edit_user, qt.title
FROM projetsql.questions qt, projetsql.users u1
WHERE qt.user_id = u1.user_id AND qt.edit_date IS NULL AND qt.closed = false
UNION
 SELECT qt.date, qt.question_id, qt.content AS question, u1.pseudo AS create_user, qt.edit_date, u2.pseudo AS edit_user, qt.title
 FROM projetsql.questions qt, projetsql.users u1, projetsql.users u2
 WHERE qt.user_id = u1.user_id AND u2.user_id = qt.edit_user_id AND qt.edit_date IS NOT NULL AND qt.closed = false
ORDER BY date DESC;

CREATE OR REPLACE VIEW ProjetSQL.questionsViewByTag(date, question_id, question, create_user, edit_date, edit_user, title, tag) AS
SELECT qt.date, qt.question_id, qt.content, u1.pseudo AS create_user, qt.edit_date, NULL::varchar(30) AS edit_user, qt.title, t.name
FROM ProjetSQL.questions qt, ProjetSQL.users u1, ProjetSQL.tags t, ProjetSQL.tags_question tq
WHERE qt.user_id = u1.user_id AND qt.edit_date IS NULL AND qt.question_id=tq.question_id AND tq.tag_id = t.tag_id AND qt.closed = FALSE
UNION(SELECT qt.date, qt.question_id, qt.content, u1.pseudo AS create_user, qt.edit_date, u2.pseudo AS edit_user, qt.title, t.name
	FROM ProjetSQL.questions qt, ProjetSQL.users u1, ProjetSQL.tags t, ProjetSQL.tags_question tq, ProjetSQL.users u2
	WHERE qt.user_id = u1.user_id AND qt.edit_user_id = u2.user_id AND qt.edit_date IS NULL AND 
	qt.question_id=tq.question_id AND tq.tag_id = t.tag_id AND qt.closed = FALSE)
ORDER BY date DESC;

CREATE OR REPLACE VIEW projetsql.answersviewbydate AS 
 SELECT DISTINCT an.date, an.answer_no, an.content, u1.pseudo AS create_user, an.score, an.question_id
 FROM projetsql.answers an, projetsql.users u1, projetsql.users u2
 WHERE an.user_id = u1.user_id
ORDER BY an.date DESC;

CREATE OR REPLACE VIEW projetsql.questionDetails AS 
SELECT an.date, an.answer_no AS answer_number, an.content AS answer, u1.pseudo AS create_user, an.question_id
FROM projetsql.answers an, projetsql.users u1, projetsql.users u2
WHERE an.user_id = u1.user_id
ORDER BY an.question_id, an.date DESC;

CREATE OR REPLACE VIEW projetsql.userHistory AS 
SELECT DISTINCT qt.date, qt.question_id, qt.content AS question, u1.pseudo AS create_user, qt.edit_date, NULL::varchar(30) AS edit_user, qt.title, an.user_id AS an_user_id
FROM projetsql.questions qt, projetsql.users u1, projetsql.answers an 
WHERE qt.user_id = u1.user_id AND qt.edit_date IS NULL AND qt.closed = false AND an.user_id = u1.user_id
UNION 
(SELECT DISTINCT qt.date, qt.question_id, qt.content AS question, u1.pseudo AS create_user, qt.edit_date, u2.pseudo AS edit_user, qt.title, an.user_id AS an_user_id
 FROM projetsql.questions qt, projetsql.users u1, projetsql.answers an, projetsql.users u2
 WHERE qt.user_id = u1.user_id AND u2.user_id = qt.edit_user_id AND qt.closed = false AND an.user_id = u1.user_id
 UNION 
 (SELECT DISTINCT qt.date, qt.question_id, qt.content AS question, u1.pseudo AS create_user, qt.edit_date, NULL::varchar(30) AS edit_user, qt.title, an.user_id AS an_user_id
  FROM projetsql.questions qt, projetsql.users u1, projetsql.answers an
  WHERE qt.user_id = u1.user_id AND qt.edit_date IS NULL AND qt.closed = false AND an.question_id = qt.question_id
  UNION
  (SELECT DISTINCT qt.date, qt.question_id, qt.content AS question, u1.pseudo AS create_user, qt.edit_date, u2.pseudo AS edit_user, qt.title, an.user_id AS an_user_id 
   FROM projetsql.questions qt, projetsql.users u1, projetsql.users u2, projetsql.answers an
   WHERE qt.user_id = u1.user_id AND u2.user_id = qt.edit_user_id AND qt.edit_date IS NOT NULL AND qt.closed = false AND an.question_id = qt.question_id
	)))
ORDER BY date DESC;

/********************************
//
//
//  TRIGGERS
//		
//
*********************************/

CREATE OR REPLACE FUNCTION ProjetSQL.update_answer_no() RETURNS TRIGGER AS $$
DECLARE
	_no INTEGER;
BEGIN
	_no := (SELECT COUNT(answer_id) FROM ProjetSQL.answers WHERE question_id = NEW.question_id);

	UPDATE ProjetSQL.answers SET answer_no = _no WHERE question_id = NEW.question_id AND answer_id = NEW.answer_id;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER answer_no_trigger AFTER INSERT ON ProjetSQL.answers FOR EACH ROW EXECUTE PROCEDURE ProjetSQL.update_answer_no();

/* TRIGGER TO CHECK IF WE HAVE TO UPDATE A USER RANK OR NOT */
CREATE OR REPLACE FUNCTION ProjetSQL.set_rank() RETURNS TRIGGER AS $$
DECLARE 
	_rank ProjetSQL.status_rep;
	_reputation INTEGER;
BEGIN
	_rank := (SELECT u.rank FROM ProjetSQL.users u WHERE u.user_id = OLD.user_id);
	_reputation := (SELECT u.reputation FROM ProjetSQL.users u WHERE u.user_id = OLD.user_id);

	IF(OLD.rank = 'normal' AND _reputation >= 50) THEN
		UPDATE ProjetSQL.users SET rank = 'advanced' WHERE user_id = OLD.user_id;
	END IF;

	IF(OLD.rank = 'advanced' AND _reputation >= 100) THEN
		UPDATE ProjetSQL.users SET rank = 'expert' WHERE user_id = OLD.user_id;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER up_rank_trigger AFTER UPDATE ON ProjetSQL.users FOR EACH ROW EXECUTE PROCEDURE ProjetSQL.set_rank();


/* TRIGGER TO MODIFY THE LAST_VOTE_DATE OF A USER + REPUTATION OF A USER AFTER INSERT ON answer_votes TABLE */
CREATE OR REPLACE FUNCTION ProjetSQL.set_vote_date_and_reputation() RETURNS TRIGGER AS $$
DECLARE 
	_scoring_user INTEGER;
	_vote INTEGER;
	_user_answer INTEGER;
BEGIN 
	_user_answer := (SELECT u.user_id FROM ProjetSQL.answers a LEFT OUTER JOIN ProjetSQL.users u ON a.user_id = u.user_id WHERE a.answer_id = NEW.answer_id);
	_scoring_user := NEW.scoring_user_id;
	_vote := NEW.vote;


	IF(_vote > 0) THEN 
		UPDATE ProjetSQL.users SET last_vote_date = now() WHERE user_id = _scoring_user;
		UPDATE ProjetSQL.users SET reputation = (reputation +5) WHERE user_id = _user_answer;
	ELSE 
		UPDATE ProjetSQL.users SET last_vote_date = now() WHERE user_id = _scoring_user;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/* THE TRIGGER */
CREATE TRIGGER vote_date_trigger AFTER INSERT ON ProjetSQL.answer_votes FOR EACH ROW EXECUTE PROCEDURE ProjetSQL.set_vote_date_and_reputation();

/* TRIGGER TO CHECK WETHER THE VOTE INSERTION CAN BE DONE, OR NOT */
CREATE OR REPLACE FUNCTION ProjetSQL.check_vote() RETURNS TRIGGER AS $$
DECLARE 
	_rank ProjetSQL.status_rep;
	_last_date TIMESTAMP;
	_vote INTEGER;
	_answer_user_id INTEGER;
BEGIN
	_answer_user_id := (SELECT a.user_id FROM ProjetSQL.answers a WHERE a.answer_id = NEW.answer_id);
	_rank := (SELECT u.rank FROM ProjetSQL.users u WHERE u.user_id = NEW.scoring_user_id);
	_last_date := (SELECT u.last_vote_date FROM ProjetSQL.users u WHERE u.user_id = NEW.scoring_user_id);
	_vote := NEW.vote;

	IF (_answer_user_id = NEW.scoring_user_id) 
		THEN RAISE EXCEPTION 'Tu ne peux voter pour ta réponse !'; 
	END IF;

	IF (_rank = 'normal') 
		THEN RAISE EXCEPTION 'Staut normal, tu ne peux pas voter !'; 
	END IF;

	IF (_rank = 'advanced' AND _vote < 0) 
		THEN RAISE EXCEPTION 'Statut avance, tu ne peux pas voter negativement !'; 
	END IF;

	IF (_rank = 'advanced' AND (now() - _last_date < INTERVAL '1 day')) 
		THEN  RAISE EXCEPTION 'Statut avance, tu ne peux voter que toute les 24h !'; 
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/* THE TRIGGER */
CREATE TRIGGER vote_trigger BEFORE INSERT ON ProjetSQL.answer_votes FOR EACH ROW EXECUTE PROCEDURE ProjetSQL.check_vote();

/********************************
//
//
//  Stored Procedures
//		
//
*********************************/

CREATE OR REPLACE FUNCTION ProjetSQL.edit_question(INTEGER, INTEGER, VARCHAR(50), VARCHAR(200)) RETURNS INTEGER AS $$
DECLARE
	_edit_user_id ALIAS FOR $1;
	_edited_question_id ALIAS FOR $2;
	_new_title ALIAS FOR $3;
	_new_content ALIAS FOR $4;
	_user_rank ProjetSQL.status_rep;
	_question_user_id INTEGER;
BEGIN

	_user_rank := (SELECT u.rank FROM ProjetSQL.users u WHERE u.user_id = _edit_user_id);
	_question_user_id := (SELECT q.user_id FROM ProjetSQL.questions q WHERE q.question_id = _edited_question_id);
	/* IF THE USER RANK IS 'normal' HE CAN ONLY EDIT HIS QUESTIONS */
	IF(_user_rank = 'normal' AND _edit_user_id != _question_user_id) 
		THEN RAISE EXCEPTION 'Statut normal, tu ne peux modifier que TES question !'; 
	END IF;
	/* IF TITLE AND CONTENT IS NULL WE DON T MODIFY THE QUESTION CONTENT AND TITLE ! */
	IF (_new_title IS NULL AND _new_content IS NULL) 
		THEN UPDATE ProjetSQL.questions SET edit_user_id = _edit_user_id, edit_date = now() WHERE question_id = _edited_question_id;
	/* IF THE TITLE IS NULL WE DON T MODIFY THE QUESTION TITLE ! */
	ELSE IF (_new_title IS NULL) 
		THEN UPDATE ProjetSQL.questions SET edit_user_id = _edit_user_id, content = _new_content, edit_date = now() WHERE question_id = _edited_question_id;
	/* IF THE CONTENT IS NULL WE DON T MODIFY THE QUESTION CONTENT ! */
		ELSE IF (_new_content IS NULL) 
			THEN UPDATE ProjetSQL.questions SET edit_user_id = _edit_user_id, title = _new_title, edit_date = now() WHERE question_id = _edited_question_id; 
		/* WE MODIFY BOTH CONTENT AND TITLE OF THE QUESTION ! */
		ELSE 
			UPDATE ProjetSQL.questions SET edit_user_id = _edit_user_id, content = _new_content, title = _new_title, edit_date = now() WHERE question_id = _edited_question_id;
		
		END IF;
		END IF;
		END IF;

	RETURN _edited_question_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.edit_answer(INTEGER, INTEGER, VARCHAR(200), INTEGER) RETURNS INTEGER AS $$
DECLARE
	_edited_answer_no ALIAS FOR $1;
	_edit_user_id ALIAS FOR $2;
	_new_content ALIAS FOR $3;
	_question_id ALIAS FOR $4;
	_user_rank ProjetSQL.status_rep;
	_answer_user_id INTEGER;
	_answer_id INTEGER;

BEGIN
	SELECT a.answer_id INTO _answer_id FROM ProjetSQL.answers a WHERE a.question_id = _question_id AND a.answer_no = _edited_answer_no;
	_user_rank := (SELECT u.rank FROM ProjetSQL.users u WHERE u.user_id = _edit_user_id);
	_answer_user_id :=  (SELECT a.user_id FROM ProjetSQL.answers a WHERE a.answer_id = _answer_id);

	IF(_new_content IS NULL) 
		THEN RAISE EXCEPTION 'Modification du contenu de la reponse par null interdit !';
	END IF;

	/* IF THE USER RANK IS 'normal' HE CAN ONLY EDIT HIS ANSWERS */
	IF(_user_rank = 'normal' AND _edit_user_id != _answer_user_id) 
		THEN RAISE EXCEPTION 'Statut normal, tu ne peux modifier que TES reponses';
	END IF;

	UPDATE ProjetSQL.answers SET content = _new_content WHERE answer_id = _answer_id;

	RETURN _answer_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION projetsql.vote(integer, integer, integer, integer)RETURNS integer AS $$
DECLARE 
	_scoring_user_id ALIAS FOR $1;
	_answer_no ALIAS FOR $2;
	_question_id ALIAS FOR $3;
	_vote ALIAS FOR $4;
	a_id INTEGER;
BEGIN
	SELECT a.answer_id INTO a_id FROM ProjetSQL.answers a WHERE a.question_id = _question_id AND a.answer_no = _answer_no;
	INSERT INTO ProjetSQL.answer_votes (vote, answer_id, scoring_user_id) VALUES (_vote, a_id, _scoring_user_id);
	RETURN _a_id+_scoring_user_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.close_question(INTEGER, INTEGER) RETURNS INTEGER AS $$
DECLARE
	_user_id ALIAS FOR $1;
	_question_id_to_close ALIAS FOR $2;
	_user_rank ProjetSQL.status_rep;
BEGIN 
	_user_rank := (SELECT u.rank FROM ProjetSQL.users u WHERE u.user_id = _user_id);
	/* ONLY EXPERT CAN CLOSE A QUESTION */
	IF(_user_rank != 'expert') 
		THEN RAISE EXCEPTION 'Tu n as pas le statut expert, tu ne peux pas cloturer une question';
	END IF;

	UPDATE ProjetSQL.questions SET closed = true WHERE question_id = _question_id_to_close;

	RETURN _question_id_to_close;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.connectUser(VARCHAR(20), VARCHAR(60)) RETURNS INTEGER AS $$
DECLARE
	_pseudo ALIAS FOR $1;
	_pwd ALIAS FOR $2;
	return_id INTEGER;
BEGIN
SELECT u.user_id INTO return_id 
FROM ProjetSQL.users u
WHERE u.pseudo = _pseudo AND u.password = _pwd;

RETURN return_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION projetsql.get_hash(VARCHAR(30))RETURNS VARCHAR(60) AS $$
DECLARE
	_pseudo ALIAS FOR $1;
	_hash VARCHAR(60);
BEGIN
	SELECT u.password INTO _hash FROM ProjetSQL.users u WHERE u.pseudo = _pseudo;
	RETURN _hash;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.CreateUser(VARCHAR(50), VARCHAR(20), VARCHAR(30)) RETURNS INTEGER AS $$
DECLARE 
	_email ALIAS FOR $1;
	_password ALIAS FOR $2;
	_pseudo ALIAS FOR $3;
	new_user_id INTEGER;
BEGIN
INSERT INTO ProjetSQL.users(email,password,pseudo) VALUES (_email, _password, _pseudo) RETURNING user_id INTO new_user_id;
RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.CreateQuestion(VARCHAR(50), VARCHAR(200), INTEGER) RETURNS INTEGER AS $$
DECLARE
	_title ALIAS FOR $1;
	_content ALIAS FOR $2;
	_user_id ALIAS FOR $3;
	new_qt_id INTEGER;
BEGIN
INSERT INTO ProjetSQL.questions(title,content,user_id) VALUES (_title,_content,_user_id) RETURNING question_id INTO new_qt_id;
RETURN new_qt_id;
END;
$$LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION projetsql.addtag(integer, VARCHAR(10)) RETURNS boolean AS $$
DECLARE
	_question_id ALIAS FOR $1;
	_tag_name ALIAS FOR $2;
	tag_id INTEGER;
BEGIN
SELECT t.tag_id INTO tag_id FROM ProjetSQL.tags t WHERE t.name=_tag_name;
INSERT INTO ProjetSQL.tags_question(question_id, tag_id) VALUES (_question_id, tag_id);
RETURN 0;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.CreateAnswer(VARCHAR(200), INTEGER, INTEGER) RETURNS INTEGER AS $$
DECLARE 
	_content ALIAS FOR $1;
	_user_id ALIAS FOR $2;
	_question_id ALIAS FOR $3;
	new_an_id INTEGER;
BEGIN
INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES (_content,_user_id,_question_id) RETURNING answer_id INTO new_an_id;
RETURN new_an_id;
END;
$$LANGUAGE plpgsql;

/********************************
//
//
//  Stored Procedures for Admin
//		
//
*********************************/

CREATE OR REPLACE FUNCTION ProjetSQL.delete_user(INTEGER) RETURNS INTEGER AS $$
DECLARE
	_user_to_delete ALIAS FOR $1;
BEGIN

	IF(SELECT u.user_id FROM ProjetSQL.users u WHERE u.user_id = _user_to_delete) IS NULL 
		THEN RAISE EXCEPTION 'Id inexistant !';
	END IF;

	UPDATE ProjetSQL.users SET closed = true WHERE user_id = _user_to_delete;
	RETURN _user_to_delete;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.upgrade_user(INTEGER, VARCHAR(15)) RETURNS INTEGER AS $$
DECLARE
	_user_to_up ALIAS FOR $1;
	_new_rank ALIAS FOR $2;
	_user_rank ProjetSQL.status_rep;
BEGIN
	_user_rank := (SELECT u.rank FROM ProjetSQL.users u WHERE u.user_id = _user_to_up);

	IF (_user_rank = 'expert' AND _new_rank = 'advanced') 
		THEN RAISE EXCEPTION 'Tu ne peux pas passer d expert a avance !';
	ELSE IF (_user_rank = 'expert' AND _new_rank = 'normal')
		THEN RAISE EXCEPTION 'Tu ne peux pas passer d expert a normal !';
	ELSE IF (_user_rank = 'advanced' AND _new_rank = 'normal')
		THEN RAISE EXCEPTION 'Tu ne peux pas passer d avance a normal !';

	END IF;
	END IF;
	END IF;

	IF (_new_rank = 'normal')
		THEN UPDATE ProjetSQL.users SET rank = 'normal' WHERE user_id = _user_to_up;
	ELSE IF (_new_rank = 'advanced')
		THEN UPDATE ProjetSQL.users SET rank = 'advanced' WHERE user_id = _user_to_up;
	ELSE IF (_new_rank = 'expert')
		THEN UPDATE ProjetSQL.users SET rank = 'expert' WHERE user_id = _user_to_up;

	END IF;
	END IF;
	END IF;

	RETURN _user_to_up;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.create_tag(VARCHAR(10)) RETURNS INTEGER AS $$
DECLARE
	_tag_name ALIAS FOR $1;
	_id_tag INTEGER;
BEGIN
	INSERT INTO ProjetSQL.tags(name) VALUES (_tag_name) RETURNING tag_id INTO _id_tag;
	RETURN _id_tag;
END;
$$ LANGUAGE plpgsql;


