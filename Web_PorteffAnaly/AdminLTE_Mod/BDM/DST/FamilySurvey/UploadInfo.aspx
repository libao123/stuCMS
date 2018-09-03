<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="UploadInfo.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.FamilySurvey.UploadInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .title
        {
            font-size: 20px;
            text-align: center;
            font-family: "微软雅黑" , "黑体" , "宋体";
            font-weight: bold;
            margin-bottom: 20px;
        }
        .info
        {
            font-size: 16px;
            font-family: "微软雅黑" , "黑体" , "宋体";
            text-align: left;
            padding: 5px;
            line-height: 40px;
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
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申请认定家庭经济困难的学生需要根据自身家庭实际情况提供相关佐证材料，即能够说明导致家庭贫困的主要事实材料，这些材料专门用于学校开展帮困助学工作，仅对履行相关职能的人员公开，不涉及其它事项。
            </td>
        </tr>
        <tr class="info">
            <td style="font-weight: bold;">
                注意：要求拍摄原件，图文清晰，图片格式或压缩包格式上传，同时需复印或打印一式两份带到学校上交存档，原件不需带到学校，符合相应条件即提供相应材料即可。
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1、广西农村建档立卡贫困户子女需提供<strong style="font-size: 18px;">当年度</strong>《广西脱贫攻坚精准帮扶手册》（贫困户/脱贫户保管）完整版（含封面封底和内部具体内容，依次拍摄编号）；区外建档立卡贫困户学生需提供当地通用材料（含当地扶贫办联系人、联系电话）；自2018年7月开始，自治区不再统一提供《建档立卡扶贫对象证明》模板，建议不再沿用，实在无法提供《帮扶手册》或官方发布的材料者可参照之前证明模板（须注明学生家庭建档立卡类型，是否脱贫，加盖县级扶贫办公章、有经办人签字及联系电话）；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2、享受城乡最低生活保障政策家庭（低保家庭）需提供民政部门颁发的《城乡居民最低生活保障救助证》（简称低保证），未发放《低保证》的地区须出示城区或县以上民政部门的证明材料或低保对象审批表（县以上民政部门的审批表）（学生本人必须是低保证上标明的享受低保待遇人员和享受时间内）；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3、孤儿、父母双亡、单亲学生需提供家庭所在地乡镇或街道民政部门出具的相关证明，离异家庭学生需提供离婚协议书、《离婚证》或其他法律文书；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4、学生本人或家庭成员残疾需提供《残疾证》（限学生本人、学生父母及未婚的兄弟姐妹）；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5、烈士子女或优抚对象学生需提供《烈军属证》或者户籍地人民政府或民政部门出具的相关证明，说明优抚类型或因见义勇为负伤情况等；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6、家庭成员长期患有重大疾病的家庭需提供医院疾病诊断书、病历卡、药费清单、就诊发票、住院证明或出院小结等；
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
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;9、在读子女多的家庭需提供在读子女的学生证页面、在读证明、学籍证明或录取通知书等，学龄前儿童和正在接受九年义务教育的家庭成员可用户口簿人口明细表代替；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10、成员下岗或待业家庭需提供《下岗证》或《失业人口登记表》等；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;11、成员遭遇重大交通事故的家庭需提供交警部门的交通事故处理决定书、相关医疗、赔偿等证明材料；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12、受自然灾害影响的家庭需提供由所在村及乡镇或街道以上单位加盖公章的受灾材料，说明自然灾害类型、家庭成员伤亡、房屋倒塌、农作物失收等情况，初步划分非常严重型：房屋完全倒塌、作物绝收、家庭成员死亡或重伤，等同特别困难；一般严重型：房屋受损较大、作物部分失收、家庭成员受轻伤，等同一般困难；
            </td>
        </tr>
        <tr class="info">
            <td>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;13、其他遭遇重大突发事件经济困难家庭需提供相关事件发生材料。
            </td>
        </tr>
    </table>
</asp:Content>
