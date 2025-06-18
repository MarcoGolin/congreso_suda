package py.com.flextech.utils.whatsapp;

public class WhattsAppWithSendFile {

	private String url;
	private String sessionKey;
	private String session;
	private String fileName;
	private String path;
	private String caption;
	private String number;
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
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getCaption() {
		return caption;
	}
	public void setCaption(String caption) {
		this.caption = caption;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public WhattsAppWithSendFile(String url, String sessionKey, String session, String fileName, String path,
			String caption, String number) {
		super();
		this.url = url;
		this.sessionKey = sessionKey;
		this.session = session;
		this.fileName = fileName;
		this.path = path;
		this.caption = caption;
		this.number = number;
	}
	
	
	
	
}
