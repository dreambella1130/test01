$(document).ready(function()
{
	var clientIP = "";		// 사용자 ip 담을 변수
	var txtChk = "";		// text 임시 변수
	
	// 수정 취소버튼 클릭 시 모달 팝업창 띄움 - 호출 : boardUpdate.jsp
	$("#updateCancel").click(function()
	{
		$("#myModal").modal();
	});
	
	// 게시글에 좋아요 클릭 이벤트 - 호출 : boardDetail.jsp
	$(".goVote").click(function()
	{
		var voteType = $(this).attr("id");
		var url="/prj01/voteboard";		// 추천 또는 신고 클릭 시 처리 할 주소
	    var params="bdSid="+$("#bdSid").val()+"&voteType="+voteType+
	    
	    //alert("클릭 이벤트 :"+$(this).attr("id"));
	    //alert("**********params :"+params+"**********");
	    
	    // 사용자 접속 ip 알아내기
	    $.getJSON("https://api.ipify.org?format=jsonp&callback=", function(json)
		{
			params = params + "&clientIP="+json.ip;
			
			//alert("******접속 IP 호출 :"+json.ip);
			
			// 좋아요 +1 해주기
			updateLike(voteType, url, params);
			 
		}); // end $.getJSON()
		
		
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
		
		
	}); // end $(".replTxtLength").bind()
	
	// 댓글 입력 버튼 눌렀을 때	- 호출 : boardDetail.jsp
	$(".gesiReplBtn").click(function()
	{
		//alert("댓글 등록 이벤트 호출");
		//alert("*****"+$(this).parent().siblings().find('textarea').attr("id")+"*****");
		
		var newOldChk = $(this).parent().siblings().find('textarea').attr("id");
		
		
		txtChk = $("#"+newOldChk).val().trim();
		
		//alert("*****"+newOldChk.substring(0,newOldChk.indexOf('_')) + "*****");
		
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
		
		// 신규 댓글 작성
		if(newOldChk == 'newReplCon')
		{
			//alert("댓글 신규등록 :"+txtChk+"*******");
			$("#bd_gesi_repl_Chk").val("NewRepl");
			$("#submitForm").attr("action", "/prj01/goinsertgesirepl");
		}
		else if(newOldChk.substring(0, newOldChk.indexOf('_')) == "replReNew")
		{
			//alert("댓글 답변 등록 :"+txtChk+"*******");
			$("#bd_gesi_repl_Chk").val("replReNew");
			$("#submitForm").attr("action", "/prj01/goinsertgesirepl");
		}
		else if(newOldChk.substring(0, newOldChk.indexOf('_')) == "editTxt")
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
	
	//  목록에서 검색 버튼 눌렀을 때 - 호출 : boardList.jsp
	$("#searchBtn").click(function()
	{
		//alert("***** 검색버튼 클릭 이벤트 ");
		//alert("***"+$("#searchOption option:selected").val());
		
		var txt = $("#searchTxt").val().trim();
		
		if(txt == "" || txt == null)
		{
			alert("검색어를 입력하세요.");
			$("#searchTxt").val(txt);
			$("#searchTxt").focus();
			
			return;
		}
		
		
		$("#searchKey").val($("#searchOption option:selected").val());
		$("#searchValue").val(txt);
		$("#submitForm").attr("action", "/prj01/boardlist");
		$("#submitForm").submit();
		
	});	// end $("#searchBtn").click()
	
	// 게시판 목록에서 목록 출력 갯수 변경 시 - 호출 : boardList.jsp
	$("#num_per").change(function()
	{
		//alert("목록 갯수 변경 이벤트");
		
		$("#numPer").val($("#num_per option:selected").val());
		$("#submitForm").attr("action", "/prj01/boardlist");
		$("#submitForm").submit();
	});
	
	// 로그인 모달 파업 내 로그인 버튼 클릭 이벤트 - 호출 : boardList.jsp
	$("#loginChk").click(function()
	{
		//alert("로그인 체크 호출");
		
		var usrname = $("#usrname").val().trim();
		var pwd = $("#psw").val().trim();
		
		if(usrname == null || usrname == "")
		{
			alert("아이디(이메일 주소)를 입력해주세요");
			$("#usrname").val(usrname);
			$("#usrname").focus();
			
			return;
		}
		
		if(pwd == null || pwd == "")
		{
			alert("비밀번호를 입력해주세요");
			$("#psw").val(pwd);
			$("#psw").focus();
			
			return;
		}
		
		$.ajax(
	    {    
	        type:"POST",  
	        url: "/prj01/login",      
	        data: {mem_id : $("#usrname").val().trim(), mem_pw : $("#psw").val()},
	        success:function(args)
	        {
	        	if(args.MEM_NICK == null || args.MEM_NICK == "")
	        	{
	        		//alert("args.MEM_NICK :"+args.MEM_NICK);
	        		$("#loginError").show();
	        		$("#psw").val("");
	        		$("#usrname").focus();
	        	}
	        	else
	        	{
	        		var currentURL = "";
	        		currentURL = $(location).attr('pathname');
	        		
	        		//alert("*** 현재 url 확인 :"+currentURL+"****");
	        		$("#submitForm").attr("action", currentURL);
	        		$("#submitForm").submit();
	        	}
	        	
	        },   
	        error:function(request,status,error)
	        {  
	        	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

	        }
	        
	    }); // -- end $.ajax()
		
	});	//-- end $("#loginChk").click()
	
	
});


//////////////////////////////////////////////////////////////////////////////////////////////////////

//목록 상세 페이지로 가기 - 호출 : boardList.jsp
function goSelect(bdsid, bd_grp_sid, bd_grp_LV)
{
	$("#bdSid").val(bdsid);
	$("#bd_grp_sid").val(bd_grp_sid);
	$("#bd_grp_LV").val(bd_grp_LV);
	
	$("#submitForm").attr("action", "/prj01/bddetail");
	$("#submitForm").submit();
}

//페이지 이동 함수	- 호출 : boardList.jsp
function listPage(pageNum)
{
	//alert("*******"+pageNum+"페이지로 이동");
	
	$("#pageNum").val(pageNum);
	$("#submitForm").attr("action", '/prj01/boardlist');
	$("#submitForm").submit();
}

// 로그인 없이 글쓰기 버튼 눌렀을 때 로그인 모달 팝업 호출 - 호출 : boardList.jsp
function loginModal()
{
	//alert("로그인 모달 팝업 호출");
	$("#loginModal").modal();
}


//////////////////////////////////////////////////////////////////////////////////////////////////////

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

// 답글 폼으로 이동 - 호출 : boardDetail.jsp
function goBoardReple()
{
	$("#submitForm").attr("action", "/prj01/bdrepleform");
	$("#submitForm").submit();
}

// 댓글 수정/답글 폼 보여주기 - 호출 : boardDetail.jsp
function repleEdit(replSid, gubun, reGrp, reLv, reDep)
{
	// 기본 셋팅
	$(".hiddenRepl").hide();
	$(".showRepl").show();
	$("#btn_"+replSid).hide();
	
	//alert("***** replSid :"+replSid+", gubun :"+ gubun);
	
	// 요청온 수정 댓글 폼 보여주기
	if(gubun == 'repleEdit')
	{
		$("#origin_"+replSid).hide();
		$("#edit_"+replSid).show();
		
	}
	else if(gubun == 'replReNew')
	{
		//alert("댓글의 답글 클릭");
		// 댓글의 답글 시 해당 textarea 보여주기
		$("#replRepl_"+replSid).show();
		
		// 답글 등록을 위한 원글에 대한 그룹번호, 그룹순서 등 값 설정해주기
		$("#bd_gesi_repl_grp").val(reGrp);
		$("#bd_gesi_repl_LV").val(reLv);
		$("#bd_gesi_repl_dep").val(reDep);
		
	}
	
	
}

// 댓글 삭제 요청 시 모달 팝업 띄워서 삭제여부 재확인하기 - 호출 : boardDetail.jsp
function repleDelete(replSid)
{
	 $("#replModal").modal();
	 // 삭제 예정 댓글 번호 저장
	 $("#bd_gesi_repl_sid").val(replSid);
}

// 댓글 삭제 폼 전송 - 호출 : boardDetail.jsp
function goDeleteRepl()
{
	$("#submitForm").attr("action","/prj01/godeletereple");
	$("#submitForm").submit();
}

//좋아요 +1 해주기 - 호출 : boardDetail.jsp
function updateLike(voteType, url, params)
{
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
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

//수정 취소 버튼 선택 시 글 상세보기 view로 돌아가기 - 호출 : boardUpdate.jsp
function updateCancel()
{
	$("#bdUpdateForm").attr("action", "/prj01/bddetail");
	$("#bdUpdateForm").submit();
}

