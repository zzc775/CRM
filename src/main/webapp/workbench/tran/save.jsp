<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title></title>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
        var json = ${stageJson};
        $(function () {
            //为时间输入框绑定时间控件
            $(".time1").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $(".time2").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            //创建和修改客户名称自动补全功能
            $("#create-accountName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/tran/getCustomerList.do",
                        {"name": query},
                        function (data) {
                            //alert(data);
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 1500
            });

            getUserList();

            //打开是市场活动窗口
            $("#open-search").on("click", function () {
                getActivityList();
            });

            //市场活动搜索
            $("#search-key").on("keydown", function (event) {
                if (event.key === "Enter") {
                    getActivityList();
                    return false;
                }
            });

            //打开是联系人窗口
            $("#open-search1").on("click", function () {
                getContactsList();
            });

            //联系人搜索
            $("#search-key1").on("keydown", function (event) {
                if (event.key === "Enter") {
                    getContactsList();
                    return false;
                }
            });

            //保存按钮事件
            $("#saveBtn").on("click",function () {
                $("#save-form").trigger("submit");
            })

            //阶段可能性变更绑定
            $("#create-transactionStage").on("change",function () {
                var key = this.value;
                $("#create-possibility").val(json[key]);
            });
        });

        //获取用户列表
        function getUserList() {
            $.ajax({
                url: "workbench/tran/getUserList.do",
                type: "get",
                dataType: "json",
                success: function (data) {
                    let htmlStr;
                    $.each(data, function (i, n) {
                        htmlStr += "<option value='" + n.id + "'>" + n.name + "</option>";
                    })
                    $("#create-transactionOwner").html(htmlStr);
                }
            });
        }

        //获取市场活动源
        function getActivityList() {
            $.ajax({
                url: "workbench/tran/getActivityList.do",
                type: "get",
                data: {
                    "name": $("#search-key").val().trim(),
                },
                dataType: "json",
                success: function (data) {
                    var htmlStr = "";
                    $.each(data, function (i, n) {
                        htmlStr += "<tr onclick=\"beSelect('" + n.id + "','" + n.name + "')\">";
                        htmlStr += "<td>" + n.name + "</td>";
                        htmlStr += "<td>" + n.startDate + "</td>";
                        htmlStr += "<td>" + n.endDate + "</td>";
                        htmlStr += "<td>" + n.owner + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#activity-list").html(htmlStr);
                }
            });
        }

        //市场活动源被选中
        function beSelect(id, name) {
            $("#create-activitySrc").val(name);
            $("#create-activityId").val(id);
            $("#findMarketActivity").modal("hide");
        }

        //获取联系人名称
        function getContactsList() {
            $.ajax({
                url: "workbench/tran/getContactsList.do",
                type: "get",
                data: {
                    "name": $("#search-key1").val().trim(),
                },
                dataType: "json",
                success: function (data) {
                    var htmlStr = "";
                    $.each(data, function (i, n) {
                        htmlStr += "<tr onclick=\"beSelect1('" + n.id + "','" + n.fullName + "')\">";
                        htmlStr += "<td>" + n.fullName + "</td>";
                        htmlStr += "<td>" + n.email + "</td>";
                        htmlStr += "<td>" + n.mphone + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#contacts-list").html(htmlStr);
                }
            });
        }

        //市场活动源被选中
        function beSelect1(id, name) {
            $("#create-contactsName").val(name);
            $("#create-contactsId").val(id);
            $("#findContacts").modal("hide");
        }

    </script>

</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询" id="search-key">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activity-list">
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>发传单</td>--%>
                    <%--                        <td>2020-10-10</td>--%>
                    <%--                        <td>2020-10-20</td>--%>
                    <%--                        <td>zhangsan</td>--%>
                    <%--                    </tr>--%>
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>发传单</td>--%>
                    <%--                        <td>2020-10-10</td>--%>
                    <%--                        <td>2020-10-20</td>--%>
                    <%--                        <td>zhangsan</td>--%>
                    <%--                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询"
                                   id="search-key1">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contacts-list">
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>李四</td>--%>
                    <%--                        <td>lisi@bjpowernode.com</td>--%>
                    <%--                        <td>12345678901</td>--%>
                    <%--                    </tr>--%>
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>李四</td>--%>
                    <%--                        <td>lisi@bjpowernode.com</td>--%>
                    <%--                        <td>12345678901</td>--%>
                    <%--                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
        <button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;" id="save-form" action="workbench/tran/save.do" method="post">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionOwner" name="owner">
                <%--                <option>zhangsan</option>--%>
                <%--                <option>lisi</option>--%>
                <%--                <option>wangwu</option>--%>
            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney" name="money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName" name="name">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time1" id="create-expectedClosingDate" name="expectedDate" readonly style="cursor: pointer;">
        </div>
    </div>

    <div class="form-group">
        <label for="create-accountName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建" name="customerName">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionStage" name="stage">
                <c:forEach var="c" items="${stage}">
                    <option value="${c.value}">${c.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType" name="type">
                <c:forEach var="c" items="${transactionType}">
                    <option value="${c.value}">${c.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility" value="10" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource" name="source">
                <c:forEach var="c" items="${source}">
                    <option value="${c.value}">${c.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a id="open-search"
                                                                                           href="javascript:void(0);"
                                                                                           data-toggle="modal"
                                                                                           data-target="#findMarketActivity"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activitySrc" readonly>
            <input type="hidden" name="activityId" id="create-activityId">
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                            data-toggle="modal"
                                                                                            data-target="#findContacts"><span
                class="glyphicon glyphicon-search" id="open-search1"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-contactsName" readonly>
            <input type="hidden" name="contactsId" id="create-contactsId">
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime" readonly style="cursor: pointer;">
        </div>
    </div>

</form>
</body>
</html>