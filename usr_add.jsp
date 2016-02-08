<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.*,java.util.regex.*,java.util.*,java.text.SimpleDateFormat,org.apache.commons.codec.digest.DigestUtils" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
      <meta content="width=device-width, initial-scale=1, user-scalable=no" name=viewport>
        <title>attenor usr_add</title>
        <%
        String atdbook_name = null,atdbook_id = null,usr_fname = null,usr_lname = null,usr_id = null;
        request.setCharacterEncoding("UTF-8");
        atdbook_name = request.getParameter("atdbook_name");
        usr_fname = request.getParameter("usr_fname");
        usr_lname = request.getParameter("usr_lname");
        if(!(atdbook_name == null)){
          atdbook_id = "atb" + DigestUtils.md5Hex(atdbook_name);
          usr_id = "usr" + DigestUtils.md5Hex(atdbook_name + usr_fname + usr_lname);
        }


        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/attenor", "attenor", "attenor");
        Statement stmt = conn.createStatement();

        if(!(atdbook_name == null)){
          String upsql = "insert into attendancebooks (attendancebooks_atdbookid, attendancebooks_atdbookname, attendancebooks_usrid, attendancebooks_fname, attendancebooks_lname) values ('" + atdbook_id + "', '" + atdbook_name + "', '" + usr_id + "', '" + usr_fname + "', '" + usr_lname + "')";
          int dbuprs = stmt.executeUpdate(upsql);
        }




        String a = atdbook_name;
        stmt.close();
        conn.close();
        %>
        <script>
          window.onload = function(){
          usradd_fm.usr_fname.focus();
          }
        </script>
      </head>
      <body>
        <form action="usr_add.jsp" name="usradd_fm">
          <label>出席簿の名前
            <input name="atdbook_name" type="text" value="<%=a %>"></label>
            <br>
              <label>姓
                <input name="usr_fname" type="text"></label>
                <br>
                  <label>名
                    <input name="usr_lname" type="text"></label>
                    <br>
                      <input type="submit" formmethod="post"></form>
                    </body>
                  </html>
