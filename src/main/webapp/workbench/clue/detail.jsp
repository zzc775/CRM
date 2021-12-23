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
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function (events, handler) {
            $("#remark").on("focus", function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").on("click", function () {
                //清空添加评论文本
                $("#remark").val("");
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            getRelation();

            $("#createRelationBtn").on("click", function () {
                getActivityList();
            });

            $("#search-key").on("keydown", function (event) {
                if (event.key === "Enter") {
                    getActivityList();
                    return false;
                }
            });

            //全选功能
            $("#selectAll").on("click", function () {
                $("input[name='activity-select']").prop("checked", this.checked);
            });

            $("#activityList").on("click", "input[name='activity-select']", function () {
                let flag = $("input[name='activity-select']").length === $("input[name='activity-select']:checked").length;
                console.log(flag);
                $("#selectAll").prop("checked", flag)
            })

            //创建关联

            $("#addRelation").on("click", function () {
                addRelation();
            });

            //获取评论
            getRemarkList();

            //添加评论按钮绑定点击事件
            $("#addRemarkBtn").on("click",function () {
                addRemark();
            })

            //保存修改评论
            $("#updateRemarkBtn").on("click", function () {
                updateRemark();
            });
        });

        function getRelation() {
            //获取市场活动关联
            $.ajax({
                url: "workbench/clue/getRelation.do",
                data: {
                    "id": $("#clueId").val()
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    var htmlStr = "";
                    $.each(data, function (i, n) {
                        htmlStr += "<tr>";
                        htmlStr += "<td>" + n.name + "</td>";
                        htmlStr += "<td>" + n.startDate + "</td>";
                        htmlStr += "<td>" + n.endDate + "</td>";
                        htmlStr += "<td>" + n.owner + "</td>";
                        htmlStr += "<td><a href='javascript:void(0);' onclick='removeRelation(\"" + n.id + "\")' style='text-decoration: none;'><span class='glyphicon glyphicon-remove'></span>解除关联</a></td>";
                        htmlStr += "</tr>";
                    });
                    $("#relationList").html(htmlStr);
                }
            });
        }

        //解除市场活动关联
        function removeRelation(id) {
            $.ajax({
                url: "workbench/clue/removeRelation.do",
                data: {
                    "id": id
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        getRelation();
                    } else {
                        alert("解除关联失败");
                    }
                }
            });
        }

        function getActivityList() {
            $.ajax({
                url: "workbench/clue/getActivityList.do",
                type: "get",
                data: {
                    "id": $("#clueId").val(),
                    "name": $("#search-key").val().trim(),
                },
                dataType: "json",
                success: function (data) {
                    var htmlStr = "";
                    $.each(data, function (i, n) {
                        htmlStr += "<tr style='color: #B3B3B3;'>";
                        htmlStr += "<td><input name='activity-select' type='checkbox' value='" + n.id + "'/></td>";
                        htmlStr += "<td>" + n.name + "</td>";
                        htmlStr += "<td>" + n.startDate + "</td>";
                        htmlStr += "<td>" + n.endDate + "</td>";
                        htmlStr += "<td>" + n.owner + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#activityList").html(htmlStr);
                }
            });
        }

        function addRelation() {
            var obj = $("input[name='activity-select']:checked");

            if (obj.length !== 0) {
                let param = "";
                obj.each(function (i) {
                    param += "activityId=" + this.value + "&";
                });
                param += "clueId=" + $("#clueId").val();
                $.ajax({
                    url: "workbench/clue/addRelation.do",
                    data: param,
                    type: "get",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            getRelation();
                            $("#bundModal").modal("hide");
                        } else {
                            alert("添加失败");
                        }
                    }
                });
            }
        }

        //评论增删改
        //添加评论
        function addRemark() {
            $.ajax({
                url: "workbench/clue/saveRemark.do",
                data: {
                    "clueId": $("#clueId").val(),
                    "noteContent": $("#remark").val().trim()
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        getRemarkList();
                        $("#cancelBtn").trigger("click");
                    }
                }
            });
        }

        //修改remark
        function editRemark(id) {
            $.ajax({
                url: "workbench/clue/getRemarkContent.do",
                data: {
                    "id": id
                },
                dataType: "json",
                type: "get",
                success: function (data) {
                    if (data.success) {
                        $("#noteContent").val(data.content);
                    }
                }
            });
            $("#remarkId").val(id);
            $("#editRemarkModal").modal("show");
        }

        //保存修改的评论
        function updateRemark() {

            $.ajax({
                url: "workbench/clue/updateRemark.do",
                data: {
                    "id":$("#remarkId").val(),
                    "noteContent": $("#noteContent").val()
                },
                dataType: "json",
                type: "post",
                success: function (data) {
                    if (data.success) {
                        $("#editRemarkModal").modal("hide");
                        getRemarkList();
                    }
                }
            });
        }

        //删除remark
        function deleteRemark(id) {
            $.ajax({
                url: "workbench/clue/deleteRemark.do",
                data: {
                    "id": id
                },
                dataType: "json",
                type: "get",
                success: function (data) {
                    if (data.success) {
                        getRemarkList();
                    }
                }
            });
        }

        //初始化拼接的html
        function initHtml() {
            $(".remarkDiv").on("mouseover", function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").on("mouseout", function () {
                $(this).children("div").children("div").hide();
            });
            $(".myHref").on("mouseover", function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").on("mouseout", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });
        }

        //拉取备注
        function getRemarkList() {
            $.ajax({
                url: "workbench/clue/getRemarkList.do",
                data: "id=${clue.id}",
                type: "get",
                dataType: "json",
                success: function (data) {
                    var htmlSrt = "";
                    var clueName = "${clue.fullName}${clue.appellation}-${clue.company}";
                    $.each(data, function (i, remark) {
                        htmlSrt += "<div class='remarkDiv' style='height: 60px;'>";
                        htmlSrt += "<img title='" + remark.createBy + "' src='image/user-thumbnail.png' style='width: 30px; height:30px;'>";
                        htmlSrt += "<div style='position: relative; top: -40px; left: 40px;' >";
                        htmlSrt += "<h5>" + remark.noteContent + "</h5>";
                        htmlSrt += "<span style='color: gray; '>线索</span> <span style='color: gray; '>-</span> <b>" + clueName + "</b> <small style='color: gray;'> " + (remark.editFlag ? remark.editTime : remark.createTime) + " 由 " + remark.createBy + "</small>";
                        htmlSrt += "<div style='position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;'>";
                        htmlSrt += "<a class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-edit' onclick='editRemark(\"" + remark.id + "\")' style='font-size: 20px; color: #E6E6E6;'></span></a>";
                        htmlSrt += "&nbsp;&nbsp;&nbsp;&nbsp;";
                        htmlSrt += "<a class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-remove' onclick='deleteRemark(\"" + remark.id + "\")' style='font-size: 20px; color: #E6E6E6;'></span></a>";
                        htmlSrt += "</div>";
                        htmlSrt += "</div>";
                        htmlSrt += "</div>";
                    });
                    $("#remarkList").html(htmlSrt);
                    initHtml();
                }
            });

        }

    </script>

</head>
<body>
<input type="hidden" id="clueId" name="id" value="${clue.id}"/>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询"
                                   id="search-key">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="selectAll"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activityList">
                    <tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="addRelation">关联</button>
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
                <h4 class="modal-title" id="myModalLabel">修改线索</h4>
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
                                    <option value="${c.value}">${c.text}</option>
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
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <c:forEach items="${source}" var="c">
                                    <option value="${c.value}">${c.text}</option>
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
                                <input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
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
                <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${clue.fullName}&nbsp;<small>${clue.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default"
                onclick="window.location.href='workbench/clue/convert.jsp?id=${clue.id}&fullName=${clue.fullName}&company=${clue.company}&appellation=${clue.appellation}&owner=${clue.owner}';">
            <span class="glyphicon glyphicon-retweet"></span> 转换
        </button>
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullName}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>12345678901</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>
    <div id="remarkList">
        <!-- 备注1 -->
        <div class="remarkDiv" style="height: 60px;">
            <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>哎呦！</h5>
                <span style="color: gray; ">线索</span> <span style="color: gray; ">-</span> <b>李四先生-动力节点</b> <small
                    style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>

        <!-- 备注2 -->
        <div class="remarkDiv" style="height: 60px;">
            <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>呵呵！</h5>
                <span style="color: gray; ">线索</span> <span style="color: gray; ">-</span> <b>李四先生-动力节点</b> <small
                    style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </div>


    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="addRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="relationList">
                <tr>
                    <td>发传单</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                    <td>zhangsan</td>
                    <td><a href="javascript:void(0);" style="text-decoration: none;"><span
                            class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>
                <tr>
                    <td>发传单</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                    <td>zhangsan</td>
                    <td><a href="javascript:void(0);" style="text-decoration: none;"><span
                            class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="createRelationBtn" data-toggle="modal" data-target="#bundModal"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>