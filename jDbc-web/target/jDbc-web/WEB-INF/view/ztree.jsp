<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/zTreeStyle/zTreeStyle.css" type="text/css">
    <script type="text/javascript" src="js/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="js/jquery.ztree.core.js"></script>
    <script type="text/javascript" src="js/jquery.ztree.excheck.js"></script>
    <script type="text/javascript" src="js/jquery.ztree.exedit.js"></script>

    <style type="text/css">
        .ztree {
            font-size: 18px;
        }

        .ztree li span.button.add {
            margin-left: 2px;
            margin-right: -1px;
            background-position: -144px 0;
            vertical-align: top;
            *vertical-align: middle
        }
    </style>
    <title>zTree-Demo</title>
</head>
<%@ include file="../../common/common-empty.jsp" %>
<input type="hidden" id="ctx" value="${ctx}"/>
<body>

<h1>This is zTree Demo</h1>
<ul id="treeDemo" class="ztree"></ul>

<script type="text/javascript">
    var $ctx = $("#ctx").val();
    // zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
    var setting = {
        check:{
            enable:true
        },
        edit: {
            enable: true,
            removeTitle: "删除",
            renameTitle: "重命名",
            showRemoveBtn: true,
            showRenameBtn: true
        },
        data: {
            simpleData: {
                enable: true,
                idKey: "id",
                pIdKey: "pid",
                rootPid: 0
            }
        },
        view: {
            showIcon: false,
            addHoverDom: addHoverDom,
            removeHoverDom: removeHoverDom,
            selectedMulti: false
        },
        callback: {
            onRename: onRename,
            onRemove: onRemove
        }
    };

    var newCount = 1;
    function addHoverDom(treeId, treeNode) {
        var sObj = $("#" + treeNode.tId + "_span");
        if (treeNode.editNameFlag || $("#addBtn_" + treeNode.tId).length > 0) return;
        var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
                + "' title='新增' onfocus='this.blur();'></span>";
        sObj.after(addStr);
        var btn = $("#addBtn_" + treeNode.tId);
        if (btn) btn.bind("click", function () {
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            alert("newCount : " + newCount);
            var tempCount = newCount;
            zTree.addNodes(treeNode, {id: (100 + newCount), pId: treeNode.id, name: "new node" + (newCount++)});

            // 向数据库中增加此节点
            $.post($ctx + '/add', {
                "id": (100 + tempCount),
                "pid": treeNode.id,
                "name": "new node" + tempCount
            }, function (data) {
                alert("success");
            }, "text");

            return false;
        });
    }
    ;
    function removeHoverDom(treeId, treeNode) {
        $("#addBtn_" + treeNode.tId).unbind().remove();
    }
    ;

    function onRename(event, treeId, treeNode, isCancel) {
        alert("rename:" + treeNode.id + ":" + treeNode.pid + ":" + treeNode.name);
        $.post($ctx + '/rename', {"id": treeNode.id, "pid": treeNode.pid, "name": treeNode.name}, function (data) {
            alert("success");
        }, "text");
    }

    function onRemove(event, treeId, treeNode) {
        alert("remove:" + treeNode.id + ":" + treeNode.pid + ":" + treeNode.name);
        $.get($ctx + '/remove', {"id": treeNode.id, "pid": treeNode.pid, "name": treeNode.name}, function (data) {
            alert("success");
        }, "text");
    }

    $.ajax({
        url: $ctx + '/getAllTree',
        type: 'get',
        dataType: 'json',
        async: false,
//    		data : {cdoi: cdoi1, title: title1},
        success: function (data) {
            $.fn.zTree.init($("#treeDemo"), setting, data);
        }, error: function () {
            alert("error");
        }
    });

</script>
</body>
</html>