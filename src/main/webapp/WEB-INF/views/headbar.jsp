<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>

.userNick 
{
	color: white;
	text-decoration: underline;
	padding-top: 15px;
}

</style>

<script type="text/javascript">
	$(document).ready(function()
	{
		if($(location).attr('pathname') == "/prj01/customCheck")
		{
			$("#userLi").hide();
		}
		
		$("#loginModal").on('hidden.bs.modal', function ()
		{
			//console.log("모달창 닫기");
			$("#usrname").val("");
			$("#psw").val("");
			$("#loginError").hide();
		});
		
	})
</script>
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="javascript:void(0);">WebSiteName</a>
    </div>
    <ul class="nav navbar-nav">
      <li class="active"><a href="javascript:void(0)">Home</a></li>
      <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">게시판<span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a href="/prj01/boardlist">자유게시판</a></li>
        </ul>
      </li>
      <li><a href="javascript:void(0);">Page 2</a></li>
    </ul>
    <ul class="nav navbar-nav navbar-right" id="userLi">
	<c:choose>
		<c:when test="${sessionScope.memNick == null}">
			<li><a href="/prj01/customCheck"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
			<li><a href="javascript:void(0);" onclick="loginModal();"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
		</c:when>
		<c:otherwise>
			<li class="userNick"><span><c:out value="${sessionScope.memNick}"/> 님 </span></li>
			<li><a href="javascript:void(0);" onclick="location.href='/prj01/logout'">
				<span class="glyphicon glyphicon-log-out"></span> 로그아웃</a>
			</li>
		</c:otherwise>
	</c:choose>
    </ul>
  </div>
</nav>

<!-- Modal -->
  <div class="modal fade" id="loginModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="padding:35px 50px;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4><span class="glyphicon glyphicon-lock"></span> Login</h4>
        </div>
        <div class="modal-body" style="padding:40px 50px;">
          <form role="form">
            <div class="form-group">
              <label for="usrname"><span class="glyphicon glyphicon-user"></span> Username</label>
              <input type="text" class="form-control" id="usrname" placeholder="Enter email">
            </div>
            <div class="form-group">
              <label for="psw"><span class="glyphicon glyphicon-eye-open"></span> Password</label>
              <input type="password" class="form-control" id="psw" placeholder="Enter password">
            </div>
            <div class="checkbox">
              <label><input type="checkbox" value="" checked>Remember me</label>
            </div>
              <button type="button" class="btn btn-success btn-block" id="loginChk"><span class="glyphicon glyphicon-off"></span> Login</button>
         	
         	<div style="margin-top: 10px;">
          		<span id="loginError" style="color: red; display: none;">입력한 아이디 또는 비밀번호가 일치하지 않습니다.</span>
         	</div>
         
          </form>
          
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-danger btn-default pull-left" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span> Cancel</button>
          <p>Not a member? <a href="/prj01/customCheck">회원가입</a></p>
          <p>Forgot <a href="/prj01/findpw">ID/PW</a></p>
        </div>
      </div>
      
    </div>
  </div>
