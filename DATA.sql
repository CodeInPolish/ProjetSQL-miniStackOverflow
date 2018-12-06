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

SELECT ProjetSQL.createUser('123@gmail.com','jeanjak','jeanjak');
SELECT ProjetSQL.createUser('1@gmail.com','jeanbul','jeanbul');
SELECT ProjetSQL.createUser('juju@gmail.com','buzz','buzz');
SELECT ProjetSQL.createUser('mamen@gmail.com','slope','slope');
SELECT ProjetSQL.createUser('hardbass@gmail.com','Squat','squat');
SELECT ProjetSQL.createUser('bak@gmail.com','jakjanu','jakjanu');
SELECT ProjetSQL.createUser('mam@gmail.com','slope','slop');
SELECT ProjetSQL.createUser('hardubass@gmail.com','Squat','uatya');
SELECT ProjetSQL.createUser('baluk@gmail.com','jakjanu','boozlok');

/**
Create Questions (title, content, user_id)
**/

SELECT ProjetSQL.createQuestion('t','content',1);
SELECT ProjetSQL.createQuestion('ti','content',2);
SELECT ProjetSQL.createQuestion('tit','content',3);
SELECT ProjetSQL.createQuestion('titl','content',4);
SELECT ProjetSQL.createQuestion('title','content',5);
SELECT ProjetSQL.createQuestion('title','conten',6);
SELECT ProjetSQL.createQuestion('title','conte',7);
SELECT ProjetSQL.createQuestion('title','cont',8);
SELECT ProjetSQL.createQuestion('title','con',9);
SELECT ProjetSQL.createQuestion('title','co',1);
SELECT ProjetSQL.createQuestion('title','c',2);

/**
Create Tags
**/
INSERT INTO ProjetSQL.tags(name) VALUES ('sql');
INSERT INTO ProjetSQL.tags(name) VALUES ('php');
INSERT INTO ProjetSQL.tags(name) VALUES ('c');
INSERT INTO ProjetSQL.tags(name) VALUES ('java');
INSERT INTO ProjetSQL.tags(name) VALUES ('css');

/**
Add Tags to questions (question_id, tag_name)
**/
SELECT ProjetSQL.AddTag(1,'sql');
SELECT ProjetSQL.AddTag(1,'php');
SELECT ProjetSQL.AddTag(1,'c');
SELECT ProjetSQL.AddTag(1,'java');
SELECT ProjetSQL.AddTag(1,'css');
SELECT ProjetSQL.AddTag(2,'sql');
SELECT ProjetSQL.AddTag(3,'sql');
SELECT ProjetSQL.AddTag(4,'php');
SELECT ProjetSQL.AddTag(5,'php');
SELECT ProjetSQL.AddTag(6,'c');
SELECT ProjetSQL.AddTag(7,'c');
SELECT ProjetSQL.AddTag(8,'java');
SELECT ProjetSQL.AddTag(9,'java');
SELECT ProjetSQL.AddTag(10,'css');
SELECT ProjetSQL.AddTag(11,'css');

/**
Create Answers (content, user_id, question_id)
**/
SELECT ProjetSQL.createAnswer('rep1-2',1,2);
SELECT ProjetSQL.createAnswer('rep1-3',1,3);
SELECT ProjetSQL.createAnswer('rep1-4',1,4);
SELECT ProjetSQL.createAnswer('rep1-5',1,5);
SELECT ProjetSQL.createAnswer('rep1-6',1,6);
SELECT ProjetSQL.createAnswer('rep1-7',1,7);
SELECT ProjetSQL.createAnswer('rep1-8',1,8);
SELECT ProjetSQL.createAnswer('rep1-9',1,9);
SELECT ProjetSQL.createAnswer('rep1-10',1,10);
SELECT ProjetSQL.createAnswer('rep1-11',1,11);

SELECT ProjetSQL.createAnswer('rep2-1',2,1);
SELECT ProjetSQL.createAnswer('rep2-3',2,3);
SELECT ProjetSQL.createAnswer('rep2-4',2,4);
SELECT ProjetSQL.createAnswer('rep2-5',2,5);
SELECT ProjetSQL.createAnswer('rep2-6',2,6);
SELECT ProjetSQL.createAnswer('rep2-7',2,7);
SELECT ProjetSQL.createAnswer('rep2-8',2,8);
SELECT ProjetSQL.createAnswer('rep2-9',2,9);
SELECT ProjetSQL.createAnswer('rep2-10',2,10);
SELECT ProjetSQL.createAnswer('rep2-11',2,11);

SELECT ProjetSQL.createAnswer('rep3-1',3,1);
SELECT ProjetSQL.createAnswer('rep3-2',3,2);
SELECT ProjetSQL.createAnswer('rep3-4',3,4);
SELECT ProjetSQL.createAnswer('rep3-5',3,5);
SELECT ProjetSQL.createAnswer('rep3-6',3,6);
SELECT ProjetSQL.createAnswer('rep3-7',3,7);
SELECT ProjetSQL.createAnswer('rep3-8',3,8);
SELECT ProjetSQL.createAnswer('rep3-9',3,9);
SELECT ProjetSQL.createAnswer('rep3-10',3,10);
SELECT ProjetSQL.createAnswer('rep3-11',3,11);

SELECT ProjetSQL.createAnswer('rep4-1',4,1);
SELECT ProjetSQL.createAnswer('rep4-2',4,2);
SELECT ProjetSQL.createAnswer('rep4-3',4,3);
SELECT ProjetSQL.createAnswer('rep4-5',4,5);
