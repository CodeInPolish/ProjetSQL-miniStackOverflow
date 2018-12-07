import static java.lang.Integer.parseInt;

import java.util.List;
import java.util.Scanner;

import domaine.Question;
import domaine.User;

public class UserApp {

	private static Scanner scanner = new Scanner(System.in);
	
	private static BackEnd backEnd;
	private static User connectedUser;
	
	public static void main(String[] args){
		
		backEnd = new BackEnd();
		
		connectedUser = null;
		
		System.out.println("Application utilisateur de StackOverFlowIPL \n");
		
		while(connectedUser == null){
			registerMenu();
		}
		
		System.out.println("SUCCES : Tu es connecté !");
		while(true){
			mainMenu();
		}
	}
	
	public static void registerMenu(){
		System.out.println("************** MENU ****************");
		System.out.println("1 : Se connecter");
		System.out.println("2 : S'inscrire");
		System.out.println("Autre. Quitter application");
		System.out.println("************************************");
		
		int choice = parseInt(scanner.nextLine());
		
		switch(choice){
			case 1 : toConnect();
				break;
			case 2 : toRegister();
				break;
			default : return;
		}
	}	
	
	private static void mainMenu() {
		
		
		System.out.println("1. Introduire une nouvelle question");
		System.out.println("2. Visualiser mon historique");
		System.out.println("3. Visualiser les questions");
		System.out.println("4. Visualiser les questions liées à un tag");
		System.out.println("Autre. Quitter Apllication");
		
		int choice = parseInt(scanner.nextLine());
		//int choice = readTillBetween(1,4);
		
		switch(choice) {
			case 1: newQuestion(); 
				break;
			case 2: userHistory();
				break;
			case 3:  viewQuestions();
				break;
			case 4: viewQuestionsByTag(); 
				break;
			default : return;
		}
		
		
	}
	
	private static int readTillBetween(int min, int max) {
		int input = min-1;
		
		while(input<min&&input>=max) {
			try {
				input = scanner.nextInt();
				scanner.nextLine();
			}
			catch(Exception e){
				
			}
		}
		
		return input;
		
	}

	
	private static void questionMenu() {
		System.out.println("1. Introduire une nouvelle réponse");
		System.out.println("2. Voter pour une réponse");
		System.out.println("3. Editer question/réponse");
		System.out.println("4. Ajouter un tag");
		System.out.println("5. Clôturer la question");
		System.out.println("Autre. Quitter application");
		
		int choice = parseInt(scanner.nextLine());
		
		//int choice = readTillBetween(1,5);
		
		switch(choice) {
			case 1: newAnswer(); 
				break;
			case 2: vote();
				break;
			case 3:  editQuestionOrAnswer();
				break;
			case 4: addTagToQuestion(); 
				break;
			case 5: closeQuestion(); 
				break;
			default : return;
		}
	}
	
	
	public static void toConnect(){

		System.out.println("*****Connexion*****");
		System.out.println("Nom d'utilisateur :");
		String pseudo = scanner.nextLine();
		
		if(backEnd.userClosed(pseudo)){
			System.out.println("ERROR : Ton compte est cloture, tu ne peux plus te connecter !");
		}else if(backEnd.unknownUser(pseudo)){
			System.out.println("ERROR : Pseudo inconnu du systeme !");
		}else{
		
			System.out.println("Mot de passe");
			String pwd = scanner.nextLine();
			
			int userId = backEnd.connectUser(pseudo);
			
			String userPwd = backEnd.getPassWord(userId);
			
			if(!BCrypt.checkpw(pwd, userPwd)){
				System.out.println("ERROR : Pas le bon mot de passe !");
			}else{
				if(userId > 0){
					connectedUser = backEnd.getUser(userId);
				}
			}
		}
		
	}
	
	public static void toRegister(){
		System.out.println("*****Inscription*****");
		System.out.println("Pseudo :");
		String pseudo = scanner.nextLine();
		System.out.println("Mot de passe :");
		String pwd = scanner.nextLine();
		System.out.println("Email :");
		String email = scanner.nextLine();
		
		int userId = backEnd.insertUser(pseudo, pwd, email);
		
		if(userId > 0){
			connectedUser = backEnd.getUser(userId);
		}
	}
	
private static void newQuestion() {
		System.out.println("*****Nouvelle question*****");
		System.out.println("titre :");
		String title = scanner.nextLine();
		System.out.println("contenu :");
		String content = scanner.nextLine();
		
		int questionId = backEnd.insertQuestion(title, content, connectedUser.getId());
		System.out.println(questionId+" question id");
	}
	
	private static void selectQuestion(int index) {
		//si question!=null
		questionMenu();
	}
	
	private static void userHistory() {
		//afficher les questions
		//selectQuestion();
	}
	
	private static void viewQuestions() {
		System.out.println("*****Questions*****");
		List<Question> list = backEnd.getQuestions();
		
		if(!list.isEmpty()){
			System.out.println("ID | DATE | TITLE | CONTENT | USER | EDIT USER | EDIT DATE |");
			for(Question q : list){
				System.out.println(q.getId() + "|" + q.getDate() +"|" + q.getTitle() + "|" +q.getContent() + "|" + q.getUserId() + "|" + q.getEditUser() + "|" + q.getEditDate());
			}
		}
	}
	
	private static void viewQuestionsByTag() {
		
	}
	
	private static void newAnswer() {
		
	}
	
	private static void vote() {
		
	}
	
	private static void editQuestionOrAnswer() {
		
	}
	
	private static void addTagToQuestion() {
		
	}
	
	private static void closeQuestion() {
		
	}
}
