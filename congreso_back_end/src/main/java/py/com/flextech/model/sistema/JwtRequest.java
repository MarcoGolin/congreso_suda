package py.com.flextech.model.sistema;


import java.io.Serializable;

public class JwtRequest implements Serializable {

    private static final long serialVersionUID = 5926468583005150707L;

    private String username;
    private String password;
    private String timeOffSet;

    public JwtRequest()

    {

    }

    public JwtRequest(String username, String password, String timeOffSet) {

        this.setUsername(username);

        this.setPassword(password);
        
        this.setTimeOffSet(timeOffSet);

    }

    public String getUsername() {

        return this.username;

    }

    public void setUsername(String username) {

        this.username = username;

    }

    public String getPassword() {

        return this.password;

    }

    public void setPassword(String password) {

        this.password = password;

    }
    
	public String getTimeOffSet() {
		return timeOffSet;
	}

	public void setTimeOffSet(String timeOffSet) {
		this.timeOffSet = timeOffSet;
	}


}
