package com.test.prj01.service;


import java.util.Date;
import java.util.Map;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.stereotype.Service;


// 페이징 처리
@Service("myUtil")
public class MyUtil
{
	
	public void mailSender(Map<String, Object> map) throws MessagingException
	{
		//---보내시는 분
/*		String smtpServer = "smtp.naver.com";
        final String sendId = "";   //---네이버 아이디
        final String sendPass = ""; //---네이버 비밀번호
        String sendEmailAddress = "" ; //---보내는 사람 이메일주소(네이버)   
        int smtpPort=465;
 */       
        
        //---받는 분
//        recieveEamilAddress = "master@soledot.com";  //---이메일주소
//        String subject = "안녕하세요. SoleDot입니다."; //---제목
//        String content = "안녕하세요. Javacreator에서 학습용으로 이메일 보내기 연습 중입니다.";  //---내용
        
        // 정보를 담기 위한 객체 생성
        Properties props = System.getProperties();
        // SMTP 서버 정보 설정
        props.put("mail.smtp.host", map.get("smtpServer").toString());
        props.put("mail.smtp.port", map.get("smtpPort").toString());
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.trust", map.get("smtpServer").toString());

        //Session 생성
        Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator()
        {
            protected PasswordAuthentication getPasswordAuthentication()
            {
                return new PasswordAuthentication(map.get("sendId").toString(), map.get("sendPass").toString());
            }
        });
        
        session.setDebug(true); //for debug
          
        Message mimeMessage = new MimeMessage(session);
        
        //발신자 셋팅 , 보내는 사람의 이메일주소를 한번 더 입력합니다. 이때는 이메일 풀 주소를 다 작성해주세요.
        mimeMessage.setFrom(new InternetAddress(map.get("sendEmailAddress").toString()));
        //수신자셋팅
        mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(map.get("recieveEamilAddress").toString()));
	    mimeMessage.setSubject(map.get("subject").toString());
	    mimeMessage.setContent(map.get("content").toString(), "text/html; charset=utf-8");
	    mimeMessage.setSentDate(new Date());
	    
	    Transport.send(mimeMessage);
			
	}
	
	// 총 페이지 수 구하기          10			전체 게시물 수
	public int getPageCount(int numPerPage, int dataCount)
	{
		int pageCount = 0;			// 전체 게시물 수
		int remain = 0;				// 총 페이지 수
		
		// 총 페이지 수를 구하기 위한 나머지 계산
		remain = dataCount % numPerPage;
		
		System.out.println("=======> MyUtil_getPageCount remain :"+remain+":::::");
		
		if(remain == 0)
			pageCount = dataCount / numPerPage;
		else
			pageCount = dataCount / numPerPage + 1;
		
		System.out.println("=======> MyUtil_getPageCount 총 페이지 수(pageCount) :"+pageCount+":::::");
		
		return pageCount;
	}
	
	
	// 자바스크립트에 의한 페이지 처리
	public String pageIndexList(int current_page, int total_page)
	{
		StringBuffer strList = new StringBuffer();	// 페이지 처리 결과 담을 변수
		
		int numPerBlock = 10;						// 리스트에 나타낼 페이지 수
		int currentPageSetUp;
		int n;
		int page;
		
		if(current_page == 0)
			return "";
		
		// 표시할 첫 페이지
		currentPageSetUp = (current_page / numPerBlock) * numPerBlock;
		if(current_page % numPerBlock == 0)
			currentPageSetUp = currentPageSetUp - numPerBlock;
		
		// 1 페이지 : 총 페이지수가 numPerBlock 이상인 경우
		if( (total_page > numPerBlock) && (currentPageSetUp > 0) )
		{
			strList.append("<a href='javascript:listPage(1);'> 1 </a>");
		}
		
		// 이전 페이지 : 총 페이지수가 numPerBlock 이상인 경우 이전 numPerBlock 보여줌
		n = current_page - numPerBlock;
		if( (total_page > numPerBlock) && (currentPageSetUp > 0) )
		{
			strList.append("&nbsp;<span class='glyphicon glyphicon-fast-backward'onclick='javascript:listPage("+n+");' aria-hidden='true'></span>");
		}
		
		// 바로가기 페이지 구현
		page = currentPageSetUp + 1;
		while ( (page <= total_page) && (page <= currentPageSetUp + numPerBlock ) )
		{
			if(page == current_page)
			{
				strList.append("&nbsp;<span class='red'> "+page+" </span>");
			}
			else
			{
				strList.append("&nbsp;<a href='javascript:listPage("+page+");'> "+page+" </a>");
			}
			
			page++;
			
		}
		
		// 다음 페이지 : 총 페이지수가 numPerBlock 페이지 이상인 경우
		n = current_page + numPerBlock;
		if( (total_page - currentPageSetUp) > numPerBlock )
		{
			strList.append("&nbsp;<span class='glyphicon glyphicon-fast-forward'onclick='javascript:listPage("+n+");' aria-hidden='true'></span>");
		}
		
		// 마지막 페이지
		if( (total_page > numPerBlock) && (currentPageSetUp + numPerBlock < total_page))
		{
			strList.append("&nbsp;<a href='javascript:listPage("+total_page+");'> "+total_page+" </a>");
		}
		
		return strList.toString();
		
	}
	
}
