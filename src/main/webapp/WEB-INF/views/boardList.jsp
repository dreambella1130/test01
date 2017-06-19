<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>자유게시판</title>
<!-- Jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<!-- script 태그에서 가져오는 자바스크립트 파일의 순서에 주의해야한다! 순서가 틀릴경우 자바스크립트 오류가 발생한다. -->
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/rsa/jsbn.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/rsa/rsa.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/rsa/prng4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/rsa/rng.js"></script>

<script type="text/javascript" src="<c:url value='resources/js/boardjs.js'/>"></script>
<link rel="stylesheet" href="<c:url value='resources/css/boardListCSS.css'/>">

<script type="text/javascript">
	
	$(document).ready(function()
	{
		var numPer = "";		//-- 한페이지 목록 보기 갯수
		var searchKey = "";		//-- 검색 항목
		var searchValue = "";	//-- 검색 어

		numPer = "${searchData.numPer }";
		searchKey = "${searchData.searchKey }";
		searchValue = "${searchData.searchValue }";
		
		if(numPer != "" && numPer != null)
		{
			$("#num_per option[value="+numPer+"]").attr("selected", "selected");
		}
		if(searchValue != "" && searchValue != null)
		{
			$("#searchOption option[value='"+searchKey+"']").attr("selected", "selected");
			$("#searchTxt").val(searchValue);
			
		}
		
	});
	
</script>
</head>
<body>
<form method="post" id="submitForm">
	<input type="hidden" name="${_csrdf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" id="bdSid" name="bdSid"/>
	<input type="hidden" id="bd_grp_sid" name="bd_grp_sid">
	<input type="hidden" id="bd_grp_LV" name="bd_grp_LV">
	<input type="hidden" id="searchKey" name="searchKey" value=${searchData.searchKey }>
	<input type="hidden" id="searchValue" name="searchValue" value=${searchData.searchValue }>
	<input type="hidden" id="pageNum" name="pageNum" value=${searchData.pageNum }>
	<input type="hidden" id="numPer" name="numPer" value=${searchData.numPer }>
	<input type="hidden" id="RSAModulus"/>
	<input type="hidden" id="RSAExponent"/>
</form>
<div class="container">
	<div class="page-header row">
		<div> <c:import url="headbar.jsp"/> </div>
		<div class="col-sm-3">
			<h1> 자유게시판 </h1>
		</div>
		<div class="col-sm-6"></div>
		<div class="col-sm-3"></div>
	</div>
	
	<div class="row">
		<div class="col-md-3">
			<button type="button" class="btn btn-default" onclick=${sessionScope.memSid == null ? 'loginModal()':'location.href="/prj01/gobdwrite"'}>
				<span class="glyphicon glyphicon-pencil"></span> 글쓰기
			</button>
		</div>
		<div class="col-md-7"></div>
		<div class="col-md-2">
			<select id="num_per" class="form-control">
				<option value="2">목록 2개</option>
				<option value="5">목록 5개</option>
				<option value="10" selected="selected">목록 10개</option>
			</select>
		</div>
		
		<table class="table table-hover titleMargin">
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
				<c:if test="${fn:length(list) == 0}"> <tr><td colspan="6" class="txCenter">등록된 게시글이 없습니다. </td></tr></c:if>
				<c:forEach var="list" items="${list }">
					<tr>
						<td class="txCenter">${list.BD_SID }</td>
						<td style="padding-left: ${list.BD_GRP_DEP != 0 ? (list.BD_GRP_DEP*3) : ''}%;">
							<c:choose>
								<c:when test="${list.BD_BLCK == 'Y' }">
									신고된 게시글입니다.
								</c:when>
								<c:otherwise>
									<a href="#" onclick="goSelect(${list.BD_SID }, ${list.BD_GRP_SID },${list.BD_GRP_LV }); return false;">${list.BD_TITLE } &nbsp; &nbsp;
									<span class="badge">${list.REPLCOUNT }</span></a><br>
								</c:otherwise>
							</c:choose>
						</td>
						<td class="txCenter">${list.MEM_NICK }</td>
						<td class="txCenter">${list.BD_REGI }</td>
						<td class="txCenter">${list.BD_CLI}</td>
						<td class="txCenter">${list.BD_LIKE }</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<hr />
		<!-- 페이징 처리 부분 ----------------------------------------------------------------------------------->
		<div class="row">
			<div class="col-sm-2"></div>
			<div class="col-sm-8">
				<ul class="pager">
					<li>${searchData.pageIndexList }</li>
				</ul>
			</div>
			<div class="col-sm-2"></div>
		</div>
		
		<!-- 검색 부분 ------------------------------------------------------------------------------------------->
		<div class="row">
			<div class="col-sm-2"></div>
			<div class="col-sm-2">
				<select class="form-control" id="searchOption">
					<option value="bdall">제목+내용</option>
					<option value="bdTitle">제목</option>
					<option value="bdCont">내용</option>
					<option value="bdUser">작성자</option>
				</select>
			</div>
			<div class="col-sm-5">
				<input type="text" class="form-control" id="searchTxt" placeholder="검색어를 입력하세요"/>
			</div>
			<div class="col-sm-1">
				<button type="button" class="btn btn-primary" id="searchBtn">검색</button>
			</div>
			<div class="col-sm-2"></div>
		
		</div>
		
	</div>
</div>

</body>
</html>