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
	
	// 댓글 입력 시 글자 수 체크하여 표시하기 - 호출 : boardDetail.jsp
	$(".replTxtLength").bind("change keyup input", function()
	{
		var text = $(this).attr("id");
		//alert("***********"+$("#"+text).val()+"***********");
		
		if($("#"+text).val().length <= 150)
		{
			$("."+text+"_chk").html($("#"+text).val().length);
		}
		else
		{
			alert("최대 150자이므로 초과된 글자수는 자동으로 삭제됩니다.")
			$("#"+text).val($("#"+text).val().substring(0, 150));
			$("#"+text).focus();
		}
		
		
	});
	
	// 댓글 입력 버튼 눌렀을 때	- 호출 : boardDetail.jsp
	$(".gesiReplBtn").click(function()
	{
		//alert("댓글 등록 이벤트 호출");
		alert("*****"+$(this).siblings().find('textarea').attr("id")+"*****");
		
		var newOldChk = $(this).siblings().find('textarea').attr("id");
		
		
		txtChk = $("#"+newOldChk).val().trim();
		
		if(txtChk == null || txtChk == "")
		{
			alert("내용을 입력해 주세요.");
			
			// textarea 공백 없애주기
			$("#"+newOldChk).val(txtChk);
			$("#"+newOldChk).focus();
			
			// 입력한 글자 수 0으로 만들어주기
			$("."+newOldChk+"_chk").html($("#"+newOldChk).val().length);
			
			return;
		}
		
		if(newOldChk == 'newReplCon')
		{
			//alert("댓글 신규등록 :"+txtChk+"*******");
			$("#bd_gesi_repl_Chk").val("NewRepl");
			$("#submitForm").attr("action", "/prj01/goinsertgesirepl");
		}
		else
		{
			//alert("댓글 수정 번호:"+newOldChk.substring(newOldChk.indexOf('_')+1)+"*******");
			
			// 댓글 수정 체크를 위해 값 넣어주기
			$("#bd_gesi_repl_Chk").val("updateRepl");
			$("#bd_gesi_repl_sid").val(newOldChk.substring(newOldChk.indexOf('_')+1));
			$("#submitForm").attr("action", "/prj01/goupdategesirepl");
		}
		
		$("#bd_gesi_repl_cont").val(txtChk);
		$("#submitForm").submit();
		
	}); // end $(".gesiReplBtn").click()
	
	
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

// 댓글 수정 폼 보여주기
function repleEdit(replSid)
{
	// 기본 셋팅
	$(".hiddenRepl").hide();
	$(".showRepl").show();
	
	// 요청온 수정 댓글 폼 보여주기
	$("#origin_"+replSid).hide();
	$("#edit_"+replSid).show();
	
}

// 댓글 삭제 요청 시 모달 팝업 띄워서 삭제여부 재확인하기
function repleDelete(replSid)
{
	 $("#replModal").modal();
	 // 삭제 예정 댓글 번호 저장
	 $("#bd_gesi_repl_sid").val(replSid);
}

// 댓글 삭제 폼 전송
function goDeleteRepl()
{
	$("#submitForm").attr("action","/prj01/godeletereple");
	$("#submitForm").submit();
}
