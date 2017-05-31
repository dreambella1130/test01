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

<script type="text/javascript" src="<c:url value='resources/js/boardjs.js'/>"></script>
<link rel="stylesheet" href="<c:url value='resources/css/boardWriteCSS.css'/>">

<script type="text/javascript">
	var oEditors = [];
	
	$(function()
	{
		var temp = "";
		
		temp = "${bdReple.bd_title }";
		
		if(temp != null && temp != "")
		{
			$("#bdTitle").val("RE: "+temp);
		}
		
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
			$("#bdInsertForm").attr("action", "/prj01/boardinsert");
			$("#bdInsertForm").submit();
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
		<h1>게시판 글쓰기</h1>
	</div>
	<br /><br />
	<form class="form-group" id="bdInsertForm" method="post">
		<input type="hidden" name="bd_grp_sid" value="${bdReple.bd_grp_sid }"/>
		<input type="hidden" name="bd_grp_LV" value="${bdReple.bd_grp_LV }"/>
		<input type="hidden" name="bd_grp_dep" value="${bdReple.bd_grp_dep }"/>
		<input type="hidden" name="repleCheck" value="${bdReple.repleCheck }"/>
	
		<div class="inputMargin">
			<input class="form-control" type="text" id="bdTitle" name="bdTitle" placeholder="제목을 입력해 주세요" >
		</div>
		<div class="inputMargin">
			<textarea class="form-control" rows="20" id="bdContent" name="bdContent" style='width:100%; min-width:260px; height:30em; display:none;'></textarea>
		</div>
		<div class="inputMargin bdCon_Btn">
			<button type="button" class="btn btn-default" id="bdSave">확인</button>
			<button type="button" class="btn btn-default" onclick="location.href='/prj01/boardlist'">취소</button>
		</div>
		
	</form>

</div>

</body>
</html>