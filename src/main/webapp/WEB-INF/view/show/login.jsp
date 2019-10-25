<%--
  Created by IntelliJ IDEA.
  User: zcq
  Date: 2018/10/10
  Time: 20:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>登录界面</title>
    <!-- 引入 Bootstrap -->
    <link href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/show/style.css" type="text/css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/show/font/font-awesome.css" type="text/css"
          rel="stylesheet"/>
    <!-- jQuery (Bootstrap 的 JavaScript 插件需要引入 jQuery) -->
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/jquery.min.js"></script>
    <!-- 包括所有已编译的插件 -->
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/show/scroll.js"></script>
    <script src="${pageContext.request.contextPath}/resources/javaex/pc/js/cookie.js"></script>
</head>
<body style="background-color: #267D9C;">
<div class="login" style="padding: 20px 0;display:none;">
    <div class="container">
        <div class="row">
            <div class="col-md-offset-4 col-md-4">
                <form class="login-form" id="form">
                    <span class="heading">用户登录</span>
                    <div class="form-group">
                        <input type="text" class="form-control" id="username" placeholder="用户名或电子邮件">
                        <i class="fa fa-user"></i>
                    </div>
                    <div class="form-group help">
                        <input type="password" class="form-control" id="password" placeholder="密　码">
                        <i class="fa fa-lock"></i>
                        <a href="#" class="fa fa-question-circle"></a>
                    </div>
                    <div class="form-group" style="margin-top:40px;">
                        <button type="button" class="btn btn-default" style="float:left;background-color: #C5C4C4;"
                                id="go-register">前往注册
                        </button>
                        <button type="button" class="btn btn-default " id="login-button-submit">登录</button>
                    </div>
                </form>
                <br/><br/>
                <p class="login-p"><a href="<%=request.getContextPath()%>/show/index/index.action" >返回首页</a></p>
            </div>
        </div>
    </div>
</div>
<div class="register" style="padding: 20px 0;display:none;">
    <div class="container">
        <div class="row">
            <div class="col-md-offset-4 col-md-4">
                <form class="login-form" id="reg">
                    <span class="heading">用户注册</span>
                    <div class="form-group">
                        <input type="text" class="form-control" id="reg-user" placeholder="用户名或电子邮件">
                        <i class="fa fa-user"></i>
                    </div>
                    <div class="form-group">
                        <input type="number" class="form-control" id="reg-num" placeholder="学   号">
                        <i class="fa fa-user"></i>
                    </div>
                    <div class="form-group help">
                        <input type="password" class="form-control" id="reg-pwd" placeholder="密　码">
                        <i class="fa fa-lock"></i>
                        <a href="#" class="fa fa-question-circle"></a>
                    </div>
                    <div class="form-group help">
                        <input type="password" class="form-control" id="reg-repwd" placeholder="确认密码">
                        <i class="fa fa-lock"></i>
                        <a href="#" class="fa fa-question-circle"></a>
                    </div>
                    <div class="form-group help">
                        <input type="select" class="form-control" id="reg-school" placeholder="学   院">
                        <i class="fa fa-lock"></i>
                        <a href="#" class="fa fa-question-circle"></a>
                    </div>
                    <div class="form-group help">
                        <input type="text" class="form-control" id="reg-professional" placeholder="专   业">
                        <i class="fa fa-lock"></i>
                        <a href="#" class="fa fa-question-circle"></a>
                    </div>
                    <div class="form-group" style="margin-top:40px;">
                        <button type="button" class="btn btn-default" style="float:left;" id="reg-button-submit">注册
                        </button>
                        <button type="button" class="btn btn-default" style="background-color: #C5C4C4;" id="go-login">
                            前往登陆
                        </button>
                    </div>
                </form>
                <br/><br/>
                <p class="login-p"><a href="<%=request.getContextPath()%>/show/index/index.action" >返回首页</a></p>
            </div>
        </div>
    </div>
</div>
<script>
    H_login = {};
    H_login.openLogin = function () {
        $('#go-register').click(function () {
            $('.login').hide();
            $('.register').show();
            $('.login-bg').show();
        });
        $('#go-login').click(function () {
            $('.register').hide();
            $('.login').show();
            $('.login-bg').show();
        });
    };
    H_login.loginForm = function () {
        $("#login-button-submit").on('click', function () {
            var username = $("#username");
            var usernameValue = $("#username").val();
            var password = $("#password");
            var passwordValue = $("#password").val();
            if (usernameValue == "") {
                alert("用户名不能为空");
                username.focus();
                return false;
            } else if (usernameValue.length > 15) {
                alert("用户名长度不能大于15字符");
                username.focus();
                return false;
            } else if (passwordValue == "") {
                alert("密码不能为空");
                password.focus();
                return false;
            } else if (passwordValue.length < 6 || passwordValue.length > 30) {
                alert("密码长度不能小于6或大于30位字符");
                password.focus();
                return false;
            } else {
                helper.toast({
                    content: "登陆中...",
                    type: "success"
                });
                $.ajax({
                    url: "/show/login.json",
                    type: "POST",
                    dataType: "json",
                    async:true,
                    data: {username: usernameValue, password: passwordValue},
                    success: function (rtn) {
                        if (rtn.code == "000000") {
                            var info = rtn.data.info;
                            delCookie("userToken");
                            setCookie("userToken", info.userToken);
                            helper.toast({
                                content: "登录成功，即将为您跳转",
                                type: "success"
                            });
                            window.location.href = "${refererUrl}";
                            return false;
                        } else {
                            helper.toast({
                                content: rtn.message,
                                type: "error"
                            });
                        }
                    },


                });
            }
        });
        $("#reg-button-submit").on('click', function () {
            var username = $("#reg-user");
            var usernameValue = $("#reg-user").val();
            var password = $("#reg-pwd");
            var passwordValue = $("#reg-pwd").val();
            var repassword = $("#reg-repwd");
            var repasswordValue = $("#reg-repwd").val();
            var student = $("#reg-num");
            var studentValue = $("#reg-num").val();
            var schoolValue = $("#reg-school").val();
            var professional = $("#reg-professional");
            var professionalValue = $("#reg-professional").val();

            if (usernameValue == "") {
                alert("用户名不能为空");
                username.focus();
                return false;
            } else if (usernameValue.length > 15) {
                alert("用户名长度不能大于15字符");
                username.focus();
                return false;
            } else if (passwordValue == "") {
                alert("密码不能为空");
                password.focus();
                return false;
            } else if (passwordValue.length < 6 || passwordValue.length > 16) {
                alert("密码长度不能小于6或大于16位字符");
                password.focus();
                return false;
            } else if (passwordValue != repasswordValue) {
                alert("两次密码不一致");
                repassword.focus();
                return false;
            } else if (studentValue.length == 8) {
                alert("学号必须是10位");
                student.focus();
                return false;
            } else if (schoolValue == "") {
                alert("学院不能为空");
                student.focus();
                return false;
            } else if (professionalValue == "") {
                alert("专业不能为空");
                student.focus();
                return false;
            } else {
                helper.toast({
                    content: "注册中...",
                    type: "success"
                });
                $.ajax({
                    url: "/show/register.json",
                    type: "POST",
                    dataType: "json",
                    data: {
                        username: usernameValue,
                        password: passwordValue,
                        studentId: studentValue,
                        college: schoolValue,
                        professional: professionalValue
                    },
                    success: function (rtn) {
                        if (rtn.code == "000000") {
                            var info = rtn.data.info;
                            helper.toast({
                                content: "注册成功，即将为您跳转",
                                type: "success"
                            });
                            delCookie("userToken");
                            setCookie("userToken", info.userToken);
                            window.location.href = "${refererUrl}";
                        } else {
                            helper.toast({
                                content: rtn.message,
                                type: "error"
                            });
                        }
                    },

                });
            }

        });
    };
    H_login.run = function () {
        this.openLogin();
        this.loginForm();
    };
    H_login.run();

</script>

<c:choose>
    <c:when test="${select == \"login\"}">
        <script>$('.login').show();</script>
    </c:when>
    <c:otherwise>
        <script>$('.register').show();</script>
    </c:otherwise>
</c:choose>

</body>
</html>
