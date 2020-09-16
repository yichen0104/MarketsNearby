<%--
  Created by IntelliJ IDEA.
  User: linkl
  Date: 8/13/2020
  Time: 19:11
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%
    String driver = "com.mysql.jdbc.Driver";
    String connection_url = "jdbc:mysql://localhost:3306/";
    String database = "farmers_market";
    String userid = "root";
    String password = "lyc0507link";

    try {
        Class.forName(driver);
        System.out.println("Found MySQL Driver!");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        out.println("Cannot find MySQL Driver!");
        System.out.println("Cannot find MySQL Driver!");
    }
    Connection connection = null;
    Statement statement = null;
    ResultSet result_set = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Markets Database</title>
    <style>
        h1 {
            font-family: verdana;
            font-size: 200%;
        }
        p {
            font-family: verdana;
            font-size: 80%;
        }
        hr {
            display: block;
            margin-top: 0.5em;
            margin-bottom: 0.5em;
            margin-left: auto;
            margin-right: auto;
            border-style: inset;
            border-width: 1px;
        }
    </style>
</head>
<body>
    <h1 align="left">Market Database</h1>
    <hr>
    <i align="left">Search by address information</i>
    <form method="get">
        City: <input type="text" name="city" placeholder="(e.g. Troy)">
        State: <input type="text" name="state" placeholder="(e.g. New York)">
        ZIP: <input type="text" name="zip" placeholder="(e.g. 12180)">
        Location: <input type="text" name="location" placeholder="(e.g. Troy,NY)">
        Distance(miles): <input type="text" name="distance" placeholder="(e.g. 30)">
        Page: <input type="text" name="page" placeholder="(e.g. 1)">
        <div align="right">
        <input type="submit" value="Search" />
        <input type="reset" value="Clear" />
        </div>
    </form>
    <hr>
    <%
        String request_city, request_state, request_zip, request_location, request_distance;

        request_city = request.getParameter("city");
        request_city = request_city == null ? "" : request_city;

        request_state = request.getParameter("state");
        request_state = request_state == null ? "" : request.getParameter("state");

        request_zip = request.getParameter("zip");
        request_zip = request_zip == null ? "" : request_zip;

        request_location = request.getParameter("location");
        request_location = request_location == null ? "" : request_location;

        request_distance = request.getParameter("distance");
        request_distance = request_distance == null ? "" : request_distance;


    %>

    <hr>

    <table align="center", border="1">
        <tr>
            <td>FMID</td>
            <td>Market name</td>
            <td>Street</td>
            <td>city</td>
            <td>State</td>
            <td>ZIP</td>
            <td>Website</td>
        </tr>
        <%

            try{
                connection = DriverManager.getConnection(connection_url+database, userid, password);
                statement=connection.createStatement();
                String query_cmd = "SELECT * FROM farmers WHERE city LIKE '%s' AND State LIKE '%s' AND zip LIKE '%s' ";
                query_cmd = String.format(query_cmd,
                        request_city==""?"%":request_city,
                        request_state==""?"%":request_state,
                        request_zip==""?"%":request_zip);

                //out.println("["+request_location+"], ["+request_distance+"]");

                // request distance from location
                if(request_city.equals("") && request_state.equals("") && !request_location.equals("") && !request_distance.equals("")){
                    // distance designated
                    //out.println(request_location+", "+request_distance);
                    Connection zip_connection = DriverManager.getConnection(connection_url+database, userid, password);
                    Statement zip_statement = zip_connection.createStatement();
                    // Get X & Y;
                    String zip_cmd = "SELECT * FROM zip_codes_states WHERE city LIKE '%s' AND state LIKE '%s'";
                    String[] locs = request_location.split(",");
                    String loc_city = locs[0], loc_state = locs[1];
                    zip_cmd = String.format(zip_cmd, loc_city, loc_state);
                    //out.println(zip_cmd);
                    String lat0 = null, lng0 = null;

                    try {
                        zip_connection = DriverManager.getConnection(connection_url+database, userid, password);
                        zip_statement = zip_connection.createStatement();
                        ResultSet zip_rs = zip_statement.executeQuery(zip_cmd);

                        if(zip_rs.next()) {
                            lat0 = zip_rs.getString("latitude");
                            lng0 = zip_rs.getString("longitude");
                        } else {
                            lat0 = "42.685792";
                            lng0 = "-73.673862";
                        }

                    } catch (SQLException e) {
                        e.printStackTrace();
                        System.err.print("Cannot access zip SQL!");
                        System.exit(1);
                    }

                    query_cmd = query_cmd + "AND (( ((6371e3 * (2 * ATAN2(SQRT((SIN((RADIANS(x-("+lng0+")))/2) * SIN((RADIANS(x-("+lng0+")))/2) +\n" +
                            "COS((RADIANS("+lng0+"))) * COS((RADIANS(x))) *\n" +
                            "SIN((RADIANS(y-("+lat0+")))/2) * SIN((RADIANS(y-("+lat0+")))/2))), SQRT(1-(SIN((RADIANS(x-("+lng0+")))/2) * SIN((RADIANS(x-("+lng0+")))/2) +\n" +
                            "COS((RADIANS("+lng0+"))) * COS((RADIANS(x))) *\n" +
                            "SIN((RADIANS(y-("+lat0+")))/2) * SIN((RADIANS(y-("+lat0+")))/2)))))) * 0.00062137) )<=" + request_distance + ")";

                    //out.println(query_cmd);

                }

                result_set = statement.executeQuery(query_cmd);
                while(result_set.next()){
        %>
        <tr>
            <td><%=result_set.getString("FMID") %></td>
            <td><%=result_set.getString("MarketName") %></td>
            <td><%=result_set.getString("street") %></td>
            <td><%=result_set.getString("City") %></td>
            <td><%=result_set.getString("State") %></td>
            <td><%=result_set.getString("zip") %></td>
            <%
                        String website = result_set.getString("Website");
                        if(website == null || website.equals("")){%>
                <td></td>
            <%}else{%>
                    <td><a href='<%=result_set.getString("Website") %>'>View Website</a></td>
                <%}
                %>
        </tr>
        <%
                    }
                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }

        %>
    </table>
</body>
</html>
