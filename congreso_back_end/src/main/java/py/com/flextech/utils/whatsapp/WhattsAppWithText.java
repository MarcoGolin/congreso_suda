package py.com.flextech.utils.whatsapp;

public class WhattsAppWithText {

	private String url;
	private String sessionKey;
	private String session;
	private String number;
	private String text;
	
	
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getSessionKey() {
		return sessionKey;
	}

	public void setSessionKey(String sessionKey) {
		this.sessionKey = sessionKey;
	}

	public String getSession() {
		return session;
	}
	public void setSession(String session) {
		this.session = session;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}

	public WhattsAppWithText(String url, String sessionKey, String session, String number, String text) {
		super();
		this.url = url;
		this.sessionKey = sessionKey;
		this.session = session;
		this.number = number;
		this.text = text;
	}

	
	
	
	
	
}
