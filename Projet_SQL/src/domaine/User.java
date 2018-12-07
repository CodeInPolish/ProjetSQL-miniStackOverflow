package domaine;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class User {
	
	private int id;
	public String pseudo;
	private String password;
	public String email;
	public Status status;
	public int reputation;
	public Timestamp lastVoteDate;
	public boolean closed;
	
	public User(){
		super();
	}
	
	public User(String pseudo, String password, String email){
		this.pseudo = pseudo;
		this.password = password;
		this.email = email;
		status = Status.NORMAL;
		reputation = 0;
		lastVoteDate = null;
		closed = false;
	}

	public String getPseudo() {
		return pseudo;
	}

	public void setPseudo(String pseudo) {
		this.pseudo = pseudo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	public int getReputation() {
		return reputation;
	}

	public void setReputation(int reputation) {
		this.reputation = reputation;
	}

	public Timestamp getLastVoteDate() {
		return lastVoteDate;
	}

	public void setLastVoteDate(Timestamp lastVoteDate) {
		this.lastVoteDate = lastVoteDate;
	}

	public boolean isClosed() {
		return closed;
	}

	public void setClosed(boolean closed) {
		this.closed = closed;
	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", pseudo=" + pseudo + ", password=" + password + ", email=" + email + ", status="
				+ status + ", reputation=" + reputation + ", lastVoteDate=" + lastVoteDate + ", closed=" + closed + "]";
	}
	
}


