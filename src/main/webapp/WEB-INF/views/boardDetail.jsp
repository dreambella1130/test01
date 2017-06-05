<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% pageContext.setAttribute("enter","\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>게시판 상세내용</title>
<!-- Jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="<c:url value='resources/css/boardDetailCSS.css'/>">

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<c:url value='resources/js/boardjs.js'/>"></script>

</head>
<body>
<form method="post" id="submitForm">
	<input type="hidden" id="bdSid" name="bdSid" value="${bdDetail.BD_SID }"/>
	<input type="hidden" id="bd_grp_sid" name="bd_grp_sid" value="${bdDetail.BD_GRP_SID }">
	<input type="hidden" id="bd_grp_LV" name="bd_grp_LV" value="${bdDetail.BD_GRP_LV }">
	<input type="hidden" id="bd_grp_dep" name="bd_grp_dep" value="${bdDetail.BD_GRP_DEP }">
	<input type="hidden" id="bd_title" name="bd_title" value="${bdDetail.BD_TITLE}">
	<input type="hidden" id="bd_gesi_repl_sid" name="bd_gesi_repl_sid"/>
	<input type="hidden" id="bd_gesi_repl_grp" name="bd_gesi_repl_grp"/>
	<input type="hidden" id="bd_gesi_repl_LV" name="bd_gesi_repl_LV"/>
	<input type="hidden" id="bd_gesi_repl_dep" name="bd_gesi_repl_dep"/>
	<input type="hidden" id="bd_gesi_repl_cont" name="bd_gesi_repl_cont"/>
	<input type="hidden" id="bd_gesi_repl_Chk" name="bd_gesi_repl_Chk"/>
</form>

<div class="container">
	<div class="page-header">
		<h1>게시판 상세내용</h1>
	</div>
	
	<!-- head 글쓰기, 답글 등 버튼 위치 -->
	<div class="row">
		<div class="col-xs-5">
			<button type="button" class="btn btn-default" onclick="location.href='/prj01/gobdwrite'">
				<span class="glyphicon glyphicon-pencil"></span> 글쓰기
			</button>
			<button type="button" class="btn btn-default" onclick="goBoardReple();">답글</button>
			
			<button type="button" class="btn btn-default" onclick="goBDEdit();">수정</button>
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">삭제</button>
			
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
	
	<!-- 제목 -------------------------------------------------------------------------------------------------->
	
	<div class="well">
		<div class="row txtTitle">
			<div class="col-xs-7">${bdDetail.BD_TITLE}</div>
		</div>
	</div>
	
	<!-- 본문 메인 내용 ---------------------------------------------------------------------------------------->
	
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
				<a href="javascript:void(0);" class="btn btn-info btn-default goVote" id="likeBoard">
		        	<span class="glyphicon glyphicon-thumbs-up"></span> Like &nbsp; <span class="badge countLike">${bdDetail.BD_LIKE}</span>
		        </a>
		        <button type="button" class="btn btn-link goVote" id="badBoard">신고</button>
			</div>
		</div>
		<p>
	</div>
	
	<!-- 댓글 시작 ----------------------------------------------------------------------------------->
	
	<div class="well">
	<c:forEach var="replList" items="${bdDetailRepl }" varStatus="status">
		<c:if test="${status.index != 0 && replList.REPL_DEPT == 0}">
			<hr class="replGubun">
		</c:if>
		<dl>
			<dt class="replMargin">
				${replList.MEM_NICK } <span class="replTime">${replList.REPL_REGI }</span>
				<span class="flotR showRepl" id="btn_${replList.REPL_SID }">
					<a href="javascript:void(0);"
						onclick="repleEdit(${replList.REPL_SID }, 'replReNew', ${replList.REPL_GRP }, ${replList.REPL_LV }, ${replList.REPL_DEPT });">답글</a> |
					<a href="javascript:void(0);" onclick="repleEdit(${replList.REPL_SID }, 'repleEdit');"> 수정</a> | 
					<a href="javascript:void(0);" onclick="repleDelete(${replList.REPL_SID })"> 삭제 </a> 
				</span>
			</dt>
			<dd class="replMargin showRepl" id="origin_${replList.REPL_SID }">${replList.REPL_CONT }</dd>
			
		<!-- 댓글 수정 폼 ----------------------------------------------------------------------------------->
	
			<dd class="replMargin hiddenRepl" style="display: none;" id="edit_${replList.REPL_SID }">
				<div class="form-group row">
					<div class="col-sm-11">
						<textarea rows="3" class="form-control replTxtLength" id="editTxt_${replList.REPL_SID }">${fn:replace(fn:replace(replList.REPL_CONT, '&nbsp; ', ''),'<br>', enter) }</textarea>
					</div>
					<div class="col-sm-1 btn-group">
						<button type="button" class="btn btn-primary gesiReplBtn">등록</button>
						<button type="button" class="btn btn-default" onclick="repleEdit();">취소</button>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-10"></div>
					<div class="col-sm-2">
						<span class="countColor editTxt_${replList.REPL_SID }_chk">${fn:length(replList.REPL_CONT) }</span> / 150자
					</div>
				</div>
			</dd> <!-- end 댓글 수정 -->

		<!-- 댓글의 답글 폼 ----------------------------------------------------------------------------------->	
		
			<dd class="replMargin hiddenRepl" style="display: none;" id="replRepl_${replList.REPL_SID }">
				<div class="form-group row">
					<div class="col-sm-11">
						<textarea rows="3" class="form-control replTxtLength" id="replReNew_${replList.REPL_SID }" placeholder="댓글을 입력해주세요"></textarea>
					</div>
					<div class="col-sm-1 btn-group">
						<button type="button" class="btn btn-primary gesiReplBtn">등록</button>
						<button type="button" class="btn btn-default" onclick="repleEdit();">취소</button>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-10"></div>
					<div class="col-sm-2">
						<span class="countColor replReNew_${replList.REPL_SID }_chk">0</span> / 150자
					</div>
				</div>
			</dd> <!-- end 댓글 답글 폼 -->
			
		</dl>
	</c:forEach>
	
	
	<!-- 댓글 입력 textarea  ---------------------------------------------------------------------------->
	
	<div class="form-horizontal">
		<div class="form-group row">
			<div class="col-sm-11">
				<textarea rows="3" class="form-control replTxtLength" id="newReplCon" placeholder="댓글을 입력해주세요"></textarea>
			</div>
			<div class="col-sm-1">
				<p class="replBtn gesiReplBtn">등록</p>
			</div>
		</div>
		
		<div class="row">
			<div class="col-sm-10"></div>
			<div class="col-sm-2"><span class="newReplCon_chk countColor">0</span> / 150자</div>
		</div>
	</div>
		
	</div>
	<p>
	
	<!-- footer 글쓰기 등 버튼  ---------------------------------------------------------------------------->
	<div class="row">
		<div class="col-xs-5">
			<button type="button" class="btn btn-default" onclick="location.href='/prj01/boardwrite'">
				<span class="glyphicon glyphicon-pencil"></span> 글쓰기
			</button>
			<button type="button" class="btn btn-default" onclick="goBoardReple();">답글</button>
			
			<button type="button" class="btn btn-default" onclick="goBDEdit();">수정</button>
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">삭제</button>
			
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
	
	<!-- 윗글, 아랫글 제목 노출 ---------------------------------------------------------------------------------->
	
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
	
<!-- 글 삭제 Modal --------------------------------------------------------------------------------------------->
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

<!-- 댓글 삭제 Modal --------------------------------------------------------------------------------------------->
<div class="modal fade" id="replModal" role="dialog">
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
      	<button type="button" class="btn btn-primary" onclick="goDeleteRepl();">확인</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
	
</div>

</body>
</html>