package com.test.prj01.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.test.prj01.service.IBoardService;

@Controller
public class BoardController
{
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired
	private IBoardService service;
	
	// 게시판 전체 목록 가져오기
	@RequestMapping(value="/boardlist")
	public String boardList(Model model)
	{
		List<Map<String, Object>> list = null;
		
		try
		{
			 list = service.getBoardList();
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		model.addAttribute("list", list);
		
		return "boardList";
	}
	
	// 게시판 상세내역 가져오기
	@RequestMapping(value="/bddetail")
	public String boardDetail(Model model, String bdSid)
	{
		logger.info("****게시판 상세목록 호출 :"+bdSid+"*****************");
		
		Map<String, Object> bdDetail = null;		// 게시글 상세내용
		List<Map<String, Object>> bdDetailRepl = null;	// 댓글
		
		try
		{
			bdDetail = service.getbdDetail(bdSid);
			bdDetailRepl = service.getbdReply(bdSid);
			/*
			for(int i=0; i<bdDetail.size(); i++)
				logger.info(bdDetail.toString());
			
			for(int i=0; i<bdDetailRepl.size(); i++)
				logger.info(bdDetailRepl.get(i).toString());
			*/
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		model.addAttribute("bdDetail", bdDetail);
		model.addAttribute("bdDetailRepl", bdDetailRepl);
		
		return "boardDetail";
	}
	
	// 게시글 작성 페이지 호출
	@RequestMapping(value="/boardwrite")
	public String boardWrite(Model model)
	{
		return "boardWrite";
	}
	
	// 게시글 작성내용 insert
	@RequestMapping(value="/boardinsert")
	public String boardInsert(Model model, @RequestParam Map<String, Object> map)
	{
		logger.info(map.toString());
		
		service.insertBDCont(map);
		
		return "redirect:/boardlist";
	}
	
	
	
	
	
	
	
}
