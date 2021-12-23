<jsp:useBean id="user" scope="session" type="com.zzc775.crm.settings.domain.User"/>
<%--
Created by IntelliJ IDEA.
User: zzc775
Date: 2021/11/3
Time: 10:25
To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
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
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript">

        /**市场活动数据获取,包含根据条件查找数据和无脑查所有
         适用场景
         1.点击市场活动
         2.创建,修改,删除市场活动
         3.查询
         4.翻页相关
         参数说明:
         pageNo:第几页
         pageSize:一页的条目
         **/

        function pageList(pageNo, pageSize) {
            $("#search-name").val($("#hidden-name").val());
            $("#search-owner").val($("#hidden-owner").val());
            $("#search-startDate").val($("#hidden-startDate").val());
            $("#search-endDate").val($("#hidden-endDate").val());
            //刷新列表前把全选框的勾取消
            $("#selectAllBtn").prop("checked", false);
            $.ajax({
                url: "workbench/activity/getActivityList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $("#search-name").val().trim(),
                    "owner": $("#search-owner").val().trim(),
                    "startDate": $("#search-startDate").val().trim(),
                    "endDate": $("#search-endDate").val().trim()
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    //往市场活动列表添加数据
                    let htmlStr = "";
                    $.each(data["dataList"], function (i, n) {
                        htmlStr += "<tr class='active'>" +
                            "<td><input type='checkbox' name='activity-select' value='" + n.id + "'/></td>" +
                            "<td><a style='text-decoration: none; cursor: pointer;' onclick=\"window.location.href='workbench/activity/detail.do?id=" + n.id + "';\">" + n.name + "</a></td>" +
                            "<td>" + n.owner + "</td>" +
                            "<td> " + n.startDate + " </td>" +
                            "<td> " + n.endDate + " </td>" +
                            "</tr>";
                    });
                    $("#marketActivityList").html(htmlStr);
                    let totalPages = data.total % pageSize === 0 ? data.total / pageSize : parseInt((data.total / pageSize + 1).toString());
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo,
                        rowsPerPage: pageSize,//默认每页显示页码数量
                        maxRowsPerPage: 20,//最大每页显示页码数量
                        totalPages: totalPages,//总页数
                        totalRows: data.total,


                        visiblePageLinks: 5,//可视的每页显示页码数量


                        showGoToPage: true,
                        showRowsPerPage: false,
                        showRowsInfo: false,
                        showRowsDefaultInfo: false,//是否显示右侧的记录信息


                        directURL: false, // or a function with current page as argument
                        disableTextSelectionInNavPane: true, // disable text selection and double click


                        // bootstrap_version: "3",


                        // bootstrap 3
                        // containerClass: "height: 50px; position: relative;top: 60px;",
                        // mainWrapperClass: "row",
                        //
                        //
                        // navListContainerClass: "position: relative;top: -88px; left: 285px;",
                        // navListWrapperClass: "row",
                        // navListClass: "pagination",
                        // navListActiveItemClass: "active",


                        // navGoToPageContainerClass: "col-xs-6 col-sm-4 col-md-2 row-space",
                        // navGoToPageIconClass: "glyphicon glyphicon-arrow-right",
                        // navGoToPageClass: "form-control small-input",
                        //
                        //
                        // navRowsPerPageContainerClass: "col-xs-6 col-sm-4 col-md-2 row-space",
                        // navRowsPerPageIconClass: "glyphicon glyphicon-th-list",
                        // navRowsPerPageClass: "form-control small-input",
                        //
                        //
                        // navInfoContainerClass: "col-xs-12 col-sm-4 col-md-2 row-space",
                        // navInfoClass: "",


                        // element IDs
                        // nav_list_id_prefix: "nav_list_",
                        // nav_top_id_prefix: "top_",
                        // nav_prev_id_prefix: "prev_",
                        // nav_item_id_prefix: "nav_item_",
                        // nav_next_id_prefix: "next_",
                        // nav_last_id_prefix: "last_",
                        //
                        //
                        // nav_goto_page_id_prefix: "goto_page_",
                        // nav_rows_per_page_id_prefix: "rows_per_page_",
                        // nav_rows_info_id_prefix: "rows_info_",


                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        },
                        onLoad: function () {
                            // returns page_num and rows_per_page on plugin load
                        }
                    });
                }
            });
        }

        $(function () {
            pageList(1, 3);
            //为时间输入框绑定时间控件
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            //搜索按钮事件绑定
            $("#searchBtn").on("click", function () {
                $("#hidden-name").val($("#search-name").val());
                $("#hidden-owner").val($("#search-owner").val());
                $("#hidden-startDate").val($("#search-startDate").val());
                $("#hidden-endDate").val($("#search-endDate").val());
                pageList(1, 3);
            });

            /**
             实现全选功能
             这代码只有一次全选、全不选的效果 第三次点击checkAll会没有任何效果
             因为checked是checkbox的固有属性使用attr是直接删除设置属性可能会导致浏览器产生错误导致js无法继续执行
             解决:使用prop函数
             **/
            $("#selectAllBtn").on("click", function () {
                $("input[name='activity-select']").prop("checked", this.checked);
            });
            $("#marketActivityList").on("click", "input[name='activity-select']", function () {
                let val = $("input[name='activity-select']").length === $("input[name='activity-select']:checked").length;
                $("#selectAllBtn").prop("checked", val)
            });

            //为创建按钮绑定事件
            $("#createBtn").on("click", function () {
                getUserList();
                //打开模态窗口
                $("#createActivityModal").modal("show");
            });

            //创建市场活动模态窗口中保存按钮的点击事件
            $("#saveBtn").on("click", function () {
                createActivity();
            });

            //修改按钮事件绑定
            $("#editBtn").on("click", function () {
                getDetail(function (htmlStr) {
                    $("#create-marketActivityOwner").html(htmlStr).val("${user.id}");
                });


            });

            //修改模态窗口中更新按钮的事件绑定
            $("#updateBtn").on("click", function () {
                updateActivity();
            });

            //删除按钮绑定点击事件
            $("#deleteBtn").on("click", function () {
                deleteActivity();
            });
        });

        function getUserList(todo) {
            $.ajax({
                url: "workbench/activity/getUserList.do",
                type: "get",
                dataType: "json",
                success: function (data) {
                    var htmlStr;
                    $.each(data, function (i, n) {
                        htmlStr += "<option value='" + n.id + "'>" + n.name + "</option>";
                    });
                    todo(htmlStr);
                }
            });
        }

        function createActivity() {
            $.ajax({
                url: "workbench/activity/save.do",
                data: {
                    "owner": $("#create-marketActivityOwner").val().trim(),
                    "name": $("#create-marketActivityName").val().trim(),
                    "startDate": $("#create-startDate").val().trim(),
                    "endDate": $("#create-endDate").val().trim(),
                    "cost": $("#create-cost").val().trim(),
                    "description": $("#create-describe").val().trim()
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    //添加成功
                    if (data.success) {
                        //1.重置模态窗口
                        $("#create-form")[0].reset();
                        //2.关闭模态窗口
                        $("#createActivityModal").modal("hide");
                        //3.刷新活动列表

                        pageList(1, 2);
                    } else {
                        //添加失败
                        alert("添加失败")
                    }
                }
            })
        }

        function getDetail() {
            let obj = $("input[name='activity-select']:checked");
            if (obj.length !== 0) {
                let id = obj[0].value;
                //获取activity信息并填充到修改模态窗口
                $.ajax({
                    url: "workbench/activity/get.do",
                    data: {"id": id},
                    type: "get",
                    dataType: "json",
                    success: function (activity) {
                        $("#edit-marketActivityName").val(activity.name);
                        $("#edit-startDate").val(activity.startDate);
                        $("#edit-endDate").val(activity.endDate);
                        $("#edit-cost").val(activity.cost);
                        $("#edit-describe").val(activity.description);
                        getUserList(function (htmlStr) {
                            $("#edit-marketActivityOwner").html(htmlStr).val(activity.owner);
                        });
                    }
                });
                $("#editActivityModal").modal("show");
            }
        }

        function updateActivity() {
            let id = $("input[name='activity-select']:checked")[0].value;
            $.ajax({
                url: "workbench/activity/update.do",
                data: {
                    "id": id,
                    "owner": $("#edit-marketActivityOwner").val().trim(),
                    "name": $("#edit-marketActivityName").val().trim(),
                    "startDate": $("#edit-startDate").val().trim(),
                    "endDate": $("#edit-endDate").val().trim(),
                    "cost": $("#edit-cost").val().trim(),
                    "description": $("#edit-describe").val().trim()
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        $("#editActivityModal").modal("hide");
                        pageList(1, 3);
                    }
                }
            });
        }

        function deleteActivity() {
            let obj = $("input[name='activity-select']:checked");
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
                    url: "workbench/activity/delete.do",
                    data: param,
                    dataType: "json",
                    type: "get",
                    success: function (data) {
                        if (data.success) {
                            //刷新activityList
                            pageList(1, 3);
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

<%-- 搜索框存储隐藏域 --%>
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>


<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="create-form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <%--					设置了默认下拉框选择项,但是不生效

                                            已解决:select标签value属性在设置时必须存在带这个值option标签,后面在添加同值的select标签是无效的,会默认显示第一个option
                            --%>
                            <select class="form-control" id="create-marketActivityOwner">
                                <%--					用户名列表				--%>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate">
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <%--		data-dismiss="modal":关闭模态窗口			--%>
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="      font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate" value="2020-10-10"
                            >
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
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
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="search-form">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>
            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">

            <%--

                data-toggle="modal":声明点击事件为打开模态窗口
                data-target="#createActivityModal":声明要打开的目标模态窗口


            --%>
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
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="selectAllBtn"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="marketActivityList">
                <%--		市场活动列表			--%>
                </tbody>
            </table>
        </div>
        <div id="activityPage">
        </div>
    </div>
    <%--    style=""--%>
</div>
</body>
</html>