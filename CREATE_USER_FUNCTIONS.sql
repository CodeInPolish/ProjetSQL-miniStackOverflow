/***
//
// Views
//
***/

CREATE OR REPLACE VIEW ProjetSQL.questionsViewByDate(date, question_id, content, create_user, edit_date, edit_user, title) AS
SELECT qt.date, qt.question_id, qt.content, u1.pseudo AS create_user, qt.edit_date, u2.pseudo AS edit_user, qt.title
FROM ProjetSQL.questions qt, ProjetSQL.users u1, ProjetSQL.users u2
WHERE qt.user_id = u1.user_id AND qt.edit_user_id = u2.user_id AND qt.closed = FALSE
ORDER BY qt.date DESC;

CREATE OR REPLACE VIEW ProjetSQL.answersViewByDate AS
SELECT an.date, an.answer_no, u1.pseudo AS create_user
FROM ProjetSQL.answers an, ProjetSQL.users u1, ProjetSQL.users u2
WHERE an.user_id = u1.user_id
ORDER BY an.date DESC;

CREATE OR REPLACE VIEW ProjetSQL.questionsViewByTag(date, question_id, content, create_user, edit_date, edit_user, title, tag) AS
SELECT qt.date, qt.question_id, qt.content, u1.pseudo AS create_user, qt.edit_date, u2.pseudo AS edit_user, qt.title, t.name
FROM ProjetSQL.questions qt, ProjetSQL.users u1, ProjetSQL.users u2, ProjetSQL.tags t, ProjetSQL.tags_question tq
WHERE qt.user_id = u1.user_id AND qt.edit_user_id = u2.user_id AND qt.question_id=tq.question_id AND tq.tag_id = t.tag_id
ORDER BY qt.date DESC;


/****
//
// Procedures
//
***/

CREATE OR REPLACE FUNCTION ProjetSQL.connectUser(VARCHAR(20), VARCHAR(30)) RETURNS INTEGER AS $$
DECLARE
	_pseudo ALIAS FOR $1;
	_pwd ALIAS FOR $2;
	return_id INTEGER;
BEGIN
SELECT u.user_id INTO return_id 
FROM ProjetSQL.users u
WHERE u.user_pseudo = _pseudo AND u.password = _pwd;

RETURN return_id;
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


CREATE OR REPLACE FUNCTION ProjetSQL.AddTag(INTEGER, VARCHAR(10)) RETURNS boolean AS $$
DECLARE
	_question_id ALIAS FOR $1;
	_tag_name ALIAS FOR $2;
	tag_id INTEGER;
BEGIN
SELECT t.tag_id INTO tag_id FROM ProjetSQL.tags t WHERE t.name=_tag_name;
INSERT INTO ProjetSQL.tags_question(question_id, tag_id) VALUES (_question_id, _tag_id);
RETURN 0;
END;
$$LANGUAGE plpgsql;


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
