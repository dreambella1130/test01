<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>게시판 글쓰기</title>
<!-- Jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<!-- 네이버 스마트 에디터 -->
<script type="text/javascript" src="<c:url value='resources/editor/js/service/HuskyEZCreator.js'/>"></script>

<link rel="stylesheet" href="<c:url value='resources/css/boardWriteCSS.css'/>">

<script type="text/javascript">
	var oEditors = [];
	
	$(function()
	{
		nhn.husky.EZCreator.createInIFrame(
		{
			oAppRef: oEditors,
	        elPlaceHolder: "bdContent",	//textarea에서 지정한 id와 일치해야 합니다. 
	        //SmartEditor2Skin.html 파일이 존재하는 경로
			sSkinURI: "resources/editor/SmartEditor2Skin.html",  
			htParams :
			{
				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseToolbar : true,             
				// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,     
				// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,         
				fOnBeforeUnload : function()
				{
				     
				}
			}, 
			fOnAppLoad : function()
			{
			    //기존 저장된 내용의 text 내용을 에디터상에 뿌려주고자 할때 사용
			    //oEditors.getById["bdContent"].exec("PASTE_HTML", ["기존 DB에 저장된 내용을 에디터에 적용할 문구"]);
			},
			fCreator: "createSEditor2"
		});
	      
		//확인버튼 클릭시 form 전송
		$("#bdSave").click(function()
	    {
			//id가 bdContent인 textarea에 에디터에서 대입
			oEditors.getById["bdContent"].exec("UPDATE_CONTENTS_FIELD", []);
			
			// 이부분에 에디터 validation 검증
			
			var txt = "";
			
			txt = $("#bdTitle").val().trim();
			
			if(txt == null || txt == "")
			{
				alert("제목을 입력하세요.");
				$("#bdTitle").focus();
				
				return;
			}
			
			txt = $("#bdContent").val();
			// 유효성 검사를 위해 html 태그 제거 하기
			txt = removeTag(txt);
			
			if(txt == null || txt == "")
			{
				alert("내용을 입력하세요.");
				oEditors.getById["bdContent"].exec("FOCUS"); //포커싱
				return;
			}
			
			//폼 submit
			$("#bdUpdateForm").attr("action", "/prj01/boardupdate");
			$("#bdUpdateForm").submit();
		});    
	});
	
	// html 태그 제거하기
	function removeTag( html )
	{
	    return html.replace(/(<([^>]+)>)/gi, "").replace(/&nbsp;/ig, "").trim();
	}
 
</script>

</head>
<body>
<div class="container">
	<div class="page-header">
		<h1>게시글 수정하기</h1>
	</div>
	<br /><br />
	<form class="form-group" id="bdUpdateForm" method="post">
		<input type="hidden" name="${_csrdf.parameterName}" value="${_csrf.token}"/>
		<input type="hidden" id="bdSid" name="bdSid" value="${bdDetail.BD_SID }"/>
		<input type="hidden" id="bd_grp_sid" name="bd_grp_sid" value="${bdDetail.BD_GRP_SID }">
		<input type="hidden" id="bd_grp_LV" name="bd_grp_LV" value="${bdDetail.BD_GRP_LV }">
		<div class="inputMargin">
			<input class="form-control" type="text" id="bdTitle" name="bdTitle" value="${bdDetail.BD_TITLE }">
		</div>
		<div class="inputMargin">
			<textarea class="form-control" rows="20" id="bdContent" name="bdContent" style='width:100%; min-width:260px; height:30em; display:none;'>
				${bdDetail.BD_CONT }
			</textarea>
		</div>
		<div class="inputMargin bdCon_Btn">
			<button type="button" class="btn btn-primary" id="bdSave">수정</button>
			<button type="button" class="btn btn-default" id="updateCancel">취소</button>
		</div>
	</form>
	
 <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">이 사이트에서 나가시겠습니까?</h4>
        </div>
        <div class="modal-body">
          <p>변경사항이 저장되지 않을 수 있습니다.</p>
        </div>
        <div class="modal-footer">
        	<button type="button" class="btn btn-primary" onclick="updateCancel();">나가기</button>
          	<button type="button" class="btn btn-default" data-dismiss="modal">머무르기</button>
        </div>
      </div>
      
    </div>
  </div>

</div>

</body>
<script type="text/javascript" src="<c:url value='resources/js/boardjs.js'/>"></script>
</html>