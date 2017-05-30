package com.test.prj01.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

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
	public String boardDetail(Model model, @RequestParam Map<String, Object> map)
	{
		logger.info("****게시판 상세목록 호출 :"+map);
		
		Map<String, Object> bdDetail = null;			// 게시글 상세내용
		List<Map<String, Object>> bdDetailRepl = null;	// 댓글
		Map<String, Object> getPreNextGesi = null;		// 윗(다음) 글, 아랫(이전) 글
		
		
		try
		{
			// 게시글 상세내용 가져오기
			bdDetail = service.getbdDetail(map.get("bdSid").toString());
			// 댓글 가져오기
			bdDetailRepl = service.getbdReply(map.get("bdSid").toString());
			// 윗(다음) 글, 아랫(이전) 글 가져오기
			getPreNextGesi = service.getPreNextGesi(map);
			
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
		model.addAttribute("getPreNextGesi", getPreNextGesi);
		
		logger.info("****** 윗글 출력:"+getPreNextGesi.get("nextGesi")+"******");
		logger.info("****** 아랫글 출력:"+getPreNextGesi.get("preGesi")+"******");
		
		return "boardDetail";
	}
	
	// 게시글 작성 페이지 호출
	@RequestMapping(value="/gobdwrite")
	public String boardWriteForm(Model model)
	{
		return "boardWrite";
	}
	
	// 게시글 작성내용 insert
	@RequestMapping(value="/boardinsert")
	public String boardInsert(Model model, @RequestParam Map<String, Object> map)
	{
		logger.info(map.toString());
		
		try
		{
			service.insertBDCont(map);
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return "redirect:/boardlist";
	}
	
	// 게시글 수정 페이지로 가기(update)
	@RequestMapping(value="/gobdedit")
	public String boardUpdateForm(Model model, @RequestParam Map<String, Object> map)
	{
		logger.info("게시글 수정할 게시글 번호 출력(bdSid):"+map.get("bdSid").toString());
		
		Map<String, Object> bdDetail = null;			// 게시글 상세내용
		
		try
		{
			// 게시글 상세내용 가져오기
			bdDetail = service.getbdDetail(map.get("bdSid").toString());
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		model.addAttribute("bdDetail", bdDetail);
		
		logger.info("쿼리문으로 가져온 수정할 게시글 내용 출력(bdDetail) :"+bdDetail);
		
		return "boardUpdate";
	}
	
	// 글 수정하기
	@RequestMapping(value="/boardupdate")
	public String boardUpdate(Model model, @RequestParam Map<String, Object> map)
	{
		logger.info("게시글 수정(update) 파라미터 출력:"+map);
		Map<String, Object> bdDetail = null;			// 게시글 상세내용
		
		try
		{
			service.updateBDCont(map);
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		// 리다이렉트 시 파라미터 값 넘겨주기
		//redirectAttr.addFlashAttribute("map", map);
		
		return "redirect:/boardlist";
	}
	
	// 글 삭제하기
	@RequestMapping(value="/godelete")
	public String boardDelete(Model model, @RequestParam Map<String, Object> map)
	{
		return "redirect:/boardlist";
	}
	
	
	
}
