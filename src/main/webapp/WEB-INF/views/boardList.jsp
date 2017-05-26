<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>게시판 목록</title>
<!-- Jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<c:url value='resources/js/boardjs.js'/>"></script>
<link rel="stylesheet" href="<c:url value='resources/css/boardListCSS.css'/>">
</head>
<body>
<form method="post" id="submitForm">
	<input type="hidden" id="bdSid" name="bdSid"/>
</form>
<div class="container">
	<div class="page-header">
		<h1>게시판 목록</h1>
	</div>
	
	<div class="row">
		<div class="col-md-3">
			<button type="button" class="btn btn-default" onclick="location.href='/prj01/boardwrite'">
				<span class="glyphicon glyphicon-pencil"></span> 글쓰기
			</button>
		</div>
		<div class="col-md-8"></div>
		
		<table class="table table-hover">
			<thead>
				<tr class="txCenter">
					<th style="width: 5%"></th>
					<th style="width: 60%">제목</th>
					<th style="width: 15%" class="txCenter">글쓴이</th>
					<th style="width: 10%" class="txCenter">작성일</th>
					<th style="width: 5%" class="txCenter">조회</th>
					<th style="width: 5%" class="txCenter">추천</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="list" items="${list }">
					<tr>
						<td class="txCenter">${list.NUM }</td>
						<td>
							<a href="#" onclick="goSelect(${list.BD_SID }); return false;">${list.BD_TITLE } &nbsp; &nbsp;
							<span class="badge">${list.REPLCOUNT }</span></a><br>
						</td>
						<td class="txCenter">${list.MEM_NICK }</td>
						<td class="txCenter">${list.BD_REGI }</td>
						<td class="txCenter">${list.BD_CLI}</td>
						<td class="txCenter">${list.BD_LIKE }</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>

</body>
</html>