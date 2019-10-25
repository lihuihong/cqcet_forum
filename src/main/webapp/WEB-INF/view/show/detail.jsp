<%--
  Created by IntelliJ IDEA.
  User: zcq
  Date: 2018/9/13
  Time: 10:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html lang="en" xmlns:th="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
    <title>重电校园</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/semantic-ui/2.2.4/semantic.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/typo.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/animate.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/lib/prism/prism.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tocbot/4.4.2/tocbot.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/me.css">
</head>
<body>
<jsp:include page="header.jsp" flush="true"/>

<div class="content">&nbsp;</div>
<div class="container content">
    <div class="row">
        <div class="col-md-3">
            <div id="float_left">
                <div class="answer-item">
                    <img class="answer-img" src="${article.avatar}"/>
                    <div style="margin-left: 50%">
                        <h3 style="color: #269abc">${user.username}</h3>
                        <p class="dark-p">${user.groupName}</p><br>
                    </div>
                    <div class="answer-bod">

                        <c:if test="${user.id eq sessionScope.get(\"user\")}">
                            <a href="${pageContext.request.contextPath}/show/personArticle.action?id=${user.id}"
                               class="btn btn-info btn-sm">
                                查 看 更 多
                            </a>
                        </c:if>
                        <c:if test="${user.id != sessionScope.get(\"user\")}">
                            <a href="${pageContext.request.contextPath}/show/personArticle.action?id=${user.id}"
                               class="btn btn-info btn-sm">
                                查 看 更 多
                            </a>
                            <c:if test="${follower == true}">
                                <a href="javascript:void(0);" onclick="unfollowUser();" class="btn btn-info btn-sm">
                                    已 关 注
                                </a>
                            </c:if>
                            <c:if test="${follower == false}">
                                <a href="javascript:void(0);" onclick="followUser();" class="btn btn-info btn-sm">
                                    关 注
                                </a>
                            </c:if>
                        </c:if>

                    </div>
                </div>
                <div class="answer-item">
                    <c:if test="${user.id eq sessionScope.get(\"user\")}">
                        <h4>Wo的更多帖子</h4>
                    </c:if>
                    <c:if test="${user.id != sessionScope.get(\"user\")}">
                        <h4>Ta的更多帖子</h4>
                    </c:if>

                    <hr/>
                    <c:forEach items="${articleList}" begin="0" end="1" var="entity" varStatus="status">
                        <div class="ans-hot">
                            <p>
                                <a href="${pageContext.request.contextPath}/show/detail.action?id=${entity.id}">${entity.title}</a>
                            </p>
                            <p style="text-align:right;">更新时间 <a href="#" style="color:#ff82e4;"><fmt:formatDate
                                    value="${entity.updateTime}" pattern="yyyy/MM/dd"/></a></p>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <div class="col-md-9" id="waypoint" >
            <div id="content" class="article-content js-toc-content typo  typo-selection  m-padded-lr-responsive m-padded-tb-large">
                <div class="navbar-default nav-title"
                     style="border-top-left-radius: 15px;border-top-right-radius: 15px">
                </div>
                <hr/>
                <div class="answer-content">
                    <div class="ans-con-rig">
                        <p>${article.title}</p>
                        <div class="right">
                            <c:if test="${user.id eq sessionScope.get(\"user\")}">
                                <button type="button" id="editor" class="btn btn-success" onclick="editor()">编辑</button>
                                <button type="button" id="delete" class="btn btn-danger" onclick="move()">删除</button>
                            </c:if>
                        </div>
                        <div class="dark-p">
                            <div class="row">
                                <div class="col-md-3">
                                    <p>来自 <a href="#" style="color:#ff82e4;">${article.username}</a></p>
                                </div>
                                <div class="col-md-6">
                                    <p>回复 <span style="color:#ff82e4;">3018</span> / 查看 <span
                                            style="color:#ff82e4;">${article.viewCount}</span> / 赞 <span
                                            style="color:#ff82e4;">${article.liked}</span></p>
                                </div>
                                <div class="col-md-6" style="text-align:left">
                                    <p>时间 <span style="color:#ff82e4;"><fmt:formatDate value="${article.updateTime}" pattern="yyyy/MM/dd  HH:mm:ss"/></span>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <hr/>
                        <div>
                            <div class="ui attached segment">
                                <!--图片区域-->
                                <img src="${article.cover}" alt="" class="ui fluid rounded image">
                            </div>
                            <%--<img style="width: 100%;" src="${article.cover}">--%>
                            <p>${article.content}</p>
                        </div>
                        <input type="text" class="answer-input" id="ans-text"/>
                        <p class="ans-other">
                            <a href="javascript:post('${article.id}','ans-text',null,null)" style="color: #ffffff" class="btn btn-info btn-sm">
                                <span class="glyphicon glyphicon-tint"></span> 快速回帖
                            </a>
                            <c:choose>
                                <c:when test="${article.islike > 0}">
                                    <a href="javascript:postdislike('${article.id}')" class="btn btn-info btn-sm" style="color: #ffffff">
                                        <span class="glyphicon glyphicon-thumbs-up"></span> 已赞
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:postlike('${article.id}')" class="btn btn-info btn-sm" style="color: #ffffff">
                                        <span class="glyphicon glyphicon-thumbs-up"></span> 赞一个
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
                <hr/>
                <c:forEach items="${answerList}" var="answer" varStatus="status">

                    <div class="answer-content ">
                        <div class="left">
                            <div class="answer-left">
                                <img src="${answer.user.avatar}"/>
                            </div>
                        </div>
                        <div class="left" style="margin-left: 20px;width: 90%;">
                            <div>
                                <p class="dark-p"><a href="#" style="color:#fe6900;">${answer.user.username}</a></p>
                                <p>${answer.answer.content}</p>
                                <p class="dark-p" style="text-align: right;letter-spacing: 0px;">
                                    <a href="javascript:opup_reply('${status.index}','${answer.user.username}','${answer.answer.id}','${answer.answer.childId}')">回复</a>&nbsp;&nbsp;
                                    <fmt:formatDate value="${answer.answer.updateTime}" pattern="yyyy/MM/dd  HH:mm:ss"/>
                                </p>
                            </div>

                            <div>
                                <c:forEach items="${answer.child}" var="child" varStatus="status1">
                                    <div class="child_content">
                                        <div class="left">
                                            <div class="answer-left">
                                                <img src="${child.childUser.avatar}"/>
                                            </div>
                                        </div>
                                        <div class="left" style="margin-left: 20px;width: 90%;">
                                            <div class="content_p">
                                                <c:choose>
                                                    <c:when test="${answer.answer.childId eq child.answer.parentId || child.childUser.username eq child.parentUser.username}">
                                                        <p class="dark-p"><a href="#"
                                                                             style="color:#fe6900;">${child.childUser.username}</a>
                                                        </p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="dark-p">
                                                            <a href="#"
                                                               style="color:#fe6900;">${child.childUser.username}</a>&nbsp;回复&nbsp;
                                                            <a href="#"
                                                               style="color:#fe6900;">${child.parentUser.username}</a>
                                                        </p>
                                                    </c:otherwise>
                                                </c:choose>
                                                <p>${child.answer.content}</p>
                                                <p class="dark-p" style="text-align: right;letter-spacing: 0px;">
                                                    <a href="javascript:opup_reply('${status.index}','${child.childUser.username}','${child.answer.id}','${child.answer.childId}')">回复</a>&nbsp;&nbsp;
                                                    <fmt:formatDate value="${child.answer.updateTime}"
                                                                    pattern="yyyy/MM/dd  HH:mm:ss"/>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <div class="input_ans" id="id${status.index}">
                                <input type="text" class="answer-input" id="input_${status.index}"/>
                                <span style="margin-top: 10px;display: inline-block;">
                                        回复 : <span id="spId${status.index}" style="color:#fe6900"></span>
                                    </span>

                                <a href="javascript:close_reply(${status.index})" class="btn btn-info btn-sm"
                                   style="float: right;margin-top: 10px;margin-left: 10px">
                                    <span class="glyphicon glyphicon-tint"></span> 收起回复
                                </a>
                                <a href="javascript:post('${article.id}','input_${status.index}')"
                                   class="btn btn-info btn-sm" style="float: right;margin-top: 10px;">
                                    <span class="glyphicon glyphicon-tint"></span> 回复
                                </a>
                            </div>
                        </div>
                    </div>
                    <hr/>
                </c:forEach>

                <input type="hidden" id="answer_info"/>
                <input type="hidden" id="child_id"/>
            </div>
        </div>

    </div>
</div>

<div id="toolbar" class="m-padded m-fixed m-right-bottom" style="display: none">
    <div class="ui vertical icon buttons ">
        <button type="button" class="ui toc teal button">目录</button>
        <div id="toTop-button" class="ui icon button"><i class="chevron up icon"></i></div>
    </div>
</div>

<div class="ui toc-container flowing popup transition hidden" style="width: 250px!important;">
    <ol class="js-toc">

    </ol>
</div>
<jsp:include page="footer.jsp" flush="true"/>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.2/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/semantic-ui/2.2.4/semantic.min.js"></script>
<script src="//cdn.jsdelivr.net/npm/jquery.scrollto@2.1.2/jquery.scrollTo.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lib/prism/prism.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/tocbot/4.4.2/tocbot.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lib/qrcode/qrcode.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lib/waypoints/jquery.waypoints.min.js"></script>
<script>

    var waypoint = new Waypoint({
        element: document.getElementById('waypoint'),
        handler: function (direction) {
            if (direction == 'down') {
                $('#toolbar').show(100);
            } else {
                $('#toolbar').hide(500);
            }
            console.log('Scrolled to waypoint!  ' + direction);
        }
    })

    $('#toTop-button').click(function () {
        $(window).scrollTo(0, 500);
    });

    tocbot.init({
        // Where to render the table of contents.
        tocSelector: '.js-toc',
        // Where to grab the headings to build the table of contents.
        contentSelector: '.js-toc-content',
        // Which headings to grab inside of the contentSelector element.
        headingSelector: 'h1, h2, h3',
    });

    $('.toc.button').popup({
        popup: $('.toc-container.popup'),
        on: 'click',
        position: 'left center'
    });


    function opup_reply(id, name, answer_id, child_id) {
        $("#id" + id).css("height", "70px");
        $("#spId" + id).text(name);
        $("#answer_info").val(answer_id);
        $("#child_id").val(child_id);
    }

    function close_reply(id) {
        $("#id" + id).css("height", "0px");
    }

    var articleId = new Array();
    articleId.push(${article.id});

    //编辑帖子
    function editor() {
        window.location.href = "<%=request.getContextPath()%>/show/posted.action?id=${article.id}";
    }

    //回复帖子
    function post(articleId, input_id) {

        //获取编辑器的内容
        var content = $("#" + input_id).val();
        var answer_id = $('#answer_info').val();
        var child_id = $('#child_id').val();

        $.ajax({
            url: "/show/saveAnswer.json",
            type: "POST",
            dataType: "json",
            data: {
                "articleId": articleId,
                "content": content,
                "answerId": answer_id,
                "childId": child_id
            },
            success: function (rtn) {
                if (rtn.code == "000000") {

                    // 刷新页面
                    window.location.reload();
                } else {
                    helper.toast({
                        content: rtn.message,
                        type: "error"
                    });
                }
            },

        });
    }
    //点赞
    function postlike(articleId) {
        $.ajax({
            url: "/show/like.json",
            type: "POST",
            dataType: "json",
            data: {
                "articleId": articleId
            },
            success: function (rtn) {
                if (rtn.code == "000000") {

                    // 刷新页面
                    window.location.reload();
                } else {
                    helper.toast({
                        content: rtn.message,
                        type: "error"
                    });
                }
            },
        });
    };
    //取消点赞
    function postdislike(articleId) {
        $.ajax({
            url: "/show/dislike.json",
            type: "POST",
            dataType: "json",
            data: {
                "articleId": articleId
            },
            success: function (rtn) {
                if (rtn.code == "000000") {
                    // 刷新页面
                    window.location.reload();
                } else {
                    helper.toast({
                        content: rtn.message,
                        type: "error"
                    });
                }
            },
        });
    };
    //关注
    function followUser() {
        $.ajax({
            url: "/show/followUser.json",
            type: "POST",
            dataType: "json",
            data: {
                "userId":${user.id}
            },
            success: function (rtn) {
                if (rtn.code == "000000") {
                    helper.toast({
                        content: "关注" + rtn.message,
                        type: "success"
                    });
                    // 刷新页面
                    window.location.reload();
                } else {
                    helper.toast({
                        content: "关注" + rtn.message,
                        type: "error"
                    });
                }
            },
        });
    };
    //取消关注
    function unfollowUser() {
        $.ajax({
            url: "/show/unfollowUser.json",
            type: "POST",
            dataType: "json",
            data: {
                "userId":${user.id}
            },
            success: function (rtn) {
                if (rtn.code == "000000") {
                    helper.toast({
                        content: "取消关注" + rtn.message,
                        type: "success"
                    });
                    // 刷新页面
                    window.location.reload();
                } else {
                    helper.toast({
                        content: "取消关注" + rtn.message,
                        type: "error"
                    });
                }
            },
        });
    };
    //删除帖子
    function move() {
        Ewin.confirm({message: "确认要删除帖子？"}).on(function (e) {
            if (!e) {
                return;
            }
            $.ajax({
                url: "delete.json",
                type: "POST",
                dataType: "json",
                traditional: "true",
                async: false,
                data: {
                    "articleId": articleId,
                    "status": "0"
                },
                success: function (rtn) {
                    if (rtn.code == "000000") {
                        helper.toast({
                            content: "删除" + rtn.message,
                            type: "success"
                        });
                        // 建议延迟加载
                        setTimeout(function () {
                            window.location.href = document.referrer;
                        }, 2000);
                    } else {
                        helper.toast({
                            content: rtn.message,
                            type: "error"
                        });
                    }
                }
            });
        });
    }
</script>
</body>
</html>
