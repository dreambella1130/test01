var emailChk = 0;		// 중복확인 여부
var emailChkTxt = "";	// 중복확인 시의 문자열
var nickChk = 0;		// 중복확인 여부
var nickChkTxt = "";	// 중복확인 시의 문자열
var maxEmailSize = 40;
var maxNameNickSize = 30;
var maxPwdSize = 16;

var d = new Date();

// 이름 유효성 검사 정규식
var regex_name = /^[가-힣a-zA-Z]+$/;
// 닉네임 유효성 검사 정규식
var regex_nick = /^[가-힣a-zA-Z0-9]+$/;
//이메일 유효성검사 정규식
var regex_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
// 비밀번호 유효성검사 정규식
var regex_pwd = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,16}/;

$(document).ready(function()
{
	// 글자 수 제한 (이름, 닉네임, 이메일, 비밀번호)
	$("#userName, #userNick, #userEmail, #password1, password2").bind("keyup paste", function()
	{
		if($(this).attr("id") == "userEmail")
		{
			// 이메일
			setTimeout(getByteLength(this, maxEmailSize), 1000);
		}
		else if($(this).attr("id") == "password1" || $(this).attr("id") == "password2")
		{
			// 비밀번호
			setTimeout(getByteLength(this, maxPwdSize), 1000);
		}
		else
		{
			// 닉네임
			setTimeout(getByteLength(this, maxNameNickSize), 1000);
		}
	});
	
	
	// 이름
	$("#userName").bind("keypress paste focusout",function()
	{
		// 공백 체크
		if(emptyCheck(this, "nameMsg"))
		{
			nameCheck(this, "nameMsg");
		}
		
	});	// end $("#userName").focusout()
	
	// 닉네임
	$("#userNick").bind("keypress paste focusout",function()
	{
		// 공백 체크
		if(emptyCheck(this, "nickMsg"))
		{
			// 입력 형식 검사
			if(nickCheck(this, "nickMsg"))
			{
				// 중복 체크 여부
				repetChk(this, "nickMsg", nickChk, nickChkTxt);
			}
			
		}
		else
		{
			$(this).next().children().addClass("disabled");
		}
		
		
	});
	
	$("#userEmail").bind("keypress paste focusout", function()
	{
		// 공백 및 이메일 형식 체크
		if(emailCheck(this, "emailMsg"))
		{
			// 중복 체크 여부
			repetChk(this, "emailMsg", emailChk, emailChkTxt);
		}
		else
		{
			$(this).next().children().addClass("disabled");
		}
		
	});
	
	$("#password1").focus(function()
	{
		$('[data-toggle="tooltip"]').tooltip('show');
		
	});
	
	$("#password1").bind("keypress paste focusout", function()
	{
		// 공백 및 형식 체크
		pwdCheck(this, "pwdMsg");
		
	});
	
	$("#password2").bind("keypress paste focusout", function()
	{
		// 비밀번호 일치 여부 체크
		if($("#password1").val() != $(this).val())
		{
			$("#pwdMsg").html("비밀번호와 일치하지 않습니다. 다시 입력해 주세요.");
			$("#pwdMsg").show();
			
			return;
		}
		
		$("#pwdMsg").hide();
	});
	
	$("#userYear").bind("keypress paste focusout", function()
	{
		// 공백 체크
		if(emptyCheck(this, "birthMsg"))
		{
			// 길이 및 미래 년도여부 체크
			yearLength(this, "birthMsg");
		}
		
	});
	
	$("#userMonth").bind("keypress paste focusout", function()
	{
		monthSelect(this, "birthMsg");
	
	});
	
	$("#userDate").bind("keypress paste focusout", function()
	{
		// 공백 체크
		emptyCheck(this, "birthMsg");
		
	});
	
	// 닉네임/이메일 중복 확인
	$("#nickChkBtn, #emailChkBtn").click(function()
	{
		//alert("****"+$(this).parent().prev().attr("id")+"****");
		
		var eventObj = $(this).parent().prev();
		
		$.ajax(
		{
			type: "POST",
			url: "/prj01/email_nick_check",
			data: { userNick : $("#userNick").val(), userEmail : $("#userEmail").val() },
			success:function(result)
			{
				
				if(result == "0")
				{
					//alert("result :"+result+", click 이벤트 :"+$(eventObj).attr("id")+"*****");
					
					if($(eventObj).attr("id") == "userNick")
					{
						nickChk  = 1;
						nickChkTxt = $("#userNick").val();
						
						$("#nickMsg").html("등록 가능한 닉네임입니다.");
						$("#nickMsg").css("color","green");
						$("#nickMsg").show();
					}
					else if($(eventObj).attr("id") == "userEmail")
					{
						//alert("result :"+result+", click 이벤트 :"+$(eventObj).attr("id")+"*****");
						
						emailChkTxt = $("#userEmail").val();
						emailChk = 1;
						
						$("#emailMsg").html("등록 가능한 이메일입니다.");
						$("#emailMsg").css("color","green");
						$("#emailMsg").show();
					}
					
				}
				else
				{
					if($(eventObj).attr("id") == "userNick")
					{
						nickChk = 0;
						nickChkTxt = "";
						
						$("#nickMsg").html("이미 등록된 닉네임입니다.");
						$("#nickMsg").css("color","red");
						$("#nickMsg").show();
					}
					else if($(eventObj).attr("id") == "userEmail")
					{
						emailChk = 0;
						emailChkTxt = "";
						
						$("#emailMsg").html("이미 등록된 이메일입니다.");
						$("#emailMsg").css("color","red");
						$("#emailMsg").show();
					}
				}
				
			},
			error:function(request,status,error)
	        {  
	        	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

	        } 
			
		});
		
	});
	
	// 회원가입 클릭 이벤트
	$("#signUpBtn").click(function()
	{
		
		// 이름 유효성 검사
		if(!nameCheck($("#userName"), "nameMsg"))
		{
			$("#userName").focus();
			return;
		}
		
		// 닉네임 유효성 검사
		// 공백 체크
		if(emptyCheck($("#userNick"), "nickMsg"))
		{
			// 입력 형식 검사
			if(!nickCheck($("#userNick"), "nickMsg"))
			{
				$("#userNick").focus();
				return;
			}
			
//			console.log("****중복체크 nickChk :"+nickChk+", nickChkTxt :"+nickChkTxt+"****");
			
			// 중복 체크 여부
			if(!repetChk($("#userNick"), "nickMsg", nickChk, nickChkTxt))
			{
				$("#userNick").focus();
				return;
			}
			
		}
		else
		{
			$("#userNick").focus();
			$("#userNick").next().children().addClass("disabled");
			return;
		}
		
		// 이메일 유효성 검사
		// 공백 및 이메일 형식 체크
		if(emailCheck($("#userEmail"), "emailMsg"))
		{
			// 중복 체크 여부
			if(!repetChk($("#userEmail"), "emailMsg", emailChk, emailChkTxt))
			{
				$("#userEmail").focus();
				return;
			}
		}
		else
		{
			$("#userEmail").focus();
			$("#userEmail").next().children().addClass("disabled");
			return;
		}
		
		// 비밀번호
		if(!pwdCheck($("#password1"), "pwdMsg"))
		{
			$("#password1").focus();
			return;
		}
		else
		{
			if($("#password1").val() != $("#password2").val() ||
					$("#password2").val() == "" || $("#password2").val() == null)
			{
				$("#password2").focus();
				$("#pwdMsg").html("비밀번호와 일치하지 않습니다. 다시 입력해 주세요.");
				$("#pwdMsg").show();
				return;
			}
			
			$("#pwdMsg").hide();
		}
		
//		console.log("비번1 :"+$("#password1").val()+", 비번2 :"+$("#password2").val());
		
		
		// 생년월일 검사
		//  연도 공백 체크 || 길이 및 미래 년도여부 체크
		if(!emptyCheck($("#userYear"), "birthMsg") || !yearLength($("#userYear"), "birthMsg"))
		{
			$("#userYear").focus();
			$("#birthMsg").show();
			return;
			
		}
		
		// 월 select 검사
		if(!monthSelect($("#userMonth"), "birthMsg"))
			return;
		
		// 일 공백 검사
		if(!emptyCheck($("#userDate"), "birthMsg"))
			return;
		
		var birthChk = new Date($("#userYear").val(), ($("#userMonth option:selected").val()-1), $("#userDate").val());
		
//		console.log("입력한 생년월일 :"+$("#userYear").val()+$("#userMonth option:selected").val()+$("#userDate").val());
//		console.log("birthChk :"+birthChk.getFullYear()+(birthChk.getMonth()+1)+birthChk.getDate()+"*****");
//		console.log("d :"+d.getFullYear()+(d.getMonth()+1)+d.getDate()+"*****");
//		console.log("birthChk.getTime() :"+birthChk.getTime()+", d.getTime() :"+d.getTime()+"****");

		if(birthChk.getTime() > d.getTime())
		{
			$("#userDate").focus();
			$("#birthMsg").html("입력한 날짜가 유효하지 않습니다. 다시 확인해주세요.");
			$("#birthMsg").show();
			return;
		}
		
		var dateFormat = "";
		
		if($("#userDate").val().length == 1)
			dateFormat = "0"+$("#userDate").val();
		else
			dateFormat = $("#userDate").val();
		
		console.log("****dateFormat :"+dateFormat+"*****");
		
		// 연월일 유효성 검사
		if(!isValidDate($("#userYear").val(), $("#userMonth option:selected").val(), dateFormat))
		{
			$("#userDate").focus();
			$("#birthMsg").html("입력한 생년월일이 유효하지 않습니다.");
			$("#birthMsg").show();
			return;
		}
		
		$("#userBirth").val($("#userYear").val()+$("#userMonth option:selected").val()+dateFormat);
		$("#userNickHidden").val($("#userNick").val());
		
		//alert("검사 종료");
		
		// 회원가입 정보 rsa 암호화
		var rsa = new RSAKey();
		rsa.setPublic($('#RSAModulus').val(),$('#RSAExponent').val());
		
		$("#userNameRSA").val(rsa.encrypt($("#userName").val()));
		$("#userEmailRSA").val(rsa.encrypt($("#userEmail").val()));
		$("#passwordRSA").val(rsa.encrypt($("#password1").val()));
		
		var submitForm = $("#signUpForm").serialize();
		
		$.ajax(
		{
			type: "POST",
			url: "/prj01/joinuser",
			data: submitForm,
			success:function(args)
			{
				if(args.result = "error")
				{
					// 개인 키 세션 만료에 따른 암호키 재설정
					$("#RSAModulus").val(args.RSAModulus);
					$("#RSAExponent")val(args.RSAExponent);
					
					return;
				}
			},
			error:function(request,status,error)
	        {  
	        	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

	        }
			
		});
		
	});
	
});

//count UTF-8 bytes of a string
function getByteLength (obj, maxSize, b, i, ch)
{
//	console.log("****s(문자열) :"+$(obj).val()+"****");
	
	var s = $(obj).val();
	var tempByte = 0;
	
	for (b = i = 0 ; s.charCodeAt(i) ; i++)
	{
//		console.log("****i(for문 변수) :"+i+"****");
		
		ch = s.charCodeAt(i);
		
//		console.log("****ch(유니코드 변환) :"+ch+"****");
//		console.log("****ch >> 11 :"+(ch >> 11)+"****");
//		console.log("****ch >> 7 :"+(ch >> 7)+"****");
		
		tempByte = ch >> 11 ? 3 : ch >> 7 ? 2 : 1;
		b += tempByte;
		
//		console.log("i ="+i+", "+b + " Bytes");
		
		if(b>maxSize)
		{
			s = s.substring(0, i-1);
			
//			console.log("***** s.substring(0, "+(i-1)+")="+s+"*****");
			
			$(obj).val(s);
			
			return;
		}
		
	}
	
	// 일반적인 FOR문으로 문자열 BYTE 계산
	/*
	console.time("일반적인FOR방식"); 
	for(var i=0; i<stringLength; i++)
	{
	    if(escape(string.charAt(i)).length >= 4)
	        stringByteLength += 3;
	    else if(escape(string.charAt(i)) == "%A7")
	        stringByteLength += 3;
	    else
	        if(escape(string.charAt(i)) != "%0D")
	            stringByteLength++;
	}
	console.log(stringByteLength + " Bytes")
	console.timeEnd("일반적인FOR방식");
	*/
	
	// 개선된 FOR문으로 문자열 BYTE 계산
	/*
	console.time("개선된FOR방식");
	stringByteLength = (function(s,b,i,c)
	{
	    for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
	    return b
	})(string);
	console.log(stringByteLength + " Bytes");
	console.timeEnd("개선된FOR방식");
	*/
	
	// 정규식을 활용한 계산
	/*
	console.time("정규식방식");
	stringByteLength = string.replace(/[\0-\x7f]|([0-\u07ff]|(.))/g,"$&$1$2").length;
	console.log(stringByteLength + " Bytes");
	console.timeEnd("정규식방식");
	*/
	return b;
}


//날짜가 정확한지 검사(문자)
function isValidDate(y, m, d)
{
	var year, month, day;
	var days = new Array (31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

	y = y.trim();
	m = m.trim();
	d = d.trim();
	if(y.length != 4 || m.length!=2 || d.length!=2)
		return false;

	year = parseInt(y);

	if(m.charAt(0) == '0')
		m = m.charAt(1);
	month = parseInt(m);

	if(d.charAt(0) == '0')
		d = d.charAt(1);
	day = parseInt(d);

	// 날짜 검사
	if(year%4==0 && year%100 !=0 || year%400==0)
		days[1]=29;
	else
		days[1]=28;

	if(month < 1 || month > 12)
		return false;

	if(day < 1 || day > days[month-1])
		return false;

	return true;
}

// 월 선택박스 체크 여부 확인
function monthSelect(obj, errSpanId)
{
	if($(obj).find('option:selected').val() == "#")
	{
		$("#"+errSpanId).html("\"월\"을 선택해 주세요.");
		$("#"+errSpanId).css("color", "red");
		$("#"+errSpanId).show();
		
		return false;
	}
	
	$("#"+errSpanId).hide();
	
	return true;
}

// 연도 입력 글자 갯수 및 현재 년도와 비교 검사
function yearLength(obj, errSpanId)
{
	if($(obj).val().length != 4 && (Number($(obj).val()) > Number(d.getFullYear())))
	{
		//alert("길이 :"+$(obj).val().length+", 크기 비교 :"+(Number($(obj).val()) > Number(d.getFullYear()))+"****");
		$("#"+errSpanId).html("입력한 연도를 다시확인해 주세요.");
		$("#"+errSpanId).css("color", "red");
		$("#"+errSpanId).show();
		
		return false;
	}
	
	$("#"+errSpanId).hide();
	
	return true;
}


// 중복확인 여부 및 중복확인 시의 입력 문자열과 현재 입력 값과 일치하는지 여부 확인
function repetChk(obj, errSpanId, chkInt, chkStr)
{
//	console.log("**** repetChk() 함수 호출 문자열 :"+$(obj).val()+"chkStr :"+chkStr+", chkInt :"+chkInt);
	
	if($(obj).val() != chkStr || chkInt == 0)
	{
		$("#"+errSpanId).html("중복확인을 해주세요.");
		$("#"+errSpanId).css("color", "red");
		$("#"+errSpanId).show();
		
//		console.log("**** repetChk() 함수 호출 결과 : false");
		
		return false;
	}
	
	$("#"+errSpanId).hide();
//	console.log("**** repetChk() 함수 호출 결과 : true");
	
	return true;
}

// 비밀번호 공백 및 형식 검사
function pwdCheck(obj, errSpanId)
{
	// 비번 공백 체크
	if(emptyCheck(obj, errSpanId))
	{
		// 비번 형식 체크
		if(!regex_pwd.test($(obj).val()))
		{
			$("#"+errSpanId).html("비밀번호는 숫자,영문,특수문자를 모두 포함하여야 합니다.(6~16자리)");
			$("#"+errSpanId).css("color", "red");
			$("#"+errSpanId).show();
			
			return false;
		}
		
		$("#"+errSpanId).hide();
		$('[data-toggle="tooltip"]').tooltip('hide');
		
		$("#"+errSpanId).html("비밀번호를 다시한번 입력해주세요.");
		$("#"+errSpanId).show();
		
		return true;
	}
	
	return false;
}

// 이메일 공백 및 형식 검사
function emailCheck(obj, errSpanId)
{
	// 공백 검사
	if(emptyCheck(obj, errSpanId))
	{
		// 이메일 형식 검사
		var isCheckEmail = regex_email.test($(obj).val());
		
		//alert("****"+isCheckEmail+"****")
		
		if(!isCheckEmail)
		{
			//alert("이메일 형식 아님 :"+errSpanId+"***");
			
			$("#"+errSpanId).html("이메일 형식이 아닙니다. 다시 확인해주세요.");
			$("#"+errSpanId).css("color", "red");
			$("#"+errSpanId).show();
			
			return false;
		}
		
		$(obj).next().children().removeClass("disabled");
		
		return true;
	}
	
	return false;
}

// 닉네임 유효성 검사
function nickCheck(obj, errSpanId)
{
	if(!regex_nick.test($(obj).val()))
	{
		//alert(regex_name.test($(obj).val()));
		
		$("#"+errSpanId).html("닉네임에 특수문자가 올 수 없습니다.");
		$("#"+errSpanId).show();
		
		return false;
	}
	
	$("#"+errSpanId).hide();
	
	return true;
}

// 이름 유효성 검사
function nameCheck(obj, errSpanId)
{
	if(!regex_name.test($(obj).val()))
	{
		//alert(regex_name.test($(obj).val()));
		
		$("#"+errSpanId).html("이름은 영문 또는 한글만 입력가능합니다.");
		$("#"+errSpanId).show();
		
		return false;
	}
	
	$("#"+errSpanId).hide();
	
	return true;
}

// 필수 입력사항 공백 확인 함수
function emptyCheck(obj, errSpanId)
{
	var text = "";
	text = $(obj).val();
	
	//alert("****"+text+"****");
	
	if(text == "" || text == null)
	{
		$("#"+errSpanId).html("필수 입력란 입니다.");
		$("#"+errSpanId).css("color", "red");
		$("#"+errSpanId).show();
		
		return false;
	}
	
	$(obj).val(text);
	$("#"+errSpanId).hide();
	$(obj).next().children().removeClass("disabled");
	
	return true;
}