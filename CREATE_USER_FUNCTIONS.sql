/***
//
// Views
//
***/

CREATE OR REPLACE VIEW ProjetSQL.questionsViewByDate(date, question_id, create_user, edit_date, edit_user, title) AS
SELECT qt.date, qt.question_id, u1.pseudo AS create_user, qt.edit_date, u2.pseudo AS edit_user, qt.title
FROM ProjetSQL.questions qt, ProjetSQL.users u1, ProjetSQL.users u2
WHERE qt.user_id = u1.user_id AND qt.edit_user_id = u2.user_id AND qt.closed = FALSE
ORDER BY qt.date DESC;

CREATE OR REPLACE VIEW ProjetSQL.answersViewByDate AS
SELECT an.date, an.answer_no, u1.pseudo AS create_user
FROM ProjetSQL.answers an, ProjetSQL.users u1, ProjetSQL.users u2
WHERE an.user_id = u1.user_id
ORDER BY an.date DESC;


/****
//
// Procedures
//
***/

CREATE OR REPLACE FUNCTION ProjetSQL.CreateUser(VARCHAR(50), VARCHAR(20), VARCHAR(30)) RETURNS boolean AS $$
DECLARE 
	_email ALIAS FOR $1;
	_password ALIAS FOR $2;
	_pseudo ALIAS FOR $3;
BEGIN
INSERT INTO ProjetSQL.users(email,password,pseudo) VALUES (_email, _password, _pseudo);
RETURN 0;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION ProjetSQL.CreateQuestion(VARCHAR(50), VARCHAR(200), INTEGER) RETURNS boolean AS $$
DECLARE
	_title ALIAS FOR $1;
	_content ALIAS FOR $2;
	_user_id ALIAS FOR $3;
	new_qt_id INTEGER;
BEGIN
INSERT INTO ProjetSQL.questions(title,content,user_id) VALUES (_title,_content,_user_id);
RETURN false;
END;
$$LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.EditQuestion(INTEGER, VARCHAR(50), VARCHAR(200), INTEGER) RETURNS INTEGER AS $$
DECLARE
	_question_id ALIAS FOR $1;
	_title ALIAS FOR $2;
	_content ALIAS FOR $3;
	_user_id ALIAS FOR $4;
	edited_qt_id INTEGER;
BEGIN

UPDATE ProjetSQL.questions qt
SET qt.content = _content, qt.title = _title
WHERE  qt.user_id = _user_id AND qt.question_id = _question_id;

RETURN qt.question_id INTO edited_qt_id;
END;
$$LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.AddTag(INTEGER, INTEGER) RETURNS boolean AS $$
DECLARE
	_question_id ALIAS FOR $1;
	_tag_id ALIAS FOR $2;
BEGIN

INSERT INTO ProjetSQL.tags_question(question_id, tag_id) VALUES (_question_id, _tag_id);
RETURN 0;
END;
$$LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.CreateAnswer(VARCHAR(200), INTEGER, INTEGER) RETURNS boolean AS $$
DECLARE 
	_content ALIAS FOR $1;
	_user_id ALIAS FOR $2;
	_question_id ALIAS FOR $3;
	an_id INTEGER;
BEGIN
INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES (_content,_user_id,_question_id);
RETURN false;
END;
$$LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ProjetSQL.EditAnswer(VARCHAR(200),INTEGER,INTEGER) RETURNS INTEGER AS $$
DECLARE
	_content ALIAS FOR $1;
	_answer_id ALIAS FOR $2;
	_user_id ALIAS FOR $3;
	editer_an_id INTEGER;
BEGIN
UPDATE ProjetSQL.answers an
SET an.content = _content
WHERE an.answer_id = _answer_id AND an.user_id = _user_id;

RETURN ProjetSQL.answer.answer_id INTO editer_an_id;
END;
$$LANGUAGE plpgsql;

/***
//
// SELECT qt.date, qt.question_id, qt.user_id, qt.edit_date, qt.edit_user_id, qt.title
// FROM  ProjetSQL.questions qt 
// WHERE qt.user_id = 1
// UNION (SELECT qt.date, qt.question_id, qt.user_id, qt.edit_date, qt.edit_user_id, qt.title
//	FROM  ProjetSQL.questions qt, ProjetSQL.answers an
//	WHERE an.user_id = 1 AND an.question_id = qt.question_id)
***/

/***
//
// Triggers
//
***/