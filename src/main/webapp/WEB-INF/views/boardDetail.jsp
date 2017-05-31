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
<form method="post" id="submitForm">
	<input type="hidden" id="bdSid" name="bdSid" value="${bdDetail.BD_SID }"/>
	<input type="hidden" id="bd_grp_sid" name="bd_grp_sid" value="${bdDetail.BD_GRP_SID }">
	<input type="hidden" id="bd_grp_LV" name="bd_grp_LV" value="${bdDetail.BD_GRP_LV }">
	<input type="hidden" id="bd_grp_LV" name="bd_grp_dep" value="${bdDetail.BD_GRP_DEP }">
	<input type="hidden" id="bd_title" name="bd_title" value="${bdDetail.BD_TITLE}">
</form>

<div class="container">
	<div class="page-header">
		<h1>게시판 상세내용</h1>
	</div>
	
	<div class="row">
		<div class="col-xs-5">
			<button type="button" class="btn btn-default" onclick="location.href='/prj01/gobdwrite'">
				<span class="glyphicon glyphicon-pencil"></span> 글쓰기
			</button>
			<button type="button" class="btn btn-default" onclick="goBoardReple();">답글</button>
			
			<button type="button" class="btn btn-default" onclick="goBDEdit();">수정</button>
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">글삭제</button>
			
		</div>
		<div class="col-xs-4"></div>
		<div class="col-xs-3 flotR">
			<button type="button" class="btn btn-link" id="bdListGo" onclick="location.href='/prj01/boardlist'"> 목록</button>
		<c:choose>
			<c:when test="${getPreNextGesi['nextGesi'] != null && getPreNextGesi['nextGesi'].BD_BLCK == 'N'}">
				<button type="button" class="btn btn-link"
						onclick="goSelect(${getPreNextGesi['nextGesi'].BD_SID}, ${getPreNextGesi['nextGesi'].BD_GRP_SID}, ${getPreNextGesi['nextGesi'].BD_GRP_LV});">
					<span class="glyphicon glyphicon-menu-up" ></span> 윗글
				</button>
			</c:when>
			<c:otherwise>
				<button type="button" class="btn btn-link" disabled="disabled">
					<span class="glyphicon glyphicon-menu-up" ></span> 윗글
				</button>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${getPreNextGesi['preGesi'] != null && getPreNextGesi['preGesi'].BD_BLCK == 'N'}">
				<button type="button" class="btn btn-link" 
					onclick="goSelect(${getPreNextGesi['preGesi'].BD_SID}, ${getPreNextGesi['preGesi'].BD_GRP_SID}, ${getPreNextGesi['preGesi'].BD_GRP_LV});">
					<span class="glyphicon glyphicon-menu-down"></span> 아랫글
				</button>
			</c:when>
			<c:otherwise>
				<button type="button" class="btn btn-link" disabled="disabled">
					<span class="glyphicon glyphicon-menu-down"></span> 아랫글
				</button>
			</c:otherwise>
		</c:choose>
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
			${bdDetail.MEM_NICK} | 조회 ${bdDetail.BD_CLI} |
			추천 <span class="countLike">${bdDetail.BD_LIKE}</span> | ${bdDetail.BD_REGI}
		</div>
		<p>
		<div>${bdDetail.BD_CONT}</div>
		<p>
		<p>
		<div class="row ectMargin">
			<div class="col-xs-2 replCount"> 댓글 ${bdDetail.REPLCOUNT} </div>
			<div class="col-xs-8">
			</div>
			<div class="flotR">
				<a href="#" class="btn btn-info btn-default" id="voteLike">
		        	<span class="glyphicon glyphicon-thumbs-up"></span> Like &nbsp; <span class="badge countLike">${bdDetail.BD_LIKE}</span>
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
		<input type="hidden" name="">
		<div class="form-group">
			<div class="col-sm-11">
				<textarea rows="3" class="form-control" id="" name="" placeholder="댓글을 입력해주세요"></textarea>
			</div>
			<div class="col-sm-1">
				<p class="replBtn">등록</p>
			</div>
		</div>
	</form>
		
	</div>
	<p>
	<div class="row">
		<div class="col-xs-5">
			<button type="button" class="btn btn-default" onclick="location.href='/prj01/boardwrite'">
				<span class="glyphicon glyphicon-pencil"></span> 글쓰기
			</button>
			<button type="button" class="btn btn-default" onclick="goBoardReple();">답글</button>
			
			<button type="button" class="btn btn-default" onclick="goBDEdit();">수정</button>
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">글삭제</button>
			
		</div>
		<div class="col-xs-4"></div>
		<div class="col-xs-3 flotR">
			<button type="button" class="btn btn-link" id="bdListGo" onclick="location.href='/prj01/boardlist'"> 목록</button>
		<c:choose>
			<c:when test="${getPreNextGesi['nextGesi'] != null && getPreNextGesi['nextGesi'].BD_BLCK == 'N'}">
				<button type="button" class="btn btn-link"
						onclick="goSelect(${getPreNextGesi['nextGesi'].BD_SID}, ${getPreNextGesi['nextGesi'].BD_GRP_SID}, ${getPreNextGesi['nextGesi'].BD_GRP_LV});">
					<span class="glyphicon glyphicon-menu-up" ></span> 윗글
				</button>
			</c:when>
			<c:otherwise>
				<button type="button" class="btn btn-link" disabled="disabled">
					<span class="glyphicon glyphicon-menu-up" ></span> 윗글
				</button>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${getPreNextGesi['preGesi'] != null && getPreNextGesi['preGesi'].BD_BLCK == 'N'}">
				<button type="button" class="btn btn-link" 
					onclick="goSelect(${getPreNextGesi['preGesi'].BD_SID}, ${getPreNextGesi['preGesi'].BD_GRP_SID}, ${getPreNextGesi['preGesi'].BD_GRP_LV});">
					<span class="glyphicon glyphicon-menu-down"></span> 아랫글
				</button>
			</c:when>
			<c:otherwise>
				<button type="button" class="btn btn-link" disabled="disabled">
					<span class="glyphicon glyphicon-menu-down"></span> 아랫글
				</button>
			</c:otherwise>
		</c:choose>
		</div>
	</div>
	<br>
	<div class="row">
		<div class="col-xs-3">
		<c:choose>
			<c:when test="${getPreNextGesi['nextGesi'] != null}">
				<button type="button" class="btn btn-link" ${getPreNextGesi['nextGesi'].BD_BLCK == 'Y' ? 'disabled' : '' }
					onclick="goSelect(${getPreNextGesi['nextGesi'].BD_SID}, ${getPreNextGesi['nextGesi'].BD_GRP_SID}, ${getPreNextGesi['nextGesi'].BD_GRP_LV});">
					<span class="glyphicon glyphicon-menu-up"></span> 윗글
				</button>
			</c:when>
			<c:otherwise>
				<button type="button" class="btn btn-link" disabled="disabled">
					<span class="glyphicon glyphicon-menu-up"></span> 윗글
				</button>
			</c:otherwise>
		</c:choose>
		</div>
	<c:choose>
		<c:when test="${getPreNextGesi['nextGesi'] != null}">
			<div class="col-xs-7">
			<c:choose>
				<c:when test="${getPreNextGesi['nextGesi'].BD_BLCK == 'N'}">
					<button type="button" class="btn btn-link"
						onclick="goSelect(${getPreNextGesi['nextGesi'].BD_SID}, ${getPreNextGesi['nextGesi'].BD_GRP_SID}, ${getPreNextGesi['nextGesi'].BD_GRP_LV});">
					${getPreNextGesi['nextGesi'].BD_TITLE }
				</button>
				</c:when>
				<c:otherwise>
					&nbsp; &nbsp;신고된 게시글입니다.
				</c:otherwise>
			</c:choose>
			</div>
			<div class="col-xs-2 flotR"> ${getPreNextGesi['nextGesi'].BD_REGI } </div>
		</c:when>
		<c:otherwise>
			<div class="col-xs-9">
				&nbsp; &nbsp;윗글이 없습니다.
			</div>
		</c:otherwise>
	</c:choose>
	</div>
	
	<div class="row">
		<div class="col-xs-3">
		<c:choose>
			<c:when test="${getPreNextGesi['preGesi'] != null}">
				<button type="button" class="btn btn-link" ${getPreNextGesi['preGesi'].BD_BLCK == 'Y' ? 'disabled' : '' }
					onclick="goSelect(${getPreNextGesi['preGesi'].BD_SID}, ${getPreNextGesi['preGesi'].BD_GRP_SID}, ${getPreNextGesi['preGesi'].BD_GRP_LV});">
					<span class="glyphicon glyphicon-menu-down"></span> 아랫글
				</button>
			</c:when>
			<c:otherwise>
				<button type="button" class="btn btn-link" disabled="disabled">
					<span class="glyphicon glyphicon-menu-down"></span> 아랫글
				</button>
			</c:otherwise>
		</c:choose>
		</div>
		
	<c:choose>
		<c:when test="${getPreNextGesi['preGesi'] != null}">
			<div class="col-xs-7">
			<c:choose>
				<c:when test="${getPreNextGesi['preGesi'].BD_BLCK == 'N' }">
					<button type="button" class="btn btn-link"
						onclick="goSelect(${getPreNextGesi['preGesi'].BD_SID}, ${getPreNextGesi['preGesi'].BD_GRP_SID}, ${getPreNextGesi['preGesi'].BD_GRP_LV});">
					${getPreNextGesi['preGesi'].BD_TITLE }
				</button>
				</c:when>
				<c:otherwise>
					&nbsp; &nbsp;신고된 게시글입니다.
				</c:otherwise>
			</c:choose>
			</div>
			<div class="col-xs-2 flotR"> ${getPreNextGesi['preGesi'].BD_REGI } </div>	
		</c:when>
		<c:otherwise>
			<div class="col-xs-9">
				&nbsp; &nbsp;아랫글이 없습니다.
			</div>
		</c:otherwise>
</c:choose>
	</div>
	<br>
	
<!-- 글 삭제 Modal -->
<div class="modal fade" id="myModal" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">정말로 삭제하시겠습니까?</h4>
      </div>
      <div class="modal-body">
        <p>삭제 시 복구가 되지 않습니다.</p>
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-primary" onclick="goBDDelete();">확인</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
	
</div>

</body>
</html>