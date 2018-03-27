<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="UploadInfo.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.FamilySurvey.UploadInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .title
        {
            font-size: 20px;
            text-align: center;
            font-family: "微软雅黑" , "黑体" , "宋体";
            font-weight: bold;
        }
        .info
        {
            font-size: 16px;
            font-family: "微软雅黑" , "黑体" , "宋体";
            text-align: left;
            padding: 5px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <table style="width:100%;">
        <tr class="title">
            <td>家庭经济困难认定佐证材料注释</td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申请认定家庭经济困难的学生需要根据自身家庭实际情况提供相关佐证材料（即能够说明导致家庭贫困的主要事实材料，以下情况提供其中之一即可）：
            </td>
        </tr>
        <tr class="info">
            <td style="font-weight: bold;">
                注意：要求拍摄原件，图片格式上传
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1、广西农村建档立卡贫困户子女需提供《建档立卡扶贫对象证明》（须为县级扶贫办盖章、有经办人签字及联系电话）或者当年度《广西脱贫攻坚精准帮扶手册》的封面、2-3页、4-5页（须有乡（镇）党委、政府承诺书盖章处是乡（镇）党委、乡（镇）人民政府两个章）；区外建档立卡贫困户学生需提供当地通用材料（含当地扶贫办联系人、联系电话）；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2、享受城乡最低生活保障政策家庭需提供民政部门颁发的《城乡居民最低生活保障救助证》（简称低保证），未发放《低保证》的地区须出示城区或县以上民政部门的证明材料或低保对象审批表（县以上民政部门的审批表）（学生本人必须是低保证上标明的享受低保待遇人员和享受时间内）；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3、孤儿、父母双亡、单亲学生需提供家庭所在地乡镇或街道民政部门出具的相关证明；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4、学生本人或家庭成员残疾需提供《残疾证》（限学生本人、学生父母及未婚的兄弟姐妹）；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5、烈士子女或优抚对象学生需提供《烈军属证》或者相关证明；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6、家庭成员长期患有重大疾病的家庭需提供医院疾病诊断书、就诊发票或住院证明等；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7、具有国家助学贷款的学生需提供贷款合同；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;8、务农或兄弟姐妹多的家庭需提供户口簿人口明细表，含首页联和所有成员页面；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;9、成员下岗或待业家庭需提供《下岗证》或《失业人口登记表》等；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10、成员遭遇重大交通事故的家庭需提供交警部门的交通事故处理决定书、相关医疗、赔偿等证明材料；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;11、受自然灾害影响的家庭需提供由所在村及乡镇或街道以上单位加盖公章的材料，说明自然灾害类型、家庭成员伤亡、房屋倒塌、农作物失收等情况；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12、其他遭遇重大突发事件经济困难家庭需提供相关事件发生材料。
            </td>
        </tr>
    </table>
</asp:Content>
