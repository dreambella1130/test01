$(document).ready(function()
{
	// 수정 취소버튼 클릭 시 모달 팝업창 띄움 - 호출 : boardUpdate.jsp
	$("#updateCancel").click(function()
	{
		$("#myModal").modal();
	});
	
	// 게시글에 좋아요 클릭 이벤트 - 호출 : boardDetail.jsp
	$("#voteLike").click(function()
	{
		alert("클릭 이벤트");
		
		var url="/prj01/voteboard";  
	    var params="bdSid="+$("#bdSid").val()+"&voteType=likeBoard";
	  
	    $.ajax(
	    {      
	        type:"POST",  
	        url:url,      
	        data:params,
	        success:function(args){   
	            $(".countLike").html(args);
	        },   
	        beforeSend:showRequest,  
	        error:function(e){  
	            alert(e.responseText);  
	        }  
	    });  

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
