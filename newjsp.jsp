<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Order Information</title>
</head>
<body>

<%
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;
    
    try {
        // Retrieve DataSource from JNDI (Java Naming and Directory Interface)
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("jdbc/MyDataSource"); // Change to your DataSource name
        connection = ds.getConnection();

        // Create a statement
        statement = connection.createStatement();

        // Execute SQL query to retrieve order information
        resultSet = statement.executeQuery("SELECT COUNT(*) AS total_orders, " +
                                            "SUM(quantity * unit_price) AS total_revenue, " +
                                            "AVG(quantity * unit_price) AS average_order_value " +
                                            "FROM orders");

        // Process the result set
        if (resultSet.next()) {
            int totalOrders = resultSet.getInt("total_orders");
            double totalRevenue = resultSet.getDouble("total_revenue");
            double averageOrderValue = resultSet.getDouble("average_order_value");

            // Display the retrieved information
            out.println("<h1>Order Information</h1>");
            out.println("<table border=\"1\">");
            out.println("<tr><th>Total Number of Orders</th><th>Total Revenue</th><th>Average Order Value</th></tr>");
            out.println("<tr><td>" + totalOrders + "</td><td>$" + totalRevenue + "</td><td>$" + averageOrderValue + "</td></tr>");
            out.println("</table>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

</body>
</html>
