package com.test.prj01;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.test.prj01.service.MyUtil;

public interface TestMain
{
	public static void main(String[] args)
	{
		MyUtil util = new MyUtil();
		
		Map<String, Object> map = new HashMap<>();
		StringBuffer sb = new StringBuffer();
		String token = UUID.randomUUID().toString().replace("-", "");
		String activationLink = "";
		String userName = "";
		
		System.out.println("****** token:"+token);
		
		sb.append("<p><b><span style='font-size: 14pt;'>안녕하세요."+userName+"님,</span></b></p><br>");
		sb.append("<p>회원가입을 환영합니다.</p>");
		sb.append("<p><b><span style='background-color: rgb(255, 239, 0);'>계정 인증을 위해 아래 링크를 클릭하여주시기 바랍니다.</span></b></p>");
		sb.append("<p>(참고. 계정 인증 후 로그인 가능)</p><br>");
		sb.append("<a href='"+activationLink+"' style='cursor: pointer; white-space: pre;'>"+activationLink+"</a><br>");
		sb.append("<p>감사합니다.</p>");
		
		
		map.put("recieveEamilAddress", "bellabella1130@naver.com");
		map.put("subject", "메일 발송 테스트");
		map.put("content", sb.toString());

		try
		{
//			util.mailSender(map);
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	
}
