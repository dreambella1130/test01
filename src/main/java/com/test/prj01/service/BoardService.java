package com.test.prj01.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.test.prj01.dao.IBoardMapper;

@Service
public class BoardService implements IBoardService
{
	@Autowired
	private SqlSession session;
	private IBoardMapper dao;
	
	// 게시판 전체 목록 가져오기
	@Override
	public List<Map<String, Object>> getBoardList() throws Exception
	{
		dao = session.getMapper(IBoardMapper.class);
		
		List<Map<String, Object>> list = dao.selectBoardList();
		
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
	public void insertBDCont(Map<String, Object> map)
	{
		dao = session.getMapper(IBoardMapper.class);
		
		String bdSID = dao.selectBDSID();
		
		System.out.println("***** 번호 출력 :"+bdSID);
		
		map.put("bdSID", bdSID);
		
		System.out.println("*****map 출력 :"+map.toString());
		
		dao.insertBDCont(map);
		
	}
	
	
	
	
}
