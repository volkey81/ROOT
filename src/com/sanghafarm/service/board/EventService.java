package com.sanghafarm.service.board;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class EventService extends IbatisService {
	public Integer getListCount(Param param) {
		return (Integer)super._scalar("Event.getListCount", param);
	}

	public List<Param> getList(Param param) {
		return super._list("Event.getList", param);
	}
	
	public Param getInfo(Param param) {
		return super._row("Event.getInfo", param); 
	}
	
	public List<Param> getEventRelationProductList(int seq, String gradeCode) {
		return super._list("Event.getEventRelationProductList", new Param("seq", seq, "gradeCode", gradeCode));
	}
	
	// 메인 CLOB 처리를 위해
	public List<Param> getMainList(Param param) {
		return super._list("Event.getMainList", param);
	}
	
	// Event Comment ----------------------------
	public List<Param> getCommentList(Param param) {
		return super._list("Event.getCommentList", param);
	}
	
	public Integer getCommentListCount(Param param) {
		return (Integer) super._scalar("Event.getCommentListCount", param);
	}
	
	public Param getCommentInfo(Param param) {
		return super._row("Event.getCommentInfo", param);
	}
	
	public void createComment(Param param) {
		super._insert("Event.insertComment", param);
	}
	
	public void modifyComment(Param param) {
		super._update("Event.updateComment", param);
	}

	public void modifyCommnetStatus(Param param) {
		super._update("Event.updateCommentStatus", param);
	}

	public void modifyHit(Param param) {
		super._update("Event.updateHit", param);
	}
}
