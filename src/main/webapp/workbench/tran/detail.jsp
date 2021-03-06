<%@ page contentType="text/html;charset=UTF-8" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title></title>

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>

    <style>
        .myStage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;
        var json = ${stageJson};
        $(function () {
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
                //清空
                $("#remark").val("");
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            initHtml();

            //阶段提示框
            $(".myStage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });

            //可能性初始化
            $("#possibility").html("<b>" + json["${tran.stage}"] + "</b>");
            getRemarkList();
            //保存评论
            $("#saveRemarkBtn").on("click",function () {
                addRemark();
            });

            //保存修改评论
            $("#updateRemarkBtn").on("click",function () {
                updateRemark();
            });
            getHistoryList();
        });

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

        //获取评论
        function getRemarkList() {
            $.ajax({
                url: "workbench/tran/getRemarkList.do",
                data: {
                    "tranId": $("#tranId").val()
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    var tranName = "${tran.name}";
                    var htmlStr = "";
                    $.each(data, function (i, remark) {
                        htmlStr += "<div class='remarkDiv' style='height: 60px;'>";
                        htmlStr += "<img title='" + remark.createBy + "' src='image/user-thumbnail.png' style='width: 30px; height:30px;'>";
                        htmlStr += "<div style='position: relative; top: -40px; left: 40px;' >";
                        htmlStr += "<h5>" + remark.noteContent + "</h5>";
                        htmlStr += "<span style='color: gray; '>交易</span> <span style='color: gray; '>-</span> <b>" + tranName + "</b> <small style='color: gray;'> " + (remark.editFlag ? remark.editTime : remark.createTime) + " 由 " + remark.createBy + "</small>";
                        htmlStr += "<div style='position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;'>";
                        htmlStr += "<a class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-edit' onclick='editRemark(\"" + remark.id + "\")' style='font-size: 20px; color: #E6E6E6;'></span></a>";
                        htmlStr += "&nbsp;&nbsp;&nbsp;&nbsp;";
                        htmlStr += "<a class='myHref' href='javascript:void(0);'><span class='glyphicon glyphicon-remove' onclick='deleteRemark(\"" + remark.id + "\")' style='font-size: 20px; color: #E6E6E6;'></span></a>";
                        htmlStr += "</div>";
                        htmlStr += "</div>";
                        htmlStr += "</div>";
                    });
                    $("#remark-list").html(htmlStr);
                    initHtml();
                }
            });
        }

        //添加评论
        function addRemark() {
            $.ajax({
                url: "workbench/tran/saveRemark.do",
                data: {
                    "tranId": $("#tranId").val(),
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
                url: "workbench/tran/getRemarkContent.do",
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

        //保存修改后的评论
        function updateRemark() {
            $.ajax({
                url: "workbench/tran/updateRemark.do",
                data: {
                    "id": $("#remarkId").val(),
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
                url: "workbench/tran/deleteRemark.do",
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




        function getHistoryList() {
            $.ajax({
                url: "workbench/tran/getHistoryList.do",
                data:{
                    "id": $("#tranId").val()
                },
                type:"get",
                dataType:"json",
                success:function (data) {
                    var htmlStr = "";
                    $.each(data,function (i,n) {
                        htmlStr += "<tr>";
                        htmlStr += "<td>"+n.stage+"</td>";
                        htmlStr += "<td>"+n.money+"</td>";
                        htmlStr += "<td>"+json[n.stage]+"</td>";
                        htmlStr += "<td>"+n.expectedDate+"</td>";
                        htmlStr += "<td>"+n.createTime+"</td>";
                        htmlStr += "<td>"+n.createBy+"</td>";
                        htmlStr += "</tr>";
                    })
                    $("#history-list").html(htmlStr);
                }
            });

        }


    </script>

</head>
<body>
<input type="hidden" id="tranId" value="${tran.id}">


<!-- 修改交易备注的模态窗口 -->
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
                        <label for="noteContent" class="col-sm-2 control-label">内容</label>
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
<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${tran.name} <small>￥${tran.money}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <span class="glyphicon glyphicon-ok-circle myStage" data-toggle="popover" data-placement="bottom"
          data-content="资质审查" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-ok-circle myStage" data-toggle="popover" data-placement="bottom"
          data-content="需求分析" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-ok-circle myStage" data-toggle="popover" data-placement="bottom"
          data-content="价值建议" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-ok-circle myStage" data-toggle="popover" data-placement="bottom"
          data-content="确定决策者" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-map-marker myStage" data-toggle="popover" data-placement="bottom"
          data-content="提案/报价" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-record myStage" data-toggle="popover" data-placement="bottom"
          data-content="谈判/复审"></span>
    -----------
    <span class="glyphicon glyphicon-record myStage" data-toggle="popover" data-placement="bottom"
          data-content="成交"></span>
    -----------
    <span class="glyphicon glyphicon-record myStage" data-toggle="popover" data-placement="bottom"
          data-content="丢失的线索"></span>
    -----------
    <span class="glyphicon glyphicon-record myStage" data-toggle="popover" data-placement="bottom"
          data-content="因竞争丢失关闭"></span>
    -----------
    <span class="closingDate">2010-10-10</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;" id="possibility"><b>-1</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${tran.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${tran.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${tran.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 100px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <div id="remark-list">
        <%--        <!-- 备注1 -->--%>
        <%--        <div class="remarkDiv" style="height: 60px;">--%>
        <%--            <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
        <%--            <div style="position: relative; top: -40px; left: 40px;">--%>
        <%--                <h5>哎呦！</h5>--%>
        <%--                <span style="color: gray; ">交易</span> <span style="color: gray; ">-</span> <b>动力节点-交易01</b> <small--%>
        <%--                    style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
        <%--                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
        <%--                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"--%>
        <%--                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
        <%--                    &nbsp;&nbsp;&nbsp;&nbsp;--%>
        <%--                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"--%>
        <%--                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
        <%--                </div>--%>
        <%--            </div>--%>
        <%--        </div>--%>

        <%--        <!-- 备注2 -->--%>
        <%--        <div class="remarkDiv" style="height: 60px;">--%>
        <%--            <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
        <%--            <div style="position: relative; top: -40px; left: 40px;">--%>
        <%--                <h5>呵呵！</h5>--%>
        <%--                <span style="color: gray; ">交易</span> <span style="color: gray; ">-</span> <b>动力节点-交易01</b> <small--%>
        <%--                    style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
        <%--                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
        <%--                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"--%>
        <%--                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
        <%--                    &nbsp;&nbsp;&nbsp;&nbsp;--%>
        <%--                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"--%>
        <%--                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
        <%--                </div>--%>
        <%--            </div>--%>
        <%--        </div>--%>
    </div>


    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody id="history-list">
                <tr>
                    <td>资质审查</td>
                    <td>5,000</td>
                    <td>10</td>
                    <td>2017-02-07</td>
                    <td>2016-10-10 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>需求分析</td>
                    <td>5,000</td>
                    <td>20</td>
                    <td>2017-02-07</td>
                    <td>2016-10-20 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>谈判/复审</td>
                    <td>5,000</td>
                    <td>90</td>
                    <td>2017-02-07</td>
                    <td>2017-02-09 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>