import static java.lang.Integer.parseInt;

import java.util.Scanner;

import domaine.User;

public class Main {

	private static Scanner scanner = new Scanner(System.in);
	
	private static BackEnd backEnd;
	
	public static void main(String[] args){
		
		backEnd = new BackEnd();
		
		User connectedUser = null;
		int choice;	
				
		System.out.println("1 : Se connecter");
		System.out.println("2 : S'inscrire");
		
		choice = parseInt(scanner.nextLine());
		while(choice < 1 || choice > 2){
			System.out.println("Erreur. recommence !");
			choice = parseInt(scanner.nextLine());
		}
		
		switch(choice){
		case 1 : connectedUser = toConnect();
			break;
		case 2 : connectedUser = toRegister();
			break;
		}
				
		if(connectedUser != null){
			
		}
		
	}
	
	public static User toConnect(){
		User u = null;
		System.out.println("Connexion");
		System.out.println("Nom d'utilisateur :");
		String pseudo = scanner.nextLine();
		System.out.println("Mot de passe");
		String pwd = scanner.nextLine();
		
		//u = backend.getUser(pseudo, pwd);
		
		return u;
	}
	
	public static User toRegister(){
		User u = null;
		System.out.println("Inscription");
		System.out.println("Nom d'utilisateur :");
		String pseudo = scanner.nextLine();
		System.out.println("Mot de passe :");
		String pwd = scanner.nextLine();
		System.out.println("Email :");
		String email = scanner.nextLine();
		
		
		//u = backend.insertUser(pseudo, pwd, email);
		
		return u;
	}
	
}
