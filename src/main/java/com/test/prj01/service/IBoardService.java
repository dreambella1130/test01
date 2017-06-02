package com.test.prj01.service;

import java.util.List;
import java.util.Map;

public interface IBoardService
{
	// 게시판 전체 목록 가져오기
	public List<Map<String, Object>> getBoardList() throws Exception;
	
	// 게시판 상세내역 가져오기
	public Map<String, Object> getbdDetail(String bdSid) throws Exception;
	
	// 윗(다음) 글, 아랫(이전) 글 가져오기
	public Map<String, Object> getPreNextGesi(Map<String, Object> map) throws Exception;
	
	// 게시판 댓글 가져오기
	public List<Map<String, Object>> getbdReply(String bdSid) throws Exception;
	
	// 게시글 작성하기
	public void insertBDCont(Map<String, Object> map) throws Exception;
	
	// 게시글 수정하기
	public void updateBDCont(Map<String, Object> map) throws Exception;
	
	// 게시글 삭제 하기
	public void deleteBD(String bdSid) throws Exception;
	
	// 게시글 추천 하기
	public String voteBDLike(Map<String, Object> map) throws Exception;
	
	// 게시글 신고 하기
	public String voteBDBL(Map<String, Object> map) throws Exception;
	
	// 댓글 작성하기
	public void insertGesiRepl(Map<String, Object> map) throws Exception;
	
	// 댓글 수정하기
	public void updateGesiRepl(Map<String, Object> map) throws Exception;
	
	// 댓글 삭제하기
	public void deleteGesiRepl(String bd_gesi_repl_sid) throws Exception;
}
