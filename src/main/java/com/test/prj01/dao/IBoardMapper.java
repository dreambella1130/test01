package com.test.prj01.dao;

import java.util.List;
import java.util.Map;

public interface IBoardMapper
{
	// 전체 게시물 목록 가져오기
	public int selectTotalBDCnt(Map<String, Object> map);
	
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
	
	// 게시판 번호(pk) 생성하기
	public String selectBDSID();
	
	// 게시글 작성하기
	public void insertBDCont(Map<String, Object> map);
	
	// 게시글 답글 작성하기
	public void insertBDReply(Map<String, Object> map);
	
	// 게시글 그룹 순서 수정하기
	public void updateBDGroupLV(Map<String, Object> map);
	
	// 게시글 수정하기
	public void updateBoard(Map<String, Object> map);
	
	// 게시글 삭제 요청 시 삭제 컬럼 'Y'로 바꿔주기
	public void deleteBoard(String bdSid);
	
	// 댓글 삭제 요청 시 삭제 컬럼 'Y'로 바꿔주기
	public void deleteReple(Map<String, Object> map);
	
	// 게시글 추천/신고 중복 확인하기
	public String selectOverlapChk(Map<String, Object> map);
	
	// 게시글 추천/신고 이력 테이블 insert
	public void insertBDVote(Map<String, Object> map);
	
	// 게시글 추천하기
	public void updateBDLike(String bdSid);
	
	// 게시글 추천 수 가져오기
	public String selectGetLike(String bdSid);
	
	// 게시글 신고하기
	public void updateBDBL(String bdSid);
	
	// 댓글 번호(pk) 생성하기
	public String selectGesiReplSID();
	
	// 댓글 등록하기
	public void insertGesiRepl(Map<String, Object> map);
	
	// 댓글 수정하기
	public void updateGesiRepl(Map<String, Object> map);
	
	// 댓글 삭제하기
	public void deleteGesiRepl(String bd_gesi_repl_sid);
	
	// 댓글의 답글 등록을 위해 댓글 그룹 순서(REPL_LV) 재설정 하기
	public void updateGesiReplGroupLV(Map<String, Object> map);
	
	// 댓글의 답글 등록하기
	public void insertGesiReplReNew(Map<String, Object> map);
	
	// 로그인
	public Map<String, Object> selectMemberLogin(Map<String, Object> map);
	
}
