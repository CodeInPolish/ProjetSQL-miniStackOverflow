package common;
import java.sql.Timestamp;

public class Question {

	private int id;
	private String title;
	private String content;
	private int userId;
	private Timestamp date;
	private boolean closed;
	private Timestamp editDate;
	private int editUser;
	
	
	public Timestamp getEditDate() {
		return editDate;
	}


	public void setEditDate(Timestamp editDate) {
		this.editDate = editDate;
	}


	public int getEditUser() {
		return editUser;
	}


	public void setEditUser(int editUser) {
		this.editUser = editUser;
	}


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getTitle() {
		return title;
	}


	public void setTitle(String title) {
		this.title = title;
	}


	public String getContent() {
		return content;
	}


	public void setContent(String content) {
		this.content = content;
	}


	public int getUserId() {
		return userId;
	}


	public void setUserId(int userId) {
		this.userId = userId;
	}


	public Timestamp getDate() {
		return date;
	}


	public void setDate(Timestamp date) {
		this.date = date;
	}


	public boolean isClosed() {
		return closed;
	}


	public void setClosed(boolean closed) {
		this.closed = closed;
	}


	public Question(){
		
	}
}

