
	/***************************
	//
	//		INSERTS TESTS
	//
	***************************/
	/* Inserts users ==> 3 users, 1 of each status */
	INSERT INTO ProjetSQL.users(email, password, pseudo) VALUES ('normal1@normal1.com', 'normal1', 'normal1');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('avance1@avance1.com', 'avance1','avance1','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('master1@master1.com', 'master1','master1', 'expert');

	/* id => 4 -> 17 */
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon1@bidon.com', 'bidon1','bidon1','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon2@bidon.com', 'bidon2','bidon2','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon3@bidon.com', 'bidon3','bidon3','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon4@bidon.com', 'bidon4','bidon4','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon5@bidon.com', 'bidon5','bidon5','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon6@bidon.com', 'bidon6','bidon6','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon7@bidon.com', 'bidon7','bidon7','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon8@bidon.com', 'bidon8','bidon8','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon9@bidon.com', 'bidon9','bidon9','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon10@bidon.com', 'bidon10','bidon10','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon11@bidon.com', 'bidon11','bidon11','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon12@bidon.com', 'bidon12','bidon12','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon13@bidon.com', 'bidon13','bidon13','advanced');
	INSERT INTO ProjetSQL.users(email, password, pseudo, rank) VALUES ('bidon14@bidon.com', 'bidon14','bidon14','advanced');

	/* Inserts questions ==> 3 questions, each user ask a question */
	INSERT INTO ProjetSQL.questions(title, content, user_id) VALUES ('Test Question 1', 'Test Question 1', 1);
	INSERT INTO ProjetSQL.questions(title, content, user_id) VALUES ('Test Question 2', 'Test Question 2', 2);
	INSERT INTO ProjetSQL.questions(title, content, user_id) VALUES ('Test Question 3', 'Test Question 3', 3);

	/* Inserts tags */ 
	INSERT INTO ProjetSQL.tags(name) VALUES('TEST');
	INSERT INTO ProjetSQL.tags(name) VALUES('SQL');
	INSERT INTO ProjetSQL.tags(name) VALUES('JAVA');
	INSERT INTO ProjetSQL.tags(name) VALUES('C');
	INSERT INTO ProjetSQL.tags(name) VALUES('PHP');

	/* Insert tags question */
	INSERT INTO ProjetSQL.tags_question(tag_id, question_id) VALUES (1, 1);
	INSERT INTO ProjetSQL.tags_question(tag_id, question_id) VALUES (1, 2);
	INSERT INTO ProjetSQL.tags_question(tag_id, question_id) VALUES (1, 3);

	/* Insert answers ==> 9 answers, each user answer the question */
	INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES ('Reponse 1 <=> Question 1', 1, 1);
	INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES ('Reponse 2 <=> Question 1', 2, 1);	
	INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES ('Reponse 3 <=> Question 1', 3, 1);

	INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES ('Reponse 1 <=> Question 2', 1, 2);
	INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES ('Reponse 2 <=> Question 2', 2, 2);	
	INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES ('Reponse 3 <=> Question 2', 3, 2);

	INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES ('Reponse 1 <=> Question 3', 1, 3);
	INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES ('Reponse 2 <=> Question 3', 2, 3);	
	INSERT INTO ProjetSQL.answers(content, user_id, question_id) VALUES ('Reponse 3 <=> Question 3', 3, 3);

	/* Inserts anwser votes */
	INSERT INTO ProjetSQL.answer_votes(vote, answer_id, scoring_user_id) VALUES(1, 1, 2);
	INSERT INTO ProjetSQL.answer_votes(vote, answer_id, scoring_user_id) VALUES(1, 1, 3);
	INSERT INTO ProjetSQL.answer_votes(vote, answer_id, scoring_user_id) VALUES(1, 2, 3);






