package com.test.prj01.service;

import java.util.List;
import java.util.Map;

public interface IBoardService
{
	// 게시판 전체 목록 가져오기
	public List<Map<String, Object>> getBoardList() throws Exception;
	
	// 게시판 상세내역 가져오기
	public Map<String, Object> getbdDetail(String bdSid) throws Exception;
	
	// 게시판 댓글 가져오기
	public List<Map<String, Object>> getbdReply(String bdSid) throws Exception;
	
	// 게시글 작성하기
	public void insertBDCont(Map<String, Object> map);
}
