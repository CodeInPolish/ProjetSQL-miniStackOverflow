/**
SELECT qt.date, qt.question_id, qt.user_id, qt.edit_date, qt.edit_user_id, qt.title
FROM  ProjetSQL.questions qt 
WHERE qt.user_id = 1
UNION (SELECT qt.date, qt.question_id, qt.user_id, qt.edit_date, qt.edit_user, qt.title
	FROM  ProjetSQL.questions qt, ProjetSQL.answers an
	WHERE an.user_id = 1 AND an.question_id = qt.question_id)
**/

/**

Insert users

**/
SELECT ProjetSQL.createUser('','','');