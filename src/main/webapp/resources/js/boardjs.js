$(document).ready(function()
{
	// 수정 취소버튼 클릭 시 모달 팝업창 띄움 - 호출 : boardUpdate.jsp
	$("#updateCancel").click(function()
	{
		$("#myModal").modal();
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

function updateCancel()
{
	$("#bdUpdateForm").attr("action", "/prj01/bddetail");
	$("#bdUpdateForm").submit();
}

