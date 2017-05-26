<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>게시판 상세내용</title>
<!-- Jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<c:url value='resources/js/boardjs.js'/>"></script>
<link rel="stylesheet" href="<c:url value='resources/css/boardDetailCSS.css'/>">
</head>
<body>
<form method="post" id="bdDetailForm">
	<input type="hidden" id="bdSid" name="bdSid" value="${bdDetail.BD_SID }"/>
</form>

<div class="container">
	<div class="page-header">
		<h1>게시판 상세내용</h1>
	</div>
	
	<div class="row">
		<div class="col-xs-5">
			<button type="button" class="btn btn-default" onclick="location.href='/prj01/boardwrite'">
				<span class="glyphicon glyphicon-pencil"></span> 글쓰기
			</button>
			<button type="button" class="btn btn-default">답글</button>
			
			<button type="button" class="btn btn-default">수정</button>
			<button type="button" class="btn btn-default">글삭제</button>
			
		</div>
		<div class="col-xs-4"></div>
		<div class="col-xs-3 flotR">
			<button type="button" class="btn btn-link" id="bdListGo" onclick="location.href='/prj01/boardlist'"> 목록</button>
			<button type="button" class="btn btn-link">
				<span class="glyphicon glyphicon-menu-up"></span> 윗글
			</button>
			<button type="button" class="btn btn-link">
				<span class="glyphicon glyphicon-menu-down"></span> 아랫글
			</button>
		</div>
	</div>
	<p>
	
	<!-- 제목 -->
	
	<div class="well">
		<div class="row txtTitle">
			<div class="col-xs-7">${bdDetail.BD_TITLE}</div>
		</div>
	</div>
	
	<!-- 본문 메인 내용 -->
	
	<div class="UDmargin">
		<div class="nickMargin">
			${bdDetail.MEM_NICK} | 조회 ${bdDetail.BD_CLI} | 추천 ${bdDetail.BD_LIKE} | ${bdDetail.BD_REGI}
		</div>
		<p>
		<div>${bdDetail.BD_CONT}</div>
		<p>
		<p>
		<div class="row ectMargin">
			<div class="col-xs-2"> 댓글 ${bdDetail.REPLCOUNT} </div>
			<div class="col-xs-8">
			</div>
			<div class="flotR">
				<a href="#" class="btn btn-info btn-default">
		        	<span class="glyphicon glyphicon-thumbs-up"></span> Like &nbsp; <span class="badge">${bdDetail.BD_LIKE}</span>
		        </a>
		        <button type="button" class="btn btn-link">신고</button>
			</div>
		</div>
		<p>
	</div>
	
	<!-- 댓글 시작 -->
	
	<div class="well">
	<c:forEach var="replList" items="${bdDetailRepl }" varStatus="status">
		<c:if test="${status.index != 0 && replList.REPL_DEPT == 0}">
			<hr class="replGubun">
		</c:if>
		
		<dl>
			<dt class="replMargin">
				${replList.MEM_NICK } <span class="replTime">${replList.REPL_REGI }</span>
				<span class="flotR"><a href="#"> 답글 </a> | <a href="#"> 신고</a></span>
			</dt>
			<dd class="replMargin">${replList.REPL_CONT }</dd>
		</dl>
	</c:forEach>
		
	<form class="form-horizontal" id="replyForm">
		<div class="form-group">
			<div class="col-sm-11">
				<textarea rows="3" class="form-control"></textarea>
			</div>
			<div class="col-sm-1">
				<p class="replBtn">등록</p>
			</div>
		</div>
	</form>
		
	</div>
	
	
</div>

</body>
</html>