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
            //????????????
            $("#selectAllBtn").on("click", function () {
                $("input[name='clue-select']").prop("checked", this.checked);
            })

            $("#clueList").on("click", "input[name='clue-select']", function () {
                var flag = $("input[name='clue-select']:checked").length === $("input[name='clue-select']").length;
                $("#selectAllBtn").prop("checked", flag);
            });


            getClueList();
            //????????????????????????????????????
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            //???????????????????????????
            $("#createBtn").on("click", function () {
                getUserList(function (htmlStr) {
                    $("#create-clueOwner").html(htmlStr).val("${user.id}");
                });
                $("#createClueModal").modal("show");
            });


            //??????clue
            $("#saveBtn").on("click", function () {
               createClue();
            });

            //????????????????????????

            $("#editBtn").on("click",function () {
                getDetail();

            });

            $("#updateBtn").on("click",function () {
                updateClue();
            });


            //??????????????????????????????
            $("#deleteBtn").on("click", function () {
                deleteClue();
            });
        });

        //??????ownerList
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

        //??????clue
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
                        //1.??????????????????
                        $("#create-form")[0].reset();
                        //2.??????????????????
                        $("#createClueModal").modal("hide");
                        //3.??????????????????
                        getClueList();
                    }
                }
            })
        }

        //??????clue??????

        function getDetail(){
            let obj = $("input[name='clue-select']:checked");
            if (obj.length !== 0) {
                let id = obj[0].value;
                //??????activity????????????????????????????????????
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
                //??????????????????
                $("#editClueModal").modal("show");
            }
        }


        //??????clue
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

        //??????clue
        function deleteClue() {
            let obj = $("input[name='clue-select']:checked");
            if (obj.length !== 0) {
                //????????????
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
                            //??????activityList
                            getClueList();
                        } else {
                            alert("????????????");
                        }
                    }
                });
            }
        }

    </script>
</head>
<body>


<!-- ??????????????????????????? -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">????????????</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="create-form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">?????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueOwner">
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">??????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <c:forEach items="${appellation}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">??????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-status">
                                <c:forEach items="${clueState}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <c:forEach items="${source}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">????????????</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">??????????????????</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">????????????</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button type="button" class="btn btn-primary" id="saveBtn">??????</button>
            </div>
        </div>
    </div>
</div>

<!-- ??????????????????????????? -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title">????????????</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">?????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">??????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="????????????">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <c:forEach items="${appellation}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">??????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="??????">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="https://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-status">
                                <c:forEach items="${clueState}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <c:forEach items="${source}" var="c">
                                    <option id="${c.id}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">?????????????????????????????????</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">????????????</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">???????????????????????????</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">??????????????????</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime"
                                       value="2017-05-01">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">????????????</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">??????????????????????????????</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
                <button type="button" class="btn btn-primary" id="updateBtn">??????</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>????????????</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">????????????</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">????????????</div>
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
                        <div class="input-group-addon">?????????</div>
                        <input class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">????????????</div>
                        <select class="form-control">
                            <c:forEach items="${clueState}" var="c">
                                <option id="${c.id}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn btn-default">??????</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createBtn"><span
                        class="glyphicon glyphicon-plus"></span> ??????
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> ??????
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> ??????
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="selectAllBtn"/></td>
                    <td>??????</td>
                    <td>??????</td>
                    <td>????????????</td>
                    <td>??????</td>
                    <td>????????????</td>
                    <td>?????????</td>
                    <td>????????????</td>
                </tr>
                </thead>
                <tbody id="clueList">
                </tbody>
            </table>
        </div>

<%--        <div style="height: 50px; position: relative;top: 60px;">--%>
<%--            <div>--%>
<%--                <button type="button" class="btn btn-default" style="cursor: default;">???<b>50</b>?????????</button>--%>
<%--            </div>--%>
<%--            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--                <button type="button" class="btn btn-default" style="cursor: default;">??????</button>--%>
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
<%--                <button type="button" class="btn btn-default" style="cursor: default;">???/???</button>--%>
<%--            </div>--%>
<%--            <div style="position: relative;top: -88px; left: 285px;">--%>
<%--                <nav>--%>
<%--                    <ul class="pagination">--%>
<%--                        <li class="disabled"><a href="#">??????</a></li>--%>
<%--                        <li class="disabled"><a href="#">?????????</a></li>--%>
<%--                        <li class="active"><a href="#">1</a></li>--%>
<%--                        <li><a href="#">2</a></li>--%>
<%--                        <li><a href="#">3</a></li>--%>
<%--                        <li><a href="#">4</a></li>--%>
<%--                        <li><a href="#">5</a></li>--%>
<%--                        <li><a href="#">?????????</a></li>--%>
<%--                        <li class="disabled"><a href="#">??????</a></li>--%>
<%--                    </ul>--%>
<%--                </nav>--%>
<%--            </div>--%>
<%--        </div>--%>

    </div>

</div>
</body>
</html>