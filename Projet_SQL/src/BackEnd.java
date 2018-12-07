import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.swing.text.AbstractDocument.BranchElement;

import domaine.Answer;
import domaine.Question;
import domaine.Status;
import domaine.Tag;
import domaine.User;

public class BackEnd {

	private static PreparedStatement psInsertUser;
	private static PreparedStatement psRemoveUser;
	private static PreparedStatement psGetUser;
	private static PreparedStatement psGetUsers;
	private static PreparedStatement psUpdateUser;
	private static PreparedStatement psGetUserAnswers;
	private static PreparedStatement psGetUserQuestions;
	private static PreparedStatement psAddTag;
	private static PreparedStatement psGetTags;
	private static PreparedStatement psConnectUser;	
	private static PreparedStatement psGetPassword;
	private static PreparedStatement psGetClosedUser;
	private static PreparedStatement psUnknowUser;
	private static PreparedStatement psInsertQuestion;
	private static PreparedStatement psGetQuestions;
	
	private static Connection conn;
	
	public BackEnd(){
		conn = ConnectionDB.initConnection();
	}
	
	public static List<User> getUsers(){
		List<User> users = new ArrayList<User>();
		
		try{
			psGetUsers = conn.prepareStatement("SELECT * FROM projetsql.get_users_view;");
			ResultSet rs = psGetUsers.executeQuery();
			while(rs.next()){
				
				User u = new User();
				
				u.setId(rs.getInt(1));
				u.setPseudo(rs.getString(2));
				u.setEmail(rs.getString(3));
				u.setStatus(Status.valueOf(rs.getString(4).toUpperCase()));
				u.setReputation(rs.getInt(5));
				u.setClosed(rs.getBoolean(6));
				
				users.add(u);
			}
		}catch(SQLException e){
			e.printStackTrace();
		}
		
		return users;
	}
	
	public static boolean upRankUser(int userIdToUp, String newStatut){
		
		try{
			psUpdateUser = conn.prepareStatement("SELECT * FROM projetsql.upgrade_user(?,?);");
			
			psUpdateUser.setInt(1, userIdToUp);
			psUpdateUser.setString(2, newStatut);
			
			psUpdateUser.executeQuery();
			
		}catch(SQLException e){
			return false;
		}
		
		return true;
	}
	
	public static boolean removeUser(int userIdToRemove){
		
		try{
			psRemoveUser = conn.prepareStatement("SELECT * FROM projetsql.delete_user(?);"); 
			
			psRemoveUser.setInt(1, userIdToRemove);
			
			psRemoveUser.executeQuery();
			
		}catch(SQLException e){
			return false;
		}
		return true;
	}

	public List<Answer> getAnswersFromUser(int userToCheckHistory, Timestamp d1, Timestamp d2) {
		List<Answer> answersList = new ArrayList<Answer>();
		
		try{
			psGetUserAnswers = conn.prepareStatement("SELECT * FROM projetsql.get_user_answers_view WHERE user_id = ? AND date BETWEEN ? AND ?;");
			
			psGetUserAnswers.setInt(1,userToCheckHistory);
			psGetUserAnswers.setTimestamp(2, d1);
			psGetUserAnswers.setTimestamp(3, d2);
			
			ResultSet rs = psGetUserAnswers.executeQuery();
			
			while(rs.next()){
				Answer a = new Answer();
				a.setId(rs.getInt(1));
				a.setContent(rs.getString(2));
				a.setDate(rs.getTimestamp(3));
				a.setScore(rs.getInt(4));
				a.setQuestionId(rs.getInt(5));
				a.setAnswer_no(rs.getInt(6));
				a.setUserId(rs.getInt(7));
				
				answersList.add(a);

			}
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}
				
		return answersList;
	}

	public List<Question> getQuestionFromUser(int userToCheckHistory, Timestamp d1, Timestamp d2) {
		List<Question> questionsList = new ArrayList<Question>();
		
		try{
			psGetUserQuestions = conn.prepareStatement("SELECT * FROM projetsql.get_user_questions_view WHERE user_id = ? AND date BETWEEN ? AND ?;");
			
			psGetUserQuestions.setInt(1, userToCheckHistory);
			psGetUserQuestions.setTimestamp(2, d1);
			psGetUserQuestions.setTimestamp(3, d2);
			
			ResultSet rs = psGetUserQuestions.executeQuery();
			
			while(rs.next()){
				
				Question q = new Question();
						
				q.setId(rs.getInt(1));
				q.setUserId(rs.getInt(2));
				q.setTitle(rs.getString(3));
				q.setContent(rs.getString(4));
				q.setDate(rs.getTimestamp(5));
				
				questionsList.add(q);
		
			}
		}catch(SQLException e){
			return null;
		}
		return questionsList;
	}

	public boolean addTag(String tagName) {
		
		try{
			psAddTag = conn.prepareStatement("SELECT * FROM projetsql.create_tag(?);");
			psAddTag.setString(1, tagName);
			psAddTag.executeQuery();
			
			return true;
		}catch(SQLException e){
			return false;
		}
	}
	
	public List<Tag> getTags(){
		
		List<Tag> tags = new ArrayList<Tag>();
		
		try{
			psGetTags = conn.prepareStatement("SELECT * FROM projetsql.get_tags_view;");
			
			ResultSet rs = psGetTags.executeQuery();
			
			while(rs.next()){
				Tag t = new Tag();
				t.setId(rs.getInt(1));
				t.setName(rs.getString(2));
				
				tags.add(t);
			}
			
		}catch(SQLException e){
			return null;
		}
		return tags;
	}

	public int connectUser(String pseudo) {
		
		int id = -1;
		
		try{
			psConnectUser = conn.prepareStatement("SELECT * FROM projetsql.connectUser(?);");
			
			psConnectUser.setString(1, pseudo);
			
			ResultSet rs = psConnectUser.executeQuery();
			
			if(rs.next()){
				id = rs.getInt(1);
			}
			
		}catch(SQLException e){
			e.printStackTrace();
			System.out.println("ERREOR : connecxion rate");
		}
		
		return id;
	}

	public int insertUser(String pseudo, String pwd, String email) {
		int id = -1;
		try {
			psInsertUser = conn.prepareStatement("SELECT * FROM projetsql.CreateUser(?,?,?);");
			
			psInsertUser.setString(1, email);
			psInsertUser.setString(2, BCrypt.hashpw(pwd, BCrypt.gensalt()));
			psInsertUser.setString(3, pseudo);
			
			ResultSet rs = psInsertUser.executeQuery();
			
			if(rs.next()){
				id = rs.getInt(1);
			}
			
		} catch (SQLException e) {
			System.out.println("ERROR : inscription rate");
		}
		
		return id;
	}
	
	public User getUser(int id){
		
		try{
			psGetUser = conn.prepareStatement("SELECT * FROM projetsql.get_user WHERE user_id = ?;");
			
			psGetUser.setInt(1, id);
			
			ResultSet rs = psGetUser.executeQuery();
			
			User u = new User();
			
			while(rs.next()){
				
				u.setId(rs.getInt(1));
				u.setPseudo(rs.getString(2));
				u.setEmail(rs.getString(3));
				u.setStatus(Status.valueOf(rs.getString(4).toUpperCase()));
				u.setReputation(rs.getInt(5));
				u.setLastVoteDate(rs.getTimestamp(6));
				
			}
			
			return u;
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		return null;
	}

	public String getPassWord(int userId) {
		
		try{
			psGetPassword = conn.prepareStatement("SELECT * FROM projetsql.get_user_password WHERE user_id = ?;");
			
			psGetPassword.setInt(1, userId);
			
			ResultSet rs = psGetPassword.executeQuery();
			
			if(rs.next()){
				return rs.getString(2);
			}
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		return null;
	}

	public boolean userClosed(String pseudo) {
		
		try{
			psGetClosedUser = conn.prepareStatement("SELECT * FROM projetsql.get_user_closed_view WHERE pseudo = ?;");
			
			psGetClosedUser.setString(1, pseudo);
			
			ResultSet rs = psGetClosedUser.executeQuery();
			
			if(rs.next()){
				return rs.getBoolean(2);
			}
		}catch(SQLException e){
			e.printStackTrace();
		}
		return false;
	}

	public boolean unknownUser(String pseudo) {
		
		try{
			psUnknowUser = conn.prepareStatement("SELECT * FROM projetsql.unknow_user WHERE pseudo = ?;");

			psUnknowUser.setString(1, pseudo);
			
			ResultSet rs = psUnknowUser.executeQuery();
			
			if(rs.next()){
				return false;
			}else{
				return true;
			}
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		return false;
	}

	public int insertQuestion(String title, String content, int userId) {
		
		int id = -1;
		
		try{
			psInsertQuestion = conn.prepareStatement("SELECT * FROM projetsql.CreateQuestion(?,?,?);");
			
			psInsertQuestion.setString(1, title);
			psInsertQuestion.setString(2, content);
			psInsertQuestion.setInt(3, userId);
			
			ResultSet rs = psInsertQuestion.executeQuery();
			
			if(rs.next()){
				id = rs.getInt(1);
			}
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		return id;
	}

	public List<Question> getQuestions() {
		List<Question> list = new ArrayList<Question>();
		
		try{
			psGetQuestions = conn.prepareStatement("SELECT * FROM projetsql.questionsViewByDate;");
			
			ResultSet rs = psGetQuestions.executeQuery();
			
			while(rs.next()){
				Question q = new Question();
				
				q.setDate(rs.getTimestamp(1));
				q.setId(rs.getInt(2));
				q.setContent(rs.getString(3));
				q.setUserId(connectUser(rs.getString(4)));
				q.setEditDate(rs.getTimestamp(5));
				q.setEditUser(connectUser(rs.getString(6)));
				q.setTitle(rs.getString(7));
				
				list.add(q);
			}
			return list;
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		
		return list;
	}
}
