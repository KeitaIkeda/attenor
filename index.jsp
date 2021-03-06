<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.*,java.util.regex.*,java.util.*,java.text.SimpleDateFormat,org.apache.commons.codec.digest.DigestUtils" %>
<!DOCTYPE html>
<html lang="ja">

  <head>
    <meta charset="UTF-8">
      <meta content="width=device-width, initial-scale=1, user-scalable=no" name=viewport>
        <title>attenor</title>
        <%
    String atdbook_name = "高井ゼミ2014年度ゼミ生",atdbook_id = null;
    atdbook_id = DigestUtils.md5Hex(atdbook_name);
    //DB接続
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/attenor", "attenor", "attenor");
    Statement stmt = conn.createStatement();

    //出欠対象の人数を取得
    ResultSet rs = stmt.executeQuery("select count(*) as cnt from attendancebooks where attendancebooks_atdbookid = '" + atdbook_id + "';");
    rs.next();
    int usr_cnt = rs.getInt("cnt");
    rs.close();
    String usr_fname[] = new String[usr_cnt];
    String usr_lname[] = new String[usr_cnt];
    String usr_id[] = new String[usr_cnt];

    //氏名・ユーザIDを取得後、配列に格納
    rs = stmt.executeQuery("select * from attendancebooks where attendancebooks_atdbookid = '" + atdbook_id + "';");
    for(int n = 0;rs.next();n++){
      usr_fname[n] = rs.getString("attendancebooks_fname");
      usr_lname[n] = rs.getString("attendancebooks_lname");
      usr_id[n] = rs.getString("attendancebooks_usrid");
    }
    rs.close();

    //データ受信部分 未実装
    /*String sample = "",fm_usr_fname = null;
    request.setCharacterEncoding("UTF-8");
    fm_usr_fname = request.getParameter(usr_id[0]);
    if(!(fm_usr_fname == null)){
      for(int n = 0;n < usr_cnt;n++){
        if(request.getParameter(usr_id[n]).equals("1")){
          sample += usr_id[n] + "<br>";
        }
      }
    }*/

    %>
        <script>
          <%
    //全ユーザIDをJS利用のためJS配列に代入。
    out.println("var usr_id = new Array(" + usr_cnt + ");");
    for(int n = 0;n < usr_cnt;n++){
      out.println("usr_id[" + n + "] = '" + usr_id[n] + "';");
    }
    %>

          //フォーム送信時に未チェックのチェックボックスも未チェックであれば value=0 で送信されるようvalueを変更しチェックをつけた後submitしている。
          //受信時に全ユーザの出欠データが存在した方がより処理しやすいと考えたため。
          var atd_chk = function () {
            <%
          for(int n = 0;n < usr_cnt;n++){
            out.println("if (!atd_fm." + usr_id[n] + ".checked) {atd_fm." + usr_id[n] + ".value = '0';atd_fm." + usr_id[n] + ".checked = true;}");
          }
          %>
            atd_fm.submit();
          }

          //引数in,outに応じて送信確認画面の表示非表示を切り替える。
          var sub_chk = function (a) {
            if (a == "in") {
              document.getElementById("cover").style.display = "block";
            } else if (a == "out") {
              document.getElementById("cover").style.display = "none";
            }

          }

          //チェックボックス変更時に実行され、その時点での出席者と欠席者の数を表示する。
          var checked_num = function () {
            var usr_cnt = atd_fm.usr_cnt.value;
            var attend = 0,
              absent = 0;
            for (var i = 0; i < usr_cnt; i++) {
              if (atd_fm.elements[i].checked) {
                attend++;
              }
            }
            absent = usr_cnt - attend;
            document.getElementById("atdornot").innerHTML = "出席：" + attend + "人<br>欠席：" + absent + "人";
          }
        </script>
        <style type="text/css">
          html,
          body {
            height: 100%;
            margin: 0;
          }
          #cover {
            background-color: rgba(108, 108, 108, 0.7);
            height: 100%;
            width: 100%;
            position: fixed;
            z-index: 100;
            display: none;
          }
          #submit_check {
            font-size: 1em;
            margin-left: auto;
            margin-right: auto;
            margin-top: 20%;
            padding: 5%;
            cursor: pointer;
          }

        </style>
      </head>

      <body>
        <div id="cover">
          <button id="submit_check" onclick="atd_chk();" type="submit">本当によろしいですか?</button>
          <button id="submit_check" onclick="sub_chk('out');" type="submit">修正</button>
        </div>
        <form action="index.jsp" method="post" name="atd_fm">
          <%
      for(int n = 0;n < usr_cnt;n++){
        out.println("<label><input type='checkbox' value='1' onclick='checked_num();' name='" + usr_id[n] + "'>" + usr_fname[n] + " " + usr_lname[n] + "</label><br>");
      }
      //接続Close
      stmt.close();
      conn.close();

      //JS利用のためユーザ数をhidden属性のフォームで残す。
      out.println("<input type='hidden' name = 'usr_cnt' value = '" + usr_cnt + "'>");
      %>
          <input onclick="sub_chk('in');" type="button" value="決定"></form>
          <p id="atdornot"></p>

        </body>

      </html>
