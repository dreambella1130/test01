$(document).ready(function()
{
	var clientIP = "";		// 사용자 ip 담을 변수
	var txtChk = "";		// text 임시 변수
	
	// 수정 취소버튼 클릭 시 모달 팝업창 띄움 - 호출 : boardUpdate.jsp
	$("#updateCancel").click(function()
	{
		$("#myModal").modal();
	});
	
	// 사용자 접속 ip 알아내기
	$.getJSON("https://api.ipify.org?format=jsonp&callback=?", function(json)
	{
		clientIP = json.ip;
		 
	});
	
	// 게시글에 좋아요 클릭 이벤트 - 호출 : boardDetail.jsp
	$(".goVote").click(function()
	{
		var voteType = $(this).attr("id");
		var url="/prj01/voteboard";		// 추천 또는 신고 클릭 시 처리 할 주소
	    var params="bdSid="+$("#bdSid").val()+"&voteType="+voteType+"&clientIP="+clientIP;
	    
	    //alert("클릭 이벤트 :"+$(this).attr("id"));
	    //alert("**********params :"+params+"**********");
	    
		// ip 중복 검사 후 좋아요 숫자 +1 해주기
		$.ajax(
	    {    
	        type:"POST",  
	        url:url,      
	        data:params,
	        success:function(args)
	        {
	        	//alert("********중복체크 :"+args.result+"********");
	        	
	        	if(voteType == "likeBoard")	// 추천 클릭의 경우
	        	{
	        		if(args.result == "Y")
		        	{
		        		alert("이미 추천하셨습니다.");
		        	}
		        	else
		        	{
		        		$(".countLike").html(args.result);
		        	}
	        	}
	        	else if(voteType == "badBoard")	// 신고 클릭의 경우
	        	{
	        		if(args.result == "Y")
		        	{
		        		alert("이미 신고하셨습니다.");
		        	}
	        	}
	        	
	        },   
	        error:function(e)
	        {  
	            alert(e.responseText);  
	        }
	        
	    }); // -- end $.ajax()
		
	});	//-- end $(".goVote").click()
	
	// 댓글 입력 버튼 눌렀을 때	- 호출 : boardDetail.jsp
	$("#gesiReplBtn").click(function()
	{
		//alert("댓글 입력 클릭 이벤트 호출");
		txtChk = $("#replCont").val().trim();
		
		if(txtChk == null || txtChk == "")
		{
			alert("내용을 입력해 주세요.");
			$("#replCont").val(txtChk);
			$("#replCont").focus();
			
			return;
		}
		
		$("#bd_gesi_repl").val(txtChk);
		$("#submitForm").attr("action", "/prj01/goinsertgesirepl");
		$("#submitForm").submit();
		
	});
	
});

// 목록 상세 페이지로 가기 - 호출 : boardList.jsp
function goSelect(bdsid, bd_grp_sid, bd_grp_LV)
{
	$("#bdSid").val(bdsid);
	$("#bd_grp_sid").val(bd_grp_sid);
	$("#bd_grp_LV").val(bd_grp_LV);
	
	$("#submitForm").attr("action", "/prj01/bddetail");
	$("#submitForm").submit();
}

// 글 수정폼으로 가기 - 호출 : boardDetail.jsp
function goBDEdit()
{
	$("#submitForm").attr("action", "/prj01/gobdedit");
	$("#submitForm").submit();
	
}

// 글 삭제하기 - 호출 : boardDetail.jsp
function goBDDelete()
{
	$("#submitForm").attr("action", "/prj01/godelete");
	$("#submitForm").submit();
}

// 수정 취소 버튼 선택 시 글 상세보기 view로 돌아가기 - 호출 : boardUpdate.jsp
function updateCancel()
{
	$("#bdUpdateForm").attr("action", "/prj01/bddetail");
	$("#bdUpdateForm").submit();
}

// 답글 폼으로 이동 - 호출 : boardDetail.jsp
function goBoardReple()
{
	$("#submitForm").attr("action", "/prj01/bdrepleform");
	$("#submitForm").submit();
}

