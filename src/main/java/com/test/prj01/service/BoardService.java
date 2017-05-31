package com.test.prj01.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.test.prj01.dao.IBoardMapper;

@Service
public class BoardService implements IBoardService
{
	private static final Logger logger = LoggerFactory.getLogger(BoardService.class);
	
	@Autowired
	private SqlSession session;
	private IBoardMapper dao;
	
	// 게시판 전체 목록 가져오기
	@Override
	public List<Map<String, Object>> getBoardList() throws Exception
	{
		dao = session.getMapper(IBoardMapper.class);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		//map.put("startN", 1);
		//map.put("endN", 10);
		
		List<Map<String, Object>> list = dao.selectBoardList(map);
		
		// 들여쓰기 설정 해주기
		for(int i=0; i<list.size(); i++)
		{
			if(!list.get(i).get("BD_GRP_DEP").toString().equals("0"))
			{
				for(int j=0; j<Integer.parseInt(list.get(i).get("BD_GRP_DEP").toString()); j++)
				{
					list.get(i).replace("BD_TITLE", "&nbsp; &nbsp; &nbsp; &nbsp;"+list.get(i).get("BD_TITLE").toString());
				}
			}
		}
		
		return list;
	}

	// 게시판 상세내역 가져오기
	@Override
	public Map<String, Object> getbdDetail(String bdSid) throws Exception
	{
		dao = session.getMapper(IBoardMapper.class);
		
		Map<String, Object> bdDetail = dao.selectBDDetail(bdSid);
		
		return bdDetail;
	}
	
	
	// 윗(다음) 글, 아랫(이전) 글 가져오기
	@Override
	public Map<String, Object> getPreNextGesi(Map<String, Object> map) throws Exception
	{
		dao = session.getMapper(IBoardMapper.class);
		
		Map<String, Object> nextGesi = null;
		Map<String, Object> preGesi = null;
		Map<String, Object> preNextGesi = new HashMap<>();
		
		// 아래(이전) 글 sql 호출
		if(Integer.parseInt(map.get("bd_grp_LV").toString()) != 1)
		{
			//System.out.println("********** Integer.parseInt(bd_grp_LV) != 1 **********");
			nextGesi = dao.selectNextGesi_1(map);
		}
		else
		{
			//System.out.println("********** Integer.parseInt(bd_grp_LV) == 1 **********");
			nextGesi = dao.selectNextGesi_2(map);
		}
		
		// 윗(다음)글 sql 호출
		
		if(dao.selectPreGesi_1(map) != null)
		{
			preGesi = dao.selectPreGesi_1(map);
		}
		else
		{
			preGesi = dao.selectPreGesi_2(map);
		}
		
		
		if(preGesi == null)
			System.out.println("******* preGesi == null *******");
		else
			System.out.println("******* preGesi :"+preGesi);
		
		
		preNextGesi.put("preGesi", preGesi);
		preNextGesi.put("nextGesi", nextGesi);
		
		return preNextGesi;
	}

	// 게시판 댓글 가져오기
	@Override
	public List<Map<String, Object>> getbdReply(String bdSid) throws Exception
	{
		dao = session.getMapper(IBoardMapper.class);
		
		List<Map<String, Object>> bdReply = dao.selectBDRepl(bdSid);
		
		// 댓글 깊이 만큼 공백 발생시키기
		for(int i=0; i<bdReply.size(); i++)
		{
			if(!bdReply.get(i).get("REPL_DEPT").toString().equals("0"))
			{
				if(bdReply.get(i).get("REPL_DEPT").toString().equals("1"))
				{
					bdReply.get(i).replace("MEM_NICK", "<span class='replMargin'>┗ </span>"+bdReply.get(i).get("MEM_NICK").toString());
					bdReply.get(i).replace("REPL_CONT", "&nbsp; &nbsp; "+bdReply.get(i).get("REPL_CONT").toString());
				}
				else
				{
					bdReply.get(i).replace("MEM_NICK", "<span class='replMargin'>┗ </span>"+bdReply.get(i).get("MEM_NICK").toString());
					
					for(int j=0; j<Integer.parseInt(bdReply.get(i).get("REPL_DEPT").toString()); j++)
					{
						bdReply.get(i).replace("MEM_NICK", "&nbsp; &nbsp;"+bdReply.get(i).get("MEM_NICK").toString());
						bdReply.get(i).replace("REPL_CONT", "&nbsp; &nbsp; "+bdReply.get(i).get("REPL_CONT").toString());
						
					}
				}
				
			}
		}
		
		return bdReply;
		
	}

	// 게시글 작성하기
	@Override
	public void insertBDCont(Map<String, Object> map) throws Exception
	{
		dao = session.getMapper(IBoardMapper.class);
		
		String bdSID = dao.selectBDSID();
		
		System.out.println("***** 번호 출력 :"+bdSID);
		
		map.put("bdSID", bdSID);
		
		System.out.println("*****map 출력 :"+map.toString());
		
		if(map.get("repleCheck").toString().equals("Y"))
		{
			// 답글 insert 전 글 그룹 순서 수정하기
			dao.updateBDGroupLV(map);
			
			// 답글 insert 하기
			dao.insertBDReply(map);
		}
		else
		{
			// 신규 글 작성
			dao.insertBDCont(map);
		}
		
		
	}

	// 게시글 수정하기
	@Override
	public void updateBDCont(Map<String, Object> map) throws Exception
	{
		dao = session.getMapper(IBoardMapper.class);
		
		dao.updateBoard(map);
		
	}

	// 게시글 삭제 하기(게시글, 댓글 삭제여부만 'Y'로 update 하기
	@Override
	public void deleteBD(String bdSid) throws Exception
	{
		dao = session.getMapper(IBoardMapper.class);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bdSid", bdSid);
		
		// 게시글 삭제(삭제여부 컬럼 update) 하기
		dao.deleteBoard(bdSid);
		
		// 게시글에 연관된 댓글 삭제(삭제여부 컬럼 update) 하기
		dao.deleteReple(map);
	}
	
	
	
	
}
