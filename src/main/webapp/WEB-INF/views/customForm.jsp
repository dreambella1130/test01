<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>회원 페이지</title>
<!-- Jquery & bootstrap-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<!-- script 태그에서 가져오는 자바스크립트 파일의 순서에 주의해야한다! 순서가 틀릴경우 자바스크립트 오류가 발생한다. -->
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/rsa/jsbn.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/rsa/rsa.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/rsa/prng4.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/rsa/rng.js"></script>

<script type="text/javascript" src="<c:url value='resources/js/boardjs.js'/>"></script>
<script type="text/javascript" src="<c:url value='resources/js/customJS.js'/>"></script>
<link rel="stylesheet" href="<c:url value='resources/css/customInfoCSS.css'/>">

<script type="text/javascript">
	
	$(document).ready(function()
	{
		var actType = "${map.actType}";
		var d = new Date();
		
		if(actType == 'signUp')
		{
			$(".signUp").addClass("active");
			$(".findInfo").children().attr("href", "/prj01/findpw");
			$(".signForm").show();
		}
		else if(actType == 'findInfo')
		{
			$(".findInfo").addClass("active");
			$(".signUp").children().attr("href", "/prj01/customCheck");
		}
		
		$("#userYear").keyup(function()
		{
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		});
		
		$("#userDate").keyup(function()
		{
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		});
		
	});
	
</script>
</head>
<body>
<div class="container">
	<div class="page-header row">
		<div> <c:import url="headbar.jsp"/> </div>
		<div class="col-xs-12">
			<h1>회원 페이지</h1>
		</div>
	</div>
	<div>
		<ul class="nav nav-tabs">
		    <li class="signUp"><a href="#">회원가입</a></li>
		    <li class="findInfo"><a href="#">아이디/비밀번호 찾기</a></li>
		  </ul>
	</div>
	
	<!-- 회원가입  --------------------------------------------------------------------------->
	<div class="row formMargin signForm" style="display: none;">
		<div class="col-sm-2"></div>
		<div class="col-sm-8">
		<form id="signUpForm" method="post">
			<input type="hidden" id="RSAModulus" value="${map.RSAModulus }"/>
			<input type="hidden" id="RSAExponent" value="${map.RSAExponent }"/>
			<input type="hidden" id="userNameRSA" name="userName">
			<input type="hidden" id="userNickHidden" name="userNick">
			<input type="hidden" id="userEmailRSA" name="userEmail">
			<input type="hidden" id="passwordRSA" name="password"/>
			<input type="hidden" id="userBirth" name="userBirth"/>
		</form>
			<div class="input-group">
				<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
				<input type="text" class="form-control" id="userName" placeholder="이름">
			</div>
			<span class="err" id="nameMsg"></span>
			<div class="input-group">
				<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
				<input type="text" class="form-control repetTxt" id="userNick" placeholder="닉네임">
				<div class="input-group-btn">
					<input type="button" class="btn btn-primary disabled" id="nickChkBtn" value="중복확인">
				</div>
			</div>
			<span class="err" id="nickMsg"></span>
			<div class="input-group">
				<span class="input-group-addon"><i class="glyphicon glyphicon-envelope"></i></span>
				<input type="text" class="form-control repetTxt" id="userEmail" placeholder="Email">
				<div class="input-group-btn">
					<input type="button" class="btn btn-primary disabled" id="emailChkBtn" value="중복확인">
				</div>
			</div>
			<span class="err" id="emailMsg"></span>
			<div class="input-group">
				<span class="input-group-addon">
					<i class="glyphicon glyphicon-lock" data-toggle="tooltip" data-placement="left" title="숫자,영문,특수문자를 모두 포함하여 입력해주세요(6~16자리)"></i>
				</span>
				<input type="password" class="form-control" id="password1" placeholder="비밀번호 만들기">
				<span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
				<input type="password" class="form-control" id="password2" placeholder="비밀번호 재확인">
			</div>
			<span class="err" id="pwdMsg"></span>
			<div class="form-inline">
				<div class="input-group" style="width: 37%;">
					<span class="input-group-addon">생일</span>
					<input type="text" class="form-control" id="userYear" placeholder="년(4자리)" maxlength="4">
				</div>
				<select id="userMonth" class="form-control" style="width: 30%;">
					<option value="#">월</option>
					<c:forEach var="cnt" begin="1" end="12">
						<c:choose>
							<c:when test="${cnt < 10}">
								<option value="0${cnt }">${cnt } 월</option>
							</c:when>						
							<c:otherwise>
								<option value="${cnt }">${cnt } 월</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
				<input type="text" class="form-control" id="userDate" placeholder="일" maxlength="2" style="width: 32%;">
			</div>
			<span class="err" id="birthMsg"></span>
			
			<div class="clearfix">
				<button type="button" class="cancelbtn">Cancel</button>
				<button type="button" class="signupbtn" id="signUpBtn">Sign Up</button>
    		</div>
		</div>
		<div class="col-sm-2"></div>
	</div>
	
	<!-- 아이디/비밀번호 찾기  --------------------------------------------------------------------------->
	
	
</div>

</body>
</html>