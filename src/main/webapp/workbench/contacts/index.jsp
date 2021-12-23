<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="source" scope="application" type="java.util.List"/>
<jsp:useBean id="appellation" scope="application" type="java.util.List"/>
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

        $(function () {

            //定制字段
            $("#definedColumns > li").on("click", function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            //为时间输入框绑定时间控件
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            //全选功能
            //全选功能
            $("#selectAllBtn").on("click", function () {
                $("input[name='contacts-select']").prop("checked", this.checked);
            })

            $("#contactsList").on("click", "input[name='contacts-select']", function () {
                var flag = $("input[name='contacts-select']:checked").length === $("input[name='contacts-select']").length;
                $("#selectAllBtn").prop("checked", flag);
            });

            //创建和修改客户名称自动补全功能
            $("#create-customerName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/contacts/getCustomerList.do",
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

            $("#edit-customerName").typeahead({
                source: function (query, process) {
                    $.post(
                        "workbench/contacts/getCustomerList.do",
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

            //加载联系人
            getContactsList();

            //给创建按钮绑定事件
            $("#createBtn").on("click", function () {
                getUserList(function (htmlStr) {
                    $("#create-contactsOwner").html(htmlStr).val("${user.id}");
                });
                getCustomerList();
            })

            //给创建-保存按钮添加事件
            $("#saveBtn").on("click", function () {
                createContacts();
            })

            //更新按钮点击事件
            $("#editBtn").on("click", function () {
                getDetail();
                getCustomerList();
            });

            $("#updateBtn").on("click", function () {

                updateContacts();
            });


            //删除按钮绑定点击事件
            $("#deleteBtn").on("click", function () {
                deleteContacts();
            });

        });

        function getContactsList() {
            $.ajax({
                url: "workbench/contacts/getList.do",
                type: "get",
                dataType: "json",
                success: function (data) {
                    var htmlStr = "";
                    $.each(data, function (i, n) {
                        htmlStr += "<tr>";
                        htmlStr += "<td><input type='checkbox' name='contacts-select' value='" + n.id + "'/></td>";
                        htmlStr += "<td><a style='text-decoration: none; cursor: pointer;' onclick=\"window.location.href='workbench/contacts/detail.do?id=" + n.id + "';\">" + n.fullName + "</a></td>";
                        htmlStr += "<td>" + n.appellation + "</td>";
                        htmlStr += "<td>" + n.owner + "</td>";
                        htmlStr += "<td>" + n.source + "</td>";
                        htmlStr += "<td>" + n.birth + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#contactsList").html(htmlStr);
                }
            });
        }

        //获取所有者列表

        function getUserList(todo) {
            $.ajax({
                url: "workbench/contacts/getUserList.do",
                type: "get",
                dataType: "json",
                success: function (data) {
                    let htmlStr;
                    $.each(data, function (i, n) {
                        htmlStr += "<option value='" + n.id + "'>" + n.name + "</option>";
                    })
                    todo(htmlStr);
                }
            });
        }

        // //获取客户列表
        //
        // function getCustomerList() {
        //     $.ajax({
        //         url: "workbench/contacts/getCustomerList.do",
        //         type: "get",
        //         dataType: "json",
        //         success: function (data) {
        //             let htmlStr;
        //             $.each(data, function (i, n) {
        //                 htmlStr += "<option value='" + n.name + "'></option>";
        //             })
        //             $("#create-customer-list").html(htmlStr);
        //             $("#edit-customer-list").html(htmlStr);
        //         }
        //     });
        // }

        //创建联系人

        function createContacts() {
            $.ajax({
                url: "workbench/contacts/add.do",
                data: {
                    "owner": $("#create-contactsOwner").val(),
                    "source": $("#create-clueSource").val(),
                    "fullName": $("#create-surname").val().trim(),
                    "appellation": $("#create-call").val(),
                    "job": $("#create-job").val().trim(),
                    "mphone": $("#create-mphone").val().trim(),
                    "email": $("#create-email").val().trim(),
                    "birth": $("#create-birth").val(),
                    "customerName": $("#create-customerName").val().trim(),
                    "description": $("#create-describe").val(),
                    "contactSummary": $("#create-contactSummary").val(),
                    "nextContactsTime": $("#create-nextContactTime").val(),
                    "address": $("#create-address").val()
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        $("#create-form")[0].reset();
                        getContactsList();
                        $("#createContactsModal").modal("hide");
                    }
                }
            });
        }


        //获取详情
        function getDetail() {
            let obj = $("input[name='contacts-select']:checked");
            if (obj.length !== 0) {
                let id = obj[0].value;
                //获取activity信息并填充到修改模态窗口
                $.ajax({
                    url: "workbench/contacts/get.do",
                    data: {"id": id},
                    type: "get",
                    dataType: "json",
                    success: function (contacts) {
                        $("#edit-clueSource").val(contacts.source);
                        $("#edit-surname").val(contacts.fullName);
                        $("#edit-call").val(contacts.appellation);
                        $("#edit-job").val(contacts.job);
                        $("#edit-mphone").val(contacts.mphone);
                        $("#edit-email").val(contacts.email);
                        $("#edit-birth").val(contacts.birth);
                        $("#edit-customerName").val(contacts.customerId);
                        $("#edit-describe").val(contacts.description);
                        $("#edit-contactSummary").val(contacts.contactSummary);
                        $("#edit-nextContactTime").val(contacts.nextContactTime);
                        $("#edit-address").val(contacts.address);
                        getUserList(function (htmlStr) {
                            $("#edit-contactsOwner").html(htmlStr).val(contacts.owner);
                        });
                    }
                });
                //打开模态窗口
                $("#editContactsModal").modal("show");
            }
        }

        //更新contacts
        function updateContacts() {
            let id = $("input[name='contacts-select']:checked")[0].value;

            $.ajax({
                url: "workbench/contacts/update.do",
                data: {
                    "id": id,
                    "owner": $("#edit-contactsOwner").val(),
                    "source": $("#edit-clueSource").val(),
                    "fullName": $("#edit-surname").val().trim(),
                    "appellation": $("#edit-call").val(),
                    "job": $("#edit-job").val().trim(),
                    "mphone": $("#edit-mphone").val().trim(),
                    "email": $("#edit-email").val().trim(),
                    "birth": $("#edit-birth").val(),
                    "customerName": $("#edit-customerName").val().trim(),
                    "description": $("#edit-describe").val(),
                    "contactSummary": $("#edit-contactSummary").val(),
                    "nextContactsTime": $("#edit-nextContactTime").val(),
                    "address": $("#edit-address").val()
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        $("#editContactsModal").modal("hide");
                        getContactsList();
                    }
                }
            });

        }

        //删除contacts
        function deleteContacts() {
            let obj = $("input[name='contacts-select']:checked");
            console.log("delete" + obj.length);

            if (obj.length !== 0) {
                //参数拼接
                let param = "";
                obj.each(function (i) {
                    param += "id=" + this.value;
                    if (i !== obj.length - 1) {
                        param += "&";
                    }
                });
                $.ajax({
                    url: "workbench/contacts/delete.do",
                    data: param,
                    dataType: "json",
                    type: "get",
                    success: function (data) {
                        if (data.success) {
                            //刷新activityList
                            getContactsList();
                        } else {
                            alert("删除失败");
                        }
                    }
                });
            }
        }
    </script>
</head>
<body>


<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="create-form">

                    <div class="form-group">
                        <label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-contactsOwner">
                                <%--              所有者列表                  --%>
                            </select>
                        </div>
                        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueSource">
                                <c:forEach items="${source}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <c:forEach var="c" items="${appellation}">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-birth">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label time">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-contactsOwner">
                                <option selected>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueSource">
                                <c:forEach items="${source}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="李四">
                        </div>
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <c:forEach var="c" items="${appellation}">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                        <label for="edit-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-birth">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>联系人列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">姓名</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control">
                            <c:forEach var="c" items="${source}">
                                <option value="${c.value}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">生日</div>
                        <input class="form-control time" type="text">
                    </div>
                </div>

                <button type="submit" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createContactsModal"
                        id="createBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="selectAllBtn"/></td>
                    <td>姓名</td>
                    <td>客户名称</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>生日</td>
                </tr>
                </thead>
                <tbody id="contactsList">
                <%--联系人列表--%>
                </tbody>
            </table>
        </div>

        <%--        <div style="height: 50px; position: relative;top: 10px;">--%>
        <%--            <div>--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
        <%--            </div>--%>
        <%--            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
        <%--                <div class="btn-group">--%>
        <%--                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
        <%--                        10--%>
        <%--                        <span class="caret"></span>--%>
        <%--                    </button>--%>
        <%--                    <ul class="dropdown-menu" role="menu">--%>
        <%--                        <li><a href="#">20</a></li>--%>
        <%--                        <li><a href="#">30</a></li>--%>
        <%--                    </ul>--%>
        <%--                </div>--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
        <%--            </div>--%>
        <%--            <div style="position: relative;top: -88px; left: 285px;">--%>
        <%--                <nav>--%>
        <%--                    <ul class="pagination">--%>
        <%--                        <li class="disabled"><a href="#">首页</a></li>--%>
        <%--                        <li class="disabled"><a href="#">上一页</a></li>--%>
        <%--                        <li class="active"><a href="#">1</a></li>--%>
        <%--                        <li><a href="#">2</a></li>--%>
        <%--                        <li><a href="#">3</a></li>--%>
        <%--                        <li><a href="#">4</a></li>--%>
        <%--                        <li><a href="#">5</a></li>--%>
        <%--                        <li><a href="#">下一页</a></li>--%>
        <%--                        <li class="disabled"><a href="#">末页</a></li>--%>
        <%--                    </ul>--%>
        <%--                </nav>--%>
        <%--            </div>--%>
        <%--        </div>--%>

    </div>

</div>
</body>
</html>