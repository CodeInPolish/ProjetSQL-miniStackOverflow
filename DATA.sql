/**
SELECT qt.date, qt.question_id, qt.user_id, qt.edit_date, qt.edit_user_id, qt.title
FROM  ProjetSQL.questions qt 
WHERE qt.user_id = 1
UNION (SELECT qt.date, qt.question_id, qt.user_id, qt.edit_date, qt.edit_user, qt.title
	FROM  ProjetSQL.questions qt, ProjetSQL.answers an
	WHERE an.user_id = 1 AND an.question_id = qt.question_id)
**/

/**

Insert users (email,pseudo,password)

**/
/**
SELECT ProjetSQL.createUser('123@gmail.com','jeanjak','jeanjak');
SELECT ProjetSQL.createUser('1@gmail.com','jeanbul','jeanbul');
SELECT ProjetSQL.createUser('juju@gmail.com','buzz','buzz');
SELECT ProjetSQL.createUser('mamen@gmail.com','slope','slope');
SELECT ProjetSQL.createUser('hardbass@gmail.com','Squat','squat');
SELECT ProjetSQL.createUser('bak@gmail.com','jakjanu','jakjanu');
SELECT ProjetSQL.createUser('mam@gmail.com','slope','slop');
SELECT ProjetSQL.createUser('hardubass@gmail.com','Squat','uatya');
SELECT ProjetSQL.createUser('baluk@gmail.com','jakjanu','boozlok');
**/


