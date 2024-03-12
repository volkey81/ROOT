package com.sanghafarm.exception;

public class NotAuthorizedError extends RuntimeException {

	public NotAuthorizedError() {
		super("인증 오류가 발생하였습니다..");
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

}
 