package com.test.prj01.controller;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;
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

import com.test.prj01.service.IBoardService;

@Controller
@SessionAttributes({"memSid", "memNick"})
public class UserController
{
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	private static String RSA_WEB_KEY = "_RSA_WEB_Key_"; 	// 개인키 session key
    private static String RSA_INSTANCE = "RSA"; 			// rsa transformation
   
    String smtpServer = "smtp.naver.com";
    private final String sendId = "";   //---네이버 아이디
    private final String sendPass = ""; //---네이버 비밀번호
    String sendEmailAddress = "" ; //---보내는 사람 이메일주소(네이버)   
    int smtpPort=465;
	
	@Autowired
	private IBoardService service;
	
	// 로그인 버튼 클릭 시 개인키 생성후 전달(ajax)
	@RequestMapping(value="/loginform")
	@ResponseBody
	public Map<String, Object> loginForm(HttpServletRequest request)
	{
		Map<String, Object> ajaxResult = new HashMap<String, Object>();
		// RSA 키 생성
		ajaxResult = initRsa(request);
		
		return ajaxResult;
	}
	
	// 로그인 (ajax)
	@RequestMapping(value="/login")
	@ResponseBody
	public Map<String, Object> memberLogin(Model model, @RequestParam Map<String, Object> map, HttpServletRequest request)
	{
		Map<String, Object> ajaxResult = new HashMap<String, Object>();
		
		logger.info("***로그인(/login) 파라미터 출력 : "+map);
		
		HttpSession session = request.getSession();
        PrivateKey privateKey = (PrivateKey) session.getAttribute(UserController.RSA_WEB_KEY);
        
        logger.info("***암호화 해제 후 파라미터 출력 : "+map);

        String mem_id = map.get("mem_id").toString();
        String mem_pw = map.get("mem_pw").toString();
		
		try
		{
			// 복호화 및 map에 해당 값 재설정 해주기
			map.replace("mem_id", decryptRsa(privateKey, mem_id));
			map.replace("mem_pw", decryptRsa(privateKey, mem_pw));
			
//			logger.info("복호화 키 출력 테스트 mem_id :"+mem_id+", mem_pw :"+mem_pw);
			
			ajaxResult = service.selectMemLogin(map);
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
//		logger.info("***** ajaxResult parma :"+ajaxResult);
		
		// 세션 설정을 위해 모델에 담아 주기
		if(ajaxResult != null)
		{
			logger.info("***** ajaxResult != null");
			
			model.addAttribute("memSid", ajaxResult.get("MEM_SID"));
			model.addAttribute("memNick", ajaxResult.get("MEM_NICK"));
			
			// 개인키 삭제
	        session.removeAttribute(UserController.RSA_WEB_KEY);
			
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
	
	// 닉네임 중복 체크
	@RequestMapping(value="/email_nick_check")
	@ResponseBody
	public String nickChk(@RequestParam Map<String, String> map)
	{
		String ajaxResult = "";
		
		logger.info("***** 파라미터 출력 :"+map+"********");
		
		try
		{
			ajaxResult = service.selectEmailNick(map);
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		logger.info("***** ajaxResult 출력 :"+ajaxResult+"********");
		
		return ajaxResult;
	}
	
	// 회원가입 폼
	@RequestMapping(value="/customCheck")
	public String loginForm(Model model, HttpServletRequest request)
	{
		Map<String, Object> map = new HashMap<String, Object>();
		
		try
		{
			map = initRsa(request);
			map.put("actType", "signUp");
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		model.addAttribute("map", map);
		
		return "customForm";
	}
	
	// 회원가입 insert
	@RequestMapping(value="/joinuser")
	@ResponseBody
	public Map<String, Object> joinUser(Model model, HttpServletRequest request, @RequestParam Map<String, Object> map)
	{
		logger.info("***** 파라미터 출력 :"+map);
		
		HttpSession session = request.getSession();
        PrivateKey privateKey = (PrivateKey) session.getAttribute(UserController.RSA_WEB_KEY);
        session.removeAttribute(RSA_WEB_KEY);
        
        
        
        if(privateKey == null)
        {
        	map.put("result", "error");
        	map = initRsa(request);
        	
        	return map;
        }
       
		try
		{
			// 복호화 및 map에 해당 값 재설정 해주기
			map.replace("userName", decryptRsa(privateKey, map.get("userName").toString()));
			map.replace("userEmail", decryptRsa(privateKey, map.get("userEmail").toString()));
			map.replace("password", decryptRsa(privateKey, map.get("password").toString()));
			
			logger.info("***** 복호화 후 파라미터 출력 :"+map);
			
			String userPk = service.insertUserService(map);
			
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
		
		return map;
	}
	
	// 아이디/비밀번호 찾기 폼
	@RequestMapping(value="/findpw")
	public String findPW(Model model, HttpServletRequest request)
	{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("actType", "findInfo");
		
		model.addAttribute("map", map);
		
		return "customForm";
	}
	
	/**
     * 복호화
     * 
     * @param privateKey
     * @param securedValue
     * @return
     * @throws Exception
     */
    private String decryptRsa(PrivateKey privateKey, String securedValue) throws Exception
    {
    	// RSA Cipher 객체 생성
        Cipher cipher = Cipher.getInstance(UserController.RSA_INSTANCE);
        byte[] encryptedBytes = hexToByteArray(securedValue);
        
        // 복호화 Cipher 초기화
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
        
        String decryptedValue = new String(decryptedBytes, "utf-8"); // 문자 인코딩 주의.
        
        return decryptedValue;
    }
 
    /**
     * 16진 문자열을 byte 배열로 변환한다.
     * 
     * @param hex
     * @return
     */
    public static byte[] hexToByteArray(String hex)
    {
        if (hex == null || hex.length() % 2 != 0)
        { 
        	return new byte[] {}; 
        }
 
        byte[] bytes = new byte[hex.length() / 2];
        
        for (int i = 0; i < hex.length(); i += 2)
        {
            byte value = (byte) Integer.parseInt(hex.substring(i, i + 2), 16);
            bytes[(int) Math.floor(i / 2)] = value;
        }
        
        return bytes;
    }
 
    /**
     * rsa 공개키, 개인키 생성
     * 
     * @param request
     */
    public Map<String, Object> initRsa(HttpServletRequest request)
    {
        HttpSession session = request.getSession();
        KeyPairGenerator generator;
        
        Map<String, Object> map = new HashMap<String, Object>();
        
        try
        {
			generator = KeyPairGenerator.getInstance(UserController.RSA_INSTANCE);
			generator.initialize(1024);		// key Size
			 
	        KeyPair keyPair = generator.genKeyPair();
	        KeyFactory keyFactory = KeyFactory.getInstance(UserController.RSA_INSTANCE);
	        PublicKey publicKey = keyPair.getPublic();		// 공개키
			PrivateKey privateKey = keyPair.getPrivate();	// 개인키
			
			// PRIVATE 키 세션 만료시간 설정하기
//            session.setMaxInactiveInterval(30*60);
			
            session.setAttribute(UserController.RSA_WEB_KEY, privateKey); // session에 RSA 개인키를 세션에 저장
//            
//            Date d = new Date(session.getCreationTime());
//            SimpleDateFormat dFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
//            logger.info("*******세션 설정 시간 :"+dFormat.format(d));
//            
            RSAPublicKeySpec publicSpec = (RSAPublicKeySpec) keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
            String publicKeyModulus = publicSpec.getModulus().toString(16);
            String publicKeyExponent = publicSpec.getPublicExponent().toString(16);
 
            map.put("RSAModulus", publicKeyModulus); 	// rsa modulus 를 map 에 담기
            map.put("RSAExponent", publicKeyExponent); 	// rsa exponent 를 map 에 담기
            
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        
        return map;
    }

}
