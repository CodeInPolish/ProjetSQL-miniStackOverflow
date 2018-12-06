package domaine;

public enum Status {

	NORMAL("normal"), ADVANCED("advanced"), EXPERT("expert");
	
	String s;
	
	private Status(String s){
		this.s = s;
	}
	
	public String getS(){
		return s;
	}
}
