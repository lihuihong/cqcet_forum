<%--
  Created by IntelliJ IDEA.
  User: zcq
  Date: 2018/10/10
  Time: 8:49
  发帖页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html lang="en" xmlns:th="http://www.w3.org/1999/xhtml">
<head>
    <title>发布帖子</title>
    <script src="${pageContext.request.contextPath}/resources/ckeditor/ckeditor.js"></script>
    <script src="${pageContext.request.contextPath}/resources/ckeditor/config.js"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/semantic-ui/2.2.4/semantic.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/lib/editormd/css/editormd.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/me.css">
</head>
<body>
<jsp:include page="header.jsp" flush="true"/>


<div class="container content">
    <div class="row">
        <div class="col-md-12">
            <div class="article-content" style="padding: 20px 40px;">
                <form action="">
                    <h3>发布帖子</h3>
                    <br/>
                    <hr/>
                    <br/>
                    <div name="form1">
                        <textarea name="title" id="title" class="answer-input form-control" rows="2"
                                  placeholder="请输入标题">${article.title}</textarea>
                        <br/>
                        <div class="required field">
                            <div class="ui left labeled input" style="margin-bottom: 10px;width: 100%;">
                                <label class="ui teal basic label">首图</label>
                                <input type="text" id="cover" name="cover" th:value="*{cover}" value="${article.cover}"
                                       placeholder="首图引用地址">
                            </div>
                        </div>
                        <br/>
                        <hr/>
                        <br/>
                        <%--<textarea name="content" id="content">${article.content}</textarea>--%>
                        <div class="required field">
                            <div id="md-content" style="z-index: 1 !important;">
                                <textarea placeholder="博客内容" name="content" style="display: none"
                                          th:th:text="*{content}">${article.content}</textarea>
                            </div>
                        </div>
                        <%--<script type="text/javascript">CKEDITOR.replace('content');</script>--%>

                        <div class="required field">
                            <div class="ui left labeled action input" style="width: 30%;">
                                <label class="ui compact teal basic label">分类</label>
                                <div class="ui fluid selection dropdown">
                                    <input type="hidden" name="type.id" id="typeId" value="${article.typeId}">
                                    <i class="dropdown icon"></i>
                                    <div class="default text">分类</div>
                                    <div class="menu">
                                        <c:forEach items="${typeList}" var="entity" varStatus="status">
                                            <div class="item" name="type" data-value="${entity.id}" >${entity.name}
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <br/>
                        <hr/>
                        <br/>
                        <%--<div style="padding-top: 10px;padding-bottom: 10px">
                            <c:forEach items="${typeList}" var="entity" varStatus="status">
                                <label class="radio-inline">
                                    <input type="radio" name="type" id="${entity.id}"
                                           value="${entity.id}">${entity.name}
                                </label>
                            </c:forEach>
                        </div>--%>
                    </div>
                    <br/><br/>
                    <a href="javascript:post()">
                        <div class="fb-div-sub">
                            <div class="bor-rai fb-sub">发布</div>
                        </div>
                    </a>
                </form>
            </div>
        </div>
    </div>
</div>
<jsp:include page="footer.jsp" flush="true"/>
</body>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.2/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/semantic-ui/2.2.4/semantic.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/lib/editormd/editormd.min.js"></script>

<script>

    //初始化Markdown编辑器
    var contentEditor;
    $(function () {
        contentEditor = editormd("md-content", {
            width: "100%",
            height: 640,
            syncScrolling: "single",
//        path    : "../static/lib/editormd/lib/"
            path: "/resources/lib/editormd/lib/"
        });
    });
    $('.ui.dropdown').dropdown({
        on: 'hover'
    });

    function setType(rName, rValue) {

        /*通过传递的元素名获取元素对象*/
        var rObj = document.getElementsByName(rName);
        /*获取到的对象是数组对象，逐一进行遍历，寻找值等于所获取数据值的子对象*/
        for (var i = 0; i < rObj.length; i++) {
            //console.log("----"+rObj[i].attributes["data-value"].value);
            if (rObj[i].attributes["data-value"].value == rValue) {
                //console.log(rObj[i].attributes["data-value"].value);
                /*寻找到子对象后，对他进行如下操作就可以实现后台数据显示到单选钮中*/
                //$(".ui fluid selection dropdown text").value = rObj[i].val();
                rObj[i].className ="item active selected";
            }
        }
    }
    //$(".ui.dropdown").dropdown("type", ${article.typeId});
    /*本函数传递两个参数，*/
    //setType('type', '${article.typeId}');
    /*$('.ui.form').form({
        typeId : {
            identifier: 'type.id',
            rules: [{
                type : 'empty',
                prompt: '标题：请输入博客分类'
            }]
        },
    });*/
    function post() {
        //获取编辑器的内容
        var stem = $('.editormd-markdown-textarea').val();
        //stem= stem.replace("<br/>", '  \n');
        var title = $("#title").val();
        var cover = $("#cover").val();
        //获取帖子分类类型
        var type = $("#typeId").val();
        if (stem == null || stem == "") {
            helper.toast({
                content: "文章内容不能为空",
                type: "error"
            });
        } else if (title == null || title == "") {
            helper.toast({
                content: "帖子标题不能为空",
                type: "error"
            });
        } else if (type == null) {
            helper.toast({
                content: "帖子类型不能为空",
                type: "error"
            });
        } else {
            $.ajax({
                url: "save_article.json",
                type: "POST",
                dataType: "json",
                data: {
                    "stem": stem,
                    "title": title,
                    "id": "${article.id}",
                    "type": type,
                    "cover": cover
                },
                success: function (rtn) {
                    if (rtn.code == "000000") {
                        helper.toast({
                            content: "发布成功",
                            type: "success"
                        });
                        // 刷新页面
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


    }


</script>
</html>
