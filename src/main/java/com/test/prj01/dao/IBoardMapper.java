package com.test.prj01.dao;

import java.util.List;
import java.util.Map;

public interface IBoardMapper
{
	// 게시판 전체 목록 가져오기
	public List<Map<String, Object>> selectBoardList();
	
	// 게시판 상세내역 가져오기
	public Map<String, Object> selectBDDetail(String bdSid);
	
	// 게시판 댓글 가져오기
	public List<Map<String, Object>> selectBDRepl(String bdSid);
	
	// 게시판 번호 생성하기
	public String selectBDSID();
	
	// 게시글 작성하기
	public void insertBDCont(Map<String, Object> map);
}
