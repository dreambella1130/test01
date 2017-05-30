package com.test.prj01.dao;

import java.util.List;
import java.util.Map;

public interface IBoardMapper
{
	// 게시판 전체 목록 가져오기
	public List<Map<String, Object>> selectBoardList(Map<String, Object> map);
	
	// 게시판 상세내역 가져오기
	public Map<String, Object> selectBDDetail(String bdSid);
	
	// 아래(이전) 글 가져오기_1
	public Map<String, Object> selectPreGesi_1(Map<String, Object> map);
	
	// 아래(이전) 글 가져오기_2 (아래(이전) 글 1번에서의 조회값이 없을 경우)
	public Map<String, Object> selectPreGesi_2(Map<String, Object> map);
	
	// 윗(다음) 글 가져오기_1
	public Map<String, Object> selectNextGesi_1(Map<String, Object> map);
	
	// 윗(다음) 글 가져오기_2 (윗(다음) 글 1번에서의 조회값이 없을 경우)
	public Map<String, Object> selectNextGesi_2(Map<String, Object> map);
	
	// 게시판 댓글 가져오기
	public List<Map<String, Object>> selectBDRepl(String bdSid);
	
	// 게시판 번호 생성하기
	public String selectBDSID();
	
	// 게시글 작성하기
	public void insertBDCont(Map<String, Object> map);
	
	public void updateBoard(Map<String, Object> map);
}
