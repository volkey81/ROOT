package com.sanghafarm.exception;

public class OrderError extends RuntimeException {
	public OrderError() {
		super("주문 처리도중 오류가 발생하였습니다..");
	}
	
	public OrderError(String msg) {
		super(msg);
	}
	
	public OrderError(Exception e) {
		super(e);
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

}
 