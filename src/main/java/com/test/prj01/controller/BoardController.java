package com.test.prj01.controller;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.test.prj01.service.IBoardService;
import com.test.prj01.service.MyUtil;

@Controller
@SessionAttributes({"memSid", "memNick"})
public class BoardController
{
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	private static final String USER_SESSION_KEY = "memSid";
	
	@Autowired
	private IBoardService service;
	
	@Resource(name="myUtil")
	private MyUtil myUtil;
	
	// 로그인 (ajax)
	@RequestMapping(value="/login")
	public @ResponseBody Map<String, Object> memberLogin(Model model, @RequestParam Map<String, Object> map)
	{
		Map<String, Object> ajaxResult = new HashMap<String, Object>();
		logger.info("***로그인(/login) 파라미터 출력 : "+map);
		
		try
		{
			ajaxResult = service.selectMemLogin(map);
			
		} catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		logger.info("***** ajaxResult map 출력 :"+ajaxResult);
		
		if(ajaxResult != null)
		{
			model.addAttribute("memSid", ajaxResult.get("MEM_SID"));
			model.addAttribute("memNick", ajaxResult.get("MEM_NICK"));
		}
		
		return ajaxResult;
	}
	
	// 로그아웃
	@RequestMapping(value="/logout")
	public String logout(SessionStatus session)
	{
		// 세션 종료
		session.setComplete();
		
		return "redirect:/boardlist";
	}
	
	// 회원가입 폼
	@RequestMapping(value="/customCheck")
	public String loginForm(Model model, HttpServletRequest request)
	{
		try
		{
			// RSA 공개키/개인키를 생성한다.
			KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
			generator.initialize(2048);	// Key_Size
			
			KeyPair keyPair = generator.genKeyPair();
			PublicKey publicKey = keyPair.getPublic();		// 공개키
			PrivateKey privateKey = keyPair.getPrivate();	// 개인키
			
			KeyFactory keyFactory = KeyFactory.getInstance("RSA");
			
			HttpSession session = request.getSession();
			session.setAttribute("_rsaPrivateKey_", privateKey);	//세션에 RSA 개인키를 세션에 저장한다.
			
			// 공개키를 문자열로 변환하여 JavaScript RSA 라이브러리 넘겨준다.
			RSAPublicKeySpec publicSpec = (RSAPublicKeySpec)keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
			
			String publicKeyModulus = publicSpec.getModulus().toString(16);
			String publicKeyExponent = publicSpec.getPublicExponent().toString(16);
			
			model.addAttribute("publicKeyModulus", publicKeyModulus);
			model.addAttribute("publicKeyExponent", publicKeyExponent);
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		model.addAttribute("actType", "signUp");
		
		
		return "/customForm";
	}
	
	// 아이디/비밀번호 찾기 폼
	@RequestMapping(value="/findpw")
	public String findPW(Model model)
	{
		
		model.addAttribute("actType", "findInfo");
		return "/customForm";
	}
	
	// 게시판 전체 목록 가져오기
	@RequestMapping(value="/boardlist")
	public String boardList(Model model, String searchKey, String searchValue, String pageNum, String numPer)
	{
		List<Map<String, Object>> list = null;
		Map<String, Object> map = new HashMap<String, Object>();
		
		logger.info("***** /boardlist 호출 searchKey :"+searchKey+", searchValue :"+searchValue+", pageNum :"+pageNum+"*****");
		
		map.put("pageNum", pageNum);
		map.put("numPer", numPer);
		
		// 검색항목이 있다면
		if(searchKey != null && !searchKey.equals(""))
			map.put("searchKey", searchKey);
		
		// 검색어가 있다면
		if(searchValue != null && !searchValue.equals(""))
			map.put("searchValue", searchValue);
		
		// 페이징 처리
		int numPerPage = 10;					// 한 화면(1페이지)에 보여주는 게시물 수
		
		if(numPer != null && !numPer.equals(""))  		
			numPerPage = Integer.parseInt(numPer);
		
		int dataCount = 0;			// 전체 게시물 수
		int total_page = 0;			// 전체 페이지 수
		
		int current_page = 1;		// 현재 페이지 기본값
		
		int start = 0;				// 리스트에 출력할 시작 값
		int end = 0;				// 리스트에 출력할 종료 값
		
		if(pageNum == null)
			pageNum = "";
		
		// 현재 페이지 재설정 하기
		if(!pageNum.equals(""))
		{
			current_page = Integer.parseInt(pageNum);
		}
		
		try
		{
			// 전체 게시물 수 구하기
			dataCount = service.selectTotalBD(map);
			
			// 전체 페이지 수 구하기
			if(dataCount != 0)
				total_page = myUtil.getPageCount(numPerPage, dataCount);
			
			// 다른 사람이 자료를 삭제하여 전체 페이지수가 변화 된 경우
			if(total_page < current_page)
				current_page = total_page;
			
			// 리스트에 출력할 데이터 값 설정하기
			start = (current_page-1) * numPerPage + 1;
			end = current_page * numPerPage;
			
			map.put("start", start);
			map.put("end", end);
			map.put("pageIndexList", myUtil.pageIndexList(current_page, total_page));
			
			list = service.getBoardList(map);
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		
			
		model.addAttribute("searchData", map);
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
	public String boardInsert(Model model, @RequestParam Map<String, Object> map, final HttpServletRequest request)
	{
		logger.info("boardInsert() :"+map.toString());
		
		String memSid = String.valueOf(request.getSession().getAttribute(USER_SESSION_KEY));
		
		map.put("memSid", memSid);
		
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
	public Map<String, Object> boardVote(Model model, @RequestParam Map<String, Object> map, final HttpServletRequest request)
	{
		logger.info("**** 투표 boardVote() ajax 파라미터 출력 :"+map);
		
		Map<String, Object> ajaxResult = new HashMap<String, Object>();
		String msg = "";
		String memSid = String.valueOf(request.getSession().getAttribute(USER_SESSION_KEY));
		
		if(memSid.equals("") || memSid != null)
			map.put("memSid",memSid);
		
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
	public String gesiReplInsert(Model model, @RequestParam Map<String, Object> map, RedirectAttributes redirectAttr
			, final HttpServletRequest request)
	{
		logger.info("**** 댓글 신규 gesiReplInsert() 파라미터 출력 :"+map);
		
		String memSid = String.valueOf(request.getSession().getAttribute(USER_SESSION_KEY));
		map.put("memSid", memSid);
		
		try
		{
			
			if(map.get("bd_gesi_repl_Chk").toString().equals("NewRepl"))
			{
				// 댓글 신규 작성이라면
				service.insertGesiRepl(map);
			}
			else if(map.get("bd_gesi_repl_Chk").toString().equals("replReNew"))
			{
				// 댓글의 답글이라면
				service.insertGesiReplre(map);
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
