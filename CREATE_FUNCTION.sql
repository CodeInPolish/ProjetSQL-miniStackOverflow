/***************************
	//
	//		INSERTS
	//
	***************************/
	CREATE OR REPLACE FUNCTION ProjetSQL.insertUser(VARCHAR(30), VARCHAR(50), VARCHAR(20)) RETURNS RECORD AS $$
	DECLARE
		_pseudo ALIAS FOR $1;
		_email ALIAS FOR $2;
		_password ALIAS FOR $3;

	BEGIN
		INSERT INTO ProjetSQL.users (pseudo, email, password) VALUES (_pseudo, _email, _password);
		RETURN RECORD;
	END;
	$$ LANGUAGE plpgsql;


/***************************
	//
	//		SELECTS
	//
	***************************/
	CREATE OR REPLACE FUNCTION ProjetSQL.getUser(INTEGER) RETURNS RECORD AS $$
	DECLARE 
		_id ALIAS FOR $1;
	BEGIN
		SELECT * FROM ProjetSQL.users u WHERE u.user_id = _id;
		RETURN RECORD;
	END;
	$$ LANGUAGE plpgsql;


	CREATE OR REPLACE FUNCTION ProjetSQL.connectUser(VARCHAR(30), VARCHAR(20)) RETURNS RECORD AS $$
	DECLARE 
		_pseudo ALIAS FOR $1;
		_password ALIAS FOR $2;

	BEGIN
		SELECT * FROM ProjetSQL.users u WHERE u.pseudo = _pseudo AND u.password = _password;
		RETURN RECORD;
	END;
	$$ LANGUAGE plpgsql;
µ
	CREATE OR REPLACE FUNCTION ProjetSQL.checkPseudo(VARCHAR(30)) RETURNS INTEGER AS $$
	DECLARE 
		_pseudo ALIAS FOR $1;
		_id INTEGER :=0;
	BEGIN
		SELECT * FROM ProjetSQL.users u WHERE u.pseudo = _pseudo;
		RETURN id INTO _id;
	END;
	$$ LANGUAGE plpgsql;

	CREATE OR REPLACE FUNCTION ProjetSQL.checkMail(VARCHAR(50)) RETURNS INTEGER AS $$
	DECLARE 
		_email ALIAS FOR $1;
		_id INTEGER :=0;
	BEGIN
		SELECT * FROM ProjetSQL.users u WHERE u.email = _email;
	END;
	$$ LANGUAGE plpgsql;

