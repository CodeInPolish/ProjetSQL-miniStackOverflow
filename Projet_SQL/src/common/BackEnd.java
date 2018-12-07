package common;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.swing.text.AbstractDocument.BranchElement;

public class BackEnd {

	private PreparedStatement psCreateUser;
	private PreparedStatement psConnectUser;
	private PreparedStatement psGetHash;
	private PreparedStatement psGetTags;
	private PreparedStatement psCreateQuestion;
	private PreparedStatement psEditQuestion;
	private PreparedStatement psCloseQuestion;	
	private PreparedStatement psViewUserHistory;
	private PreparedStatement psViewQuestions;
	private PreparedStatement psViewQuestionsByTag;
	private PreparedStatement psCreateAnswer;
	private PreparedStatement psEditAnswer;
	private PreparedStatement psViewAnswers;
	private PreparedStatement psAddTag;
	private PreparedStatement psVote;
	
	
	private Connection conn;
	
	public BackEnd(){
		this.conn = connectDB();
		
		try {
			psCreateUser = conn.prepareStatement("SELECT * FROM ProjetSQL.CreateUser(?,?,?);");
			psConnectUser = conn.prepareStatement("SELECT * FROM ProjetSQL.ConnectUser(?,?);");
			psGetHash = conn.prepareStatement("SELECT * FROM ProjetSQL.get_hash(?);");
			
			psCreateQuestion = conn.prepareStatement("SELECT * FROM ProjetSQL.CreateQuestion(?,?,?);");
			psEditQuestion = conn.prepareStatement("SELECT * FROM ProjetSQL.Edit_Question(?,?,?,?);");
			psCloseQuestion = conn.prepareStatement("SELECT * FROM ProjetSQL.close_Question(?,?);");
			psViewQuestions = conn.prepareStatement("SELECT * FROM projetsql.questionsViewByDate;");
			psViewQuestionsByTag = conn.prepareStatement("SELECT * FROM ProjetSQL.questionsViewByTag WHERE tag=?;");
			
			psCreateAnswer = conn.prepareStatement("SELECT * FROM ProjetSQL.CreateAnswer(?,?,?);");
			psEditAnswer = conn.prepareStatement("SELECT * FROM ProjetSQL.edit_answer(?,?,?,?);");
			psViewAnswers = conn.prepareStatement("SELECT * FROM ProjetSQL.AnswersViewByDate WHERE question_id = ?;");
			
			
			psViewUserHistory = conn.prepareStatement("SELECT * FROM ProjetSQL.UserHistory WHERE an_user_id = ?;");
			
			psGetTags = conn.prepareStatement("SELECT t.name FROM ProjetSQL.tags t;");
			psAddTag = conn.prepareStatement("SELECT * FROM ProjetSQL.addTag(?,?);");
			
			psVote = conn.prepareStatement("SELECT * FROM ProjetSQL.vote(?,?,?,?);");
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
	}

	public void createUser(String pseudo, String password, String email) {
		try {
			psCreateUser.clearParameters();
			psCreateUser.setString(1, email);
			psCreateUser.setString(2, BCrypt.hashpw(password, BCrypt.gensalt()));
			psCreateUser.setString(3, pseudo);
			psCreateUser.executeQuery();
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public int connectUser(String pseudo, String password) {
		int index = -1;
		try {
			psGetHash.clearParameters();
			psGetHash.setString(1, pseudo);
			ResultSet rs = psGetHash.executeQuery();
			String hash = "";
			if(rs.next()) {
				hash = rs.getString(1);
			}
			if(BCrypt.checkpw(password, hash)) {
				psConnectUser.clearParameters();
				psConnectUser.setString(1, pseudo);
				psConnectUser.setString(2, hash);
				ResultSet rs2 = psConnectUser.executeQuery();
				if(rs2.next()) {
					index = rs2.getInt(1);
				}
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return index;
	}
	
	public int createQuestion(String title, String data, int user_id) {
		int index=-1;
		try {
			psCreateQuestion.clearParameters();
			psCreateQuestion.setString(1, title);
			psCreateQuestion.setString(2, data);
			psCreateQuestion.setInt(3, user_id);
			ResultSet rs = psCreateQuestion.executeQuery();
			if(rs.next()) {
				index = rs.getInt(1);
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return index;
	}
	
	public void editQuestion(String title, String data, int user_id, int question_id) {
		try {
			psEditQuestion.clearParameters();
			psEditQuestion.setInt(1, user_id);
			psEditQuestion.setInt(2, question_id);
			psEditQuestion.setString(3, title);
			psEditQuestion.setString(4, data);
			psEditQuestion.executeQuery();
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void closeQuestion(int user_id, int question_id) {
		try {
			psCloseQuestion.clearParameters();
			psCloseQuestion.setInt(1, user_id);
			psCloseQuestion.setInt(2, question_id);
			psCloseQuestion.executeQuery();
		}
		catch(SQLException e) {
			System.out.print("error");
		}
	}
	
	public ResultSet viewQuestions() {
		
		ResultSet ret=null;
		
		try{			
			ret = psViewQuestions.executeQuery();
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		
		return ret;
	}
	
	public void createAnswer(String content, int user_id, int question_id) {
		try {
			psCreateAnswer.clearParameters();
			psCreateAnswer.setString(1, content);
			psCreateAnswer.setInt(2, user_id);
			psCreateAnswer.setInt(3, question_id);
			psCreateAnswer.executeQuery();
		}
		catch(SQLException e) {
			System.out.print("error");
		}
	}
	
	public void editAnswer(String data, int user_id, int question_id, int answer_no) {
		try {
			psEditAnswer.clearParameters();
			psEditAnswer.setInt(1,answer_no);
			psEditAnswer.setInt(2,user_id);
			psEditAnswer.setString(3, data);
			psEditAnswer.setInt(4,question_id);
			psEditAnswer.executeQuery();
		}
		catch(SQLException e) {
			System.out.print("error");
		}
	}
	
	public ResultSet viewQuestionsByTag(String tag) {
		ResultSet ret=null;
		
		try{
			psViewQuestionsByTag.clearParameters();
			psViewQuestionsByTag.setString(1, tag);
			ret = psViewQuestionsByTag.executeQuery();
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		
		return ret;
	}
	
	
	
	public ResultSet viewAnswers(int question_id) {
		ResultSet ret=null;
		
		try{
			psViewAnswers.clearParameters();
			psViewAnswers.setInt(1, question_id);
			ret = psViewAnswers.executeQuery();
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		
		return ret;
	}
	
	public ResultSet viewUserHistory(int user_id) {
		ResultSet ret=null;
		
		try{
			psViewUserHistory.clearParameters();
			psViewUserHistory.setInt(1, user_id);
			ret = psViewUserHistory.executeQuery();
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		
		return ret;
	}
	
	public ResultSet getTags() {
		ResultSet ret=null;
		
		try{
			ret = psGetTags.executeQuery();
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		
		return ret;
	}
	
	public void addTag(int question_id, String tag_name) {
		try{
			psAddTag.clearParameters();
			psAddTag.setInt(1, question_id);
			psAddTag.setString(2, tag_name);
			psAddTag.executeQuery();
		}catch(SQLException e){
			System.out.println(tag_name+" n'est pas dans la base de données");
		}
	}
	
	public void vote(int user_id, int answer_no, int question_id, int value) {
		try{
			psVote.clearParameters();
			psVote.setInt(1, user_id);
			psVote.setInt(2, answer_no);
			psVote.setInt(3, question_id);
			psVote.setInt(4, value);
			psVote.executeQuery();
		}catch(SQLException e){
			System.out.println("Erreur de vote");
		}
	}
	
	private Connection connectDB() {
		conn = null;
				
		try{
			Class.forName("org.postgresql.Driver");
		}catch(ClassNotFoundException e){
			System.out.println("Erreur. Driver postgres manquant !");
			e.printStackTrace();
			System.exit(0);
		}
		System.out.println("Driver OK");

		try{
			conn = DriverManager.getConnection(ConnectionDB.url, ConnectionDB.user, ConnectionDB.pwd);
		}catch(SQLException e){
			System.out.println("Erreur. La connexion DB a echoué !");
			e.printStackTrace();
			System.exit(0);
		}
		
		System.out.println("Connexion DB OK");
		
		return conn;
	}
}
