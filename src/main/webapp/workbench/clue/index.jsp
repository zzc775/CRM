<%@ page contentType="text/html;charset=UTF-8" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

    <script type="text/javascript">

        function getClueList() {
            $.ajax({
                url: "workbench/clue/getList.do",
                type: "get",
                dataType: "json",
                success: function (data) {
                    var htmlStr = "";
                    $.each(data, function (i, n) {
                        htmlStr += "<tr>";
                        htmlStr += "<td><input type='checkbox' name='clue-select' value='" + n.id + "'/></td>";
                        htmlStr += "<td><a style='text-decoration: none; cursor: pointer;' onclick=\"window.location.href='workbench/clue/detail.do?id=" + n.id + "';\">" + n.fullName + "</a></td>";
                        htmlStr += "<td>" + n.company + "</td>";
                        htmlStr += "<td>" + n.mphone + "</td>";
                        htmlStr += "<td>" + n.phone + "</td>";
                        htmlStr += "<td>" + n.source + "</td>";
                        htmlStr += "<td>" + n.owner + "</td>";
                        htmlStr += "<td>" + n.state + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#clueList").html(htmlStr);
                }
            });
        }

        $(function () {
            //全选功能
            $("#selectAllBtn").on("click", function () {
                $("input[name='clue-select']").prop("checked", this.checked);
            })

            $("#clueList").on("click", "input[name='clue-select']", function () {
                var flag = $("input[name='clue-select']:checked").length === $("input[name='clue-select']").length;
                $("#selectAllBtn").prop("checked", flag);
            });


            getClueList();
            //为时间输入框绑定时间控件
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            //为创建按钮绑定事件
            $("#createBtn").on("click", function () {
                getUserList(function (htmlStr) {
                    $("#create-clueOwner").html(htmlStr).val("${user.id}");
                });
                $("#createClueModal").modal("show");
            });


            //创建clue
            $("#saveBtn").on("click", function () {
               createClue();
            });

            //更新按钮点击事件

            $("#editBtn").on("click",function () {
                getDetail();

            });

            $("#updateBtn").on("click",function () {
                updateClue();
            });


            //删除按钮绑定点击事件
            $("#deleteBtn").on("click", function () {
                deleteClue();
            });
        });

        //获取ownerList
        function getUserList(todo) {
            $.ajax({
                url: "workbench/clue/getUserList.do",
                type: "get",
                dataType: "json",
                success: function (data) {
                    var htmlStr;
                    $.each(data, function (i, n) {
                        htmlStr += "<option value='" + n.id + "'>" + n.name + "</option>";
                    })
                    todo(htmlStr);
                }
            });
        }

        //创建clue
        function createClue() {
            $.ajax({
                url: "workbench/clue/save.do",
                data: {
                    "fullName": $("#create-surname").val().trim(),
                    "appellation": $("#create-call").val().trim(),
                    "owner": $("#create-clueOwner").val().trim(),
                    "company": $("#create-company").val().trim(),
                    "job": $("#create-job").val().trim(),
                    "email": $("#create-email").val().trim(),
                    "phone": $("#create-phone").val().trim(),
                    "website": $("#create-website").val().trim(),
                    "mphone": $("#create-mphone").val().trim(),
                    "state": $("#create-status").val().trim(),
                    "source": $("#create-source").val().trim(),
                    "description": $("#create-describe").val().trim(),
                    "contactSummary": $("#create-contactSummary").val().trim(),
                    "nextContactTime": $("#create-nextContactTime").val().trim(),
                    "address": $("#create-address").val().trim(),
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        //1.重置模态窗口
                        $("#create-form")[0].reset();
                        //2.关闭模态窗口
                        $("#createClueModal").modal("hide");
                        //3.刷新活动列表
                        getClueList();
                    }
                }
            })
        }

        //获取clue信息

        function getDetail(){
            let obj = $("input[name='clue-select']:checked");
            if (obj.length !== 0) {
                let id = obj[0].value;
                //获取activity信息并填充到修改模态窗口
                $.ajax({
                    url: "workbench/clue/get.do",
                    data: {"id": id},
                    type: "get",
                    dataType: "json",
                    success: function (clue) {
                        $("#edit-company").val(clue.company);
                        $("#edit-call").val(clue.appellation);
                        $("#edit-surname").val(clue.fullName);
                        $("#edit-job").val(clue.job);
                        $("#edit-email").val(clue.email);
                        $("#edit-phone").val(clue.phone);
                        $("#edit-website").val(clue.website);
                        $("#edit-mphone").val(clue.mphone);
                        $("#edit-status").val(clue.state);
                        $("#edit-source").val(clue.source);
                        $("#edit-describe").val(clue.description);
                        $("#edit-contactSummary").val(clue.contactSummary);
                        $("#edit-nextContactTime").val(clue.nextContactTime);
                        $("#edit-address").val(clue.address);
                        getUserList(function (htmlStr) {
                            $("#edit-clueOwner").html(htmlStr).val(clue.owner);
                        });
                    }
                });
                //打开模态窗口
                $("#editClueModal").modal("show");
            }
        }


        //更新clue
        function updateClue() {
            let id = $("input[name='clue-select']:checked")[0].value;
            $.ajax({
                url: "workbench/clue/update.do",
                data: {
                    "id":id,
                    "fullName": $("#edit-surname").val().trim(),
                    "appellation": $("#edit-call").val().trim(),
                    "owner": $("#edit-clueOwner").val().trim(),
                    "company": $("#edit-company").val().trim(),
                    "job": $("#edit-job").val().trim(),
                    "email": $("#edit-email").val().trim(),
                    "phone": $("#edit-phone").val().trim(),
                    "website": $("#edit-website").val().trim(),
                    "mphone": $("#edit-mphone").val().trim(),
                    "state": $("#edit-status").val().trim(),
                    "source": $("#edit-source").val().trim(),
                    "description": $("#edit-describe").val().trim(),
                    "contactSummary": $("#edit-contactSummary").val().trim(),
                    "nextContactTime": $("#edit-nextContactTime").val().trim(),
                    "address": $("#edit-address").val().trim()
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        $("#editClueModal").modal("hide");
                        getClueList();
                    }
                }
            });

        }

        //删除clue
        function deleteClue() {
            let obj = $("input[name='clue-select']:checked");
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
                    url: "workbench/clue/delete.do",
                    data: param,
                    dataType: "json",
                    type: "get",
                    success: function (data) {
                        if (data.success) {
                            //刷新activityList
                            getClueList();
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


<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="create-form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueOwner">
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <c:forEach items="${appellation}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-status">
                                <c:forEach items="${clueState}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <c:forEach items="${source}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <c:forEach items="${appellation}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="https://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-status">
                                <c:forEach items="${clueState}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <c:forEach items="${source}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
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
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime"
                                       value="2017-05-01">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control">
                            <c:forEach items="${source}" var="c">
                                <option id="${c.id}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control">
                            <c:forEach items="${clueState}" var="c">
                                <option id="${c.id}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="selectAllBtn"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueList">
                </tbody>
            </table>
        </div>

<%--        <div style="height: 50px; position: relative;top: 60px;">--%>
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