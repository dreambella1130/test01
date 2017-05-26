$(document).ready(function()
{

});


// 목록 상세 페이지로 가기
function goSelect(bdsid)
{
	$("#bdSid").val(bdsid);
	$("#submitForm").attr("action", "/prj01/bddetail");
	$("#submitForm").submit();
}