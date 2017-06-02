package com.test.prj01.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
	public String boardDetail(Model model, @RequestParam Map<String, Object> map, HttpServletRequest request)
	{
		logger.info("****게시판 상세목록 호출 :"+map);
		logger.info("****map.size() :"+map.size());
		
		Map<String, ?> map_1 = RequestContextUtils.getInputFlashMap(request);
		
		// map의 크기가 0 이면 리다이렉트로 호출 된 것임.
		// redirect에서 넘어온 파라미터 값 map에 재설정 해주기
		if(map.size() == 0)
		{
			logger.info("***** map == null");
			logger.info("map_1 출력 :"+map_1);
			
			map.put("bdSid", map_1.get("bdSid").toString());
			map.put("bd_grp_sid", map_1.get("bd_grp_sid").toString());
			map.put("bd_grp_LV", map_1.get("bd_grp_LV").toString());
			
			logger.info("map에 map_1 값 넣은 후 출력 :"+map);
			
		}
		
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
		logger.info("boardInsert() :"+map.toString());
		
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
	public String boardUpdate(Model model, @RequestParam Map<String, Object> map, RedirectAttributes redirectAttr)
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
		redirectAttr.addFlashAttribute("bdSid", map.get("bdSid").toString());
		redirectAttr.addFlashAttribute("bd_grp_sid", map.get("bd_grp_sid").toString());
		redirectAttr.addFlashAttribute("bd_grp_LV", map.get("bd_grp_LV").toString());
		
		return "redirect:/bddetail";
	}
	
	// 글 삭제하기
	@RequestMapping(value="/godelete")
	public String boardDelete(Model model, @RequestParam Map<String, Object> map)
	{
		try
		{
			service.deleteBD((String)map.get("bdSid"));
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return "redirect:/boardlist";
	}
	
	// 답글 폼으로 이동하기
	@RequestMapping(value="/bdrepleform")
	public String boardReple(Model model, @RequestParam Map<String, Object> map)
	{
		// 답글의 경우 답글 여부를 알 수 있는 key를 설정해서 map에 담아준다
		map.put("repleCheck", "Y");
		
		model.addAttribute("bdReple", map);
		
		logger.info("***** map 출력 :"+map);
		
		return "boardWrite";
	}
	
	// 투표(좋아요, 신고) ajax
	@RequestMapping(value="/voteboard")
	@ResponseBody
	public Map<String, Object> boardVote(Model model, @RequestParam Map<String, Object> map)
	{
		logger.info("**** 투표 boardVote() ajax 파라미터 출력 :"+map);
		
		Map<String, Object> ajaxResult = new HashMap<String, Object>();
		String msg = "";
		
		try
		{
			if(map.get("voteType").toString().equals("likeBoard"))
			{
				// 추천 구분번호 셋팅
				map.put("gubun_sid", 2);
				msg = service.voteBDLike(map);
			}
			else if(map.get("voteType").toString().equals("badBoard"))
			{
				// 신고 구분번호 셋팅
				map.put("gubun_sid", 3);
				msg = service.voteBDBL(map);
			}
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		ajaxResult.put("result", msg);
		
		return ajaxResult;
	}
	
	// 댓글 등록
	@RequestMapping(value="/goinsertgesirepl")
	public String gesiReplInsert(Model model, @RequestParam Map<String, Object> map, RedirectAttributes redirectAttr)
	{
		logger.info("**** 댓글 신규 gesiReplInsert() 파라미터 출력 :"+map);
		
		try
		{
			
			if(map.get("bd_gesi_repl_Chk").toString().equals("NewRepl"))
			{
				// 댓글 신규 작성이라면
				service.insertGesiRepl(map);
			}
			else if(map.get("bd_gesi_repl_Chk").toString().equals("replRepl"))
			{
				// 댓글의 답글이라면
			}
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		
		
		// 리다이렉트 시 파라미터 값 넘겨주기
		redirectAttr.addFlashAttribute("bdSid", map.get("bdSid").toString());
		redirectAttr.addFlashAttribute("bd_grp_sid", map.get("bd_grp_sid").toString());
		redirectAttr.addFlashAttribute("bd_grp_LV", map.get("bd_grp_LV").toString());
		
		return "redirect:/bddetail";
		
	}
	
	// 댓글 수정
	@RequestMapping(value="/goupdategesirepl")
	public String gesiReplUpdate(Model model, @RequestParam Map<String, Object> map, RedirectAttributes redirectAttr)
	{
		
		logger.info("**** 댓글 수정 goupdategesirepl() 파라미터 출력 :"+map);
		
		try
		{
			service.updateGesiRepl(map);
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		// 리다이렉트 시 파라미터 값 넘겨주기
		redirectAttr.addFlashAttribute("bdSid", map.get("bdSid").toString());
		redirectAttr.addFlashAttribute("bd_grp_sid", map.get("bd_grp_sid").toString());
		redirectAttr.addFlashAttribute("bd_grp_LV", map.get("bd_grp_LV").toString());
		
		return "redirect:/bddetail";
	}
	
	@RequestMapping(value="/godeletereple")
	public String gesiReplDelete(Model model, @RequestParam Map<String, Object> map, RedirectAttributes redirectAttr)
	{
		logger.info("**** 댓글 삭제 gesiReplDelete() 파라미터 출력 :"+map);
		
		try
		{
			service.deleteGesiRepl(map.get("bd_gesi_repl_sid").toString());
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		// 리다이렉트 시 파라미터 값 넘겨주기
		redirectAttr.addFlashAttribute("bdSid", map.get("bdSid").toString());
		redirectAttr.addFlashAttribute("bd_grp_sid", map.get("bd_grp_sid").toString());
		redirectAttr.addFlashAttribute("bd_grp_LV", map.get("bd_grp_LV").toString());
		
		return "redirect:/bddetail";
	}
	
}
