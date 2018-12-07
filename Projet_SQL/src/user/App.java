package user;
import common.*;

import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

import static java.lang.Integer.parseInt;

public class App {
	
	/*
	 * trigger score réponse manquant
	 * 
	 */
	
	private static Scanner sc = new Scanner(System.in);
	

	public static void main(String[] args) {
		
		BackEnd bd = new BackEnd();
		
		int user_id = -1;

		while(user_id<0) {
			user_id = firstMenu(bd);
		}
		
		
		while(true) {
			mainMenu(bd, user_id);
		}
	}
	
	private static int firstMenu(BackEnd bd) {
		System.out.println("1. Se connecter");
		System.out.println("2. S'enregistrer");
		
		int choice = parseInt(sc.nextLine());
		
		switch(choice) {
			case 1: return loginMenu(bd); 
			case 2: registerMenu(bd);
				return -1;
			default : return -1;
		}
	}
	
	private static int loginMenu(BackEnd bd) {
		System.out.println("Entrez votre pseudo:");
		String pseudo = sc.nextLine();
		System.out.println("Entrez votre mot de passe:");
		String pwd = sc.nextLine();
		int user_id = bd.connectUser(pseudo, pwd);
		if(user_id>=0) {
			System.out.println("Connecté!");
		}
		return user_id;
		
	}
	
	private static void registerMenu(BackEnd bd) {
		System.out.println("Entrez un pseudo:");
		String pseudo = sc.nextLine();
		System.out.println("Entrez votre mail:");
		String mail = sc.nextLine();
		System.out.println("Entrez un mot de passe:");
		String pwd = sc.nextLine();
		System.out.println("Confirmez votre mot de passe:");
		String pwd2 = sc.nextLine();
		
		if(pwd.equals(pwd2)) {
			bd.createUser(pseudo, pwd, mail);
		}
		else {
			System.out.println("les mots de passe ne correspondent pas");
		}
		
	}
	
	private static void mainMenu(BackEnd bd, int user_id) {
		System.out.println("");
		System.out.println("1. Introduire une nouvelle question");
		System.out.println("2. Visualiser mon historique");
		System.out.println("3. Visualiser les questions");
		System.out.println("4. Visualiser les questions liées à un tag");
		System.out.println("Autre. Quitter Application");
		
		int choice = parseInt(sc.nextLine());
		
		switch(choice) {
			case 1: newQuestion(bd, user_id); 
				break;
			case 2: userHistory(bd, user_id);
				break;
			case 3:  viewQuestions(bd,user_id);
				break;
			case 4: viewQuestionsByTag(bd,user_id); 
				break;
			default : return;
		}
	}

	private static void newQuestion(BackEnd bd, int user_id) {
		System.out.println("Entrez un titre:");
		String title=sc.nextLine();
		System.out.println("Entrez la question:");
		String content=sc.nextLine();
		System.out.println("titre:"+title+" question:"+content);
		int question_id = bd.createQuestion(title, content, user_id);
		addTags(bd, user_id, question_id);
		selectQuestion(bd, user_id, question_id);
	}
	
	private static void addTags(BackEnd bd, int user_id, int question_id) {
		System.out.println("Ajouter tag? O/N");
		String ajout = sc.nextLine();
		if(ajout.equals("O")) {
			System.out.println("Pour quitter tapez 'N'");
			String tag = "O";
			printTags(bd.getTags());
			while(!tag.equals("N")) {
				tag = sc.nextLine();
				bd.addTag(question_id, tag);
			}
		}
	}

	
	private static void questionMenu(BackEnd bd, int user_id, int question_id) {
		System.out.println("");
		System.out.println("1. Introduire une nouvelle réponse");
		System.out.println("2. Voter pour une réponse");
		System.out.println("3. Editer question/réponse");
		System.out.println("4. Ajouter un tag");
		System.out.println("5. Clôturer la question");
		System.out.println("Autre. Quitter ce menu");
		
		int choice = parseInt(sc.nextLine());
		
		switch(choice) {
			case 1: newAnswer(bd,user_id,question_id); 
				break;
			case 2: vote(bd,user_id,question_id);
				break;
			case 3:  editQuestionOrAnswer(bd,user_id,question_id);
				break;
			case 4: addTags(bd,user_id,question_id); 
				break;
			case 5: closeQuestion(bd,user_id,question_id); 
				break;
			default : return;
		}
	}
	
	private static void selectQuestion(BackEnd bd, int user_id, int question_id) {
		printAnswers(bd.viewAnswers(question_id));
		questionMenu(bd,user_id,question_id);
	}
	
	private static void userHistory(BackEnd bd, int user_id) {
		printQuestions(bd.viewUserHistory(user_id));
		System.out.println("Sélectionnez une question:");
		int select = parseInt(sc.nextLine());
		selectQuestion(bd,user_id,select);
	}
	
	private static void viewQuestions(BackEnd bd, int user_id) {
		printQuestions(bd.viewQuestions());
		System.out.println("Sélectionnez une question:");
		int select = parseInt(sc.nextLine());
		selectQuestion(bd,user_id,select);
	}

	private static void viewQuestionsByTag(BackEnd bd, int user_id) {
		printTags(bd.getTags());
		System.out.println("Entrez un tag:");
		String tagName = sc.nextLine();
		printQuestions(bd.viewQuestionsByTag(tagName));
		System.out.println("Sélectionnez une question:");
		int select = parseInt(sc.nextLine());
		selectQuestion(bd,user_id,select);
	}
	
	private static void newAnswer(BackEnd bd, int user_id, int question_id) {
		System.out.println("Entrez votre réponse:");
		String rep = sc.nextLine();
		bd.createAnswer(rep, user_id, question_id);
	}
	
	private static void vote(BackEnd bd, int user_id, int question_id) {
		//afficher les réponses
		System.out.println("Indiquez le numéro de la réponse:");
		int answer_no = parseInt(sc.nextLine());
		System.out.println("Vote (1/-1):");
		int vote = parseInt(sc.nextLine());
		System.out.println("Vous avez voté pour la réponse n°"+answer_no+": "+vote);
	}
	
	private static void editQuestionOrAnswer(BackEnd bd, int user_id, int question_id) {
		System.out.println("1. Editer question");
		System.out.println("2. Editer réponse");
		System.out.println("Autre. Sortir de ce menu");
		int choice = parseInt(sc.nextLine());
		switch(choice) {
			case 1: editQuestion(bd,user_id,question_id);
				break;
			case 2: editAnswer(bd,user_id,question_id);
				break;
			default:
				break;
		}
	}
	
	private static void editQuestion(BackEnd bd, int user_id, int question_id) {
		//print question again
		System.out.println("Entrez un titre:");
		String title=sc.nextLine();
		System.out.println("Entrez la question:");
		String content=sc.nextLine();
		System.out.println("titre:"+title+" question:"+content);
		bd.editQuestion(title, content, user_id,question_id);
	}
	
	private static void editAnswer(BackEnd bd, int user_id, int question_id) {
		printAnswers(bd.viewAnswers(question_id));
		System.out.println("Indiquez le numéro de la réponse:");
		int answer_no = parseInt(sc.nextLine());
		System.out.println("Entrez votre réponse:");
		String data = sc.nextLine();
		bd.editAnswer(data, user_id, question_id, answer_no);
	}
	
	private static void closeQuestion(BackEnd bd, int user_id, int question_id) {
		bd.closeQuestion(user_id, question_id);
	}
	
	private static void printQuestions(ResultSet rs) {
		try {
			System.out.println("");
			ResultSetMetaData rsmd = rs.getMetaData();
			System.out.print("  "+rsmd.getColumnName(1)+"  ");
			System.out.print("|  "+rsmd.getColumnName(2)+"  ");
			System.out.print("|  "+rsmd.getColumnName(3)+"  ");
			System.out.print("|  "+rsmd.getColumnName(4)+"  ");
			System.out.print("|  "+rsmd.getColumnName(5)+"  ");
			System.out.print("|  "+rsmd.getColumnName(6)+"  ");
			System.out.println("|  "+rsmd.getColumnName(7));
			while(rs.next()) {
				System.out.print(" "+rs.getTimestamp(1)+" ");
				System.out.print("| "+rs.getString(2)+" ");
				System.out.print("| "+rs.getString(3)+" ");
				System.out.print("| "+rs.getString(4)+" ");
				System.out.print("| "+rs.getString(5)+" ");
				System.out.print("| "+rs.getString(6)+" ");
				System.out.println("| "+rs.getString(7));
			}
		}
		catch(Exception e) {
		}
	}
	
	private static void printAnswers(ResultSet rs) {
		try {
			System.out.println("");
			ResultSetMetaData rsmd = rs.getMetaData();
			System.out.print("  "+rsmd.getColumnName(1)+"  ");
			System.out.print("|  "+rsmd.getColumnName(2)+"  ");
			System.out.print("|  "+rsmd.getColumnName(3)+"  ");
			System.out.print("|  "+rsmd.getColumnName(4)+"  ");
			System.out.println("|  "+rsmd.getColumnName(5));
			while(rs.next()) {
				System.out.print(" "+rs.getTimestamp(1)+" ");
				System.out.print("| "+rs.getInt(2)+" ");
				System.out.print("| "+rs.getString(3)+" ");
				System.out.print("| "+rs.getString(4)+" ");
				System.out.println("| "+rs.getInt(5));
			}
		}
		catch(Exception e) {
		}
	}
	
	private static void printTags(ResultSet rs) {
		try {
			System.out.println("");
			while(rs.next()) {
				System.out.println(" "+rs.getString(1)+" ");
			}
		}
		catch(Exception e) {
		}
	}
}
