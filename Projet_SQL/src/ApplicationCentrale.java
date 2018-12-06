import static java.lang.Integer.parseInt;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Scanner;

import domaine.Answer;
import domaine.Question;
import domaine.Tag;
import domaine.User;

public class ApplicationCentrale {

	private static Scanner scanner = new Scanner(System.in);
	private static BackEnd backEnd;
	
	private static int TAILLE_TAGS = 10;

	
	public static void main(String[] args) throws IOException{
		
		backEnd = new BackEnd();
		
		menuDisplay();
		
		int choice = parseInt(scanner.nextLine());
		
		while((choice <= 6) && (choice >= 1)){
			
			switch(choice){
				case 1 : removeUser();
					break;
				case 2 : upgradeUser();
					break;
				case 3 : userHistory();
					break;
				case 4 : addTag();
					break;
				case 5 : usersDisplay();
					break;
				case 6 : tagsDisplay();
					break;
				default : return;
			}
			
			menuDisplay();
			choice = parseInt(scanner.nextLine());
		}
		System.out.println("Au revoir ! :) ");
		
	}
	
	private static void menuDisplay() throws IOException{
		System.out.println("Application Admin de StackOverflowIPL \n");
		System.out.println("****************** MENU ****************** ");
		System.out.println("1. Desactiver un compte utilisateur (ok) ");
		System.out.println("2. Ameliorer le statut d'un utilisateur (ok) ");
		System.out.println("3. Consulter historique utilisateur (ok)");
		System.out.println("4. Ajouter un tag (ok) ");
		System.out.println("5. Visualiser les utilisateurs (ok) ");
		System.out.println("6. Visualiser les tags (ok) \n");
		System.out.println("Autre. Quitter application \n");
		System.out.println("****************************************** ");
	}

	private static void userHistory() throws IOException {
		
		System.out.println("Visualiser l'historique d'un utilisateur ");
		usersDisplay();
		System.out.println("Quel est l'id de l'utilisateur dont tu veux regarder l'historique ? ");
		int userToCheckHistory = parseInt(scanner.nextLine());
		
		System.out.println("Date 1 (YYYY-MM-DD): ");
		Timestamp d1 = Timestamp.valueOf(scanner.nextLine()+" 00:00:00");
		
		System.out.println("Date 2 (YYYY-MM-DD): ");
		Timestamp d2 = Timestamp.valueOf(scanner.nextLine()+ " 23:59:59");
		
		List<Question> questionsList = backEnd.getQuestionFromUser(userToCheckHistory, d1, d2);
		if(questionsList.isEmpty()){
			System.out.println("Aucune question ! \n");
		}else {
			historicQuestionsDisplay(questionsList);
		}
		
		
		List<Answer> answersList = backEnd.getAnswersFromUser(userToCheckHistory, d1, d2);
		
		if(answersList.isEmpty()){
			System.out.println("Aucune reponse !");
		}else{
			historicAnswersDisplay(answersList);
		}
		System.out.println("");
	}

	private static void historicAnswersDisplay(List<Answer> list) throws IOException{

		System.out.println("REPONSES DE L'UTILISATEUR :");
		System.out.println("ID| SCORE |     CONTENT     | QUESTION ID |  DATE  | ");
		for(Answer a : list){
			System.out.println(a.getId() + "|" + a.getScore() + "|" + a.getContent() + "|" + a.getQuestionId() + "|" +  a.getDate() + "");
		}
		System.out.println("");
	}

	private static void historicQuestionsDisplay(List<Question> list) throws IOException{

		System.out.println("REPONSES DE L'UTILISATEUR :");
		System.out.println("ID|    TITRE    |     CONTENT     | USER ID |   DATE   | ");
		for(Question q : list){
			System.out.println(q.getId() + "|" + q.getTitle() + "|" + q.getContent() + "|" + q.getUserId() + "|" + q.getDate() + "");
		}
		System.out.println();
		
	}

	private static void upgradeUser() throws IOException {
		System.out.println("Augmenter le statut d'un utilisateur ");
		usersDisplay();
		System.out.println("Quel est l'id de l'utilisateur a augmenter ? ");
		
		int userIdToUp = parseInt(scanner.nextLine());
				
		System.out.println("Entre le nouveau statut de l'utilisateur (normal - advanced - expert) \n");
				
		String newStatut = scanner.nextLine().toLowerCase();
		
		boolean upgraded = backEnd.upRankUser(userIdToUp, newStatut);
		
		if(upgraded){
			System.out.println("SUCCES : Utilisateur mis a jour ! ");
		}else {
			System.out.println("ERROR : Tu ne peux diminuer le statut d'un utilisateur ");
		}
		System.out.println();
	}
	
	private static void usersDisplay() throws IOException{
		
		List<User> users = backEnd.getUsers();
		System.out.println("ID| PSEUDO |      EMAIL      |REP| RANK |CLOSED| ");
		for(User u : users){
			System.out.println(u.getId() + " |" + u.getPseudo() + "|" + u.getEmail() + "|" + u.getReputation() + "|"  + u.getStatus() + "|" + u.isClosed() + "");
		}
		System.out.println();
	}

	private static void removeUser() throws IOException{
		
		System.out.println("Suppression d'un utilisateur : ");
		usersDisplay();
		System.out.println("Quel est l'id de l'utilisateur a supprimer ? ");

		
		int userIdToRemove = parseInt(scanner.nextLine());
		boolean removed = backEnd.removeUser(userIdToRemove);
		
		if(removed){
			System.out.println("SUCCES : Utilisateur supprime ! \n");
		}else{
			System.out.println("ERREUR : Utilisateur non present ! \n");
		}
		System.out.println();
	}
	
	private static void addTag() throws IOException {
		System.out.println("Entre l'intitule du tag : ");
		String tagName = scanner.nextLine();
		
		while(tagName.length() > TAILLE_TAGS){
			System.out.println("taille max du tag : " + TAILLE_TAGS);
			tagName = scanner.nextLine();
		}
		
		boolean tagAdded = backEnd.addTag(tagName);
		
		if(tagAdded){
			System.out.println("SUCCES : Tag ajoute ! \n");
		}else{
			System.out.println("ERROR : Tag deja existant ! \n");
		}
		System.out.println();
	}
	
	private static void tagsDisplay() throws IOException {
		List<Tag> tags = backEnd.getTags();
		System.out.println("ID| NAME |\n");
		for(Tag t : tags){
			System.out.println(t.getId() + "| " + t.getName() + "|");
		}
		System.out.println();
	}

}
